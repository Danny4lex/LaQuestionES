<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class QuestionOption extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'question_options';

    public $timestamps = false;

    protected $fillable = [
        'option_text',
        'sort_order',
        'question_id',
    ];

    protected $casts = [
        'sort_order' => 'integer',
        'deleted_at' => 'datetime',
    ];

    public function question(): BelongsTo
    {
        return $this->belongsTo(Question::class, 'question_id');
    }

    public function responses(): BelongsToMany
    {
        return $this->belongsToMany(
            Response::class,
            'multiple_choise_responses',
            'question_option_id',
            'response_id'
        );
    }
}
