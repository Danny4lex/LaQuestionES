<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('groups', function (Blueprint $table) {
            $table->id('group_id');
            $table->string('name');
            $table->text('description')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->foreignId('created_by')->constrained('survey_users')->cascadeOnDelete();
            $table->foreignId('dependency_id')->constrained('organizational_units')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('groups');
    }
};