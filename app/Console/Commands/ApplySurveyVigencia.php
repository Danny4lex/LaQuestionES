<?php

namespace App\Console\Commands;

use App\Models\Status;
use App\Models\Survey;
use App\Services\ChangeLogService;
use App\Services\SurveyStatusFlowService;
use Illuminate\Console\Command;

// =========================================================================
// Automatización de vigencia (regla del documento de requerimientos:
// "Controlar la vigencia de las encuestas").
//
// Antes, start_date/end_date solo se guardaban como datos informativos:
// una encuesta "scheduled" nunca pasaba sola a "published" el día que
// tocaba, y una "published" que ya venció su end_date se quedaba
// recibiendo respuestas indefinidamente hasta que alguien la cerrara a
// mano. Kernel::schedule() estaba vacío, sin ningún comando registrado.
//
// Este comando:
//   1. Publica automáticamente las encuestas en estado "scheduled" cuya
//      start_date ya llegó (start_date <= hoy).
//   2. Cierra automáticamente las encuestas en estado "published" cuya
//      end_date ya pasó (end_date < hoy).
//
// Reutiliza SurveyStatusFlowService para que la transición respete las
// mismas reglas que un cambio de estado manual, y ChangeLogService para
// dejar rastro de auditoría de cada cambio automático.
// =========================================================================
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
            ->whereDate('start_date', '<=', now())
            ->get();

        foreach ($surveys as $survey) {
            $statusFlow->transition($survey, $publishedStatus->id);
            $changeLog->log(
                null,
                'Survey',
                'Publicación automática',
                "La encuesta \"{$survey->title}\" se publicó automáticamente al llegar su fecha de inicio ({$survey->start_date}).",
                $survey->id
            );
        }

        return $surveys->count();
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
            ->whereDate('end_date', '<', now())
            ->get();

        foreach ($surveys as $survey) {
            $statusFlow->transition($survey, $closedStatus->id);
            $changeLog->log(
                null,
                'Survey',
                'Cierre automático',
                "La encuesta \"{$survey->title}\" se cerró automáticamente al vencer su fecha de fin ({$survey->end_date}).",
                $survey->id
            );
        }

        return $surveys->count();
    }
}
