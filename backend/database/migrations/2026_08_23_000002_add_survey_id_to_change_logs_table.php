<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // El botón "Historial de cambios" en el listado de encuestas necesita
    // filtrar los logs de UNA encuesta específica. change_logs guardaba el
    // module/action/description como texto libre, sin ninguna referencia
    // relacional a qué encuesta pertenece cada evento.
    public function up(): void
    {
        Schema::table('change_logs', function (Blueprint $table) {
            $table->foreignId('survey_id')
                ->nullable()
                ->after('user_id')
                ->constrained('surveys')
                ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('change_logs', function (Blueprint $table) {
            $table->dropConstrainedForeignId('survey_id');
        });
    }
};
