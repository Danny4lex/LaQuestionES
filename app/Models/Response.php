<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class Response extends Model
{
    use HasFactory;

    protected $table = 'responses';

    // La tabla real no define timestamps; el control de fecha se hace con submitted_at.
    public $timestamps = false;

    protected $fillable = [
        'anonymous_identifier',
        'source_ip',
        'submitted_at',
        'is_completed',
        'text_value',
        'scale_value',
        'boolean_value',
        'question_id',
        'survey_id',
        'participant_id',
    ];

    protected $casts = [
        'submitted_at' => 'datetime',
        'is_completed' => 'boolean',
        'scale_value' => 'integer',
        'boolean_value' => 'boolean',
    ];

    /**
     * Ciclo de vida del Modelo (Booted)
     * Aplica la lógica que definiste con tu compañero: si no hay un participante identificado,
     * el sistema asegura el orden técnico inyectando un UUID único automáticamente.
     */
    protected static function booted(): void
    {
        static::creating(function (Response $response) {
            if (empty($response->participant_id) && empty($response->anonymous_identifier)) {
                $response->anonymous_identifier = (string) Str::uuid();
            }
        });
    }

    // ==========================================
    // RELACIONES (De dónde viene esta respuesta)
    // ==========================================

    // A qué encuesta pertenece la respuesta
    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }

    // A qué pregunta exacta responde el ciudadano
    public function question(): BelongsTo
    {
        return $this->belongsTo(Question::class, 'question_id');
    }

    // Qué participante la respondió (Nullable: queda en NULL si la encuesta es anónima)
    public function participant(): BelongsTo
    {
        return $this->belongsTo(Participant::class, 'participant_id');
    }

    // ==========================================
    // RELACIONES N:N (Para preguntas de opción múltiple)
    // ==========================================

    // Conecta con las opciones seleccionadas a través de la tabla pivote 'multiple_choise_responses'
    public function selectedOptions(): BelongsToMany
    {
        return $this->belongsToMany(
            QuestionOption::class,
            'multiple_choise_responses', // Nombre de la tabla intermedia/pivote
            'response_id',               // Llave foránea de este modelo en el pivote
            'question_option_id'         // Llave foránea del modelo vecino
        );
    }
}
