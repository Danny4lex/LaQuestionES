<?php

namespace App\Http\Controllers;

use App\Models\Template;
use App\Models\Survey;
use App\Models\Section;
use App\Services\ChangeLogService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;

class TemplateController extends Controller
{
    private const CACHE_KEY_LIST = 'templates_list_active';
    private const CACHE_TTL = 86400; // 24 horas

    public function __construct(
        private readonly ChangeLogService $changeLogService
    ) {}

    public function index(): JsonResponse
    {
        $templates = Cache::remember(self::CACHE_KEY_LIST, self::CACHE_TTL, function () {
            return Template::select('id', 'name', 'description', 'is_public', 'user_id', 'created_at')
                ->with(['user' => fn($query) => $query->select('id', 'name')])
                ->orderBy('name')
                ->get();
        });

        return response()->json($templates, 200);
    }

    private function clearCache(): void
    {
        Cache::forget(self::CACHE_KEY_LIST);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'is_public' => 'required|boolean',
        ]);

        $template = Template::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        $this->clearCache();

        $this->changeLogService->log(
            $request,
            'Template',
            'Creación',
            "Se creó la plantilla \"{$template->name}\"."
        );

        return response()->json($template, 201);
    }

    public function show(Template $template): JsonResponse
    {
        return response()->json($template->load('questions.options'), 200);
    }

    public function update(Request $request, Template $template): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'is_public' => 'sometimes|required|boolean',
        ]);

        $template->update($validated);
        $this->clearCache();

        $this->changeLogService->log(
            $request,
            'Template',
            'Edición',
            "Se editó la plantilla \"{$template->name}\"."
        );

        return response()->json($template, 200);
    }

    public function convertToSurvey(Request $request, Template $template): JsonResponse
    {
        $validated = $request->validate([
            'survey_category_id' => 'required|exists:survey_categories,id',
            'type_id'            => 'required|exists:types,id',
            'status_id'          => 'required|exists:statuses,id',
            'dependency_id'     => 'required|exists:organizational_units,id',
            'start_date'        => 'nullable|date',
            'end_date'          => 'nullable|date|after_or_equal:start_date',
        ]);

        // Carga ansiosa para evitar N+1
        $template->load('questions.options');

        $survey = DB::transaction(function () use ($template, $validated, $request) {
            $newSurvey = Survey::create([
                'title'              => $template->name,
                'description'        => $template->description,
                'survey_category_id' => $validated['survey_category_id'],
                'type_id'            => $validated['type_id'],
                'status_id'          => $validated['status_id'],
                'dependency_id'     => $validated['dependency_id'],
                'user_id'           => $request->user()->id,
                'start_date'        => $validated['start_date'] ?? null,
                'end_date'          => $validated['end_date'] ?? null,
                'is_single_response' => false,
            ]);

            $defaultSection = Section::create([
                'survey_id'   => $newSurvey->id,
                'name'        => 'Sección General',
                'description' => 'Preguntas importadas de la plantilla: ' . $template->name,
            ]);

            $newSurvey->update(['section_id' => $defaultSection->id]);

            $now = now();

            foreach ($template->questions as $oldQuestion) {
                $newQuestion = $defaultSection->questions()->create([
                    'type'         => $oldQuestion->type,
                    'statement'    => $oldQuestion->statement,
                    'is_mandatory' => $oldQuestion->is_mandatory,
                    'sort_order'   => $oldQuestion->sort_order,
                ]);

                if ($oldQuestion->options->isNotEmpty()) {
    $optionsToInsert = [];
    foreach ($oldQuestion->options as $oldOption) {
        $optionsToInsert[] = [
            'question_id' => $newQuestion->id,
            'option_text' => $oldOption->option_text,
            'sort_order'  => $oldOption->sort_order,
        ];
    }
    
    // Inserción masiva en una sola consulta por pregunta
    DB::table('question_options')->insert($optionsToInsert);
}
            }

            return $newSurvey;
        });

        $this->changeLogService->log(
            $request,
            'Survey',
            'Creación',
            "Se creó la encuesta \"{$survey->title}\" a partir de la plantilla \"{$template->name}\".",
            $survey->id
        );

        return response()->json([
            'message'   => 'Encuesta generada exitosamente desde la plantilla.',
            'survey_id' => $survey->id
        ], 201);
    }

    public function destroy(Request $request, Template $template): JsonResponse
    {
        $nombre = $template->name;
        $template->delete();
        $this->clearCache();

        $this->changeLogService->log(
            $request,
            'Template',
            'Eliminación',
            "Se eliminó la plantilla \"{$nombre}\"."
        );

        return response()->json(['message' => 'Plantilla eliminada correctamente.'], 200);
    }
}