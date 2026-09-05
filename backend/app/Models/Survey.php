<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Survey extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'surveys';

    // Por defecto las encuestas sí llevan control de fechas de creación y actualización
    public $timestamps = true;

    protected $fillable = [
        'title',
        'description',
        'is_single_response',
        'start_date',
        'end_date',
        'section_id',
        'dependency_id',
        'user_id',
        'template_id',
        'survey_category_id',
        'type_id',
        'status_id',
    ];

    protected $casts = [
        'is_single_response' => 'boolean',
        'section_id' => 'integer',
        'dependency_id' => 'integer',
        'user_id' => 'integer',
        'template_id' => 'integer',
        'survey_category_id' => 'integer',
        'type_id' => 'integer',
        'status_id' => 'integer',
        'start_date' => 'datetime',
        'end_date' => 'datetime',
        'deleted_at' => 'datetime',
    ];

    // ==========================================
    // RELACIONES (A qué catálogos y dueños pertenece)
    // ==========================================

    // La dependencia que creó y es dueña de la encuesta
    public function department(): BelongsTo
    {
        return $this->belongsTo(OrganizationalUnit::class, 'dependency_id');
    }

    public function owner(): BelongsTo
    {
    return $this->belongsTo(SurveyUser::class, 'user_id');
    }

    // Su categoría (Informativa, Satisfacción, Clima Organizacional, etc.)
    public function category(): BelongsTo
    {
        return $this->belongsTo(SurveyCategory::class, 'survey_category_id');
    }

    // Su tipo de acceso (Pública o Privada)
    public function type(): BelongsTo
    {
        return $this->belongsTo(Type::class, 'type_id');
    }

    // Su estado en el flujo de aprobación (Borrador, Publicada, Cerrada, etc.)
    public function status(): BelongsTo
    {
        return $this->belongsTo(Status::class, 'status_id');
    }

    // ==========================================
    // RELACIONES (Qué contiene la encuesta hacia abajo)
    // ==========================================

    // Una encuesta se divide en múltiples secciones lógicas
    public function sections(): HasMany
    {
        return $this->hasMany(Section::class, 'survey_id');
    }

    // Registro de todas las respuestas que ha recibido esta encuesta
    public function responses(): HasMany
    {
        return $this->hasMany(Response::class, 'survey_id');
    }

    // Cola de notificaciones por correo programadas para esta encuesta
    public function emailNotifications(): HasMany
    {
        return $this->hasMany(EmailNotification::class, 'survey_id');
    }

    // El código QR asignado a esta encuesta para su distribución pública
    public function qrCode(): HasMany
    {
        return $this->hasMany(QrCode::class, 'survey_id');
    }
}
