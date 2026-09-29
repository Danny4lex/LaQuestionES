<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\Response as SurveyResponse;
use App\Models\Participant;
use App\Exports\SurveyResponsesExport;
use App\Models\OrganizationalUnit;
use App\Services\SurveyReportService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Barryvdh\DomPDF\Facade\Pdf;

// =========================================================================
// Exportación real habilitada vía maatwebsite/excel y barryvdh/laravel-dompdf.
// Requiere que ambos paquetes estén instalados por Composer (ver guía de
// instalación) — sin ellos, exportExcel()/exportPdf() van a lanzar un error
// de clase no encontrada.
// =========================================================================
class ReportController extends Controller
{
    public function __construct(private readonly SurveyReportService $reportService) {}

    // Un usuario sin "surveys.viewAll" solo puede consultar reportes de su
    // propia dependencia (misma regla multi-dependencia del listado).
    private function dependenciaPermitida(Request $request, int $dependencyId): bool
    {
        $puedeVerTodas = $request->user()?->role?->hasPermission('surveys.viewAll') ?? false;

        return $puedeVerTodas || (int) $request->user()?->dependency_id === $dependencyId;
    }

    // =====================================================================
    // REPORTE POR ENCUESTA — total de respuestas, tasa de finalización,
    // y desglose de participación por tipo de participante.
    // =====================================================================
    public function bySurvey(Survey $survey): JsonResponse
    {
        $totalParticipants = $this->reportService->countRespondents($survey->id);

        $totalResponses = $survey->responses()->count();
        $completedResponses = $survey->responses()->where('is_completed', true)->count();

        return response()->json([
            'survey_id' => $survey->id,
            'title' => $survey->title,
            'total_participants_estimated' => $totalParticipants,
            'total_responses' => $totalResponses,
            'completed_responses' => $completedResponses,
            'completion_rate' => $totalResponses > 0
                ? round(($completedResponses / $totalResponses) * 100, 2)
                : 0,
        ], 200);
    }

    // =====================================================================
    // RESULTADOS COMPLETOS — métricas, satisfacción y resumen de todas las
    // preguntas en una sola llamada (antes la pantalla hacía 3 llamadas más
    // una por cada pregunta). Alimenta SurveyResultsPage.vue.
    // =====================================================================
    public function results(Survey $survey): JsonResponse
    {
        return response()->json($this->reportService->buildLiveResults($survey), 200);
    }

    // =====================================================================
    // REPORTE POR DEPENDENCIA — resumen de todas las encuestas de una
    // dependencia, con su cantidad de respuestas cada una.
    // =====================================================================
    public function byDepartment(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'dependency_id' => 'required|exists:organizational_units,id',
        ]);

        if (!$this->dependenciaPermitida($request, (int) $validated['dependency_id'])) {
            return response()->json(['message' => 'No tienes acceso a los reportes de esta dependencia.'], 403);
        }

        $surveys = Survey::where('dependency_id', $validated['dependency_id'])
            ->with(['status', 'category'])
            ->withCount('responses')
            ->get();

        return response()->json([
            'dependency_id' => $validated['dependency_id'],
            'total_surveys' => $surveys->count(),
            'total_responses' => $surveys->sum('responses_count'),
            'surveys' => $surveys,
        ], 200);
    }

    // =====================================================================
    // INDICADORES DE SATISFACCIÓN — promedio de las preguntas tipo "escala"
    // de una encuesta, útil para encuestas de categoría "Satisfacción".
    // =====================================================================
    public function satisfactionIndicators(Survey $survey): JsonResponse
    {
        $scaleQuestions = $survey->sections()
            ->with(['questions' => fn($q) => $q->where('type', 'escala')])
            ->get()
            ->pluck('questions')
            ->flatten();

        $indicators = $scaleQuestions->map(function ($question) {
            $average = SurveyResponse::where('question_id', $question->id)->avg('scale_value');

            return [
                'question_id' => $question->id,
                'statement' => $question->statement,
                'average_score' => $average !== null ? round($average, 2) : null,
                'total_responses' => SurveyResponse::where('question_id', $question->id)->count(),
            ];
        });

        return response()->json([
            'survey_id' => $survey->id,
            'indicators' => $indicators,
        ], 200);
    }

    // =====================================================================
    // COMPARATIVO ENTRE PERÍODOS — respuestas recibidas por día, dentro de
    // dos rangos de fecha distintos, para comparar (ej. este mes vs. el
    // mes pasado).
    // =====================================================================
    public function comparePeriods(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
            'period_1_start' => 'required|date',
            'period_1_end' => 'required|date|after_or_equal:period_1_start',
            'period_2_start' => 'required|date',
            'period_2_end' => 'required|date|after_or_equal:period_2_start',
        ]);

        $countInRange = fn($start, $end) => SurveyResponse::where('survey_id', $validated['survey_id'])
            ->whereBetween('submitted_at', [$start, $end])
            ->count();

        return response()->json([
            'period_1' => [
                'range' => [$validated['period_1_start'], $validated['period_1_end']],
                'total_responses' => $countInRange($validated['period_1_start'], $validated['period_1_end']),
            ],
            'period_2' => [
                'range' => [$validated['period_2_start'], $validated['period_2_end']],
                'total_responses' => $countInRange($validated['period_2_start'], $validated['period_2_end']),
            ],
        ], 200);
    }

    // =====================================================================
    // EXPORTAR A EXCEL — descarga directa del archivo .xlsx generado por
    // SurveyResponsesExport (app/Exports/SurveyResponsesExport.php).
    // =====================================================================
    public function exportExcel(Survey $survey)
    {
        $filename = 'respuestas-encuesta-' . $survey->id . '-' . now()->format('Y-m-d') . '.xlsx';

        return Excel::download(new SurveyResponsesExport($survey->id), $filename);
    }

    // =====================================================================
    // EXPORTAR A PDF — renderiza la vista resources/views/reports/
    // survey-responses-pdf.blade.php y la descarga como PDF.
    // =====================================================================
    public function exportPdf(Survey $survey)
    {
        $filename = 'resultados-encuesta-' . $survey->id . '-' . now()->format('Y-m-d') . '.pdf';

        return Pdf::loadView('reports.survey-responses-pdf', [
            'survey'  => $survey->loadMissing(['department', 'category', 'type', 'status']),
            'results' => $this->reportService->buildResults($survey),
            'detail'  => $this->reportService->buildDetail($survey),
            'logo'    => $this->reportService->logoDataUri(),
        ])->setPaper('a4')->download($filename);
    }

    // =====================================================================
    // EXPORTAR REPORTE POR DEPENDENCIA A PDF — mismo diseño institucional.
    // =====================================================================
    public function exportDepartmentPdf(Request $request)
    {
        $validated = $request->validate([
            'dependency_id' => 'required|exists:organizational_units,id',
        ]);

        if (!$this->dependenciaPermitida($request, (int) $validated['dependency_id'])) {
            return response()->json(['message' => 'No tienes acceso a los reportes de esta dependencia.'], 403);
        }

        $department = OrganizationalUnit::findOrFail($validated['dependency_id']);

        $surveys = Survey::where('dependency_id', $department->id)
            ->with(['status', 'category'])
            ->withCount('responses')
            ->orderBy('title')
            ->get();

        $filename = 'reporte-dependencia-' . $department->id . '-' . now()->format('Y-m-d') . '.pdf';

        return Pdf::loadView('reports.department-report-pdf', [
            'department' => $department,
            'surveys'    => $surveys,
            'logo'       => $this->reportService->logoDataUri(),
        ])->setPaper('a4')->download($filename);
    }

    // =====================================================================
    // RESULTADOS POR ENCUESTADO — una "hoja de respuestas" por persona,
    // paginada (5 por página). Alimenta la pestaña "Por encuestado" de
    // SurveyResultsPage.vue.
    //
    // Cada "encuestado" es un participant_id (identificado/invitado) o,
    // si la encuesta es anónima, su anonymous_identifier (UUID que
    // Response::booted() genera automáticamente cuando no hay
    // participante — ver app/Models/Response.php). COALESCE junta ambos
    // casos bajo una sola clave de agrupación.
    // =====================================================================
    public function byParticipant(Survey $survey, Request $request): JsonResponse
    {
        $perPage = 5;
        $page = max((int) $request->get('page', 1), 1);

        // Un encuestado = participant_id (identificado/invitado) o, si es
        // anónimo, su anonymous_identifier. La paginación se hace en la base
        // de datos (antes se traían todos los encuestados a memoria).
        $agrupado = SurveyResponse::where('survey_id', $survey->id)
            ->select(
                DB::raw('COALESCE(participant_id, anonymous_identifier) as encuestado_key'),
                DB::raw('MAX(submitted_at) as ultima_respuesta')
            )
            ->groupBy('encuestado_key');

        $total = DB::query()->fromSub(clone $agrupado, 'e')->count();

        $paginaActual = (clone $agrupado)
            ->orderByDesc('ultima_respuesta')
            ->forPage($page, $perPage)
            ->get();

        $participantIds = $paginaActual->pluck('encuestado_key')->filter(fn($k) => is_numeric($k))->values();
        $anonIds = $paginaActual->pluck('encuestado_key')->reject(fn($k) => is_numeric($k))->values();

        $participants = Participant::whereIn('id', $participantIds)->get()->keyBy('id');

        // Todas las respuestas de la página en UNA consulta.
        $respuestas = SurveyResponse::with(['question', 'selectedOptions'])
            ->where('survey_id', $survey->id)
            ->where(function ($q) use ($participantIds, $anonIds) {
                $q->whereIn('participant_id', $participantIds)
                    ->orWhereIn('anonymous_identifier', $anonIds);
            })
            ->get();

        $data = $paginaActual->map(function ($item) use ($participants, $respuestas) {
            $key = $item->encuestado_key;
            $participant = is_numeric($key) ? $participants->get((int) $key) : null;

            $propias = is_numeric($key)
                ? $respuestas->where('participant_id', (int) $key)
                : $respuestas->where('anonymous_identifier', $key)->whereNull('participant_id');

            $propias = $propias->sortBy(fn($r) => $r->question?->sort_order ?? 0);

            return [
                'encuestado_key' => (string) $key,
                'participant' => $participant ? [
                    'id' => $participant->id,
                    'name' => $participant->name,
                    'email' => $participant->email,
                    'type' => $participant->type,
                ] : null,
                'is_anonymous' => !$participant,
                'submitted_at' => $item->ultima_respuesta,
                'answers' => $propias->values()->map(fn($r) => [
                    'question_id' => $r->question_id,
                    'statement' => $r->question?->statement,
                    'type' => $r->question?->type,
                    'value' => match ($r->question?->type) {
                        'escala' => $r->scale_value,
                        'si_no' => $r->boolean_value,
                        'opcion_unica', 'opcion_multiple', 'casilla' => $r->selectedOptions->pluck('option_text'),
                        default => $r->text_value,
                    },
                ]),
            ];
        })->values();

        return response()->json([
            'data' => $data,
            'current_page' => $page,
            'per_page' => $perPage,
            'total' => $total,
            'last_page' => $total > 0 ? (int) ceil($total / $perPage) : 1,
        ], 200);
    }
}
