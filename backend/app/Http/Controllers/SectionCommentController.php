<?php

namespace App\Http\Controllers;

use App\Models\Section;
use App\Models\SectionComment;
use App\Services\ChangeLogService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

// =========================================================================
// "Papelito" de correcciones por sección (ver migración
// create_section_comments_table). Solo llega hasta aquí Administrador o
// Encuestador — ambos son los únicos roles con "admin.access", que es lo
// que exige el grupo de rutas donde vive este controlador; un
// participante público (Respondedor) nunca tiene sesión en el panel, así
// que no necesita un permission:xxx adicional para cumplir "que solo lo
// vean Administrador y Encuestador".
// =========================================================================
class SectionCommentController extends Controller
{
    public function __construct(
        private readonly ChangeLogService $changeLogService
    ) {}

    /**
     * Lista los comentarios de una sección, del más antiguo al más
     * reciente (orden de conversación), con el autor incluido.
     */
    public function index(Section $section): JsonResponse
    {
        $comments = $section->comments()
            ->with(['user:id,name,role_id', 'user.role:id,name'])
            ->orderBy('created_at')
            ->get();

        return response()->json($comments, 200);
    }

    /**
     * Agrega un comentario a una sección. El autor se toma de la sesión,
     * nunca del body, para que no se pueda suplantar a otro usuario.
     */
    public function store(Request $request, Section $section): JsonResponse
    {
        $validated = $request->validate([
            'comment' => 'required|string|max:2000',
        ]);

        $comment = SectionComment::create([
            'section_id' => $section->id,
            'survey_id' => $section->survey_id,
            'user_id' => $request->user()->id,
            'comment' => $validated['comment'],
        ]);

        $this->changeLogService->log(
            $request,
            'SectionComment',
            'Comentario agregado',
            "Se agregó un comentario de corrección en la sección \"{$section->name}\".",
            $section->survey_id
        );

        return response()->json($comment->load(['user:id,name,role_id', 'user.role:id,name']), 201);
    }

    /**
     * Elimina un comentario. Solo su propio autor puede borrarlo (evita
     * que alguien borre una corrección ajena para "esconderla").
     */
    public function destroy(Request $request, SectionComment $sectionComment): JsonResponse
    {
        if ($sectionComment->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Solo el autor de un comentario puede eliminarlo.',
            ], 403);
        }

        $sectionComment->delete();

        return response()->json(['message' => 'Comentario eliminado.'], 200);
    }
}
