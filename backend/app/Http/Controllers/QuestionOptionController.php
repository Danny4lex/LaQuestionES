<?php

namespace App\Http\Controllers;

use App\Models\QuestionOption;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class QuestionOptionController extends Controller
{
    /**
     * Crea una opción de respuesta para una pregunta de selección.
     * Uso: agrega alternativas al formulario de pregunta múltiple.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'question_id' => 'required|exists:questions,id',
            'option_text' => 'required|string', // Cambiado de 'value' a 'option_text' según tu modelo
            'sort_order' => 'required|integer',
        ]);

        $option = QuestionOption::create($validated);
        return response()->json($option, 201);
    }

    /**
     * Actualiza el texto de una opción de pregunta.
     * Uso: edita la opción visible en el select o radio button.
     */
    public function update(Request $request, QuestionOption $questionOption): JsonResponse
    {
        $validated = $request->validate([
            'option_text' => 'required|string', // Ajustado a tu modelo
        ]);

        $questionOption->update($validated);
        return response()->json($questionOption, 200);
    }

    /**
     * Reordena las opciones de una pregunta.
     * Uso: guarda la posición de las alternativas en el diseñador.
     */
    public function reorder(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'options' => 'required|array',
            'options.*.id' => 'required|exists:question_options,id',
            'options.*.sort_order' => 'required|integer',
        ]);

        DB::transaction(function () use ($validated) {
            foreach ($validated['options'] as $item) {
                QuestionOption::where('id', $item['id'])->update(['sort_order' => $item['sort_order']]);
            }
        });

        return response()->json(['message' => 'Orden de las opciones actualizado.'], 200);
    }

    /**
     * Elimina una opción de respuesta de la pregunta.
     * Uso: borra la alternativa del catálogo de la pregunta.
     */
    public function destroy(QuestionOption $questionOption): JsonResponse
    {
        $questionOption->delete();
        return response()->json(['message' => 'Opción de selección eliminada.'], 200);
    }
}
