<?php

namespace App\Services;

use App\Models\Survey;
use App\Models\Response as SurveyResponse;
use Illuminate\Support\Facades\DB;

// =========================================================================
// Arma los datos que consumen los reportes en PDF. Usa consultas agrupadas
// (una por tipo de dato) en lugar de una consulta por pregunta, para que
// generar el reporte sea rápido aunque la encuesta tenga muchas preguntas.
// =========================================================================
class SurveyReportService
{
    public const TIPOS = [
        'texto'           => 'Texto abierto',
        'opcion_unica'    => 'Opción única',
        'opcion_multiple' => 'Opción múltiple',
        'escala'          => 'Escala de satisfacción (1-5)',
        'si_no'           => 'Sí / No',
        'casilla'         => 'Casilla de verificación',
    ];

    // Logo institucional como data URI (evita depender de rutas/permisos de
    // archivos remotos al renderizar el PDF).
    public function logoDataUri(): ?string
    {
        $path = resource_path('images/report-logo.png');

        if (!is_file($path)) {
            return null;
        }

        return 'data:image/png;base64,' . base64_encode(file_get_contents($path));
    }

    // Cantidad de personas distintas que respondieron (no de filas: cada
    // respuesta a cada pregunta es una fila en la tabla responses).
    public function countRespondents(int $surveyId): int
    {
        $identificados = SurveyResponse::where('survey_id', $surveyId)
            ->whereNotNull('participant_id')
            ->distinct()
            ->count('participant_id');

        $anonimos = SurveyResponse::where('survey_id', $surveyId)
            ->whereNull('participant_id')
            ->whereNotNull('anonymous_identifier')
            ->distinct()
            ->count('anonymous_identifier');

        return $identificados + $anonimos;
    }

    public function buildResults(Survey $survey): array
    {
        $survey->loadMissing(['department', 'category', 'type', 'status']);

        $sections = $survey->sections()
            ->with(['questions' => fn($q) => $q->orderBy('sort_order'), 'questions.options' => fn($q) => $q->orderBy('sort_order')])
            ->orderBy('id')
            ->get();

        $surveyId = $survey->id;

        [$escalas, $booleanos, $opciones, $textoTotales] = $this->aggregates($surveyId);

        // Texto libre: últimas respuestas de cada pregunta.
        $textoMuestras = SurveyResponse::where('survey_id', $surveyId)
            ->whereNotNull('text_value')
            ->orderByDesc('submitted_at')
            ->limit(1500)
            ->get(['question_id', 'text_value'])
            ->groupBy('question_id');

        $preguntas = [];
        $numero = 0;
        $sumaEscalas = 0;
        $cantEscalas = 0;

        foreach ($sections as $section) {
            foreach ($section->questions as $q) {
                $numero++;
                $item = [
                    'number'    => $numero,
                    'section'   => $section->name,
                    'statement' => $q->statement,
                    'type'      => $q->type,
                    'type_label'=> self::TIPOS[$q->type] ?? $q->type,
                    'mandatory' => (bool) $q->is_mandatory,
                    'total'     => 0,
                ];

                if ($q->type === 'escala') {
                    $filas = $escalas->get($q->id, collect());
                    $total = (int) $filas->sum('total');
                    $suma = $filas->sum(fn($f) => $f->scale_value * $f->total);
                    $dist = [];
                    for ($n = 1; $n <= 5; $n++) {
                        $cantidad = (int) ($filas->firstWhere('scale_value', $n)->total ?? 0);
                        $dist[] = ['label' => (string) $n, 'count' => $cantidad, 'pct' => $total ? round($cantidad / $total * 100, 1) : 0];
                    }
                    $item['total'] = $total;
                    $item['average'] = $total ? round($suma / $total, 2) : null;
                    $item['bars'] = $dist;
                    if ($total) {
                        $sumaEscalas += $suma;
                        $cantEscalas += $total;
                    }
                } elseif (in_array($q->type, ['si_no', 'casilla'], true)) {
                    $filas = $booleanos->get($q->id, collect());
                    $si = (int) ($filas->first(fn($f) => (bool) $f->boolean_value)->total ?? 0);
                    $no = (int) ($filas->first(fn($f) => !(bool) $f->boolean_value)->total ?? 0);
                    $total = $si + $no;
                    $item['total'] = $total;
                    $item['bars'] = [
                        ['label' => 'Sí', 'count' => $si, 'pct' => $total ? round($si / $total * 100, 1) : 0],
                        ['label' => 'No', 'count' => $no, 'pct' => $total ? round($no / $total * 100, 1) : 0],
                    ];
                } elseif (in_array($q->type, ['opcion_unica', 'opcion_multiple'], true)) {
                    $total = 0;
                    foreach ($q->options as $o) {
                        $total += (int) ($opciones[$o->id] ?? 0);
                    }
                    $item['total'] = $total;
                    $item['bars'] = $q->options->map(fn($o) => [
                        'label' => $o->option_text,
                        'count' => (int) ($opciones[$o->id] ?? 0),
                        'pct'   => $total ? round(((int) ($opciones[$o->id] ?? 0)) / $total * 100, 1) : 0,
                    ])->values()->all();
                } else {
                    $item['total'] = (int) ($textoTotales[$q->id] ?? 0);
                    $item['samples'] = ($textoMuestras->get($q->id) ?? collect())
                        ->take(5)
                        ->map(fn($r) => mb_strimwidth($r->text_value, 0, 220, '…'))
                        ->values()
                        ->all();
                }

                $preguntas[] = $item;
            }
        }

        $filas = SurveyResponse::where('survey_id', $surveyId);
        $totalRespuestas = (clone $filas)->count();
        $completadas = (clone $filas)->where('is_completed', true)->count();

        return [
            'respondents'       => $this->countRespondents($surveyId),
            'answers'           => $totalRespuestas,
            'completion_rate'   => $totalRespuestas ? round($completadas / $totalRespuestas * 100, 1) : 0,
            'satisfaction_avg'  => $cantEscalas ? round($sumaEscalas / $cantEscalas, 2) : null,
            'questions'         => $preguntas,
        ];
    }

    // Agregados por tipo de pregunta con UNA consulta agrupada cada uno
    // (en lugar de una consulta por pregunta).
    private function aggregates(int $surveyId): array
    {
        // Escala: distribución 1..5 por pregunta.
        $escalas = SurveyResponse::where('survey_id', $surveyId)
            ->whereNotNull('scale_value')
            ->select('question_id', 'scale_value', DB::raw('COUNT(*) as total'))
            ->groupBy('question_id', 'scale_value')
            ->get()
            ->groupBy('question_id');

        // Sí / No y casillas.
        $booleanos = SurveyResponse::where('survey_id', $surveyId)
            ->whereNotNull('boolean_value')
            ->select('question_id', 'boolean_value', DB::raw('COUNT(*) as total'))
            ->groupBy('question_id', 'boolean_value')
            ->get()
            ->groupBy('question_id');

        // Opciones seleccionadas (única y múltiple).
        $opciones = DB::table('multiple_choise_responses as m')
            ->join('responses as r', 'r.id', '=', 'm.response_id')
            ->where('r.survey_id', $surveyId)
            ->select('m.question_option_id', DB::raw('COUNT(*) as total'))
            ->groupBy('m.question_option_id')
            ->pluck('total', 'question_option_id');

        // Texto libre: total por pregunta.
        $textoTotales = SurveyResponse::where('survey_id', $surveyId)
            ->whereNotNull('text_value')
            ->select('question_id', DB::raw('COUNT(*) as total'))
            ->groupBy('question_id')
            ->pluck('total', 'question_id');

        return [$escalas, $booleanos, $opciones, $textoTotales];
    }

    // =====================================================================
    // Todo lo que necesita la pantalla de resultados en UNA sola llamada:
    // métricas, indicadores de satisfacción y resumen de cada pregunta
    // (mismo formato que ResponseController::summaryByQuestion).
    // =====================================================================
    public function buildLiveResults(Survey $survey): array
    {
        $surveyId = $survey->id;

        $questions = $survey->sections()
            ->with(['questions' => fn($q) => $q->orderBy('sort_order'), 'questions.options' => fn($q) => $q->orderBy('sort_order')])
            ->get()
            ->pluck('questions')
            ->flatten();

        [$escalas, $booleanos, $opciones, $textoTotales] = $this->aggregates($surveyId);

        $summaries = [];
        $satisfaction = [];

        foreach ($questions as $q) {
            if ($q->type === 'escala') {
                $filas = $escalas->get($q->id, collect());
                $total = (int) $filas->sum('total');
                $average = $total ? round($filas->sum(fn($f) => $f->scale_value * $f->total) / $total, 2) : 0;

                $summaries[$q->id] = ['type' => 'escala', 'average' => $average, 'total_responses' => $total];
                $satisfaction[] = [
                    'question_id' => $q->id,
                    'statement' => $q->statement,
                    'average_score' => $total ? $average : null,
                    'total_responses' => $total,
                ];
            } elseif (in_array($q->type, ['si_no', 'casilla'], true)) {
                $filas = $booleanos->get($q->id, collect());
                $summaries[$q->id] = [
                    'type' => $q->type,
                    'true_count' => (int) ($filas->first(fn($f) => (bool) $f->boolean_value)->total ?? 0),
                    'false_count' => (int) ($filas->first(fn($f) => !(bool) $f->boolean_value)->total ?? 0),
                ];
            } elseif (in_array($q->type, ['opcion_unica', 'opcion_multiple'], true)) {
                $summaries[$q->id] = [
                    'type' => $q->type,
                    'options' => $q->options->map(fn($o) => [
                        'id' => $o->id,
                        'option_text' => $o->option_text,
                        'responses_count' => (int) ($opciones[$o->id] ?? 0),
                    ])->values()->all(),
                ];
            } else {
                $summaries[$q->id] = [
                    'type' => $q->type,
                    'total_responses' => (int) ($textoTotales[$q->id] ?? 0),
                ];
            }
        }

        $filas = SurveyResponse::where('survey_id', $surveyId);
        $totalRespuestas = (clone $filas)->count();
        $completadas = (clone $filas)->where('is_completed', true)->count();

        return [
            'metrics' => [
                'survey_id' => $surveyId,
                'title' => $survey->title,
                'total_participants_estimated' => $this->countRespondents($surveyId),
                'total_responses' => $totalRespuestas,
                'completed_responses' => $completadas,
                'completion_rate' => $totalRespuestas ? round($completadas / $totalRespuestas * 100, 2) : 0,
            ],
            'satisfaction' => $satisfaction,
            'summaries' => (object) $summaries,
        ];
    }

    // Detalle fila por fila (limitado para que el PDF no crezca sin control).
    public function buildDetail(Survey $survey, int $limit = 500): array
    {
        $total = $survey->responses()->count();

        $rows = $survey->responses()
            ->with(['question:id,statement,type', 'selectedOptions:id,option_text', 'participant:id,name,email'])
            ->orderBy('submitted_at')
            ->limit($limit)
            ->get();

        return ['rows' => $rows, 'total' => $total, 'limit' => $limit, 'truncated' => $total > $limit];
    }
}
