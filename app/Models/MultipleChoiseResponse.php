<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MultipleChoiseResponse extends Model
{
    use HasFactory;

    protected $table = 'multiple_choise_responses';

    public $incrementing = false;

    public $timestamps = false;

    protected $fillable = [
        'response_id',
        'question_option_id',
    ];

    // ==========================================
    // RELACIONES (Los cables de la tabla intermedia)
    // ==========================================

    // Se conecta con la respuesta general del formulario
    public function response(): BelongsTo
    {
        return $this->belongsTo(Response::class, 'response_id');
    }

    // Se conecta con la opción específica que el ciudadano marcó
    public function questionOption(): BelongsTo
    {
        return $this->belongsTo(QuestionOption::class, 'question_option_id');
    }
}
