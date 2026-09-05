<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

// =========================================================================
// Middleware paramétrico de autorización: 'permission:surveys.changeStatus',
// 'permission:catalogs.manage', etc. Debe ir SIEMPRE después de
// AuthenticateSurveyUser (alias 'survey.auth'), que es quien deja el
// SurveyUser real en $request->user().
// =========================================================================
class CheckSurveyPermission
{
    public function handle(Request $request, Closure $next, string $ability): Response
    {
        $surveyUser = $request->user();

        if (!$surveyUser?->role?->hasPermission($ability)) {
            return response()->json([
                'message' => 'No tienes permiso para realizar esta acción.'
            ], 403);
        }

        return $next($request);
    }
}
