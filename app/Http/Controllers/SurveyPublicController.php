<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\Participant;
use App\Models\Response as SurveyResponse;
use App\Services\AnonymizeResponseService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class SurveyPublicController extends Controller
{
    public function __construct(
        private readonly AnonymizeResponseService $anonymizeService
    ) {}

    public function show(Survey $survey): JsonResponse
    {
        $error = $this->validateSurveyIsOpen($survey);
        if ($error) {
            return $error;
        }

        if (!str_contains($survey->type->name ?? '', 'Pública')) {
            return response()->json([
                'message' => 'Esta encuesta requiere una invitación para responderla.'
            ], 403);
        }

        return response()->json(
            $survey->only(['id', 'title', 'description', 'is_single_response', 'anonymity_mode'])
                + ['sections' => $survey->load('sections.questions.options')->sections],
            200
        );
    }

    public function showByToken(string $token): JsonResponse
    {
        $participant = Participant::where('access_token', $token)->first();

        if (!$participant) {
            return response()->json(['message' => 'Enlace de invitación no válido.'], 404);
        }

        if ($participant->invitation_status === 'respondido') {
            return response()->json(['message' => 'Esta invitación ya fue respondida.'], 409);
        }

        $error = $this->validateSurveyIsOpen($participant->survey);
        if ($error) {
            return $error;
        }

        return response()->json([
            'participant' => $participant->only(['id', 'name', 'email', 'phone', 'invitation_status']),
            'survey' => $participant->survey->only(['id', 'title', 'description', 'is_single_response', 'anonymity_mode']),
            'sections' => $participant->survey->load('sections.questions.options')->sections,
        ], 200);
    }

    public function submit(Request $request, Survey $survey): JsonResponse
    {
        $error = $this->validateSurveyIsOpen($survey);
        if ($error) {
            return $error;
        }

        // Encuesta identificada: nombre y correo son obligatorios (los datos
        // del encuestado que pide la primera sección). Encuesta anónima: no
        // se piden ni se guardan.
        $datosRequeridos = $this->anonymizeService->isAnonymousSubmission($survey, $request) ? 'nullable' : 'required';

        $validated = $request->validate([
            'name' => $datosRequeridos . '|string|max:255',
            'email' => $datosRequeridos . '|email|max:255',
            'phone' => 'nullable|string|max:50',
            'anonymous' => 'sometimes|boolean',
            'answers' => 'required|array|min:1',
            'answers.*.question_id' => 'required|exists:questions,id',
            'answers.*.value' => 'nullable',
            'answers.*.option_ids' => 'nullable|array',
            'answers.*.option_ids.*' => 'exists:question_options,id',
        ]);

        $participant = $this->anonymizeService->resolvePublicParticipant($survey, $request);

        return $this->storeAnswers($request, $survey, $participant, $validated['answers']);
    }

    public function submitByToken(Request $request, string $token): JsonResponse
    {
        $participant = Participant::where('access_token', $token)->first();

        if (!$participant) {
            return response()->json(['message' => 'Enlace de invitación no válido.'], 404);
        }

        if ($participant->invitation_status === 'respondido') {
            return response()->json(['message' => 'Esta invitación ya fue respondida.'], 409);
        }

        $survey = $participant->survey;
        $error = $this->validateSurveyIsOpen($survey);
        if ($error) {
            return $error;
        }

        $validated = $request->validate([
            'name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:50',
            'anonymous' => 'sometimes|boolean',
            'answers' => 'required|array|min:1',
            'answers.*.question_id' => 'required|exists:questions,id',
            'answers.*.value' => 'nullable',
            'answers.*.option_ids' => 'nullable|array',
            'answers.*.option_ids.*' => 'exists:question_options,id',
        ]);

        // Encuesta identificada: el invitado completa su nombre y teléfono
        // (el correo ya es el de la invitación y no se modifica). En una
        // encuesta anónima no se guarda ningún dato personal.
        if (!$this->anonymizeService->isAnonymousSubmission($survey, $request)) {
            $participant->update([
                'name' => $validated['name'] ?? $participant->name,
                'phone' => $validated['phone'] ?? $participant->phone,
            ]);
        }

        return $this->storeAnswers($request, $survey, $participant, $validated['answers']);
    }

    private function storeAnswers(Request $request, Survey $survey, Participant $participant, array $answers): JsonResponse
    {
        if ($survey->is_single_response && $this->anonymizeService->alreadyResponded($survey, $participant, $request)) {
            return response()->json([
                'message' => 'Esta encuesta permite una sola respuesta por participante, y ya fue respondida.'
            ], 409);
        }

        $allQuestions = $survey->sections()->with('questions')->get()->pluck('questions')->flatten();
        $mandatoryIds = $allQuestions->where('is_mandatory', true)->pluck('id');
        $answeredIds = collect($answers)->pluck('question_id');

        $missing = $mandatoryIds->diff($answeredIds);
        if ($missing->isNotEmpty()) {
            return response()->json([
                'message' => 'Faltan respuestas obligatorias.',
                'missing_question_ids' => $missing->values(),
            ], 422);
        }

        // FIX: el límite de caracteres (questions.max_length, ver
        // migración add_max_length_to_questions_table) antes solo se
        // sugería visualmente en el frontend — nada impedía que alguien
        // mandara una respuesta más larga directamente contra la API.
        // Se valida aquí, ANTES de guardar nada, para no dejar respuestas
        // a medias si una pregunta excede el límite.
        $excedidas = [];
        foreach ($answers as $answer) {
            $question = $allQuestions->firstWhere('id', $answer['question_id']);
            if (
                $question
                && in_array($question->type, ['texto', 'comentario', 'abierta'], true)
                && $question->max_length
                && is_string($answer['value'] ?? null)
                && mb_strlen($answer['value']) > $question->max_length
            ) {
                $excedidas[] = [
                    'question_id' => $question->id,
                    'max_length' => $question->max_length,
                ];
            }
        }
        if (!empty($excedidas)) {
            return response()->json([
                'message' => 'Una o más respuestas de texto exceden el límite de caracteres permitido.',
                'exceeded_questions' => $excedidas,
            ], 422);
        }

        // Anónima: respuestas sin participant_id. Un MISMO identificador
        // por envío para poder agruparlas después como "un encuestado"
        // (antes cada fila generaba su propio UUID y se separaban).
        $esAnonima = $this->anonymizeService->isAnonymousSubmission($survey, $request) || $participant->type === 'anonimo';
        $anonymousId = $esAnonima ? (string) \Illuminate\Support\Str::uuid() : null;

        DB::transaction(function () use ($request, $survey, $participant, $answers, $allQuestions, $esAnonima, $anonymousId) {
            foreach ($answers as $answer) {
                $question = $allQuestions->firstWhere('id', $answer['question_id']);

                $response = SurveyResponse::create([
                    'source_ip' => $request->ip(),
                    'submitted_at' => now(),
                    'is_completed' => true,
                    // Se amplia la validación para incluir 'comentario' o cualquier otro tipo textual
                    'text_value' => in_array($question->type, ['texto', 'comentario', 'abierta']) 
                        ? ($answer['value'] ?? null) 
                        : null,

                    // Casteo numérico estricto para evitar errores SQLSTATE[22007]
                    'scale_value' => ($question->type === 'escala' && is_numeric($answer['value'] ?? null)) 
                        ? (int) $answer['value'] 
                        : null,

                    'boolean_value' => in_array($question->type, ['si_no', 'casilla']) 
                        ? filter_var($answer['value'] ?? false, FILTER_VALIDATE_BOOLEAN) 
                        : null,

                    'question_id' => $question->id,
                    'survey_id' => $survey->id,
                    'anonymous_identifier' => $anonymousId,
                    'participant_id' => $esAnonima ? null : $participant->id,
                ]);

                if (in_array($question->type, ['opcion_unica', 'opcion_multiple']) && !empty($answer['option_ids'])) {
                    $response->selectedOptions()->attach($answer['option_ids']);
                }
            }

            $participant->update([
                'responded_at' => now(),
                'invitation_status' => $participant->invitation_status !== null ? 'respondido' : null,
            ]);
        });

        return response()->json(['message' => 'Respuestas registradas correctamente.'], 201);
    }

    private function validateSurveyIsOpen(Survey $survey): ?JsonResponse
    {
        // FIX: comparaba por el nombre visible del estado ("Publicada"),
        // el mismo anti-patrón ya corregido en SurveyController y
        // DashboardController — un simple cambio de texto en el catálogo
        // de estados rompería silenciosamente el acceso público. Se
        // compara por slug (columna técnica estable, ver StatusSeeder).
        if (($survey->status->slug ?? null) !== 'published') {
            return response()->json(['message' => 'Esta encuesta no está disponible actualmente.'], 403);
        }

        $now = now();
        if ($survey->start_date && $now->lt($survey->start_date)) {
            return response()->json(['message' => 'Esta encuesta todavía no ha iniciado.'], 403);
        }
        if ($survey->end_date && $now->gt($survey->end_date)) {
            return response()->json(['message' => 'Esta encuesta ya finalizó.'], 403);
        }

        return null;
    }
}