<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // Habilita permisos reales por rol (ej. "surveys.create",
    // "surveys.changeStatus", "admin.access"). Antes los roles eran solo
    // etiquetas decorativas sin ningún efecto sobre lo que un usuario podía
    // hacer — con esto, SurveyRole pasa a controlar de verdad el acceso.
    public function up(): void
    {
        Schema::table('survey_roles', function (Blueprint $table) {
            $table->json('permissions')->nullable()->after('description');
        });
    }

    public function down(): void
    {
        Schema::table('survey_roles', function (Blueprint $table) {
            $table->dropColumn('permissions');
        });
    }
};
