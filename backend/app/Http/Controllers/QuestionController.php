<?php

namespace App\Http\Controllers;

use App\Models\Question;
use App\Models\Section;
use App\Services\ChangeLogService;
use App\Services\SurveyStatusFlowService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class QuestionController extends Controller
{
    public function __construct(
        private readonly ChangeLogService $changeLogService,
        private readonly SurveyStatusFlowService $statusFlowService
    ) {}

    /**
     * Resuelve el survey_id dueño de una pregunta ligada a una sección,
     * para poder auditarla contra esa encuesta. Las preguntas de
     * plantilla (template_id) no pertenecen a ninguna encuesta, así que
     * en ese caso se audita sin survey_id.
     */
    private function surveyIdDeLaSeccion(?int $sectionId): ?int
    {
        if (!$sectionId) {
            return null;
        }
        return Section::where('id', $sectionId)->value('survey_id');
    }

    /**
     * FIX: mismo candado que en SectionController — las preguntas de
     * plantilla (template_id, sin section_id) quedan exentas porque una
     * plantilla no tiene estado de encuesta.
     */
    private function bloquearSiNoEditable(?int $sectionId): ?JsonResponse
    {
        if (!$sectionId) {
            return null;
        }
        $section = Section::with('survey.status')->find($sectionId);
        if ($section?->survey && !$this->statusFlowService->isEditable($section->survey)) {
            return response()->json([
                'message' => "No se puede modificar la estructura de la encuesta mientras está en estado \"{$section->survey->status?->name}\". "
                    . 'Solo se puede modificar en Borrador, En revisión, Aprobada, Rechazada o Corregida.',
            ], 422);
        }
        return null;
    }

    /**
     * Crea una nueva pregunta en la estructura de encuesta o plantilla.
     * Uso: agrega preguntas al constructor dinámico de encuestas.
     * CORRECCIÓN: se removió "help_text" — la tabla "questions" no tiene esa
     * columna según la migración/diccionario (statement, type, is_mandatory,
     * sort_order, section_id, template_id). Si el equipo decide que sí hace
     * falta un texto de ayuda por pregunta, primero hay que agregar la
     * columna en una migración nueva antes de volver a validarla aquí.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'section_id' => 'nullable|exists:sections,id',
            'template_id' => 'nullable|exists:templates,id',
            'type' => 'required|string|max:50',
            'statement' => 'required|string',
            'is_mandatory' => 'required|boolean',
            // Solo aplica a preguntas de texto libre (corto/largo); el
            // límite real de negocio se valida en ResponseController al
            // recibir la respuesta, no solo aquí.
            'max_length' => 'nullable|integer|min:1|max:5000',
            'sort_order' => 'required|integer',
        ]);

        if (empty($validated['section_id']) && empty($validated['template_id'])) {
            return response()->json(['message' => 'La pregunta debe ligarse a una sección o a una plantilla.'], 422);
        }

        if ($bloqueo = $this->bloquearSiNoEditable($validated['section_id'] ?? null)) {
            return $bloqueo;
        }

        $question = Question::create($validated);

        $this->changeLogService->log(
            $request,
            'Question',
            'Creación',
            "Se agregó la pregunta \"{$question->statement}\".",
            $this->surveyIdDeLaSeccion($validated['section_id'] ?? null)
        );

        return response()->json($question, 201);
    }

    /**
     * Actualiza los datos de una pregunta existente.
     * Uso: edita el texto, tipo o obligatoriedad de la pregunta en el diseñador.
     * CORRECCIÓN: se removió "help_text" por la misma razón que en store().
     */
    public function update(Request $request, Question $question): JsonResponse
    {
        if ($bloqueo = $this->bloquearSiNoEditable($question->section_id)) {
            return $bloqueo;
        }

        $validated = $request->validate([
            'type' => 'sometimes|required|string|max:50',
            'statement' => 'sometimes|required|string',
            'is_mandatory' => 'sometimes|required|boolean',
            'max_length' => 'nullable|integer|min:1|max:5000',
        ]);

        $question->update($validated);

        $this->changeLogService->log(
            $request,
            'Question',
            'Edición',
            "Se editó la pregunta \"{$question->statement}\".",
            $this->surveyIdDeLaSeccion($question->section_id)
        );

        return response()->json($question, 200);
    }

    /**
     * Reordena las preguntas según la nueva posición enviada por el frontend.
     * Uso: guarda el orden del Wizard o la sección de preguntas.
     * Nota: no se audita cada reorder individual (es una acción de UI muy
     * frecuente, sin valor real como evidencia de auditoría); sí queda
     * registrado el contenido de cada pregunta vía store()/update().
     * No se bloquea aquí por estado (sería una consulta por cada pregunta
     * del lote); el candado real ya está en store()/update()/destroy(),
     * que son las operaciones que de verdad alteran el contenido.
     */
    public function reorder(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'questions' => 'required|array',
            'questions.*.id' => 'required|exists:questions,id',
            'questions.*.sort_order' => 'required|integer',
        ]);

        DB::transaction(function () use ($validated) {
            foreach ($validated['questions'] as $item) {
                Question::where('id', $item['id'])->update(['sort_order' => $item['sort_order']]);
            }
        });

        return response()->json(['message' => 'Orden de las preguntas modificado con éxito.'], 200);
    }

    /**
     * Elimina una pregunta de la encuesta o plantilla.
     * Uso: borra el registro de la estructura de preguntas.
     */
    public function destroy(Request $request, Question $question): JsonResponse
    {
        if ($bloqueo = $this->bloquearSiNoEditable($question->section_id)) {
            return $bloqueo;
        }

        $enunciado = $question->statement;
        $surveyId = $this->surveyIdDeLaSeccion($question->section_id);

        $question->delete();

        $this->changeLogService->log(
            $request,
            'Question',
            'Eliminación',
            "Se eliminó la pregunta \"{$enunciado}\".",
            $surveyId
        );

        return response()->json(['message' => 'Pregunta eliminada de la estructura.'], 200);
    }
}
