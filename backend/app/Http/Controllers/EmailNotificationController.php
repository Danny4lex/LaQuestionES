<?php

namespace App\Http\Controllers;

use App\Models\EmailNotification;
use App\Mail\SurveyInvitationMail;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;

// =========================================================================
// Envío real habilitado vía SurveyInvitationMail (app/Mail/). Requiere
// configurar MAIL_MAILER y credenciales reales en .env — sin eso, Laravel
// va a lanzar una excepción de conexión al intentar enviar, no un error
// silencioso, así que el estado 'fallido' sí refleja la realidad.
// =========================================================================
class EmailNotificationController extends Controller
{
    // =====================================================================
    // LISTADO — cola de notificaciones de una encuesta, filtrable por
    // estado (pendiente, enviado, fallido).
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
            'status' => 'nullable|string',
        ]);

        $notifications = EmailNotification::where('survey_id', $validated['survey_id'])
            ->when($request->status, fn($q, $v) => $q->where('status', $v))
            ->orderByDesc('created_at')
            ->get();

        return response()->json($notifications, 200);
    }

    // =====================================================================
    // ENVIAR — procesa las notificaciones pendientes de una encuesta,
    // enviando el correo real por cada una. Si una falla (ej. dirección
    // inválida, servidor SMTP caído), se marca 'fallido' individualmente
    // sin detener el envío de las demás.
    // =====================================================================
    public function send(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'survey_id' => 'required|exists:surveys,id',
        ]);

        $pending = EmailNotification::where('survey_id', $validated['survey_id'])
            ->where('status', 'pendiente')
            ->get();

        $sent = 0;
        $failed = 0;

        foreach ($pending as $notification) {
            try {
                Mail::to($notification->destination_email)->send(new SurveyInvitationMail($notification));

                $notification->update([
                    'status' => 'enviado',
                    'sent_at' => now(),
                ]);
                $sent++;
            } catch (\Throwable $e) {
                Log::error('Fallo al enviar EmailNotification #' . $notification->id . ': ' . $e->getMessage());
                $notification->update(['status' => 'fallido']);
                $failed++;
            }
        }

        return response()->json([
            'message' => "$sent notificación(es) enviada(s), $failed fallida(s).",
        ], 200);
    }

    // =====================================================================
    // REENVIAR — para un registro puntual que quedó en 'fallido'.
    // =====================================================================
    public function resend(EmailNotification $emailNotification): JsonResponse
    {
        try {
            Mail::to($emailNotification->destination_email)->send(new SurveyInvitationMail($emailNotification));

            $emailNotification->update([
                'status' => 'enviado',
                'sent_at' => now(),
            ]);

            return response()->json($emailNotification, 200);
        } catch (\Throwable $e) {
            Log::error('Fallo al reenviar EmailNotification #' . $emailNotification->id . ': ' . $e->getMessage());
            $emailNotification->update(['status' => 'fallido']);

            return response()->json([
                'message' => 'No se pudo reenviar el correo: ' . $e->getMessage(),
            ], 500);
        }
    }
}