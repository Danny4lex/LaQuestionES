<?php

namespace App\Services;

use App\Models\ChangeLog;
use Illuminate\Http\Request;

// =========================================================================
// Registro de auditoría reutilizable (módulo change_logs).
//
// Antes vivía como un método privado ("logChange") solo dentro de
// SurveyController, así que únicamente las acciones sobre la ENCUESTA en
// sí (crear/editar/cambiar estado/duplicar/eliminar) quedaban auditadas.
// Se extrae aquí como servicio para que cualquier controlador pueda
// registrar sus propias acciones (preguntas, secciones, plantillas,
// grupos, etc.) contra la regla del documento de requerimientos:
// "Registrar historial de modificaciones".
// =========================================================================
class ChangeLogService
{
    /**
     * $request es nullable porque los comandos programados (ej. el cierre
     * automático de encuestas vencidas, ver
     * App\Console\Commands\ApplySurveyVigencia) también deben quedar
     * auditados, y esos corren por consola sin un HTTP Request ni un
     * usuario autenticado — en ese caso user_id queda en null.
     */
    public function log(
        ?Request $request,
        string $module,
        string $action,
        string $description,
        ?int $surveyId = null
    ): void {
        ChangeLog::create([
            'module'      => $module,
            'action'      => $action,
            'description' => $description,
            'action_date' => now(),
            'user_id'     => $request?->user()?->id,
            'survey_id'   => $surveyId,
        ]);
    }
}
