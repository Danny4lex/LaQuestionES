<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// =========================================================================
// "Papelito" de correcciones por sección.
//
// Cuando el Administrador revisa una encuesta y la regresa con el estado
// "needs_correction" (ver StatusSeeder y SurveyStatusFlowService), deja
// aquí sus observaciones puntuales por sección, para que el Encuestador
// sepa exactamente qué ajustar sin tener que adivinar por qué no se
// aprobó. Solo lo ven Administrador y Encuestador (ambos con
// admin.access) — un participante público nunca llega a estas rutas.
// =========================================================================
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('section_comments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('section_id')->constrained('sections')->cascadeOnDelete();
            // Denormalizado a propósito: permite listar/filtrar comentarios
            // por encuesta sin tener que pasar por sections en cada
            // consulta, igual que ya hace change_logs.survey_id.
            $table->foreignId('survey_id')->constrained('surveys')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('survey_users')->cascadeOnDelete();
            $table->text('comment');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('section_comments');
    }
};
