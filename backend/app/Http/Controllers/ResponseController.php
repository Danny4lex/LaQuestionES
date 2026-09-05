<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\Response as SurveyResponse;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ResponseController extends Controller
{
    // =====================================================================
    // LISTADO — respuestas de una encuesta, paginadas. Incluye la pregunta
    // y las opciones seleccionadas (si aplica), pero NO expone participant_id
    // salvo que el consumidor tenga permiso — por ahora se devuelve tal cual,
    // ya que el control de acceso fino por rol todavía no está implementado.
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
            'question_id' => 'nullable|exists:questions,id',
        ]);

        $responses = SurveyResponse::with(['question', 'selectedOptions'])
            ->where('survey_id', $validated['survey_id'])
            ->when($request->question_id, fn($q, $v) => $q->where('question_id', $v))
            ->orderByDesc('submitted_at')
            ->paginate($request->integer('per_page', 25));

        return response()->json($responses, 200);
    }

    // =====================================================================
    // DETALLE
    // =====================================================================
    public function show(SurveyResponse $response): JsonResponse
    {
        $response->load(['question', 'selectedOptions', 'participant']);

        return response()->json($response, 200);
    }

    // =====================================================================
    // RESUMEN POR PREGUNTA — agregación básica para alimentar gráficos:
    // promedio para preguntas de escala, conteo de "sí/no", y conteo de
    // opciones seleccionadas para preguntas de selección. Es la base sobre
    // la que se construirá ReportController más adelante (paso 7 de la
    // hoja de ruta); aquí se deja solo el cálculo por pregunta individual.
    // =====================================================================
    public function summaryByQuestion(Survey $survey, int $questionId): JsonResponse
    {
        $question = $survey->sections()
            ->with('questions')
            ->get()
            ->pluck('questions')
            ->flatten()
            ->firstWhere('id', $questionId);

        if (!$question) {
            return response()->json(['message' => 'Pregunta no encontrada en esta encuesta.'], 404);
        }

        $baseQuery = SurveyResponse::where('survey_id', $survey->id)
            ->where('question_id', $questionId);

        $summary = match ($question->type) {
            'escala' => [
                'type' => 'escala',
                'average' => round($baseQuery->avg('scale_value'), 2),
                'total_responses' => $baseQuery->count(),
            ],
            'si_no', 'casilla' => [
                'type' => $question->type,
                'true_count' => (clone $baseQuery)->where('boolean_value', true)->count(),
                'false_count' => (clone $baseQuery)->where('boolean_value', false)->count(),
            ],
            'opcion_unica', 'opcion_multiple' => [
                'type' => $question->type,
                'options' => $question->options()->withCount([
                    'responses' => fn($q) => $q->where('survey_id', $survey->id),
                ])->get(['id', 'option_text']),
            ],
            default => [
                'type' => $question->type,
                'total_responses' => $baseQuery->count(),
                'note' => 'Las respuestas de texto libre no se agregan automáticamente; consulte index() para revisarlas una a una.',
            ],
        };

        return response()->json($summary, 200);
    }
}
