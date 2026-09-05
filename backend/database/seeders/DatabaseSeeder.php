<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ===================================================================
        // Seeders originales de base-app-2 — NO TOCAR.
        // ===================================================================
        $this->call([
            DepartmentSeeder::class,
            RoleSeeder::class,
        ]);

        // ===================================================================
        // Seeders propios de encuestas-mc.
        // SurveyRoleSeeder ya se puede correr: User/Role propios restaurados
        // con luz verde institucional.
        // ===================================================================
        $this->call([
            OrganizationalUnitSeeder::class,
            SurveyRoleSeeder::class,
            TypeSeeder::class,
            StatusSeeder::class,
            SurveyCategorySeeder::class,
            // Debe correr DESPUES de SurveyRoleSeeder: enlaza cada cuenta
            // real con un SurveyRole que ya debe existir.
            SurveyUserAccountsSeeder::class,
            // Banco de plantillas (módulo 2.8). Debe correr DESPUÉS de
            // tener al menos un SurveyUser existente (se usa como autor
            // de las 6 plantillas); no crea usuarios ni dependencias.
            TemplateBankSeeder::class,
        ]);

        // Datos de demostración del sistema de encuestas (solo en entorno local)
        if (app()->environment('local')) {
            $this->call([
                DemoDataSeeder::class,
            ]);
        }
    }
}