<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Tabla pivote N:N entre responses y question_options.
        // Guarda IDs de opciones (no texto plano) para no romper estadísticas
        // históricas si se edita el texto de una opción.
        Schema::create('multiple_choise_responses', function (Blueprint $table) {
            $table->foreignId('response_id')->constrained('responses')->cascadeOnDelete();
            $table->foreignId('question_option_id')->constrained('question_options')->cascadeOnDelete();

            $table->primary(['response_id', 'question_option_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('multiple_choise_responses');
    }
};
