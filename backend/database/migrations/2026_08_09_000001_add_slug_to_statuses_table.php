<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // Columna técnica estable para identificar cada estado sin depender
    // del texto visible (name), que puede cambiar sin previo aviso —
    // exactamente el problema que ya causó bugs en SurveyController y
    // DashboardController al comparar por str_contains($name, '...').
    public function up(): void
    {
        Schema::table('statuses', function (Blueprint $table) {
            $table->string('slug')->nullable()->unique()->after('name');
        });
    }

    public function down(): void
    {
        Schema::table('statuses', function (Blueprint $table) {
            $table->dropColumn('slug');
        });
    }
};
