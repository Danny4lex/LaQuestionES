<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// =========================================================================
// Límite de caracteres por pregunta de texto libre.
//
// El tipo "texto" del enum de questions cubre tanto "Texto corto" como
// "Texto largo" (el frontend ya distinguía ambas etiquetas en el
// selector, pero las dos se guardaban con el mismo type="texto" — no
// había ninguna columna que reflejara esa diferencia). Se agrega
// max_length (nullable) para:
//   1. Validar en el backend que la respuesta no exceda el límite
//      (ResponseController), no solo decorarlo en el frontend.
//   2. Decidir en la pantalla de respuesta si se renderiza un campo de
//      una sola línea o un textarea (umbral > 200 caracteres).
// NULL = sin límite (compatibilidad con preguntas ya existentes).
// =========================================================================
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('questions', function (Blueprint $table) {
            $table->unsignedInteger('max_length')->nullable()->after('is_mandatory');
        });
    }

    public function down(): void
    {
        Schema::table('questions', function (Blueprint $table) {
            $table->dropColumn('max_length');
        });
    }
};
