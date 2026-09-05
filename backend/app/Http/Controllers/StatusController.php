<?php

namespace App\Http\Controllers;

use App\Models\Status;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class StatusController extends Controller
{
    private const CACHE_KEY = 'catalog_statuses';
    private const CACHE_TTL = 86400; // 24 horas

    /**
     * Retorna todos los estados disponibles para las encuestas.
     * Uso: llena el listado de estados de flujo en el frontend.
     * CORRECCIÓN: se agregó caché — este endpoint se había quedado sin
     * la optimización que sí recibieron TypeController y los demás
     * catálogos, y aparecía con el mismo piso de ~850-987ms en las
     * mediciones de rendimiento antes del ajuste.
     */
    public function index(): JsonResponse
    {
        $statuses = Cache::remember(self::CACHE_KEY, self::CACHE_TTL, fn () => Status::all());
        return response()->json($statuses, 200);
    }

    /**
     * Crea un nuevo estado de flujo.
     * Uso: define etapas como Borrador, Publicada o Cerrada.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100|unique:statuses,name',
            'description' => 'nullable|string',
        ]);

        $status = Status::create($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($status, 201);
    }

    /**
     * Muestra los datos de un estado.
     * Uso: visualiza la configuración de un estado específico.
     */
    public function show(Status $status): JsonResponse
    {
        return response()->json($status, 200);
    }

    /**
     * Actualiza un estado existente.
     * Uso: modifica nombre o descripción del flujo.
     */
    public function update(Request $request, Status $status): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100|unique:statuses,name,' . $status->id,
            'description' => 'nullable|string',
        ]);

        $status->update($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($status, 200);
    }

    /**
     * Elimina un estado de encuesta.
     * Uso: borra etapas que ya no se usan en el proceso.
     */
    public function destroy(Status $status): JsonResponse
    {
        $status->delete();
        Cache::forget(self::CACHE_KEY);

        return response()->json(['message' => 'Estado del flujo eliminado.'], 200);
    }
}