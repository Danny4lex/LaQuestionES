<?php

namespace Database\Seeders;

use App\Models\SurveyUser;
use App\Models\Template;
use Illuminate\Database\Seeder;

// =========================================================================
// BANCO DE PLANTILLAS (módulo 2.8 del documento de requerimientos)
//
// El PDF pide plantillas predefinidas para 6 casos de uso institucionales
// concretos. Antes solo existían 3 categorías de encuesta sembradas
// (SurveyCategorySeeder) pero ninguna plantilla real lista para clonar
// vía TemplateController::convertToSurvey — este seeder llena ese vacío.
//
// IMPORTANTE (acople con el sistema externo): este seeder NO crea
// usuarios ni dependencias nuevas. Solo usa un SurveyUser que ya debe
// existir (el primero disponible, sin importar cuál sea en el ambiente
// real de integración) como autor de las plantillas — si no encuentra
// ninguno, se detiene sin fallar el resto del seeding.
//
// Es idempotente: updateOrCreate por nombre de plantilla, así que
// correrlo varias veces no duplica registros.
// =========================================================================
class TemplateBankSeeder extends Seeder
{
    public function run(): void
    {
        $autorId = SurveyUser::query()->value('id');

        if (!$autorId) {
            $this->command?->warn(
                'TemplateBankSeeder: no hay ningún SurveyUser existente todavía, '
                . 'se omite la siembra del banco de plantillas (correr de nuevo '
                . 'después de tener al menos un usuario del módulo).'
            );
            return;
        }

        foreach ($this->plantillas() as $definicion) {
            $template = Template::updateOrCreate(
                ['name' => $definicion['name']],
                [
                    'description' => $definicion['description'],
                    'is_public' => true,
                    'user_id' => $autorId,
                ]
            );

            // Idempotencia a nivel de preguntas: se reemplazan por
            // completo en cada corrida, para que un ajuste de texto en
            // este seeder se refleje sin dejar preguntas duplicadas.
            $template->questions()->delete();

            foreach ($definicion['questions'] as $index => $pregunta) {
                $question = $template->questions()->create([
                    'statement' => $pregunta['statement'],
                    'type' => $pregunta['type'],
                    'is_mandatory' => $pregunta['is_mandatory'] ?? true,
                    'sort_order' => $index + 1,
                ]);

                foreach ($pregunta['options'] ?? [] as $opcionIndex => $texto) {
                    $question->options()->create([
                        'option_text' => $texto,
                        'sort_order' => $opcionIndex + 1,
                    ]);
                }
            }
        }
    }

    /**
     * Definición de las 6 plantillas pedidas en el PDF (sección 2.8),
     * cada una con preguntas representativas usando los 6 tipos de
     * pregunta soportados por el sistema (texto, opcion_unica,
     * opcion_multiple, escala, si_no, casilla).
     */
    private function plantillas(): array
    {
        return [
            [
                'name' => 'Evaluación de eventos culturales',
                'description' => 'Mide la satisfacción y experiencia de los asistentes a un evento, exposición o actividad cultural del Ministerio.',
                'questions' => [
                    ['statement' => '¿A qué evento asististe?', 'type' => 'texto'],
                    ['statement' => '¿Cómo calificarías la organización general del evento?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías el lugar/sede donde se realizó?', 'type' => 'escala'],
                    [
                        'statement' => '¿Cómo te enteraste del evento?',
                        'type' => 'opcion_unica',
                        'options' => ['Redes sociales', 'Radio o televisión', 'Un conocido', 'Portal institucional', 'Otro'],
                    ],
                    [
                        'statement' => '¿Qué aspectos te gustaría que se repitieran en futuros eventos?',
                        'type' => 'opcion_multiple',
                        'options' => ['Horario', 'Ubicación', 'Actividades para niños', 'Duración', 'Artistas invitados'],
                    ],
                    ['statement' => '¿Volverías a asistir a un evento similar?', 'type' => 'si_no'],
                    ['statement' => 'Comentarios o sugerencias adicionales', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
            [
                'name' => 'Evaluación de capacitaciones',
                'description' => 'Evalúa la calidad de un taller, curso o capacitación impartida a empleados, artistas o participantes externos.',
                'questions' => [
                    ['statement' => 'Nombre de la capacitación recibida', 'type' => 'texto'],
                    ['statement' => '¿Cómo calificarías el dominio del tema por parte del facilitador?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías el material didáctico proporcionado?', 'type' => 'escala'],
                    ['statement' => '¿El contenido cumplió tus expectativas?', 'type' => 'si_no'],
                    [
                        'statement' => '¿Qué modalidad prefieres para futuras capacitaciones?',
                        'type' => 'opcion_unica',
                        'options' => ['Presencial', 'Virtual', 'Híbrida'],
                    ],
                    [
                        'statement' => '¿Qué temas te gustaría que se incluyan en próximas capacitaciones?',
                        'type' => 'opcion_multiple',
                        'options' => ['Gestión cultural', 'Herramientas digitales', 'Atención al público', 'Normativa institucional', 'Otro'],
                    ],
                    ['statement' => 'Sugerencias para mejorar futuras capacitaciones', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
            [
                'name' => 'Clima organizacional',
                'description' => 'Mide la percepción del personal sobre el ambiente laboral, liderazgo y condiciones de trabajo dentro de la institución.',
                'questions' => [
                    ['statement' => '¿En qué dirección o unidad organizativa trabajas?', 'type' => 'texto'],
                    ['statement' => '¿Cómo calificarías la comunicación con tu jefatura inmediata?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías el ambiente de trabajo con tus compañeros?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías el equilibrio entre tu vida laboral y personal?', 'type' => 'escala'],
                    ['statement' => '¿Consideras que tienes las herramientas necesarias para realizar tu trabajo?', 'type' => 'si_no'],
                    [
                        'statement' => '¿Qué aspectos consideras que deben mejorar en tu dirección o unidad?',
                        'type' => 'casilla',
                        'options' => ['Comunicación interna', 'Reconocimiento al desempeño', 'Capacitación', 'Infraestructura', 'Carga laboral'],
                    ],
                    ['statement' => 'Comentarios adicionales sobre el ambiente laboral', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
            [
                'name' => 'Atención al ciudadano',
                'description' => 'Evalúa la calidad de la atención recibida por un ciudadano en una ventanilla, oficina o punto de servicio institucional.',
                'questions' => [
                    ['statement' => '¿Qué trámite o servicio solicitaste?', 'type' => 'texto'],
                    ['statement' => '¿Cómo calificarías la amabilidad del personal que te atendió?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías el tiempo de espera?', 'type' => 'escala'],
                    ['statement' => '¿Tu trámite fue resuelto satisfactoriamente?', 'type' => 'si_no'],
                    [
                        'statement' => '¿Por qué canal realizaste tu trámite?',
                        'type' => 'opcion_unica',
                        'options' => ['Presencial', 'Teléfono', 'Correo electrónico', 'Portal en línea'],
                    ],
                    ['statement' => '¿Qué sugieres para mejorar la atención al ciudadano?', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
            [
                'name' => 'Satisfacción de servicios',
                'description' => 'Mide el nivel de satisfacción general de usuarios de un servicio institucional específico (biblioteca, museo, programa cultural, etc.).',
                'questions' => [
                    ['statement' => '¿Qué servicio utilizaste?', 'type' => 'texto'],
                    ['statement' => '¿Qué tan satisfecho estás con el servicio recibido en general?', 'type' => 'escala'],
                    ['statement' => '¿Cómo calificarías la calidad de las instalaciones?', 'type' => 'escala'],
                    ['statement' => '¿Recomendarías este servicio a otras personas?', 'type' => 'si_no'],
                    [
                        'statement' => '¿Qué aspectos del servicio consideras que deben mejorar?',
                        'type' => 'opcion_multiple',
                        'options' => ['Horario de atención', 'Infraestructura', 'Variedad de la oferta', 'Personal de apoyo', 'Accesibilidad'],
                    ],
                    ['statement' => 'Comentarios adicionales', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
            [
                'name' => 'Consultas institucionales',
                'description' => 'Recoge la opinión de ciudadanos o grupos de interés sobre una política, iniciativa o consulta pública impulsada por el Ministerio.',
                'questions' => [
                    ['statement' => '¿Conocías la iniciativa/política antes de esta consulta?', 'type' => 'si_no'],
                    [
                        'statement' => '¿Qué tan de acuerdo estás con la propuesta presentada?',
                        'type' => 'opcion_unica',
                        'options' => ['Muy de acuerdo', 'De acuerdo', 'Neutral', 'En desacuerdo', 'Muy en desacuerdo'],
                    ],
                    ['statement' => '¿Cómo calificarías la claridad de la información presentada?', 'type' => 'escala'],
                    [
                        'statement' => '¿Qué grupos de interés representas o con cuáles te identificas?',
                        'type' => 'casilla',
                        'options' => ['Ciudadanía en general', 'Artista o gestor cultural', 'Institución aliada', 'Academia', 'Sector privado'],
                    ],
                    ['statement' => '¿Qué observaciones o propuestas adicionales deseas compartir?', 'type' => 'texto', 'is_mandatory' => false],
                ],
            ],
        ];
    }
}
