<?php

namespace App\Http\Controllers;

use App\Models\Section;
use App\Models\Survey;
use App\Services\ChangeLogService;
use App\Services\SurveyStatusFlowService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SectionController extends Controller
{
    public function __construct(
        private readonly ChangeLogService $changeLogService,
        private readonly SurveyStatusFlowService $statusFlowService
    ) {}

    private function bloquearSiNoEditable(?Survey $survey): ?JsonResponse
    {
        if ($survey && !$this->statusFlowService->isEditable($survey)) {
            return response()->json([
                'message' => "No se puede modificar la estructura de la encuesta mientras está en estado \"{$survey->status?->name}\". "
                    . 'Solo se puede modificar en Borrador, En revisión, Aprobada, Rechazada o Corregida.',
            ], 422);
        }
        return null;
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id'   => 'required|exists:surveys,id',
            'name'        => 'required|string|max:255',
            'description' => 'nullable|string',
            'type'        => 'nullable|string|in:general,personal_data', // <-- AGREGADO
        ]);

        if ($bloqueo = $this->bloquearSiNoEditable(Survey::find($validated['survey_id']))) {
            return $bloqueo;
        }

        $section = Section::create([
            ...$validated,
            'type' => $validated['type'] ?? 'general',
        ]);

        $this->changeLogService->log(
            $request,
            'Section',
            'Creación',
            "Se agregó la sección \"{$section->name}\".",
            $section->survey_id
        );

        return response()->json($section, 201);
    }

    public function update(Request $request, Section $section): JsonResponse
    {
        if ($bloqueo = $this->bloquearSiNoEditable($section->survey)) {
            return $bloqueo;
        }

        $validated = $request->validate([
            'name'        => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'type'        => 'sometimes|required|string|in:general,personal_data', // <-- AGREGADO
        ]);

        $section->update($validated);

        $this->changeLogService->log(
            $request,
            'Section',
            'Edición',
            "Se editó la sección \"{$section->name}\".",
            $section->survey_id
        );

        return response()->json($section, 200);
    }

    public function destroy(Request $request, Section $section): JsonResponse
    {
        if ($bloqueo = $this->bloquearSiNoEditable($section->survey)) {
            return $bloqueo;
        }

        $nombre = $section->name;
        $surveyId = $section->survey_id;

        $section->delete();

        $this->changeLogService->log(
            $request,
            'Section',
            'Eliminación',
            "Se eliminó la sección \"{$nombre}\".",
            $surveyId
        );

        return response()->json(['message' => 'Sección eliminada del diseño.'], 200);
    }
}