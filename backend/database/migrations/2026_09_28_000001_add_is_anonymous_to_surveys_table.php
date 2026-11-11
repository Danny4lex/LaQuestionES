<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Marca si la encuesta es anónima: en ese caso la página pública NO
        // pide los datos del encuestado (nombre, correo, teléfono) y las
        // respuestas se guardan sin participant_id.
        Schema::table('surveys', function (Blueprint $table) {
            $table->boolean('is_anonymous')->default(false)->after('is_single_response');
        });
    }

    public function down(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->dropColumn('is_anonymous');
        });
    }
};
