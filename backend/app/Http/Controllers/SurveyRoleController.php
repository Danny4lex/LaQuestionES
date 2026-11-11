<?php

namespace App\Http\Controllers;

use App\Models\SurveyRole;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SurveyRoleController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(SurveyRole::all(), 200);
    }

    public function show(SurveyRole $surveyRole): JsonResponse
    {
        $surveyRole->loadCount('users');
        return response()->json($surveyRole, 200);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:survey_roles,name',
            'description' => 'nullable|string',
        ]);

        $role = SurveyRole::create($validated);
        return response()->json($role, 201);
    }

    public function update(Request $request, SurveyRole $surveyRole): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255|unique:survey_roles,name,' . $surveyRole->id,
            'description' => 'nullable|string',
        ]);

        $surveyRole->update($validated);
        return response()->json($surveyRole, 200);
    }

    public function destroy(SurveyRole $surveyRole): JsonResponse
    {
        if ($surveyRole->users()->exists()) {
            return response()->json([
                'message' => 'No se puede eliminar: hay usuarios asignados a este rol.'
            ], 422);
        }

        $surveyRole->delete();
        return response()->json(['message' => 'Rol eliminado correctamente.'], 200);
    }
}
