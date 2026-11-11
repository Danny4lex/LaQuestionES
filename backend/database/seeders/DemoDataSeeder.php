<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Survey;
use App\Models\Section;
use App\Models\Question;
use App\Models\QuestionOption;
use App\Models\Template;

class DemoDataSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Obtener IDs de catálogos (usamos DB para evitar problemas con SoftDeletes)
        $adminRoleId   = DB::table('survey_roles')->where('name', 'Administrador')->value('id');
        $mainDeptId    = DB::table('organizational_units')->where('code', 'DM')->value('id');
        $statusBorradorId  = DB::table('statuses')->where('name', 'like', '%Borrador%')->value('id');
        $statusPublicadaId = DB::table('statuses')->where('name', 'like', '%Publicada%')->value('id');
        $statusCerradaId   = DB::table('statuses')->where('name', 'like', '%Cerrada%')->value('id');
        $tipoPublicaId = DB::table('types')->where('name', 'Pública')->value('id');
        $tipoPrivadaId = DB::table('types')->where('name', 'Privada')->value('id');
        $catEvaluacionId    = DB::table('survey_categories')->where('name', 'Evaluación de Evento')->value('id');
        $catSatisfaccionId  = DB::table('survey_categories')->where('name', 'Satisfacción')->value('id');
        $catInstitucionalId = DB::table('survey_categories')->where('name', 'Institucional')->value('id');

        // 2. Usuario administrador
        $admin = \App\Models\SurveyUser::firstOrCreate(
            ['email' => 'admin@cultura.gob.sv'],
            [
                'external_id'   => 'ext-001',
                'name'          => 'Carlos Méndez',
                'is_active'     => true,
                'role_id'       => $adminRoleId,
                'dependency_id' => $mainDeptId,
            ]
        );

        // 3. Encuesta 1: Evaluación Festival (Borrador)
        $survey1 = Survey::create([
            'title'              => 'Evaluación Festival Nacional de las Artes 2026',
            'description'        => 'Encuesta de satisfacción general del festival.',
            'is_single_response' => false,
            'start_date'         => '2026-04-01',
            'end_date'           => '2026-04-30',
            'section_id'         => null,
            'dependency_id'      => $mainDeptId,
            'user_id'            => $admin->id,
            'template_id'        => null,
            'survey_category_id' => $catEvaluacionId,
            'type_id'            => $tipoPublicaId,
            'status_id'          => $statusBorradorId,
        ]);

        $sec1 = Section::create([
            'survey_id'   => $survey1->id,
            'name'        => 'Datos generales',
            'description' => 'Información básica del participante',
        ]);

        $q1 = Question::create([
            'section_id'   => $sec1->id,
            'statement'    => 'Nombre completo',
            'type'         => 'texto',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);

        $q2 = Question::create([
            'section_id'   => $sec1->id,
            'statement'    => 'Género',
            'type'         => 'opcion_unica',
            'is_mandatory' => true,
            'sort_order'   => 2,
        ]);
        QuestionOption::create(['question_id' => $q2->id, 'option_text' => 'Masculino', 'sort_order' => 1]);
        QuestionOption::create(['question_id' => $q2->id, 'option_text' => 'Femenino',  'sort_order' => 2]);

        $sec2 = Section::create([
            'survey_id'   => $survey1->id,
            'name'        => 'Evaluación del evento',
            'description' => 'Preguntas sobre el festival',
        ]);

        $q3 = Question::create([
            'section_id'   => $sec2->id,
            'statement'    => 'Calificación general del festival (1-5)',
            'type'         => 'escala',
            'is_mandatory' => true,
            'sort_order'   => 3,
        ]);

        $survey1->update(['section_id' => $sec1->id]);

        // 4. Encuesta 2: Clima organizacional (Publicada)
        $survey2 = Survey::create([
            'title'              => 'Clima organizacional 2do semestre',
            'description'        => 'Evaluación del ambiente laboral y satisfacción interna.',
            'is_single_response' => true,
            'start_date'         => '2026-05-15',
            'end_date'           => '2026-06-15',
            'section_id'         => null,
            'dependency_id'      => $mainDeptId,
            'user_id'            => $admin->id,
            'template_id'        => null,
            'survey_category_id' => $catInstitucionalId,
            'type_id'            => $tipoPrivadaId,
            'status_id'          => $statusPublicadaId,
        ]);

        $sec3 = Section::create([
            'survey_id'   => $survey2->id,
            'name'        => 'Ambiente laboral',
            'description' => 'Percepción del espacio de trabajo',
        ]);

        Question::create([
            'section_id'   => $sec3->id,
            'statement'    => '¿Cómo calificarías la comunicación interna?',
            'type'         => 'escala',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);

        Question::create([
            'section_id'   => $sec3->id,
            'statement'    => '¿Recomendarías la institución como lugar de trabajo?',
            'type'         => 'si_no',
            'is_mandatory' => false,
            'sort_order'   => 2,
        ]);

        $survey2->update(['section_id' => $sec3->id]);

        // 5. Encuesta 3: Satisfacción ciudadana (Cerrada)
        $survey3 = Survey::create([
            'title'              => 'Satisfacción de atención al ciudadano',
            'description'        => 'Medición de calidad en atención al ciudadano.',
            'is_single_response' => false,
            'start_date'         => '2026-02-01',
            'end_date'           => '2026-02-28',
            'section_id'         => null,
            'dependency_id'      => $mainDeptId,
            'user_id'            => $admin->id,
            'template_id'        => null,
            'survey_category_id' => $catSatisfaccionId,
            'type_id'            => $tipoPublicaId,
            'status_id'          => $statusCerradaId,
        ]);

        $sec4 = Section::create([
            'survey_id'   => $survey3->id,
            'name'        => 'Atención recibida',
            'description' => 'Evalúa la calidad del servicio',
        ]);

        $q4 = Question::create([
            'section_id'   => $sec4->id,
            'statement'    => '¿Cómo fue la amabilidad del personal?',
            'type'         => 'opcion_multiple',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);
        QuestionOption::create(['question_id' => $q4->id, 'option_text' => 'Excelente', 'sort_order' => 1]);
        QuestionOption::create(['question_id' => $q4->id, 'option_text' => 'Buena', 'sort_order' => 2]);
        QuestionOption::create(['question_id' => $q4->id, 'option_text' => 'Regular', 'sort_order' => 3]);
        QuestionOption::create(['question_id' => $q4->id, 'option_text' => 'Mala', 'sort_order' => 4]);

        $survey3->update(['section_id' => $sec4->id]);

        // 6. Plantillas de ejemplo
        $plantilla1 = Template::create([
            'name'        => 'Evaluación de eventos',
            'description' => 'Plantilla para evaluar eventos culturales y festivales.',
            'is_public'   => true,
            'user_id'     => $admin->id,
        ]);
        $tq1 = Question::create([
            'template_id'  => $plantilla1->id,
            'statement'    => '¿Qué te pareció la organización?',
            'type'         => 'opcion_unica',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);
        QuestionOption::create(['question_id' => $tq1->id, 'option_text' => 'Muy buena', 'sort_order' => 1]);
        QuestionOption::create(['question_id' => $tq1->id, 'option_text' => 'Buena', 'sort_order' => 2]);
        QuestionOption::create(['question_id' => $tq1->id, 'option_text' => 'Regular', 'sort_order' => 3]);

        $plantilla2 = Template::create([
            'name'        => 'Clima organizacional',
            'description' => 'Evaluación del ambiente laboral y satisfacción interna.',
            'is_public'   => true,
            'user_id'     => $admin->id,
        ]);
        Question::create([
            'template_id'  => $plantilla2->id,
            'statement'    => '¿Cómo calificarías el liderazgo de tu jefe?',
            'type'         => 'escala',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);
        Question::create([
            'template_id'  => $plantilla2->id,
            'statement'    => '¿Tienes las herramientas necesarias para tu trabajo?',
            'type'         => 'si_no',
            'is_mandatory' => false,
            'sort_order'   => 2,
        ]);

        $plantilla3 = Template::create([
            'name'        => 'Satisfacción ciudadana',
            'description' => 'Medición de calidad en atención al ciudadano.',
            'is_public'   => true,
            'user_id'     => $admin->id,
        ]);
        $tq3 = Question::create([
            'template_id'  => $plantilla3->id,
            'statement'    => '¿El servicio cumplió con tus expectativas?',
            'type'         => 'opcion_multiple',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);
        QuestionOption::create(['question_id' => $tq3->id, 'option_text' => 'Sí, totalmente', 'sort_order' => 1]);
        QuestionOption::create(['question_id' => $tq3->id, 'option_text' => 'En parte', 'sort_order' => 2]);
        QuestionOption::create(['question_id' => $tq3->id, 'option_text' => 'No', 'sort_order' => 3]);

        $plantilla4 = Template::create([
            'name'        => 'Diagnóstico de bibliotecas',
            'description' => 'Evaluación de servicios bibliotecarios municipales.',
            'is_public'   => true,
            'user_id'     => $admin->id,
        ]);
        Question::create([
            'template_id'  => $plantilla4->id,
            'statement'    => '¿Cómo valoras la variedad de libros?',
            'type'         => 'texto',
            'is_mandatory' => false,
            'sort_order'   => 1,
        ]);

        $plantilla5 = Template::create([
            'name'        => 'Capacitación',
            'description' => 'Evaluación de cursos y talleres de capacitación.',
            'is_public'   => true,
            'user_id'     => $admin->id,
        ]);
        Question::create([
            'template_id'  => $plantilla5->id,
            'statement'    => '¿Recomendarías este curso a otros?',
            'type'         => 'si_no',
            'is_mandatory' => true,
            'sort_order'   => 1,
        ]);

        echo "¡Datos de demostración creados con éxito!\n";
    }
}