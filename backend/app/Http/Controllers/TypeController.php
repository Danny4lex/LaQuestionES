<?php

namespace App\Http\Controllers;

use App\Models\Type;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class TypeController extends Controller
{
    private const CACHE_KEY = 'catalog_types';
    private const CACHE_TTL = 86400; // 24 horas

    /**
     * Devuelve la lista completa de tipos de encuesta.
     * Uso: llena el catálogo de modalidades disponibles.
     */
    public function index(): JsonResponse
    {
        $types = Cache::remember(self::CACHE_KEY, self::CACHE_TTL, fn () => Type::all());
        return response()->json($types, 200);
    }

    /**
     * Crea un tipo nuevo.
     * Uso: agrega nuevas modalidades a la encuesta (en la práctica: Pública/Privada).
     * CORRECCIÓN: se removió "slug" — la tabla "types" solo tiene name y
     * description; validarlo no tenía ningún efecto real.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100|unique:types,name',
            'description' => 'nullable|string',
        ]);

        $type = Type::create($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($type, 201);
    }

    /**
     * Muestra un tipo de encuesta específico.
     * Uso: visualiza los detalles para edición.
     */
    public function show(Type $type): JsonResponse
    {
        return response()->json($type, 200);
    }

    /**
     * Actualiza un tipo existente.
     * Uso: edita nombre o descripción del tipo.
     * CORRECCIÓN: se removió "slug" por la misma razón que en store().
     */
    public function update(Request $request, Type $type): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100|unique:types,name,' . $type->id,
            'description' => 'nullable|string',
        ]);

        $type->update($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($type, 200);
    }

    /**
     * Elimina un tipo de encuesta.
     * Uso: borra modalidades que ya no se usan.
     */
    public function destroy(Type $type): JsonResponse
    {
        $type->delete();
        Cache::forget(self::CACHE_KEY);

        return response()->json(['message' => 'Tipo eliminado con éxito.'], 200);
    }
}
