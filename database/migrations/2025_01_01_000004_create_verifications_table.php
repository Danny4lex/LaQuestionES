<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // NOTA: por corrección del cliente, NO se persiste el código de verificación.
        // Solo se genera, se envía y se valida en el flujo de la aplicación.
        Schema::create('verifications', function (Blueprint $table) {
            $table->id();
            $table->enum('status', ['pendiente', 'usado', 'expirado'])->default('pendiente');
            $table->timestamp('created_at')->useCurrent();
            $table->dateTime('expires_at');
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('verifications');
    }
};
