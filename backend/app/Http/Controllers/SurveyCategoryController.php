<?php

namespace App\Http\Controllers;

use App\Models\SurveyCategory;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class SurveyCategoryController extends Controller
{
    private const CACHE_KEY = 'catalog_survey_categories';
    private const CACHE_TTL = 86400; // 24 horas

    /**
     * Lista todas las categorías de encuestas.
     * Uso: llena el catálogo de categorías en la UI.
     */
    public function index()
{
    return Cache::remember('survey_categories_active', 86400, function () {
        return SurveyCategory::select('id', 'name', 'status')->where('status', true)->get();
    });
}

    /**
     * Crea una categoría nueva.
     * Uso: agrega clasificaciones para encuestas.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:150|unique:survey_categories,name',
            'description' => 'nullable|string',
        ]);

        $category = SurveyCategory::create($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($category, 201);
    }

    /**
     * Muestra los datos de una categoría.
     * Uso: visualiza la categoría para edición.
     */
    public function show(SurveyCategory $surveyCategory): JsonResponse
    {
        return response()->json($surveyCategory, 200);
    }

    /**
     * Actualiza una categoría existente.
     * Uso: edita nombre y descripción de clasificación.
     */
    public function update(Request $request, SurveyCategory $surveyCategory): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:150|unique:survey_categories,name,' . $surveyCategory->id,
            'description' => 'nullable|string',
        ]);

        $surveyCategory->update($validated);
        Cache::forget(self::CACHE_KEY);

        return response()->json($surveyCategory, 200);
    }

    /**
     * Elimina una categoría de encuesta.
     * Uso: remueve clasificaciones que ya no se usan.
     */
    public function destroy(SurveyCategory $surveyCategory): JsonResponse
    {
        $surveyCategory->delete();
        Cache::forget(self::CACHE_KEY);

        return response()->json(['message' => 'Categoría eliminada correctamente.'], 200);
    }
}
