<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Agregar columna slug a statuses SOLO si no existe
        if (!Schema::hasColumn('statuses', 'slug')) {
            Schema::table('statuses', function (Blueprint $table) {
                $table->string('slug')->nullable()->after('name');
            });
        }

        // Agregar deleted_at a las tablas que usan SoftDeletes en sus modelos
        $tablas = [
            'organizational_units',
            'survey_roles',
            'survey_categories',
            'types',
            'statuses',
            'surveys',
            'sections',
            'questions',
            'question_options',
        ];

        foreach ($tablas as $tabla) {
            if (Schema::hasTable($tabla) && !Schema::hasColumn($tabla, 'deleted_at')) {
                Schema::table($tabla, function (Blueprint $table) {
                    $table->softDeletes();
                });
            }
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('statuses', 'slug')) {
            Schema::table('statuses', function (Blueprint $table) {
                $table->dropColumn('slug');
            });
        }

        $tablas = [
            'organizational_units',
            'survey_roles',
            'survey_categories',
            'types',
            'statuses',
            'surveys',
            'sections',
            'questions',
            'question_options',
        ];

        foreach ($tablas as $tabla) {
            if (Schema::hasTable($tabla) && Schema::hasColumn($tabla, 'deleted_at')) {
                Schema::table($tabla, function (Blueprint $table) {
                    $table->dropSoftDeletes();
                });
            }
        }
    }
};