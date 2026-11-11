<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

// Reemplaza el booleano is_anonymous por anonymity_mode:
//   identified : se piden los datos del encuestado (valor por defecto).
//   optional   : el encuestado decide si participa de forma anónima.
//   anonymous  : todos los encuestados son anónimos, no se piden datos.
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->string('anonymity_mode', 20)->default('identified')->after('is_single_response');
        });

        if (Schema::hasColumn('surveys', 'is_anonymous')) {
            // Las encuestas que ya eran anónimas pasan a "todos anónimos".
            DB::table('surveys')->where('is_anonymous', true)->update(['anonymity_mode' => 'anonymous']);

            Schema::table('surveys', function (Blueprint $table) {
                $table->dropColumn('is_anonymous');
            });
        }
    }

    public function down(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->boolean('is_anonymous')->default(false)->after('is_single_response');
        });

        DB::table('surveys')->where('anonymity_mode', 'anonymous')->update(['is_anonymous' => true]);

        Schema::table('surveys', function (Blueprint $table) {
            $table->dropColumn('anonymity_mode');
        });
    }
};