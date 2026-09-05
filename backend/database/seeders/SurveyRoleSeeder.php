<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\SurveyRole;

class SurveyRoleSeeder extends Seeder
{
    // "permissions" es lo que de verdad controla el acceso — ver
    // AuthenticateSurveyUser (exige "admin.access" para entrar al panel)
    // y CheckSurveyPermission (exige la habilidad puntual de cada ruta).
    public function run(): void
    {
        $roles = [
            [
                'name'        => 'Administrador',
                'description' => 'Acceso total al sistema de encuestas, todas las dependencias',
                'permissions' => [
                    'admin.access',
                    'surveys.create',
                    'surveys.delete',
                    'surveys.viewAll',   // ve/filtra encuestas de TODAS las dependencias
                    'status.moderate',   // aprobar, rechazar y cualquier otra transición de estado
                    'status.submitForReview',
                    'status.publish',
                    'surveys.respond',
                    'changelogs.view',
                    'catalogs.manage',
                ],
            ],
            [
                // Crea y edita encuestas de SU PROPIA dependencia. Puede
                // enviarlas a revisión y publicarlas una vez aprobadas,
                // pero NO puede aprobarlas/rechazarlas ni eliminarlas —
                // eso es exclusivo del Administrador (status.moderate).
                'name'        => 'Encuestador',
                'description' => 'Creación de encuestas de su dependencia; envía a revisión y publica una vez aprobadas',
                'permissions' => [
                    'admin.access',
                    'surveys.create',
                    'status.submitForReview',
                    'status.publish',
                    'surveys.respond',
                    'changelogs.view',
                ],
            ],
            [
                // Sin "admin.access": no puede entrar al panel
                // administrativo en absoluto, solo responder encuestas
                // (lo cual, al ser público, no requiere login de todas
                // formas — este rol es para cuentas que solo deben
                // usarse para eso, nunca para gestión).
                'name'        => 'Respondedor',
                'description' => 'Solo puede responder encuestas públicas o por invitación',
                'permissions' => [
                    'surveys.respond',
                ],
            ],
        ];

        foreach ($roles as $role) {
            SurveyRole::updateOrCreate(['name' => $role['name']], $role);
        }
    }
}
