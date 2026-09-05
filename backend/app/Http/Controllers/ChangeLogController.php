<?php

namespace App\Http\Controllers;

use App\Models\ChangeLog;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

// =========================================================================
// Solo lectura por diseño: change_logs es la "pistola humeante" de
// auditoría del sistema (quién, cuándo, qué módulo, qué acción). No debe
// existir store/update/destroy — un log editable o borrable deja de servir
// como evidencia confiable.
// =========================================================================
class ChangeLogController extends Controller
{
    // =====================================================================
    // LISTADO — filtrable por módulo, usuario y rango de fechas, paginado
    // porque esta tabla crece indefinidamente con el uso del sistema.
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $logs = ChangeLog::with('user')
            ->when($request->module, fn($q, $v) => $q->where('module', $v))
            ->when($request->user_id, fn($q, $v) => $q->where('user_id', $v))
            // Filtro usado por el botón "Historial de cambios" del listado
            // de encuestas — trae solo los eventos de UNA encuesta.
            ->when($request->survey_id, fn($q, $v) => $q->where('survey_id', $v))
            ->when($request->date_from, fn($q, $v) => $q->where('action_date', '>=', $v))
            ->when($request->date_to, fn($q, $v) => $q->where('action_date', '<=', $v))
            ->orderByDesc('action_date')
            ->paginate($request->integer('per_page', 25));

        return response()->json($logs, 200);
    }

    // =====================================================================
    // DETALLE
    // =====================================================================
    public function show(ChangeLog $changeLog): JsonResponse
    {
        return response()->json($changeLog->load('user'), 200);
    }
}
