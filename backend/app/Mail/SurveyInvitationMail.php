<?php

namespace App\Mail;

use App\Models\EmailNotification;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

// =========================================================================
// Representa el correo real de invitación a una encuesta. Se le pasa el
// registro de EmailNotification (que ya trae el destino, el asunto, y la
// relación hacia la encuesta/participante) y arma el correo a partir de
// esos datos, en vez de tener la lógica de armado dispersa en el Controller.
// =========================================================================
class SurveyInvitationMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public EmailNotification $notification)
    {
    }

    public function build()
    {
        $survey = $this->notification->survey;
        $participant = $this->notification->participant;

        // El enlace de acceso depende de si el participante fue invitado
        // (tiene access_token propio, encuesta privada) o si es un envío
        // masivo hacia una encuesta pública (usa el ID directo).
        $accessUrl = $participant && $participant->access_token
            ? config('app.frontend_url', 'http://localhost:5173') . '/encuestas/token/' . $participant->access_token
            : config('app.frontend_url', 'http://localhost:5173') . '/encuestas/' . $survey->id;

        return $this
            ->subject($this->notification->subject)
            ->view('emails.survey-invitation')
            ->with([
                'surveyTitle' => $survey->title,
                'surveyDescription' => $survey->description,
                'participantName' => $participant->name ?? 'Estimado/a participante',
                'accessUrl' => $accessUrl,
            ]);
    }
}
