<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\OrganizationalUnitController;
use App\Http\Controllers\SurveyRoleController;
use App\Http\Controllers\SurveyCategoryController;
use App\Http\Controllers\TypeController;
use App\Http\Controllers\StatusController;
use App\Http\Controllers\TemplateController;
use App\Http\Controllers\SurveyController;
use App\Http\Controllers\SectionController;
use App\Http\Controllers\SectionCommentController;
use App\Http\Controllers\QuestionController;
use App\Http\Controllers\QuestionOptionController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\ParticipantController;
use App\Http\Controllers\EmailNotificationController;
use App\Http\Controllers\QrCodeController;
use App\Http\Controllers\ResponseController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\ChangeLogController;
use App\Http\Controllers\SessionLogController;
use App\Http\Controllers\SurveyPublicController;

/*
|============================================================================
| API — Sistema de Gestion de Encuestas e Indicadores Institucionales
| Ministerio de Cultura — modulo construido sobre base-app-2
|============================================================================
|
| GUIA PARA FRONTEND (Carlos):
| - Toda ruta marcada [ADMIN] requiere el JWT real de /auth/login (mismo
|   header Authorization: Bearer que ya se manda hoy). El backend resuelve
|   el SurveyUser ligado a ese usuario y valida su rol/permisos — un token
|   valido pero sin perfil de encuestas, o con un rol sin "admin.access",
|   recibe 401/403. Algunas rutas exigen ademas un permiso puntual del rol
|   (ej. "surveys.changeStatus", "catalogs.manage") — ver
|   AuthenticateSurveyUser y CheckSurveyPermission.
| - Toda ruta marcada [PUBLICA] es para el flujo de un participante SIN
|   login (responde una encuesta via enlace o QR). Nunca mandar cabecera
|   de autenticacion en estas, no la necesitan.
| - Las rutas de /auth/* son del sistema base (login-mc / base-app-2),
|   no pertenecen al modulo de encuestas.
|
|============================================================================
*/


// ============================================================================
// 1. AUTENTICACION — originales de base-app-2, no tocar desde este modulo
// ============================================================================
Route::group(['middleware' => ['api', 'throttle:api'], 'prefix' => 'auth'], function () {
    Route::post('login', [AuthController::class, 'login']);
});

Route::group(['middleware' => ['api', 'auth:api'], 'prefix' => 'auth'], function () {
    Route::post('logout', [AuthController::class, 'logout']);
    Route::post('userInfo', [AuthController::class, 'me']);
    Route::post('refresh', [AuthController::class, 'refresh']);
});

Route::get('/status', fn () => response()->json(["message" => "Active"]));


// ============================================================================
// 2. ZONA ADMINISTRATIVA DEL SISTEMA DE ENCUESTAS — todo [ADMIN]
//    'auth:api' valida el JWT real (login de base-app-2, mismo token que
//    ya envia el frontend en cada request). 'auth.external' resuelve el
//    SurveyUser ligado a ese JWT y bloquea a quien no tenga permiso
//    "admin.access" en su rol (ver AuthenticateSurveyUser).
// ============================================================================
Route::middleware(['auth:api', 'auth.external'])->group(function () {

    // -------------------------------------------------------------------
    // 2.1 Dashboard
    // -------------------------------------------------------------------
    Route::get('/dashboard/summary', [DashboardController::class, 'getSummaryMetrics']);

    // -------------------------------------------------------------------
    // 2.2 Organizacion institucional + 2.3 Roles + 2.5 Catalogos
    //     parametricos.
    //     LECTURA: cualquier rol con admin.access (Creador incluido) la
    //     necesita para poblar selects al crear/editar una encuesta.
    //     ESCRITURA: solo "catalogs.manage" (Administrador) puede crear,
    //     editar o borrar estos catalogos.
    // -------------------------------------------------------------------
    Route::get('/organizational-units/tree', [OrganizationalUnitController::class, 'tree']);
    Route::apiResource('organizational-units', OrganizationalUnitController::class)->only(['index', 'show']);
    Route::apiResource('survey-roles', SurveyRoleController::class)->only(['index', 'show']);
    Route::apiResource('survey-categories', SurveyCategoryController::class)->only(['index', 'show']);
    Route::apiResource('types', TypeController::class)->only(['index', 'show']);
    Route::apiResource('statuses', StatusController::class)->only(['index', 'show']);

    Route::middleware('permission:catalogs.manage')->group(function () {
        Route::apiResource('organizational-units', OrganizationalUnitController::class)->except(['index', 'show']);
        Route::apiResource('survey-roles', SurveyRoleController::class)->except(['index', 'show']);
        Route::apiResource('survey-categories', SurveyCategoryController::class)->except(['index', 'show']);
        Route::apiResource('types', TypeController::class)->except(['index', 'show']);
        Route::apiResource('statuses', StatusController::class)->except(['index', 'show']);
    });

    // -------------------------------------------------------------------
    // 2.4 Auditoria — solo lectura, nunca se edita ni se borra un log.
    //     Se filtra por ?survey_id= para el boton "Historial de cambios"
    //     del listado de encuestas.
    // -------------------------------------------------------------------
    Route::middleware('permission:changelogs.view')->group(function () {
        Route::apiResource('change-logs', ChangeLogController::class)->only(['index', 'show']);
    });
    Route::apiResource('session-logs', SessionLogController::class)->only(['index', 'show']);

    // -------------------------------------------------------------------
    // 2.6 Plantillas de encuesta
    // -------------------------------------------------------------------
    Route::post('/templates/{template}/convert', [TemplateController::class, 'convertToSurvey']);
    Route::apiResource('templates', TemplateController::class);

    // -------------------------------------------------------------------
    // 2.7 Encuestas — CRUD, clonacion y flujo de estados
    //     "surveys.create"/"surveys.delete"/"surveys.changeStatus" se
    //     evaluan por separado porque cada rol tiene un subconjunto
    //     distinto (ej. el rol Creador puede crear/editar pero NO puede
    //     cambiar el estado ni borrar).
    // -------------------------------------------------------------------
    Route::post('/surveys/{survey}/duplicate', [SurveyController::class, 'duplicate'])
        ->middleware('permission:surveys.create');
    Route::patch('/surveys/{survey}/status', [SurveyController::class, 'changeStatus']);
    Route::post('/surveys', [SurveyController::class, 'store'])
        ->middleware('permission:surveys.create');
    Route::delete('/surveys/{survey}', [SurveyController::class, 'destroy'])
        ->middleware('permission:surveys.delete');
    Route::apiResource('surveys', SurveyController::class)->except(['store', 'destroy']);

    // -------------------------------------------------------------------
    // 2.8 Constructor de encuesta: secciones, preguntas, opciones
    //     (cada uno con su endpoint de reordenamiento para drag & drop)
    // -------------------------------------------------------------------
    Route::put('/sections/reorder', [SectionController::class, 'reorder']);
    Route::apiResource('sections', SectionController::class)->except(['index', 'show']);

    // "Papelito" de correcciones por sección — solo Administrador y
    // Encuestador llegan aquí (ambos requieren admin.access, exigido por
    // este mismo grupo de rutas). Ver SectionCommentController.
    Route::get('/sections/{section}/comments', [SectionCommentController::class, 'index']);
    Route::post('/sections/{section}/comments', [SectionCommentController::class, 'store']);
    Route::delete('/section-comments/{sectionComment}', [SectionCommentController::class, 'destroy']);

    Route::put('/questions/reorder', [QuestionController::class, 'reorder']);
    Route::apiResource('questions', QuestionController::class)->except(['index', 'show']);

    Route::put('/question-options/reorder', [QuestionOptionController::class, 'reorder']);
    Route::apiResource('question-options', QuestionOptionController::class)->except(['index', 'show']);

    // -------------------------------------------------------------------
    // 2.9 Distribucion: grupos y participantes invitados
    // -------------------------------------------------------------------
    Route::apiResource('groups', GroupController::class);
    Route::post('/groups/{group}/participants', [GroupController::class, 'addParticipant']);
    Route::delete('/groups/{group}/participants/{groupParticipant}', [GroupController::class, 'removeParticipant']);

    Route::get('/participants', [ParticipantController::class, 'index']);
    Route::get('/participants/{participant}', [ParticipantController::class, 'show']);
    Route::post('/participants/invite', [ParticipantController::class, 'invite']);
    Route::delete('/participants/{participant}', [ParticipantController::class, 'destroy']);

    // -------------------------------------------------------------------
    // 2.10 Notificaciones por correo y codigos QR
    // -------------------------------------------------------------------
    Route::get('/email-notifications', [EmailNotificationController::class, 'index']);
    Route::post('/email-notifications/send', [EmailNotificationController::class, 'send']);
    Route::post('/email-notifications/{emailNotification}/resend', [EmailNotificationController::class, 'resend']);

    Route::post('/surveys/{survey}/qr-code', [QrCodeController::class, 'generate']);
    Route::put('/surveys/{survey}/qr-code', [QrCodeController::class, 'regenerate']);
    Route::get('/surveys/{survey}/qr-code/image', [QrCodeController::class, 'image']); // <img src="...">

    // -------------------------------------------------------------------
    // 2.11 Respuestas recolectadas (vista administrativa)
    // -------------------------------------------------------------------
    Route::get('/responses', [ResponseController::class, 'index']);
    Route::get('/responses/{response}', [ResponseController::class, 'show']);
    Route::get('/surveys/{survey}/questions/{questionId}/summary', [ResponseController::class, 'summaryByQuestion']);

    // -------------------------------------------------------------------
    // 2.12 Reportes e indicadores
    // -------------------------------------------------------------------
    Route::get('/reports/surveys/{survey}', [ReportController::class, 'bySurvey']);
    Route::get('/reports/departments', [ReportController::class, 'byDepartment']);
    Route::get('/reports/surveys/{survey}/satisfaction', [ReportController::class, 'satisfactionIndicators']);

    // Pestaña "Por encuestado" de SurveyResultsPage.vue — paginado, 5 por
    // página (?page=n).
    Route::get('/reports/surveys/{survey}/by-participant', [ReportController::class, 'byParticipant']);
    Route::get('/reports/compare-periods', [ReportController::class, 'comparePeriods']);
    Route::get('/reports/surveys/{survey}/export-excel', [ReportController::class, 'exportExcel']); // descarga .xlsx
    Route::get('/reports/surveys/{survey}/export-pdf', [ReportController::class, 'exportPdf']);       // descarga .pdf

});


// ============================================================================
// 3. ZONA PUBLICA — participante SIN login. NUNCA agregar middleware aqui.
// ============================================================================

// Encuesta tipo "Publica": acceso directo por ID (enlace o QR general)
Route::get('/public/surveys/{survey}', [SurveyPublicController::class, 'show']);
Route::post('/public/surveys/{survey}/submit', [SurveyPublicController::class, 'submit']);

// Encuesta tipo "Privada": acceso via token individual de invitacion
Route::get('/public/participants/{token}', [SurveyPublicController::class, 'showByToken']);
Route::post('/public/participants/{token}/submit', [SurveyPublicController::class, 'submitByToken']);