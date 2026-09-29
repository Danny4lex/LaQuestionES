<?php

namespace App\Services;

use App\Models\Survey;
use App\Models\Status;
use InvalidArgumentException;

// =========================================================================
// Encapsula qué transiciones de estado son válidas para una encuesta.
//
// CORREGIDO: ya no traduce el nombre visible del catálogo a una clave
// canónica por coincidencia de palabra clave (str_contains) — ahora usa
// directamente la columna "slug" de la tabla statuses, que es estable
// aunque el texto visible (name) cambie. El mapeo de transiciones se
// define sobre esos slugs.
// =========================================================================
class SurveyStatusFlowService
{
    private const TRANSITIONS = [
        'draft' => ['review', 'deleted'],
        // NUEVO: desde revisión, el Administrador ahora tiene una tercera
        // opción además de aprobar/rechazar: "needs_correction", para
        // pedir ajustes puntuales (con comentarios por sección) sin que
        // cuente como un rechazo total.
        'review' => ['approved', 'rejected', 'needs_correction'],
        'rejected' => ['draft', 'deleted'],
        // NUEVO: el Encuestador puede volver a Borrador para editar, o
        // reenviar directo a revisión si los cambios ya fueron mínimos.
        'needs_correction' => ['draft', 'review', 'approved', 'published', 'deleted'],
        'approved' => ['scheduled', 'published'],
        'scheduled' => ['published', 'draft'],
        'published' => ['paused', 'closed'],
        'paused' => ['published', 'closed'],
        'closed' => ['archived'],
        'archived' => [], // Estado terminal.
        'deleted' => [], // Estado terminal.
    ];

    // Estados en los que SÍ se puede modificar el contenido de la
    // encuesta (título, secciones, preguntas). Una vez publicada o
    // cerrada (o cualquier estado posterior: scheduled, paused,
    // archived), el contenido queda congelado para no invalidar
    // resultados ya recolectados o en curso. El CAMBIO DE ESTADO en sí
    // (changeStatus/transition) es una acción aparte, no gobernada por
    // esta lista — el Administrador puede mover una encuesta entre
    // estados aunque no pueda editar su contenido.
    public const EDITABLE_STATUSES = ['draft', 'review', 'approved', 'rejected', 'needs_correction'];

    public function isEditable(Survey $survey): bool
    {
        $slug = $survey->status?->slug;
        return $slug !== null && in_array($slug, self::EDITABLE_STATUSES, true);
    }

    public function transition(Survey $survey, int $newStatusId): Survey
    {
        $currentStatus = $survey->status;
        $newStatus = Status::findOrFail($newStatusId);

        if (!$currentStatus) {
            $survey->update(['status_id' => $newStatusId]);
            return $survey->fresh('status');
        }

        if ($currentStatus->id === $newStatus->id) {
            return $survey;
        }

        $currentSlug = $currentStatus->slug;
        $newSlug = $newStatus->slug;

        $allowed = self::TRANSITIONS[$currentSlug] ?? [];

        if (!in_array($newSlug, $allowed, true)) {
            throw new InvalidArgumentException(
                "No se puede pasar de \"{$currentStatus->name}\" a \"{$newStatus->name}\". " .
                'Transiciones permitidas desde este estado: ' . (empty($allowed) ? 'ninguna (estado terminal)' : implode(', ', $allowed))
            );
        }

        $survey->update(['status_id' => $newStatusId]);

        return $survey->fresh('status');
    }
}