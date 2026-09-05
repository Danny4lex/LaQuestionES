<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Models\GroupParticipant;
use App\Services\ChangeLogService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class GroupController extends Controller
{
    public function __construct(
        private readonly ChangeLogService $changeLogService
    ) {}

    // =====================================================================
    // LISTADO — grupos de la dependencia del usuario, con el conteo de
    // participantes ya incluido para no tener que consultarlo aparte.
    // FIX: antes confiaba ciegamente en ?dependency_id= del cliente, lo
    // que permitía a cualquier usuario autenticado listar grupos de OTRA
    // dependencia con solo cambiar el query param. Se aplica el mismo
    // criterio de autorización que SurveyController::index — solo quien
    // tiene el permiso 'surveys.viewAll' puede ver/filtrar libremente;
    // el resto queda forzado a su propia dependencia.
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $query = Group::with('department')->withCount('groupParticipants');

        $puedeVerTodas = $request->user()?->role?->hasPermission('surveys.viewAll') ?? false;

        if ($puedeVerTodas) {
            if ($request->has('dependency_id')) {
                $query->where('dependency_id', $request->dependency_id);
            }
        } else {
            $query->where('dependency_id', $request->user()?->dependency_id);
        }

        $groups = $query->orderByDesc('created_at')->get();

        return response()->json($groups, 200);
    }

    // =====================================================================
    // DETALLE — incluye el listado completo de participantes del grupo
    // (tanto funcionarios internos como ciudadanos externos por email).
    // =====================================================================
    public function show(Group $group): JsonResponse
    {
        $group->load(['department', 'creator', 'groupParticipants.user']);

        return response()->json($group, 200);
    }

    // =====================================================================
    // CREAR — "created_by" NUNCA se recibe del cliente, viene de la sesión
    // autenticada (mismo criterio de seguridad aplicado en SurveyController
    // y TemplateController: evitar que alguien suplante la autoría).
    // =====================================================================
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'dependency_id' => 'required|exists:organizational_units,id',
        ]);

        // Mismo criterio que en index(): sin 'surveys.viewAll' no se
        // puede crear un grupo "a nombre" de otra dependencia con solo
        // mandar otro dependency_id en el body.
        $puedeVerTodas = $request->user()?->role?->hasPermission('surveys.viewAll') ?? false;
        if (!$puedeVerTodas) {
            $validated['dependency_id'] = $request->user()?->dependency_id;
        }

        $group = Group::create([
            ...$validated,
            'created_by' => $request->user()->id,
        ]);

        $this->changeLogService->log(
            $request,
            'Group',
            'Creación',
            "Se creó el grupo de participantes \"{$group->name}\"."
        );

        return response()->json($group, 201);
    }

    // =====================================================================
    // ACTUALIZAR
    // =====================================================================
    public function update(Request $request, Group $group): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $group->update($validated);

        $this->changeLogService->log(
            $request,
            'Group',
            'Edición',
            "Se editó el grupo de participantes \"{$group->name}\"."
        );

        return response()->json($group, 200);
    }

    // =====================================================================
    // ELIMINAR
    // =====================================================================
    public function destroy(Request $request, Group $group): JsonResponse
    {
        $nombre = $group->name;
        $group->delete();

        $this->changeLogService->log(
            $request,
            'Group',
            'Eliminación',
            "Se eliminó el grupo de participantes \"{$nombre}\"."
        );

        return response()->json(['message' => 'Grupo eliminado correctamente.'], 200);
    }

    // =====================================================================
    // AGREGAR PARTICIPANTE AL GRUPO — regla de negocio del diccionario:
    // solo uno de los dos (external_email o user_id) debe tener valor por
    // registro. Se valida explícitamente aquí porque la base de datos no
    // tiene un CHECK constraint nativo para forzarlo.
    // =====================================================================
    public function addParticipant(Request $request, Group $group): JsonResponse
    {
        $validated = $request->validate([
            'external_email' => 'nullable|email|required_without:user_id',
            'user_id' => 'nullable|exists:users,id|required_without:external_email',
        ]);

        if (!empty($validated['external_email']) && !empty($validated['user_id'])) {
            return response()->json([
                'message' => 'Debe indicar external_email O user_id, no ambos a la vez.'
            ], 422);
        }

        $participant = GroupParticipant::create([
            'external_email' => $validated['external_email'] ?? null,
            'user_id' => $validated['user_id'] ?? null,
            'group_id' => $group->group_id,
        ]);

        $this->changeLogService->log(
            $request,
            'Group',
            'Participante agregado',
            "Se agregó a " . ($validated['external_email'] ?? "el usuario #{$validated['user_id']}")
                . " al grupo \"{$group->name}\"."
        );

        return response()->json($participant, 201);
    }

    // =====================================================================
    // QUITAR PARTICIPANTE DEL GRUPO
    // =====================================================================
    public function removeParticipant(Request $request, Group $group, GroupParticipant $groupParticipant): JsonResponse
    {
        if ($groupParticipant->group_id !== $group->group_id) {
            return response()->json([
                'message' => 'Ese participante no pertenece a este grupo.'
            ], 422);
        }

        $identificador = $groupParticipant->external_email ?? "usuario #{$groupParticipant->user_id}";
        $groupParticipant->delete();

        $this->changeLogService->log(
            $request,
            'Group',
            'Participante removido',
            "Se quitó a {$identificador} del grupo \"{$group->name}\"."
        );

        return response()->json(['message' => 'Participante removido del grupo.'], 200);
    }
}
