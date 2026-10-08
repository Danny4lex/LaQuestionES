<?php

namespace App\Http\Controllers;

use App\Models\OrganizationalUnit;
use App\Models\Participant;
use App\Models\Survey;
use App\Models\SurveyUser;
use App\Models\EmailNotification;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

// =========================================================================
// NOTA DE ARQUITECTURA: este controlador es el lado ADMINISTRATIVO
// (requiere sesión, vive bajo el middleware auth.external). El acceso del
// participante final a su encuesta (sin login, vía access_token/QR) va a
// vivir en SurveyPublicController — paso 8 de la hoja de ruta, todavía
// pendiente — y NO pasa por este controlador ni por su middleware.
// =========================================================================
class ParticipantController extends Controller
{
    // =====================================================================
    // LISTADO — participantes de una encuesta puntual, filtrable por estado
    // de invitación (pendiente, enviado, respondido, expirado).
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
            'invitation_status' => 'nullable|string',
        ]);

        $participants = Participant::where('survey_id', $validated['survey_id'])
            ->when($request->invitation_status, fn($q, $v) => $q->where('invitation_status', $v))
            ->orderByDesc('registered_at')
            ->get();

        return response()->json($participants, 200);
    }

    // =====================================================================
    // DETALLE
    // =====================================================================
    public function show(Participant $participant): JsonResponse
    {
        $participant->load('survey');

        return response()->json($participant, 200);
    }

    // =====================================================================
    // INVITAR — crea el/los participante(s) para una encuesta PRIVADA y
    // deja en cola su notificación por correo. El access_token (UUID) se
    // genera automáticamente en el Model vía booted(), no aquí — así se
    // garantiza que nunca falte, sin importar desde qué controlador se cree.
    // =====================================================================
    public function invite(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
            'emails' => 'required|array|min:1',
            'emails.*' => 'required|email',
        ]);

        $participants = DB::transaction(function () use ($validated) {
            $created = [];

            foreach ($validated['emails'] as $email) {
                $participant = Participant::create([
                    'type' => 'invitado',
                    'email' => $email,
                    'invitation_status' => 'pendiente',
                    'registered_at' => now(),
                    'survey_id' => $validated['survey_id'],
                ]);

                // Se deja la notificación en cola; el envío real (SMTP) lo
                // resuelve EmailNotificationController::send(), no aquí —
                // este controlador solo se encarga de la lógica de invitación.
                EmailNotification::create([
                    'destination_email' => $email,
                    'subject' => 'Invitación a encuesta institucional',
                    'status' => 'pendiente',
                    'created_at' => now(),
                    'survey_id' => $validated['survey_id'],
                    'participant_id' => $participant->id,
                ]);

                $created[] = $participant;
            }

            return $created;
        });

        return response()->json([
            'message' => count($participants) . ' participante(s) invitado(s) correctamente.',
            'data' => $participants,
        ], 201);
    }
    // =====================================================================
    // ORGANIZACIÓN — miembros de la dependencia de la encuesta. Se toman de
    // survey_users (personas activas con ese dependency_id) y, si se pide,
    // de todas las sub-dependencias. Se excluye a quien está invitando.
    // =====================================================================
    private function miembrosOrganizacion(Request $request, Survey $survey, bool $incluirSub)
    {
        $ids = $incluirSub
            ? OrganizationalUnit::idsWithDescendants((int) $survey->dependency_id)
            : [(int) $survey->dependency_id];

        return SurveyUser::whereIn('dependency_id', $ids)
            ->where('is_active', true)
            ->whereNotNull('email')
            ->where('id', '!=', $request->user()?->id)
            ->get(['id', 'name', 'email']);
    }

    // Misma regla multi-dependencia del resto del sistema; devuelve la
    // respuesta de error o null si todo está bien.
    private function validarOrganizacion(Request $request, Survey $survey): ?JsonResponse
    {
        $user = $request->user();
        $puedeVerTodas = $user?->role?->hasPermission('surveys.viewAll') ?? false;

        if (!$puedeVerTodas && (int) $survey->dependency_id !== (int) $user?->dependency_id) {
            return response()->json(['message' => 'No tienes acceso a esta encuesta.'], 403);
        }

        if (!$survey->dependency_id) {
            return response()->json(['message' => 'Esta encuesta no tiene una dependencia asignada.'], 422);
        }

        return null;
    }

    private function correosYaInvitados(Survey $survey): array
    {
        return Participant::where('survey_id', $survey->id)
            ->whereNotNull('email')
            ->pluck('email')
            ->map(fn($e) => mb_strtolower($e))
            ->all();
    }

    // =====================================================================
    // VISTA PREVIA — cuántas personas tiene la organización y a cuántas
    // falta invitar, antes de pulsar el botón.
    // =====================================================================
    public function organizationPreview(Request $request, Survey $survey): JsonResponse
    {
        if ($error = $this->validarOrganizacion($request, $survey)) {
            return $error;
        }

        $miembros = $this->miembrosOrganizacion($request, $survey, $request->boolean('include_children'));
        $yaInvitados = $this->correosYaInvitados($survey);

        $porInvitar = $miembros->reject(fn($m) => in_array(mb_strtolower($m->email), $yaInvitados, true));

        return response()->json([
            'organization'     => $survey->department?->name,
            'total_members'    => $miembros->count(),
            'already_invited'  => $miembros->count() - $porInvitar->count(),
            'to_invite'        => $porInvitar->count(),
        ], 200);
    }

    // =====================================================================
    // INVITAR A TODA LA ORGANIZACIÓN — crea una invitación (con su propio
    // enlace) por cada miembro que todavía no esté invitado. Es seguro
    // repetirlo: solo agrega a quienes falten (por ejemplo, personas
    // nuevas en la organización). El envío real de los correos sigue siendo
    // "Enviar pendientes".
    // =====================================================================
    public function inviteOrganization(Request $request, Survey $survey): JsonResponse
    {
        if ($error = $this->validarOrganizacion($request, $survey)) {
            return $error;
        }

        $survey->loadMissing('status');

        if (in_array($survey->status?->slug, ['closed', 'archived', 'deleted'], true)) {
            return response()->json(['message' => 'No se puede invitar: la encuesta está cerrada.'], 422);
        }

        $miembros = $this->miembrosOrganizacion($request, $survey, $request->boolean('include_children'));
        $yaInvitados = $this->correosYaInvitados($survey);

        $porInvitar = $miembros->reject(fn($m) => in_array(mb_strtolower($m->email), $yaInvitados, true));

        if ($porInvitar->isEmpty()) {
            return response()->json([
                'message' => 'Todos los miembros de la organización ya estaban invitados.',
                'invited' => 0,
            ], 200);
        }

        DB::transaction(function () use ($porInvitar, $survey) {
            foreach ($porInvitar as $miembro) {
                $participant = Participant::create([
                    'type' => 'invitado',
                    'name' => $miembro->name,
                    'email' => $miembro->email,
                    'invitation_status' => 'pendiente',
                    'registered_at' => now(),
                    'survey_id' => $survey->id,
                ]);

                EmailNotification::create([
                    'destination_email' => $miembro->email,
                    'subject' => 'Invitación a encuesta institucional',
                    'status' => 'pendiente',
                    'created_at' => now(),
                    'survey_id' => $survey->id,
                    'participant_id' => $participant->id,
                ]);
            }
        });

        return response()->json([
            'message' => $porInvitar->count() . ' persona(s) de la organización agregada(s). Ahora presiona "Enviar pendientes" para mandar los correos.',
            'invited' => $porInvitar->count(),
        ], 201);
    }


    // =====================================================================
    // REVOCAR INVITACIÓN — bloqueado si el participante ya respondió, para
    // no perder una respuesta ya recolectada por accidente.
    // =====================================================================
    public function destroy(Participant $participant): JsonResponse
    {
        if ($participant->invitation_status === 'respondido') {
            return response()->json([
                'message' => 'No se puede revocar: el participante ya respondió la encuesta.'
            ], 422);
        }

        $participant->delete();

        return response()->json(['message' => 'Invitación revocada correctamente.'], 200);
    }
}
