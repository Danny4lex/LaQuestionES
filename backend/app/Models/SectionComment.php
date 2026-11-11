<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class SectionComment extends Model
{
    use HasFactory;

    protected $table = 'section_comments';

    protected $fillable = [
        'section_id',
        'survey_id',
        'user_id',
        'comment',
    ];

    public function section(): BelongsTo
    {
        return $this->belongsTo(Section::class, 'section_id');
    }

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(SurveyUser::class, 'user_id');
    }
}
