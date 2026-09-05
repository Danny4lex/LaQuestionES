<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use App\Models\SurveyUser;
use Encrypt;
use Hash;
use Http;
use Log;

class AuthController extends Controller
{
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['login']]);
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
        public function login()
    {
        $credentials = request(['email', 'password']);

        if (!$token = auth('api')->attempt($credentials)) {
            return response()->json([
                'message' => 'Credenciales no válidas',
                'error' => 'Unauthorized'
            ], 401);
        }

        $user = auth('api')->user();

        return response()->json([
            'message' => 'Token generado correctamente.',
            'data' => [
                'backend' => [
                    'access_token' => $token,
                    'token_type' => 'Bearer',
                    'expires_in' => auth('api')->factory()->getTTL() * 60,
                    'refresh_token' => auth('api')->setTTL(8600)->claims(['token_type' => 'refresh'])->refresh(),
                ],
                'user' => $user->format(),
                // Perfil e identidad dentro del módulo de encuestas — es lo
                // que el frontend usa para saber qué botones mostrar
                // (surveys.create, surveys.changeStatus, catalogs.manage...).
                // Puede venir null si el usuario de login no tiene un
                // SurveyUser vinculado todavía (no tiene acceso al módulo).
                'survey_profile' => $this->buildSurveyProfile($user),
            ]
        ]);
    }

    // Resuelve el SurveyUser ligado a este login (por external_id, ver
    // AuthenticateSurveyUser) y lo formatea para el frontend.
    private function buildSurveyProfile(User $user): ?array
    {
        $surveyUser = SurveyUser::with(['role', 'dependency'])
            ->where('external_id', (string) $user->id)
            ->first();

        if (!$surveyUser) {
            return null;
        }

        return [
            'id'          => $surveyUser->id,
            'name'        => $surveyUser->name,
            'is_active'   => $surveyUser->is_active,
            'role'        => $surveyUser->role?->name,
            'permissions' => $surveyUser->role?->permissions ?? [],
            'dependency'  => $surveyUser->dependency ? [
                'id'   => $surveyUser->dependency->id,
                'name' => $surveyUser->dependency->name,
            ] : null,
        ];
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function loginSso()
    {
        $credentials = request(['email', 'password']);

        if (!$token = auth('api')->attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        return $this->respondWithToken($token);
    }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function me()
    {
        $authUser = auth('api')->user();

        return response()->json([
            'status' => 'success',
            'message' => 'Usuario encontrado satisfactoriamente.',
            'user' => $authUser->format(),
            'survey_profile' => $this->buildSurveyProfile($authUser),
        ]);
    }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout()
    {
        auth('api')->logout();

        return response()->json([
            'status' => 'success',
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function refresh()
    {
        return $this->respondWithToken(auth('api')->refresh());
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function respondWithToken($token)
    {
        return response()->json([
            'status' => 'success',
            'message' => 'Token generado correctamente.',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'expires_in' => auth('api')->factory()->getTTL() * 60
        ]);
    }
}
