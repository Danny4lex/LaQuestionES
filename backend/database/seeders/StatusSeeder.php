<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Status;

class StatusSeeder extends Seeder
{
    public function run(): void
    {
        // El "slug" es fijo para siempre — el código lo usa para decidir
        // (SurveyStatusFlowService, SurveyController, DashboardController).
        // El "name" es lo que ve el usuario y SÍ puede cambiar de texto
        // sin que nada se rompa.
        $statuses = [
            ['name' => 'Borrador', 'slug' => 'draft', 'description' => 'Creación y edición'],
            ['name' => 'En revisión', 'slug' => 'review', 'description' => 'Pendiente de validación por otros'],
            ['name' => 'Aprobada', 'slug' => 'approved', 'description' => 'Validada y lista para publicar'],
            ['name' => 'Rechazada', 'slug' => 'rejected', 'description' => 'Devuelta a borrador para corregir'],
            // NUEVO: intermedio entre "En revisión" y "Rechazada". El
            // Administrador la usa cuando NO aprueba la encuesta tal cual
            // está, pero tampoco es un rechazo total — deja comentarios
            // de corrección por sección (ver SectionComment) y la regresa
            // al Encuestador para que ajuste puntos específicos.
            ['name' => 'Corregida', 'slug' => 'needs_correction', 'description' => 'El Administrador solicitó correcciones puntuales; revisar los comentarios por sección'],
            ['name' => 'Programada', 'slug' => 'scheduled', 'description' => 'Aprobada pero esperando fecha de publicación'],
            ['name' => 'Activa', 'slug' => 'published', 'description' => 'Recibiendo respuestas'],
            ['name' => 'En pausa', 'slug' => 'paused', 'description' => 'Detenida temporalmente, se puede reanudar'],
            ['name' => 'Cerrada', 'slug' => 'closed', 'description' => 'Recogida de datos finalizada'],
            ['name' => 'Archivada', 'slug' => 'archived', 'description' => 'Almacenada para consulta futura'],
            ['name' => 'Eliminada / Desechada', 'slug' => 'deleted', 'description' => 'Borrada del sistema'],
        ];

        foreach ($statuses as $status) {
            // Se busca/actualiza por "slug" (estable), no por "name" (que
            // puede cambiar) — así, si alguien edita el texto visible de
            // un estado, el seeder no crea un duplicado por accidente.
            Status::updateOrCreate(
                ['slug' => $status['slug']],
                $status
            );
        }
    }
}