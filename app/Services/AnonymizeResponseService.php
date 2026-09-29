<?php

namespace App\Services;

use App\Models\Survey;
use App\Models\Participant;
use App\Models\Response as SurveyResponse;
use Illuminate\Http\Request;

// =========================================================================
// Encapsula la regla de negocio más delicada del diccionario de datos:
// decidir si una respuesta queda ligada a un participant_id real o si debe
// quedar anónima (participant_id = NULL + anonymous_identifier generado),
// y controlar duplicados según is_single_response.
//
// Una encuesta es anónima cuando surveys.is_anonymous = true. En ese caso
// NUNCA se guardan nombre, correo ni teléfono, aunque el cliente los envíe.
// =========================================================================
class AnonymizeResponseService
{
    // =====================================================================
    // Resuelve (o crea) el Participant correspondiente a una respuesta
    // pública.
    //
    // - Encuesta anónima: participante "anonimo" sin ningún dato personal.
    // - Encuesta identificada: se reutiliza el participante de esa misma
    //   encuesta con el mismo correo (así "una respuesta por persona"
    //   realmente funciona) y se actualizan sus datos.
    // =====================================================================
    public function resolvePublicParticipant(Survey $survey, Request $request): Participant
    {
        if ($survey->is_anonymous) {
            return Participant::create([
                'type' => 'anonimo',
                'invitation_status' => null,
                'registered_at' => now(),
                'survey_id' => $survey->id,
            ]);
        }

        $email = mb_strtolower(trim((string) $request->input('email')));

        $participant = Participant::where('survey_id', $survey->id)
            ->where('type', 'identificado')
            ->where('email', $email)
            ->first();

        $data = [
            'name' => $request->input('name'),
            'email' => $email,
            'phone' => $request->input('phone'),
        ];

        if ($participant) {
            $participant->update($data);
            return $participant;
        }

        return Participant::create($data + [
            'type' => 'identificado',
            'invitation_status' => null, // No aplica: no hubo invitación previa.
            'registered_at' => now(),
            'survey_id' => $survey->id,
        ]);
    }

    // =====================================================================
    // Verifica si, dado el flag is_single_response de la encuesta, esta
    // persona ya respondió antes.
    //
    // - Participantes IDENTIFICADOS o INVITADOS: verificación exacta por
    //   participant_id (100% confiable).
    // - Respuestas ANÓNIMAS: verificación por IP de origen (source_ip).
    //   Es una heurística práctica, no perfecta: varias personas detrás de
    //   la misma IP podrían compartir el bloqueo, y una IP dinámica podría
    //   evitarlo. Se documenta la limitación, no se oculta.
    // =====================================================================
    public function alreadyResponded(Survey $survey, Participant $participant, Request $request): bool
    {
        if ($survey->is_anonymous || $participant->type === 'anonimo') {
            return SurveyResponse::where('survey_id', $survey->id)
                ->whereNull('participant_id')
                ->where('source_ip', $request->ip())
                ->exists();
        }

        return $survey->responses()
            ->where('participant_id', $participant->id)
            ->exists();
    }
}
