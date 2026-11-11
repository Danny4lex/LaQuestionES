<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Survey;
use App\Models\Question;
use App\Models\Response;
use Carbon\Carbon;

class FakeResponsesSeeder extends Seeder
{
    public function run(): void
    {
        // Limpiar respuestas anteriores para evitar duplicados
        DB::table('multiple_choise_responses')->delete();
        DB::table('responses')->delete();

        // Obtener todas las encuestas con sus preguntas y opciones
        $surveys = Survey::with(['sections.questions.options'])->get();

        foreach ($surveys as $survey) {
            $questions = $survey->sections->flatMap->questions;

            if ($questions->isEmpty()) {
                continue;
            }

            // Número aleatorio de respuestas entre 15 y 30
            $totalResponses = rand(15, 30);

            for ($i = 1; $i <= $totalResponses; $i++) {
                $submittedAt = Carbon::now()
                    ->subDays(rand(0, 29))
                    ->addMinutes(rand(0, 1440));

                foreach ($questions as $question) {
                    // Decidir si se responde esta pregunta
                    // Obligatorias: siempre; opcionales: 80% probabilidad
                    if ($question->is_mandatory || rand(0, 100) < 80) {
                        $this->createResponse($survey, $question, $submittedAt, $i);
                    }
                }
            }
        }

        echo "Respuestas ficticias generadas correctamente.\n";
    }

    private function createResponse(Survey $survey, Question $question, Carbon $submittedAt, int $respondentNumber): void
    {
        $response = new Response();
        $response->survey_id = $survey->id;
        $response->question_id = $question->id;
        $response->submitted_at = $submittedAt;
        $response->is_completed = true;
        // participant_id queda null, anonymous_identifier se genera automáticamente

        switch ($question->type) {
            case 'texto':
            case 'comentario':
            case 'abierta':
                $response->text_value = fake()->name();
                break;

            case 'escala':
                $response->scale_value = rand(1, 5);
                break;

            case 'si_no':
            case 'casilla':
                $response->boolean_value = (bool) rand(0, 1);
                break;

            case 'opcion_unica':
                $option = $question->options->random();
                $response->save();
                $response->selectedOptions()->attach($option->id);
                return; // ya guardado

            case 'opcion_multiple':
                $selectedOptions = $question->options
                    ->random(rand(1, $question->options->count()))
                    ->pluck('id')
                    ->toArray();
                $response->save();
                $response->selectedOptions()->attach($selectedOptions);
                return; // ya guardado

            default:
                // Por si acaso, no se crea respuesta
                return;
        }

        $response->save();
    }
}