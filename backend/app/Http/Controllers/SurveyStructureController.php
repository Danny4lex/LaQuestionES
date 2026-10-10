<?php

namespace App\Http\Controllers;

use App\Models\Question;
use App\Models\QuestionOption;
use App\Models\Section;
use App\Models\Survey;
use App\Services\ChangeLogService;
use App\Services\SurveyStatusFlowService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

// Guarda secciones, preguntas y opciones de una encuesta en UNA sola
// petición y UNA sola transacción (antes eran decenas de peticiones).
class SurveyStructureController extends Controller
{
    public function __construct(
        private readonly ChangeLogService $changeLogService,
        private readonly SurveyStatusFlowService $statusFlowService
    ) {}

    public function sync(Request $request, Survey $survey): JsonResponse
    {
        if (!$this->statusFlowService->isEditable($survey)) {
            return response()->json([
                'message' => "No se puede modificar la estructura de la encuesta mientras está en estado \"{$survey->status?->name}\".",
            ], 422);
        }

        $data = $request->validate([
            'sections'                                      => 'present|array',
            'sections.*.id'                                 => 'nullable|integer',
            'sections.*.name'                               => 'required|string|max:255',
            'sections.*.description'                        => 'nullable|string|max:800',
            'sections.*.questions'                          => 'present|array',
            'sections.*.questions.*.id'                     => 'nullable|integer',
            'sections.*.questions.*.type'                   => 'required|string|max:50',
            'sections.*.questions.*.statement'              => 'required|string',
            'sections.*.questions.*.is_mandatory'           => 'required|boolean',
            'sections.*.questions.*.max_length'             => 'nullable|integer|min:1|max:5000',
            'sections.*.questions.*.options'                => 'nullable|array',
            'sections.*.questions.*.options.*.id'           => 'nullable|integer',
            'sections.*.questions.*.options.*.text'         => 'required|string',
            'deleted'                                       => 'nullable|array',
            'deleted.sections'                              => 'nullable|array',
            'deleted.sections.*'                            => 'integer',
            'deleted.questions'                             => 'nullable|array',
            'deleted.questions.*'                           => 'integer',
            'deleted.options'                               => 'nullable|array',
            'deleted.options.*'                             => 'integer',
        ]);

        $result = DB::transaction(function () use ($survey, $data) {
            // Se cargan una sola vez; así solo se pueden tocar filas de ESTA encuesta.
            $sections  = Section::where('survey_id', $survey->id)->get()->keyBy('id');
            $questions = Question::whereIn('section_id', $sections->keys())->get()->keyBy('id');
            $options   = QuestionOption::whereIn('question_id', $questions->keys())->get()->keyBy('id');

            // 1) Eliminaciones
            foreach ($data['deleted']['options'] ?? [] as $id) {
                $options->get($id)?->delete();
            }
            foreach ($data['deleted']['questions'] ?? [] as $id) {
                $questions->get($id)?->delete();
            }
            foreach ($data['deleted']['sections'] ?? [] as $id) {
                $sections->get($id)?->delete();
            }

            // 2) Crear / actualizar (solo se escribe lo que realmente cambió)
            $respuesta = [];

            foreach (array_values($data['sections']) as $sData) {
                $attrsSeccion = [
                    'name'        => $sData['name'],
                    'description' => $sData['description'] ?? null,
                ];

                if (!empty($sData['id'])) {
                    $section = $sections->get($sData['id']);
                    if (!$section) abort(422, 'Una sección no pertenece a esta encuesta.');
                    $section->fill($attrsSeccion);
                    if ($section->isDirty()) $section->save();
                } else {
                    $section = Section::create($attrsSeccion + ['survey_id' => $survey->id]);
                }

                $secOut = ['id' => $section->id, 'questions' => []];

                foreach (array_values($sData['questions']) as $qIndex => $qData) {
                    $attrsPregunta = [
                        'section_id'   => $section->id,
                        'type'         => $qData['type'],
                        'statement'    => $qData['statement'],
                        'is_mandatory' => (bool) $qData['is_mandatory'],
                        'max_length'   => $qData['max_length'] ?? null,
                        'sort_order'   => $qIndex + 1,
                    ];

                    if (!empty($qData['id'])) {
                        $question = $questions->get($qData['id']);
                        if (!$question) abort(422, 'Una pregunta no pertenece a esta encuesta.');
                        $question->fill($attrsPregunta);
                        if ($question->isDirty()) $question->save();
                    } else {
                        $question = Question::create($attrsPregunta + ['template_id' => null]);
                    }

                    $qOut = ['id' => $question->id, 'options' => []];

                    foreach (array_values($qData['options'] ?? []) as $oIndex => $oData) {
                        $attrsOpcion = [
                            'question_id' => $question->id,
                            'option_text' => $oData['text'],
                            'sort_order'  => $oIndex + 1,
                        ];

                        if (!empty($oData['id'])) {
                            $option = $options->get($oData['id']);
                            if (!$option) abort(422, 'Una opción no pertenece a esta encuesta.');
                            $option->fill($attrsOpcion);
                            if ($option->isDirty()) $option->save();
                        } else {
                            $option = QuestionOption::create($attrsOpcion);
                        }

                        $qOut['options'][] = $option->id;
                    }

                    $secOut['questions'][] = $qOut;
                }

                $respuesta[] = $secOut;
            }

            return $respuesta;
        });

        $this->changeLogService->log(
            $request,
            'Survey',
            'Edición de estructura',
            'Se actualizaron las secciones y preguntas de la encuesta.',
            $survey->id
        );

        Cache::forget("survey_detail_{$survey->id}_full");
        Cache::forget("survey_detail_{$survey->id}_anon");

        return response()->json(['sections' => $result], 200);
    }
}

