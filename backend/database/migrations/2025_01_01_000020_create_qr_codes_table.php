<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Solo se guarda la URL; la imagen del QR se genera al vuelo en Laravel.
        Schema::create('qr_codes', function (Blueprint $table) {
            $table->id();
            $table->string('public_url');
            $table->timestamp('generated_at')->useCurrent();
            $table->foreignId('survey_id')->constrained('surveys')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('qr_codes');
    }
};
