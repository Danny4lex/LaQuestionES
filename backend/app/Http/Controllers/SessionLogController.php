<?php

namespace App\Http\Controllers;

use App\Models\SessionLog;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

// =========================================================================
// Solo lectura por diseño, mismo criterio que ChangeLogController: registro
// de auditoría de accesos administrativos, no debe ser editable.
// =========================================================================
class SessionLogController extends Controller
{
    // =====================================================================
    // LISTADO — filtrable por usuario y estado (éxito/fallo), paginado.
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $logs = SessionLog::with('user')
            ->when($request->user_id, fn($q, $v) => $q->where('user_id', $v))
            ->when($request->status, fn($q, $v) => $q->where('status', $v))
            ->orderByDesc('access_date')
            ->paginate($request->integer('per_page', 25));

        return response()->json($logs, 200);
    }

    // =====================================================================
    // DETALLE
    // =====================================================================
    public function show(SessionLog $sessionLog): JsonResponse
    {
        return response()->json($sessionLog->load('user'), 200);
    }
}
