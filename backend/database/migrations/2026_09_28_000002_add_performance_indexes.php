<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

// Índices para acelerar las consultas de resultados, reportes y listados.
// Cada índice se crea solo si no existe, así la migración es segura de
// correr aunque alguno ya se haya agregado a mano.
return new class extends Migration
{
    private array $indices = [
        // tabla => [nombre_indice => columnas]
        'responses' => [
            'idx_responses_survey_question' => ['survey_id', 'question_id'],
            'idx_responses_survey_participant' => ['survey_id', 'participant_id'],
            'idx_responses_survey_anon' => ['survey_id', 'anonymous_identifier'],
        ],
        'participants' => [
            'idx_participants_survey_email' => ['survey_id', 'email'],
        ],
        'surveys' => [
            'idx_surveys_dependency_status' => ['dependency_id', 'status_id'],
        ],
    ];

    public function up(): void
    {
        foreach ($this->indices as $tabla => $definiciones) {
            if (!Schema::hasTable($tabla)) {
                continue;
            }
            foreach ($definiciones as $nombre => $columnas) {
                if (!Schema::hasColumns($tabla, $columnas) || $this->existe($tabla, $nombre)) {
                    continue;
                }
                Schema::table($tabla, fn($t) => $t->index($columnas, $nombre));
            }
        }
    }

    public function down(): void
    {
        foreach ($this->indices as $tabla => $definiciones) {
            foreach (array_keys($definiciones) as $nombre) {
                if (Schema::hasTable($tabla) && $this->existe($tabla, $nombre)) {
                    Schema::table($tabla, fn($t) => $t->dropIndex($nombre));
                }
            }
        }
    }

    private function existe(string $tabla, string $nombre): bool
    {
        return count(DB::select("SHOW INDEX FROM `{$tabla}` WHERE Key_name = ?", [$nombre])) > 0;
    }
};
