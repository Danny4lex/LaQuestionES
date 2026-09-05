<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('session_logs', function (Blueprint $table) {
            $table->id();
            $table->string('ip_address');
            $table->string('device')->nullable();
            $table->timestamp('access_date')->useCurrent();
            $table->string('status');
            $table->foreignId('user_id')->constrained('survey_users')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('session_logs');
    }
};