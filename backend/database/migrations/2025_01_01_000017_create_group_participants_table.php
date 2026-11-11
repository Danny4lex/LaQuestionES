<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('group_participants', function (Blueprint $table) {
            $table->id();
            $table->string('external_email')->nullable();
            $table->foreignId('group_id')->constrained('groups', 'group_id')->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained('users')->cascadeOnDelete();

            // Regla de negocio: solo uno de los dos (external_email o user_id) debe tener valor.
            // Se recomienda reforzarla con un CHECK constraint o validación a nivel de aplicación.
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('group_participants');
    }
};
