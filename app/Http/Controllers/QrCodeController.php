<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\QrCode as QrCodeModel;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

// =========================================================================
// Requiere: composer require simplesoftwareio/simple-qrcode
// La tabla qr_codes SOLO guarda la URL (según el diccionario de datos) —
// la imagen se genera al vuelo en cada request, nunca se persiste en BD.
// =========================================================================
class QrCodeController extends Controller
{
    // =====================================================================
    // GENERAR — crea el registro de QR para una encuesta pública.
    // =====================================================================
    public function generate(Survey $survey): JsonResponse
    {
        if ($survey->qrCode()->exists()) {
            return response()->json([
                'message' => 'Esta encuesta ya tiene un código QR generado. Use regenerate() si necesita uno nuevo.'
            ], 422);
        }

        $qrCode = QrCodeModel::create([
            'public_url' => $this->buildPublicUrl($survey),
            'generated_at' => now(),
            'survey_id' => $survey->id,
        ]);

        return response()->json($qrCode, 201);
    }

    // =====================================================================
    // REGENERAR — reemplaza el QR existente.
    // =====================================================================
    public function regenerate(Survey $survey): JsonResponse
    {
        $survey->qrCode()->delete();

        $qrCode = QrCodeModel::create([
            'public_url' => $this->buildPublicUrl($survey),
            'generated_at' => now(),
            'survey_id' => $survey->id,
        ]);

        return response()->json($qrCode, 201);
    }

    // =====================================================================
    // IMAGEN — devuelve la imagen SVG del QR, generada al vuelo a partir
    // de la public_url ya guardada. El frontend consume esto directo en
    // un <img src="..."> apuntando a esta ruta, o descarga el SVG.
    // =====================================================================
    public function image(Survey $survey)
    {
        $qrCode = $survey->qrCode()->first();

        if (!$qrCode) {
            return response()->json([
                'message' => 'Esta encuesta todavía no tiene un código QR generado. Use generate() primero.'
            ], 404);
        }

        $svg = QrCode::size(300)->generate($qrCode->public_url);

        return response($svg, 200)->header('Content-Type', 'image/svg+xml');
    }

    private function buildPublicUrl(Survey $survey): string
    {
        // FIX: apuntaba a "/encuestas/{id}", ruta que no existe en el
        // frontend. La ruta real para responder una encuesta pública es
        // "/survey/{id}/answer" (ver router/index.js y el enlace público
        // que ya arma SurveyListPage.vue -> enlacePublico).
        return config('app.frontend_url', 'http://localhost:5173') . '/survey/' . $survey->id . '/answer';
    }
}