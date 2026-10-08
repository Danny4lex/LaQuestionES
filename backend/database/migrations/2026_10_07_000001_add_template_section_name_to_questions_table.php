<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// Las plantillas no tienen secciones propias: sus preguntas cuelgan de
// questions.template_id. Para no perder la estructura al guardar una encuesta
// como plantilla, cada pregunta de plantilla recuerda el nombre de su sección
// y, al crear una encuesta desde la plantilla, las secciones se reconstruyen.
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('questions', function (Blueprint $table) {
            $table->string('template_section_name')->nullable()->after('template_id');
        });
    }

    public function down(): void
    {
        Schema::table('questions', function (Blueprint $table) {
            $table->dropColumn('template_section_name');
        });
    }
};