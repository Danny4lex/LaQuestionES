<?php

namespace App\Console\Commands;

use App\Models\Status;
use App\Models\Survey;
use App\Services\ChangeLogService;
use App\Services\SurveyStatusFlowService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;

// Automatización de vigencia:
//   1. Publica las encuestas "Programadas" cuya fecha y hora de inicio ya llegó.
//   2. Cierra las encuestas "Publicadas" cuya fecha y hora de fin ya pasó.
class ApplySurveyVigencia extends Command
{
    protected $signature = 'surveys:apply-vigencia';

    protected $description = 'Publica encuestas programadas cuya fecha de inicio llegó y cierra encuestas publicadas cuya fecha de fin ya pasó.';

    public function handle(SurveyStatusFlowService $statusFlow, ChangeLogService $changeLog): int
    {
        $publicadas = $this->publicarProgramadas($statusFlow, $changeLog);
        $cerradas = $this->cerrarVencidas($statusFlow, $changeLog);

        $this->info("Vigencia aplicada: {$publicadas} encuesta(s) publicada(s), {$cerradas} encuesta(s) cerrada(s).");

        return self::SUCCESS;
    }

    private function publicarProgramadas(SurveyStatusFlowService $statusFlow, ChangeLogService $changeLog): int
    {
        $publishedStatus = Status::where('slug', 'published')->first();
        if (!$publishedStatus) {
            $this->warn('No existe un estado con slug "published" en el catálogo; se omite la publicación automática.');
            return 0;
        }

        $surveys = Survey::whereHas('status', fn($q) => $q->where('slug', 'scheduled'))
            ->whereNotNull('start_date')
            ->where('start_date', '<=', now())
            ->get();

        $hechas = 0;

        foreach ($surveys as $survey) {
            try {
                $statusFlow->transition($survey, $publishedStatus->id);
                $this->limpiarCache($survey->id);
                $changeLog->log(
                    null,
                    'Survey',
                    'Publicación automática',
                    "La encuesta \"{$survey->title}\" se publicó automáticamente al llegar su fecha de inicio ({$survey->start_date}).",
                    $survey->id
                );
                $hechas++;
            } catch (\Throwable $e) {
                $this->warn("No se pudo publicar la encuesta {$survey->id}: {$e->getMessage()}");
            }
        }

        return $hechas;
    }

    private function cerrarVencidas(SurveyStatusFlowService $statusFlow, ChangeLogService $changeLog): int
    {
        $closedStatus = Status::where('slug', 'closed')->first();
        if (!$closedStatus) {
            $this->warn('No existe un estado con slug "closed" en el catálogo; se omite el cierre automático.');
            return 0;
        }

        $surveys = Survey::whereHas('status', fn($q) => $q->where('slug', 'published'))
            ->whereNotNull('end_date')
            ->where('end_date', '<', now())
            ->get();

        $hechas = 0;

        foreach ($surveys as $survey) {
            try {
                $statusFlow->transition($survey, $closedStatus->id);
                $this->limpiarCache($survey->id);
                $changeLog->log(
                    null,
                    'Survey',
                    'Cierre automático',
                    "La encuesta \"{$survey->title}\" se cerró automáticamente al vencer su fecha de fin ({$survey->end_date}).",
                    $survey->id
                );
                $hechas++;
            } catch (\Throwable $e) {
                $this->warn("No se pudo cerrar la encuesta {$survey->id}: {$e->getMessage()}");
            }
        }

        return $hechas;
    }

    // El detalle de la encuesta (editor y resultados) se guarda en caché
    // 24 horas; sin esto seguiría mostrando el estado anterior.
    private function limpiarCache(int $surveyId): void
    {
        Cache::forget("survey_detail_{$surveyId}_full");
        Cache::forget("survey_detail_{$surveyId}_anon");
    }
}