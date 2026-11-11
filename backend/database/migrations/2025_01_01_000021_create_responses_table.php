<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('responses', function (Blueprint $table) {
            $table->id();

            // Regla de anonimato: si la respuesta es anónima, participant_id es NULL
            // y se genera este UUID en su lugar.
            $table->uuid('anonymous_identifier')->nullable();
            $table->string('source_ip')->nullable();
            $table->timestamp('submitted_at')->nullable();
            $table->boolean('is_completed')->default(false);

            // Diseño polimórfico por columnas: solo una de estas tendrá valor
            // según questions.type
            $table->text('text_value')->nullable();
            $table->integer('scale_value')->nullable();
            $table->boolean('boolean_value')->nullable();

            $table->foreignId('question_id')->constrained('questions')->cascadeOnDelete();
            $table->foreignId('survey_id')->constrained('surveys')->cascadeOnDelete();
            $table->foreignId('participant_id')->nullable()->constrained('participants')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('responses');
    }
};
