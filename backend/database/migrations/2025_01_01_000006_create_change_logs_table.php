<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('change_logs', function (Blueprint $table) {
            $table->id('action_id');
            $table->string('module');
            $table->string('action');
            $table->text('description')->nullable();
            $table->timestamp('action_date')->useCurrent();
            $table->foreignId('user_id')->nullable()->constrained('survey_users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('change_logs');
    }
};