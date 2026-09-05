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
// =========================================================================
class AnonymizeResponseService
{
    // =====================================================================
    // Resuelve (o crea) el Participant correspondiente a una respuesta
    // pública, según el tipo de encuesta y si la persona se identificó
    // voluntariamente (nombre/email) o no.
    // =====================================================================
    public function resolvePublicParticipant(Survey $survey, Request $request): Participant
    {
        $identifiesVoluntarily = $request->filled('name') || $request->filled('email');

        return Participant::create([
            'type' => $identifiesVoluntarily ? 'identificado' : 'anonimo',
            'name' => $request->input('name'),
            'email' => $request->input('email'),
            'phone' => $request->input('phone'),
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
    // - Participantes ANÓNIMOS: verificación por IP de origen (source_ip),
    //   tal como está previsto en el diccionario de datos ("Trazabilidad
    //   sin romper anonimato"). Es una heurística práctica, no perfecta:
    //   varias personas detrás de la misma IP (red de oficina, WiFi
    //   público) podrían compartir el bloqueo; alguien con IP dinámica
    //   podría evitarlo. Se documenta la limitación, no se oculta.
    // =====================================================================
    public function alreadyResponded(Survey $survey, Participant $participant, Request $request): bool
    {
        if ($participant->type === 'anonimo') {
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
