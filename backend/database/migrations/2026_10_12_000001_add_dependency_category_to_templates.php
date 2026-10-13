<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('templates', function (Blueprint $table) {
            $table->foreignId('dependency_id')->nullable()->after('user_id')
                ->constrained('organizational_units')->nullOnDelete();
            $table->foreignId('survey_category_id')->nullable()->after('dependency_id')
                ->constrained('survey_categories')->nullOnDelete();
        });

        // Las plantillas existentes toman la dependencia de quien las creó
        DB::statement('UPDATE templates t JOIN survey_users u ON u.id = t.user_id SET t.dependency_id = u.dependency_id');
    }

    public function down(): void
    {
        Schema::table('templates', function (Blueprint $table) {
            $table->dropConstrainedForeignId('survey_category_id');
            $table->dropConstrainedForeignId('dependency_id');
        });
    }
};