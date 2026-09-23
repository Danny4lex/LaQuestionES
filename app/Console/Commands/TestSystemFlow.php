<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Survey;
use App\Models\SurveyCategory;
use App\Models\Type;
use App\Models\Status;
use App\Models\OrganizationalUnit;
use App\Models\Section;
use App\Models\Question;

class TestSystemFlow extends Command
{
    protected $signature = 'test:system';
    protected $description = 'Prueba integral del sistema de encuestas';

    public function handle()
    {
        $this->info("=== INICIANDO DIAGNÓSTICO INTEGRAL DEL SISTEMA ===");

        // 1. Catálogos básicos
        $this->check("Catálogo de Tipos", fn() => Type::count() > 0);
        $this->check("Catálogo de Categorías", fn() => SurveyCategory::count() > 0);
        $this->check("Catálogo de Estados", fn() => Status::count() > 0);
        $this->check("Catálogo de Unidades Organizativas", fn() => OrganizationalUnit::count() > 0);

        // 2. Probar lectura y relaciones de Encuestas
        $survey = Survey::with(['sections.questions.options', 'category', 'type', 'status'])->first();

        if ($survey) {
            $this->info("✔ Encuesta encontrada ID {$survey->id}: '{$survey->title}'");
            $this->check("Carga de Secciones", fn() => $survey->sections !== null);
            
            $firstSection = $survey->sections->first();
            if ($firstSection) {
                $this->check("Carga de Preguntas", fn() => $firstSection->questions !== null);
            }
        } else {
            $this->warn("⚠ No hay encuestas registradas actualmente en la base de datos.");
        }

        $this->info("=== DIAGNÓSTICO FINALIZADO CON ÉXITO ===");

        // 3. Probar ciclo de vida de escritura y borrado de caché
        $this->info("--- Probando escritura e invalidación de caché ---");
        try {
            // Crear sección temporal
            $tempSection = Section::create([
                'survey_id' => $survey->id,
                'name' => 'Sección de Prueba Automatizada',
                'description' => 'Test'
            ]);
            $this->line("<fg=green>✔ [OK]</fg=green> Creación de Sección");

            // Borrar sección temporal
            $tempSection->delete();
            $this->line("<fg=green>✔ [OK]</fg=green> Eliminación de Sección e invalidación de caché");
        } catch (\Throwable $e) {
            $this->line("<fg=red>✘ [ERROR]</fg=red> Escritura/Invalidación: " . $e->getMessage());
        }
        return 0;
    }

    private function check(string $label, callable $callback)
    {
        try {
            if ($callback()) {
                $this->line("<fg=green>✔ [OK]</fg=green> {$label}");
            } else {
                $this->line("<fg=yellow>⚠ [VACÍO]</fg=yellow> {$label}");
            }
        } catch (\Throwable $e) {
            $this->line("<fg=red>✘ [ERROR]</fg=red> {$label}: " . $e->getMessage());
        }
    }
}