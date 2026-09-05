<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\SurveyCategory;

class SurveyCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Satisfacción', 'status' => true, 'description' => 'Encuestas sobre calidad del servicio'],
            ['name' => 'Evaluación de Evento', 'status' => true, 'description' => 'Medición de impacto de eventos'],
            ['name' => 'Institucional', 'status' => true, 'description' => 'Temas internos de la institución'],
        ];

        foreach ($categories as $category) {
            SurveyCategory::updateOrInsert(['name' => $category['name']], $category);
        }
    }
}