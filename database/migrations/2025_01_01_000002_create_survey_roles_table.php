<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // Catálogo de roles PROPIO del sistema de encuestas — separado del
    // "role" real de base-app-2 (que gobierna login/JWT). Se llama
    // "survey_roles" para no chocar en nombre de tabla ni de clase PHP
    // con App\Models\Role de base-app-2.
    public function up(): void
    {
        Schema::create('survey_roles', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->text('description')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('survey_roles');
    }
};
