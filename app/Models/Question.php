<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Question extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'questions';

    public $timestamps = false;

    protected $fillable = [
        'statement',
        'type',
        'is_mandatory',
        'max_length',
        'sort_order',
        'section_id',
        'template_id',
    ];

    protected $casts = [
        'is_mandatory' => 'boolean',
        'max_length' => 'integer',
        'sort_order' => 'integer',
        'section_id' => 'integer',
        'template_id' => 'integer',
        'deleted_at' => 'datetime',
    ];

    public function section(): BelongsTo
    {
        return $this->belongsTo(Section::class, 'section_id');
    }

    public function template(): BelongsTo
    {
        return $this->belongsTo(Template::class, 'template_id');
    }

    public function options(): HasMany
    {
        return $this->hasMany(QuestionOption::class, 'question_id');
    }
}
