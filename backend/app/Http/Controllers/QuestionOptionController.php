<?php

namespace App\Http\Controllers;

use App\Models\QuestionOption;
use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;

class QuestionOptionController extends Controller
{
    private function surveyIdDeLaOpcion(QuestionOption $questionOption): ?int
    {
        return $questionOption->question?->section?->survey_id;
    }

    private function surveyIdDeLaPregunta(int $questionId): ?int
    {
        return Question::find($questionId)?->section?->survey_id;
    }

    private function clearSurveyCache(?int $surveyId): void
    {
        if ($surveyId) {
            Cache::forget("survey_detail_{$surveyId}_full");
            Cache::forget("survey_detail_{$surveyId}_anon");
        }
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'question_id' => 'required|exists:questions,id',
            'option_text' => 'required|string',
            'sort_order'  => 'required|integer',
        ]);

        $option = QuestionOption::create($validated);
        $this->clearSurveyCache($this->surveyIdDeLaPregunta($validated['question_id']));

        return response()->json($option, 201);
    }

    public function update(Request $request, QuestionOption $questionOption): JsonResponse
    {
        $validated = $request->validate([
            'option_text' => 'required|string',
        ]);

        $questionOption->update($validated);
        $this->clearSurveyCache($this->surveyIdDeLaOpcion($questionOption));

        return response()->json($questionOption, 200);
    }

    public function reorder(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'options'              => 'required|array',
            'options.*.id'         => 'required|exists:question_options,id',
            'options.*.sort_order' => 'required|integer',
        ]);

        $firstOptionId = $validated['options'][0]['id'] ?? null;
        $surveyId = null;

        if ($firstOptionId) {
            $firstOption = QuestionOption::find($firstOptionId);
            if ($firstOption) {
                $surveyId = $this->surveyIdDeLaOpcion($firstOption);
            }
        }

        DB::transaction(function () use ($validated) {
            foreach ($validated['options'] as $item) {
                QuestionOption::where('id', $item['id'])->update(['sort_order' => $item['sort_order']]);
            }
        });

        $this->clearSurveyCache($surveyId);

        return response()->json(['message' => 'Orden de las opciones actualizado.'], 200);
    }

    public function destroy(QuestionOption $questionOption): JsonResponse
    {
        $surveyId = $this->surveyIdDeLaOpcion($questionOption);
        $questionOption->delete();
        $this->clearSurveyCache($surveyId);

        return response()->json(['message' => 'Opción de selección eliminada.'], 200);
    }
}