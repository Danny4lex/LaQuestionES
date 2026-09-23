<?php

namespace App\Http\Controllers;

use App\Models\Survey;
use App\Models\Section;
use App\Services\SurveyStatusFlowService;
use App\Services\ChangeLogService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;
use Illuminate\Support\Facades\Cache;

class SurveyController extends Controller
{
    public function __construct(
        private readonly SurveyStatusFlowService $statusFlowService,
        private readonly ChangeLogService $changeLogService
    ) {}

    // Registro de auditoria real (no hay datos de ejemplo: cada fila de
    // change_logs corresponde a una accion que de verdad ocurrio sobre
    // una encuesta). Alimenta el boton "Historial de cambios" del listado.
    // Delega en ChangeLogService (ver app/Services/ChangeLogService.php),
    // que ahora tambien usan QuestionController, SectionController,
    // TemplateController y GroupController.
    private function logChange(Request $request, int $surveyId, string $action, string $description): void
    {
        $this->changeLogService->log($request, 'Survey', $action, $description, $surveyId);
    }

    // Nombres de campo -> descripcion legible en español, para que el
    // historial de cambios no le muestre a un usuario final claves
    // tecnicas como "survey_category_id" o "is_single_response".
    private const CAMPOS_LEGIBLES = [
        'title'              => 'el título',
        'description'        => 'la descripción',
        'is_single_response' => 'la restricción de respuesta única',
        'survey_category_id' => 'la categoría',
        'type_id'            => 'el tipo de acceso',
        'start_date'         => 'la fecha de inicio',
        'end_date'           => 'la fecha de fin',
        'dependency_id'      => 'la dependencia',
    ];

    private function describirCambios(array $camposEditados): string
    {
        $legibles = array_map(
            fn($campo) => self::CAMPOS_LEGIBLES[$campo] ?? $campo,
            array_keys($camposEditados)
        );

        if (count($legibles) === 1) {
            return "Se actualizó {$legibles[0]}.";
        }

        $ultimo = array_pop($legibles);
        return 'Se actualizaron ' . implode(', ', $legibles) . " y {$ultimo}.";
    }

    // =====================================================================
    // PANTALLA: GESTIÓN DE ENCUESTAS (LISTADO)
    // Multi-tenencia: cada usuario ve solo las encuestas de SU dependencia,
    // salvo que su rol tenga "surveys.viewAll" (Administrador), en cuyo
    // caso ve todas y opcionalmente puede filtrar por ?dependency_id=.
    // =====================================================================
    public function index(Request $request): JsonResponse
    {
        $query = Survey::with(['category', 'type', 'status', 'department', 'owner'])
            ->withCount('responses');

        $puedeVerTodas = $request->user()?->role?->hasPermission('surveys.viewAll') ?? false;

        if ($puedeVerTodas) {
            if ($request->has('dependency_id')) {
                $query->where('dependency_id', $request->dependency_id);
            }
        } else {
            // Ignora cualquier dependency_id que venga del cliente: un
            // Encuestador no puede pedir ver encuestas de otra dependencia
            // simplemente cambiando el query param.
            $query->where('dependency_id', $request->user()?->dependency_id);
        }

        return response()->json($query->get(), 200);
    }

    // =====================================================================
    // PANTALLA: CONSTRUCTOR DE ENCUESTAS (CREACIÓN)
    // user_id viene de la sesión autenticada, nunca del body.
    // dependency_id tambien viene de la sesión (la dependencia del propio
    // usuario) — SOLO un Administrador ("surveys.viewAll") puede crear una
    // encuesta explícitamente a nombre de otra dependencia.
    // =====================================================================
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'              => 'required|string|max:255',
            'description'        => 'nullable|string',
            'is_single_response' => 'required|boolean',
            'survey_category_id' => 'required|exists:survey_categories,id',
            'type_id'            => 'required|exists:types,id',
            'status_id'          => 'required|exists:statuses,id',
            'dependency_id'      => 'nullable|exists:organizational_units,id',
            'template_id'        => 'nullable|exists:templates,id',
            'start_date'         => 'nullable|date',
            'end_date'           => 'nullable|date|after_or_equal:start_date',
        ]);

        $puedeElegirDependencia = $request->user()?->role?->hasPermission('surveys.viewAll') ?? false;

        $dependencyId = ($puedeElegirDependencia && $validated['dependency_id'])
            ? $validated['dependency_id']
            : $request->user()?->dependency_id;

        if (!$dependencyId) {
            return response()->json([
                'message' => 'Tu usuario no tiene una dependencia asignada; no puedes crear encuestas. Contacta al administrador.'
            ], 422);
        }

        $survey = DB::transaction(function () use ($validated, $request, $dependencyId) {
            $survey = Survey::create([
                ...$validated,
                'dependency_id' => $dependencyId,
                'section_id'    => null,
                'user_id'       => $request->user()->id,
            ]);

            $defaultSection = Section::create([
                'survey_id'   => $survey->id,
                'name'        => 'Sección Inicial Principal',
                'description' => 'Bloque introductorio generado automáticamente por el sistema.',
            ]);

            $survey->update(['section_id' => $defaultSection->id]);

            return $survey;
        });

        $this->logChange($request, $survey->id, 'Creación', "Se creó la encuesta \"{$survey->title}\".");

        return response()->json($survey->load('sections'), 201);
    }

    // =====================================================================
    // PANTALLA: CONSTRUCTOR DE ENCUESTAS (VISTA PREVIA / EDICIÓN)
    // =====================================================================
    public function show(Request $request, Survey $survey): JsonResponse
    {
        $isAnonymous = $request->boolean('is_anonymous') || $survey->type?->slug === 'anonymous';

        $anonKey = $isAnonymous ? 'anon' : 'full';
        $cacheKey = "survey_detail_{$survey->id}_{$anonKey}";
        $cacheTTL = 86400; // 24 horas

        $surveyData = Cache::remember($cacheKey, $cacheTTL, function () use ($survey, $isAnonymous) {
            return Survey::where('id', $survey->id)
                ->with([
                    'sections' => function ($query) use ($isAnonymous) {
                        $query->select('id', 'survey_id', 'name', 'description');
                        if ($isAnonymous) {
                            $query->where('type', '!=', 'personal_data');
                        }
                    },
                    'sections.questions' => function ($query) {
                        $query->select('id', 'section_id', 'statement', 'type', 'is_mandatory', 'sort_order', 'max_length')
                            ->orderBy('sort_order', 'asc');
                    },
                    'sections.questions.options' => function ($query) {
                        $query->select('id', 'question_id', 'option_text', 'sort_order')
                            ->orderBy('sort_order', 'asc');
                    },
                    'sections.comments.user:id,name',
                    'department',
                    'category',
                    'status',
                    'type'
                ])
                ->first();
        });

        return response()->json($surveyData, 200);
    }

    private function clearSurveyCache(int $surveyId): void
    {
        Cache::forget("survey_detail_{$surveyId}_full");
        Cache::forget("survey_detail_{$surveyId}_anon");
    }

    // =====================================================================
    // PANTALLA: CONSTRUCTOR DE ENCUESTAS (MODAL DE CONFIGURACIÓN)
    // =====================================================================
    public function update(Request $request, Survey $survey): JsonResponse
    {
        // FIX: antes se podía editar título/descripción/vigencia de una
        // encuesta en CUALQUIER estado, incluida "Publicada" — lo que
        // permitía alterar la encuesta mientras ya tenía respuestas en
        // curso. Solo se permite editar en los estados definidos como
        // editables (ver SurveyStatusFlowService::EDITABLE_STATUSES).
        if (!$this->statusFlowService->isEditable($survey)) {
            return response()->json([
                'message' => "No se puede editar la encuesta mientras está en estado \"{$survey->status?->name}\". "
                    . 'Solo se puede modificar en Borrador, En revisión, Aprobada, Rechazada o Corregida.',
            ], 422);
        }

        $validated = $request->validate([
            'title'              => 'sometimes|required|string|max:255',
            'description'        => 'nullable|string',
            'is_single_response' => 'sometimes|required|boolean',
            'survey_category_id' => 'sometimes|required|exists:survey_categories,id',
            'type_id'            => 'sometimes|required|exists:types,id',
            'start_date'         => 'nullable|date',
            'end_date'           => 'nullable|date|after_or_equal:start_date',
        ]);

        $survey->update($validated);

        if (!empty($validated)) {
            $this->logChange($request, $survey->id, 'Edición', $this->describirCambios($validated));
        }

        $this->clearSurveyCache($survey->id);

        return response()->json($survey, 200);
    }

    // Determina qué habilidad exige CADA transición puntual. No es un
    // único permiso "cambiar estado": el Encuestador puede enviar a
    // revisión y publicar (solo si ya está Aprobada), pero solo el
    // Administrador puede aprobar/rechazar o hacer cualquier otra
    // transición ("status.moderate" cubre todo lo demás).
    private function habilidadRequerida(?string $fromSlug, string $toSlug): string
    {
        if ($toSlug === 'review' && $fromSlug === 'draft') {
            return 'status.submitForReview';
        }

        if ($toSlug === 'published' && $fromSlug === 'approved') {
            return 'status.publish';
        }

        return 'status.moderate';
    }

    // =====================================================================
    // PANTALLA: GESTIÓN DE ENCUESTAS (ACCIONES DE FLUJO DE TRABAJO)
    // =====================================================================
    public function changeStatus(Request $request, Survey $survey): JsonResponse
    {
        $validated = $request->validate([
            'status_id' => 'required|exists:statuses,id',
        ]);

        $estadoAnteriorObj = $survey->status;
        $estadoAnterior = $estadoAnteriorObj?->name ?? 'Sin estado';
        $estadoNuevoObj = \App\Models\Status::find($validated['status_id']);

        $ability = $this->habilidadRequerida($estadoAnteriorObj?->slug, $estadoNuevoObj?->slug ?? '');
        $permisos = $request->user()?->role?->permissions ?? [];

        if (!in_array($ability, $permisos, true) && !in_array('status.moderate', $permisos, true)) {
            return response()->json([
                'message' => "No tienes permiso para pasar la encuesta de \"{$estadoAnterior}\" a \"{$estadoNuevoObj?->name}\"."
            ], 403);
        }

        try {
            $survey = $this->statusFlowService->transition($survey, $validated['status_id']);
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $estadoNuevo = $survey->fresh('status')->status?->name ?? 'Sin estado';
        $this->logChange(
            $request,
            $survey->id,
            'Cambio de estado',
            "El estado cambió de \"{$estadoAnterior}\" a \"{$estadoNuevo}\"."
        );
        $this->clearSurveyCache($survey->id);

        return response()->json([
            'message'   => 'Estado de la encuesta actualizado correctamente.',
            'status_id' => $survey->status_id,
            'status'    => $survey->status,
        ], 200);
    }

    // =====================================================================
    // PANTALLA: GESTIÓN DE ENCUESTAS (BOTÓN DUPLICAR)
    // =====================================================================
    public function duplicate(Request $request, Survey $survey): JsonResponse
    {
        $validated = $request->validate([
            'status_id' => 'required|exists:statuses,id',
        ]);

        $duplicatedSurvey = DB::transaction(function () use ($survey, $validated, $request) {
            $newSurvey = $survey->replicate();
            $newSurvey->title = $survey->title . ' (Copia)';
            $newSurvey->section_id = null;
            $newSurvey->status_id = $validated['status_id'];
            $newSurvey->user_id = $request->user()->id;
            $newSurvey->save();

            $newDefaultSectionId = null;

            foreach ($survey->sections as $section) {
                $newSection = $section->replicate();
                $newSection->survey_id = $newSurvey->id;
                $newSection->save();

                if ($section->id === $survey->section_id) {
                    $newDefaultSectionId = $newSection->id;
                }

                foreach ($section->questions as $question) {
                    $newQuestion = $question->replicate();
                    $newQuestion->section_id = $newSection->id;
                    $newQuestion->save();

                    foreach ($question->options as $option) {
                        $newOption = $option->replicate();
                        $newOption->question_id = $newQuestion->id;
                        $newOption->save();
                    }
                }
            }

            $newSurvey->update(['section_id' => $newDefaultSectionId]);

            return $newSurvey;
        });

        $this->logChange(
            $request,
            $duplicatedSurvey->id,
            'Duplicación',
            "Duplicada a partir de la encuesta \"{$survey->title}\" (ID {$survey->id})."
        );

        return response()->json([
            'message'       => 'Encuesta e infraestructura duplicadas con éxito.',
            'new_survey_id' => $duplicatedSurvey->id
        ], 201);
    }

    // =====================================================================
    // PANTALLA: GESTIÓN DE ENCUESTAS (BOTÓN BORRAR)
    // =====================================================================
    public function destroy(Request $request, Survey $survey): JsonResponse
    {
        if ($survey->status && $survey->status->slug === 'published') {
            return response()->json([
                'message' => 'No es posible eliminar una encuesta que ya se encuentra Publicada y recolectando datos.'
            ], 422);
        }

        if ($survey->responses()->exists()) {
            return response()->json([
                'message' => 'No es posible eliminar una encuesta que ya tiene respuestas registradas.'
            ], 422);
        }

        $titulo = $survey->title;
        $surveyId = $survey->id;

        // Se registra ANTES de borrar: la FK survey_id exige que la
        // encuesta exista al momento de insertar el log. El título queda
        // en la descripción para que el registro siga siendo legible
        // aunque, tras el borrado, "survey_id" quede en null (nullOnDelete).
        $this->logChange($request, $surveyId, 'Eliminación', "Se eliminó la encuesta \"{$titulo}\" (ID {$surveyId}).");
        $this->clearSurveyCache($survey->id);

        $survey->delete();

        return response()->json(['message' => 'Encuesta eliminada correctamente.'], 200);
    }
}