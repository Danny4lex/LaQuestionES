<?php

namespace App\Http\Middleware;

use App\Models\SurveyRole;
use App\Models\SurveyUser;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

// =========================================================================
// DEPRECADO — ya NO está enlazado a ningún alias de Kernel.php.
//
// Reemplazado por AuthenticateSurveyUser, que resuelve el SurveyUser real
// a partir del JWT de login (auth('api')) en vez de simular siempre un
// Administrador. Se conserva el archivo solo como referencia histórica
// de cómo se probó el módulo antes de tener login real conectado.
// =========================================================================
class FakeAuthMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        $fakeRole = SurveyRole::firstOrCreate(['name' => 'Administrador']);

        $fakeUser = SurveyUser::firstOrCreate(
            ['email' => 'dev.local@encuestas-mc.test'],
            [
                'external_id' => 'FAKE-DEV-001',
                'name' => 'Usuario de Prueba (Dev Local)',
                'is_active' => true,
                'role_id' => $fakeRole->id,
                'dependency_id' => null,
            ]
        );

        $request->setUserResolver(fn () => $fakeUser);

        return $next($request);
    }
}