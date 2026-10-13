<?php

namespace App\Http\Controllers;

use App\Models\Participant;
use App\Models\Survey;
use App\Models\QrCode as QrCodeModel;
use Illuminate\Http\JsonResponse;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

// =========================================================================
// El QR sirve para COMPARTIR la encuesta: al escanearlo, el encuestado
// llega directo a la página donde la responde.
//
// - Encuesta PÚBLICA: un QR general -> {FRONTEND_URL}/survey/{id}/answer
// - Encuesta PRIVADA: un QR por invitado -> {FRONTEND_URL}/responder/{token}
//
// La tabla qr_codes conserva el registro (fecha de generación y última URL),
// pero la URL que se codifica en la imagen SIEMPRE se arma al momento con
// FRONTEND_URL, así un cambio de dominio no deja QR apuntando a la dirección
// vieja.
// =========================================================================
class QrCodeController extends Controller
{
    // =====================================================================
    // INFO — datos del QR de una encuesta pública (URL vigente y fecha).
    // =====================================================================
    public function show(Survey $survey): JsonResponse
    {
        if ($error = $this->exigirPublica($survey)) {
            return $error;
        }

        $qrCode = $survey->qrCode()->first();

        if (!$qrCode) {
            return response()->json([
                'message' => 'Esta encuesta todavía no tiene un código QR generado.'
            ], 404);
        }

        $url = $this->syncPublicUrl($qrCode, $survey);

        return response()->json([
            'public_url'   => $url,
            'generated_at' => $qrCode->generated_at,
        ], 200);
    }

    // =====================================================================
    // GENERAR — crea el registro de QR para una encuesta pública.
    // =====================================================================
    public function generate(Survey $survey): JsonResponse
    {
        if ($error = $this->exigirPublica($survey)) {
            return $error;
        }

        if ($survey->qrCode()->exists()) {
            return response()->json([
                'message' => 'Esta encuesta ya tiene un código QR generado. Use regenerate() si necesita uno nuevo.'
            ], 422);
        }

        $qrCode = QrCodeModel::create([
            'public_url'   => $this->buildPublicUrl($survey),
            'generated_at' => now(),
            'survey_id'    => $survey->id,
        ]);

        return response()->json($qrCode, 201);
    }

    // =====================================================================
    // REGENERAR — reemplaza el registro existente (nueva fecha y URL vigente).
    // =====================================================================
    public function regenerate(Survey $survey): JsonResponse
    {
        if ($error = $this->exigirPublica($survey)) {
            return $error;
        }

        $survey->qrCode()->delete();

        $qrCode = QrCodeModel::create([
            'public_url'   => $this->buildPublicUrl($survey),
            'generated_at' => now(),
            'survey_id'    => $survey->id,
        ]);

        return response()->json($qrCode, 201);
    }

    // =====================================================================
    // IMAGEN — SVG del QR de la encuesta pública, generado al vuelo.
    // =====================================================================
    public function image(Survey $survey)
    {
        if ($error = $this->exigirPublica($survey)) {
            return $error;
        }

        $qrCode = $survey->qrCode()->first();

        if (!$qrCode) {
            return response()->json([
                'message' => 'Esta encuesta todavía no tiene un código QR generado. Use generate() primero.'
            ], 404);
        }

        $url = $this->syncPublicUrl($qrCode, $survey);

        return $this->svgResponse($url);
    }

    // =====================================================================
    // IMAGEN POR INVITADO — QR del enlace individual de una encuesta privada.
    // No se guarda nada: el token del participante ya vive en participants.
    // =====================================================================
    public function participantImage(Participant $participant)
    {
        if ($participant->type !== 'invitado' || !$participant->access_token) {
            return response()->json([
                'message' => 'Solo los participantes invitados tienen un enlace individual.'
            ], 422);
        }

        if ($participant->invitation_status === 'respondido') {
            return response()->json([
                'message' => 'Este participante ya respondió; su enlace ya no es válido.'
            ], 409);
        }

        return $this->svgResponse($this->buildParticipantUrl($participant));
    }

    // ---------------------------------------------------------------------

    private function svgResponse(string $url)
    {
        // Margen de 2 módulos y corrección de errores "M": lectura estable
        // tanto en pantalla como impreso.
        $svg = QrCode::format('svg')
            ->size(512)
            ->margin(2)
            ->errorCorrection('M')
            ->generate($url);

        return response($svg, 200)
            ->header('Content-Type', 'image/svg+xml')
            ->header('Cache-Control', 'no-store');
    }

    private function exigirPublica(Survey $survey): ?JsonResponse
    {
        if (!$this->esPublica($survey)) {
            return response()->json([
                'message' => 'El código QR general solo está disponible para encuestas públicas. '
                    . 'Las encuestas privadas se comparten con el enlace individual de cada invitado.'
            ], 422);
        }

        return null;
    }

    private function esPublica(Survey $survey): bool
    {
        return mb_stripos($survey->type?->name ?? '', 'públic') !== false;
    }

    // Mantiene qr_codes.public_url al día con la URL vigente.
    private function syncPublicUrl(QrCodeModel $qrCode, Survey $survey): string
    {
        $url = $this->buildPublicUrl($survey);

        if ($qrCode->public_url !== $url) {
            $qrCode->update(['public_url' => $url]);
        }

        return $url;
    }

    private function frontendBase(): string
    {
        return rtrim((string) config('app.frontend_url', 'http://localhost:5173'), '/');
    }

    private function buildPublicUrl(Survey $survey): string
    {
        return $this->frontendBase() . '/survey/' . $survey->id . '/answer';
    }

    private function buildParticipantUrl(Participant $participant): string
    {
        return $this->frontendBase() . '/responder/' . $participant->access_token;
    }
}
