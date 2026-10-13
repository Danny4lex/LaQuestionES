<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // Espejo LOCAL del usuario institucional (diseño original: reflejo de
    // login-mc). Separado del "users" real de base-app-2 (JWT/password),
    // se llama "survey_users" para no chocar en nombre. La integración
    // definitiva entre ambos sistemas de usuario queda pendiente de
    // definición institucional — por ahora, esta tabla es la fuente de
    // verdad para "quién hizo qué" dentro del módulo de encuestas.
    public function up(): void
    {
        Schema::create('survey_users', function (Blueprint $table) {
            $table->id();
            $table->string('external_id')->unique()->comment('ID del sistema institucional externo (login-mc)');
            $table->string('name');
            $table->string('email')->unique();
            $table->boolean('is_active')->default(true);
            $table->foreignId('role_id')->nullable()->constrained('survey_roles')->nullOnDelete();
            $table->foreignId('dependency_id')->nullable()->constrained('organizational_units')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('survey_users');
    }
};
