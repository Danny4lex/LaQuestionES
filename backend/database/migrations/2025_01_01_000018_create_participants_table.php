<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('participants', function (Blueprint $table) {
            $table->id();
            $table->enum('type', ['anonimo', 'identificado', 'invitado']);
            $table->string('name')->nullable();
            $table->string('email')->nullable();
            $table->string('phone')->nullable();
            $table->uuid('access_token')->nullable()->unique();
            $table->string('invitation_status')->nullable();
            $table->timestamp('registered_at')->nullable();
            $table->timestamp('responded_at')->nullable();
            $table->foreignId('survey_id')->constrained('surveys')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('participants');
    }
};
