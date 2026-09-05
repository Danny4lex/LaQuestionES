<?php

namespace App\Http\Middleware;

use App\Models\SurveyUser;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

// =========================================================================
// AUTENTICACIÓN REAL DEL MÓDULO DE ENCUESTAS.
//
// Reemplaza a FakeAuthMiddleware (que simulaba siempre un Administrador,
// sin importar quién iniciara sesión). Se apoya en el JWT real que ya
// emite AuthController::login() (auth('api') / tabla "users" de
// base-app-2) — este middleware debe ir SIEMPRE después de 'auth:api' en
// la ruta, para que auth('api')->user() ya esté resuelto.
//
// El puente entre el usuario de login (App\Models\User) y su identidad
// dentro de encuestas-mc (App\Models\SurveyUser) es "external_id": se
// guarda ahí el id del usuario real de base-app-2 (como string), tal
// como estaba previsto en el comentario original de SurveyUser para la
// futura integración con login-mc.
// =========================================================================
class AuthenticateSurveyUser
{
    public function handle(Request $request, Closure $next): Response
    {
        $loggedUser = auth('api')->user();

        if (!$loggedUser) {
            return response()->json(['message' => 'No autenticado.'], 401);
        }

        $surveyUser = SurveyUser::with('role')
            ->where('external_id', (string) $loggedUser->id)
            ->first();

        if (!$surveyUser) {
            return response()->json([
                'message' => 'Tu cuenta no tiene un perfil configurado en el módulo de encuestas.'
            ], 403);
        }

        if (!$surveyUser->is_active) {
            return response()->json(['message' => 'Tu cuenta en el módulo de encuestas está inactiva.'], 403);
        }

        if (!$surveyUser->role || !$surveyUser->role->hasPermission('admin.access')) {
            return response()->json([
                'message' => 'Tu rol no tiene acceso al panel administrativo de encuestas.'
            ], 403);
        }

        // A partir de aquí, $request->user() en cualquier controller de la
        // zona admin devuelve el SurveyUser real (con su rol cargado),
        // exactamente como ya lo hacía FakeAuthMiddleware — ningún
        // controller necesita cambiar.
        $request->setUserResolver(fn () => $surveyUser);

        return $next($request);
    }
}
