<?php

namespace App\Http\Controllers;

use App\Models\Template;
use App\Models\Survey;
use App\Models\Section;
use App\Models\Question;
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

    public function index(Request $request): JsonResponse
    {
        $templates = Cache::remember(self::CACHE_KEY_LIST, self::CACHE_TTL, function () {
            return Template::select('id', 'name', 'description', 'is_public', 'user_id', 'created_at')
                ->with(['user' => fn($query) => $query->select('id', 'name')])
                ->orderBy('name')
                ->get();
        });

        // La lista se cachea completa; cada usuario ve solo las plantillas
        // públicas, las suyas y (Administrador) todas.
        $visibles = $templates
            ->filter(fn($t) => $t->is_public || $this->esDuenoOAdmin($request, $t))
            ->values();

        return response()->json($visibles, 200);
    }

    private function esDuenoOAdmin(Request $request, Template $template): bool
    {
        $user = $request->user();

        return (int) $template->user_id === (int) $user?->id
            || ($user?->role?->hasPermission('surveys.viewAll') ?? false);
    }

    private function sinAcceso(): JsonResponse
    {
        return response()->json(['message' => 'No tienes acceso a esta plantilla.'], 403);
    }

    private function clearCache(): void
    {
        Cache::forget(self::CACHE_KEY_LIST);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:800',
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

    // =====================================================================
    // GUARDAR UNA ENCUESTA COMO PLANTILLA — copia secciones, preguntas y
    // opciones (no copia respuestas, fechas, participantes ni estado).
    // =====================================================================
    public function storeFromSurvey(Request $request, Survey $survey): JsonResponse
    {
        $user = $request->user();
        $puedeVerTodas = $user?->role?->hasPermission('surveys.viewAll') ?? false;

        // Misma regla multi-dependencia del resto del sistema.
        if (!$puedeVerTodas && (int) $survey->dependency_id !== (int) $user?->dependency_id) {
            return response()->json(['message' => 'No tienes acceso a esta encuesta.'], 403);
        }

        $validated = $request->validate([
            'name'        => 'required|string|max:255',
            'description' => 'nullable|string|max:800',
            'is_public'   => 'required|boolean',
        ]);

        $survey->load([
            'sections' => fn($q) => $q->orderBy('id'),
            'sections.questions' => fn($q) => $q->orderBy('sort_order'),
            'sections.questions.options',
        ]);

        $template = DB::transaction(function () use ($validated, $user, $survey) {
            $template = Template::create([...$validated, 'user_id' => $user->id]);

            $orden = 0; // orden global: secciones en su orden, preguntas dentro de cada una

            foreach ($survey->sections as $section) {
                foreach ($section->questions as $question) {
                    $nueva = Question::create([
                        'type'                  => $question->type,
                        'statement'             => $question->statement,
                        'is_mandatory'          => $question->is_mandatory,
                        'max_length'            => $question->max_length,
                        'sort_order'            => ++$orden,
                        'section_id'            => null,
                        'template_id'           => $template->id,
                        'template_section_name' => $section->name,
                    ]);

                    if ($question->options->isNotEmpty()) {
                        DB::table('question_options')->insert(
                            $question->options->map(fn($o) => [
                                'question_id' => $nueva->id,
                                'option_text' => $o->option_text,
                                'sort_order'  => $o->sort_order,
                            ])->all()
                        );
                    }
                }
            }

            return $template;
        });

        $this->clearCache();

        $this->changeLogService->log(
            $request,
            'Template',
            'Creación',
            "Se guardó la encuesta \"{$survey->title}\" como plantilla \"{$template->name}\"."
        );

        return response()->json([
            'message'  => 'Plantilla guardada correctamente.',
            'template' => $template,
        ], 201);
    }


    public function show(Request $request, Template $template): JsonResponse
    {
        if (!$template->is_public && !$this->esDuenoOAdmin($request, $template)) {
            return $this->sinAcceso();
        }
        return response()->json($template->load('questions.options'), 200);
    }

    public function update(Request $request, Template $template): JsonResponse
    {
        if (!$this->esDuenoOAdmin($request, $template)) {
            return $this->sinAcceso();
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string|max:800',
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

        if (!$template->is_public && !$this->esDuenoOAdmin($request, $template)) {
            return $this->sinAcceso();
        }
        $validated = $request->validate([
            'survey_category_id' => 'required|exists:survey_categories,id',
            'type_id'            => 'required|exists:types,id',
            'status_id'          => 'required|exists:statuses,id',
            'dependency_id'     => 'required|exists:organizational_units,id',
            'start_date' => 'nullable|date|after_or_equal:today',
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

                        // Las secciones se reconstruyen con el nombre que guardó cada
            // pregunta; las plantillas antiguas (sin nombre) van a una sola
            // "Sección General".
            $secciones = [];
            $primeraSeccion = null;

            foreach ($template->questions->sortBy('sort_order') as $oldQuestion) {
                $nombre = $oldQuestion->template_section_name ?: 'Sección General';

                if (!isset($secciones[$nombre])) {
                    $secciones[$nombre] = Section::create([
                        'survey_id'   => $newSurvey->id,
                        'name'        => $nombre,
                        'description' => $oldQuestion->template_section_name
                            ? null
                            : 'Preguntas importadas de la plantilla: ' . $template->name,
                    ]);
                    $primeraSeccion ??= $secciones[$nombre];
                }

                $newQuestion = $secciones[$nombre]->questions()->create([
                    'type'         => $oldQuestion->type,
                    'statement'    => $oldQuestion->statement,
                    'is_mandatory' => $oldQuestion->is_mandatory,
                    'max_length'   => $oldQuestion->max_length,
                    'sort_order'   => $oldQuestion->sort_order,
                ]);

                if ($oldQuestion->options->isNotEmpty()) {
                    DB::table('question_options')->insert(
                        $oldQuestion->options->map(fn($o) => [
                            'question_id' => $newQuestion->id,
                            'option_text' => $o->option_text,
                            'sort_order'  => $o->sort_order,
                        ])->all()
                    );
                }
            }

            // Plantilla sin preguntas: la encuesta igual necesita una sección.
            $primeraSeccion ??= Section::create([
                'survey_id'   => $newSurvey->id,
                'name'        => 'Sección General',
                'description' => 'Preguntas importadas de la plantilla: ' . $template->name,
            ]);

            $newSurvey->update(['section_id' => $primeraSeccion->id]);

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
        if (!$this->esDuenoOAdmin($request, $template)) {
            return $this->sinAcceso();
        }
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