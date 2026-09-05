<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('questions', function (Blueprint $table) {
            $table->id();
            $table->text('statement');
            $table->enum('type', ['texto', 'opcion_unica', 'opcion_multiple', 'escala', 'si_no', 'casilla']);
            $table->boolean('is_mandatory')->default(false);
            $table->integer('sort_order')->default(0);

            // Pertenece a una sección (si es de una encuesta) O a una plantilla (mutuamente excluyente)
            $table->foreignId('section_id')->nullable()->constrained('sections')->cascadeOnDelete();
            $table->foreignId('template_id')->nullable()->constrained('templates')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('questions');
    }
};
