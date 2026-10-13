<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\Response;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * PANTALLA: DASHBOARD GENERAL (TARJETAS DE CONTEO SUPERIORES E INDICADORES)
     * Propósito: Devuelve los KPIs unificados para pintar las tarjetas principales de la UI,
     * las gráficas dinámicas de dona y líneas, y los ránkings históricos del Ministerio.
     * CORREGIDO DEFINITIVAMENTE: ya no compara por texto visible (name) —
     * usa la columna "slug" de statuses, estable aunque el nombre cambie.
     *
     * FILTROS (todos opcionales, vía query string):
     * - start_date / end_date: rango de fechas (YYYY-MM-DD).
     *   Se aplican a la fecha de creación de la encuesta (created_at) para
     *   las tarjetas/gráficos de encuestas, y a la fecha de respuesta
     *   (submitted_at) para el total y la gráfica de respuestas por día.
     * - dependency_id: limita todo a una dependencia (organizational_units.id).
     * - survey_category_id: limita todo a una categoría de encuesta.
     */
    public function getSummaryMetrics(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'dependency_id' => 'nullable|exists:organizational_units,id',
            'survey_category_id' => 'nullable|exists:survey_categories,id',
        ]);

        // Filtro base reutilizable, aplicado a cualquier query sobre "surveys".
        $applySurveyFilters = function ($query) use ($validated) {
            if (!empty($validated['dependency_id'])) {
                $query->where('dependency_id', $validated['dependency_id']);
            }
            if (!empty($validated['survey_category_id'])) {
                $query->where('survey_category_id', $validated['survey_category_id']);
            }
            if (!empty($validated['start_date'])) {
                $query->whereDate('created_at', '>=', $validated['start_date']);
            }
            if (!empty($validated['end_date'])) {
                $query->whereDate('created_at', '<=', $validated['end_date']);
            }
            return $query;
        };

        // Filtro reutilizable para "responses", vía su encuesta dueña
        // (dependencia/categoría) y su propia fecha de envío.
        $applyResponseFilters = function ($query) use ($validated) {
            if (!empty($validated['dependency_id']) || !empty($validated['survey_category_id'])) {
                $query->whereHas('survey', function ($q) use ($validated) {
                    if (!empty($validated['dependency_id'])) {
                        $q->where('dependency_id', $validated['dependency_id']);
                    }
                    if (!empty($validated['survey_category_id'])) {
                        $q->where('survey_category_id', $validated['survey_category_id']);
                    }
                });
            }
            if (!empty($validated['start_date'])) {
                $query->whereDate('submitted_at', '>=', $validated['start_date']);
            }
            if (!empty($validated['end_date'])) {
                $query->whereDate('submitted_at', '<=', $validated['end_date']);
            }
            return $query;
        };

        // 1. DATA PARA: TARJETAS SUPERIORES DE CONTEO LOGÍSTICO
        $totalSurveys = $applySurveyFilters(Survey::query())->count();

        $activeSurveys = $applySurveyFilters(Survey::query())
            ->whereHas('status', function ($q) {
                $q->where('slug', 'published');
            })->count();

        $completedSurveys = $applySurveyFilters(Survey::query())
            ->whereHas('status', function ($q) {
                $q->where('slug', 'closed');
            })->count();

        $totalResponses = $applyResponseFilters(Response::query())->count();

        // 2. DATA PARA GRÁFICO: DISTRIBUCIÓN POR TIPO DE ACCESO (GRÁFICO DE DONA)
        $distributionByType = $applySurveyFilters(
            Survey::join('types', 'surveys.type_id', '=', 'types.id')
        )
            ->select('types.name as type_name', DB::raw('count(surveys.id) as total'))
            ->groupBy('types.name')
            ->get();

        // 3. DATA PARA GRÁFICO: PARTICIPACIÓN / RESPUESTAS POR DÍA (GRÁFICO DE LÍNEAS)
        //    Si no se pasa un rango de fechas, se mantiene el comportamiento
        //    original (últimos 30 días) como valor por defecto.
        $responsesPerDayQuery = Response::select(
            DB::raw('DATE(submitted_at) as date'),
            DB::raw('count(id) as total')
        );
        $applyResponseFilters($responsesPerDayQuery);
        if (empty($validated['start_date']) && empty($validated['end_date'])) {
            $responsesPerDayQuery->where('submitted_at', '>=', now()->subDays(30));
        }
        $responsesPerDay = $responsesPerDayQuery
            ->groupBy(DB::raw('DATE(submitted_at)'))
            ->orderBy('date', 'ASC')
            ->get();

        // 4. DATA PARA TABLA: ENCUESTAS CON MAYOR PARTICIPACIÓN (TOP 5 DE BARRAS)
        $topSurveys = $applySurveyFilters(Survey::query())
        ->select('surveys.id', 'surveys.title')
        ->selectSub(
            Response::query()
                ->selectRaw('COUNT(DISTINCT COALESCE(CAST(participant_id AS CHAR), anonymous_identifier))')
                ->whereColumn('responses.survey_id', 'surveys.id'),
            'responses_count'
        )
        ->orderByDesc('responses_count')
        ->limit(5)
        ->get();

        // 5. DATA PARA TARJETA: ENCUESTAS MÁS RECIENTES
        //    Se agrega esta sección para alimentar el componente RecentSurveys
        //    del frontend sin depender de datos fijos.
        $latestSurveys = $applySurveyFilters(Survey::query())
            ->orderByDesc('created_at')
            ->limit(5)
            ->get(['id', 'title', 'created_at'])
            ->map(fn($survey) => [
                'id' => $survey->id,
                'title' => $survey->title,
                'date' => $survey->created_at ? $survey->created_at->format('d/m/Y') : null,
            ]);

        // 6. CONSOLIDACIÓN FINAL DEL JSON PARA VUE 3
        return response()->json([
            'cards' => [
                'total_surveys' => $totalSurveys,
                'active_surveys' => $activeSurveys,
                'completed_surveys' => $completedSurveys,
                'total_responses' => $totalResponses,
            ],
            'charts' => [
                'distribution_by_type' => $distributionByType,
                'responses_per_day' => $responsesPerDay,
                'top_participated_surveys' => $topSurveys,
                'latest_surveys' => $latestSurveys,
            ]
        ], 200);
    }
}