<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('surveys', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description')->nullable();
            $table->boolean('is_single_response')->default(false);
            $table->timestamp('start_date')->nullable();
            $table->timestamp('end_date')->nullable();

            $table->unsignedBigInteger('section_id')->nullable();

            $table->foreignId('dependency_id')->constrained('organizational_units')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('survey_users')->cascadeOnDelete();
            $table->foreignId('template_id')->nullable()->constrained('templates')->nullOnDelete();
            $table->foreignId('survey_category_id')->constrained('survey_categories');
            $table->foreignId('type_id')->constrained('types');
            $table->foreignId('status_id')->constrained('statuses');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('surveys');
    }
};