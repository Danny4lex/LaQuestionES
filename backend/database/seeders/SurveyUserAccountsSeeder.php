<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use App\Models\SurveyRole;
use App\Models\SurveyUser;
use App\Models\OrganizationalUnit;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

// =========================================================================
// Provisiona las 3 cuentas reales del módulo de encuestas — no son datos
// de ejemplo desechables, son las credenciales con las que cada persona
// inicia sesión de verdad (ver AuthController::login, que valida contra
// la tabla "users" real de base-app-2).
//
// Cada User (login) queda ligado a su SurveyUser (identidad/rol dentro
// de encuestas-mc) a través de external_id = (string) User->id — el
// mismo puente que resuelve AuthenticateSurveyUser en cada request.
//
// Las contraseñas son temporales y deben cambiarse tras el primer login;
// se listan aquí solo porque este seeder es el único lugar donde existen
// en texto plano antes de hashearse.
// =========================================================================
class SurveyUserAccountsSeeder extends Seeder
{
    public function run(): void
    {
        // El "users" real de base-app-2 exige un role_id (tabla "role",
        // ajena a este módulo) — se usa el primero disponible, sembrado
        // por RoleSeeder.
        $baseRoleId = Role::first()?->id ?? 1;

        $cuentas = [
            [
                'name'       => 'Carlos Méndez',
                'email'      => 'carlos.mendez@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Administrador',
                'dependency' => 'Despacho Ministerial de Cultura',
            ],

            // -----------------------------------------------------------
            // Usuarios de gestión (Encuestador) — uno por dependencia,
            // para probar el filtro de multi-tenencia: cada uno solo debe
            // ver/crear encuestas de SU propia dependencia.
            // -----------------------------------------------------------
            [
                'name'       => 'Ana Ramírez',
                'email'      => 'ana.ramirez@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Encuestador',
                'dependency' => 'Dirección General Ejecutiva',
            ],
            [
                'name'       => 'Jorge Alas',
                'email'      => 'jorge.alas@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Encuestador',
                'dependency' => 'Biblioteca Nacional de El Salvador',
            ],
            [
                'name'       => 'Karla Núñez',
                'email'      => 'karla.nunez@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Encuestador',
                'dependency' => 'Dirección Nacional de Artes',
            ],

            // -----------------------------------------------------------
            // Usuarios encuestados (Respondedor) — para pruebas de
            // llenado. Sin dependencia: su rol no tiene "admin.access",
            // así que nunca entran al panel de gestión de todas formas.
            // -----------------------------------------------------------
            [
                'name'       => 'Luis Portillo',
                'email'      => 'luis.portillo@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Respondedor',
                'dependency' => null,
            ],
            [
                'name'       => 'Mario Cruz',
                'email'      => 'mario.cruz@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Respondedor',
                'dependency' => null,
            ],
            [
                'name'       => 'Diana Flores',
                'email'      => 'diana.flores@cultura.gob.sv',
                'password'   => 'CulturaMC#2026',
                'surveyRole' => 'Respondedor',
                'dependency' => null,
            ],
        ];

        foreach ($cuentas as $cuenta) {
            $role = SurveyRole::where('name', $cuenta['surveyRole'])->first();

            if (!$role) {
                // SurveyRoleSeeder debe correr antes que este seeder
                // (ver orden en DatabaseSeeder).
                continue;
            }

            $dependencyId = $cuenta['dependency']
                ? OrganizationalUnit::where('name', $cuenta['dependency'])->value('id')
                : null;

            $user = User::updateOrCreate(
                ['email' => $cuenta['email']],
                [
                    'name'     => $cuenta['name'],
                    'password' => Hash::make($cuenta['password']),
                    'role_id'  => $baseRoleId,
                ]
            );

            SurveyUser::updateOrCreate(
                ['external_id' => (string) $user->id],
                [
                    'name'          => $cuenta['name'],
                    'email'         => $cuenta['email'],
                    'is_active'     => true,
                    'role_id'       => $role->id,
                    'dependency_id' => $dependencyId,
                ]
            );
        }
    }
}
