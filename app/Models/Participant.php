<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class Participant extends Model
{
    use HasFactory;

    protected $table = 'participants';

    // Deshabilitado: El control de fechas se gestiona con registered_at y responded_at según el documento
    public $timestamps = false;

    protected $fillable = [
        'type',
        'name',
        'email',
        'phone',
        'access_token',
        'invitation_status',
        'registered_at',
        'responded_at',
        'survey_id',
    ];

    protected $casts = [
        'registered_at' => 'datetime',
        'responded_at' => 'datetime',
        'survey_id' => 'integer',
    ];

    /**
     * Evento de Eloquent para automatizar la inyección del UUID seguro.
     */
    protected static function booted(): void
    {
        static::creating(function (Participant $participant) {
            if (empty($participant->access_token)) {
                $participant->access_token = (string) Str::uuid();
            }
        });
    }

    /**
     * Encuesta asignada al participante (survey_id -> surveys.id).
     */
    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }

    /**
     * Respuestas del dominio de recolección asociadas a este participante.
     */
    public function responses(): HasMany
    {
        return $this->hasMany(Response::class, 'participant_id');
    }

    /**
     * Notificaciones de correo electrónico enviadas a este participante.
     */
    public function emailNotifications(): HasMany
    {
        return $this->hasMany(EmailNotification::class, 'participant_id');
    }
}
