<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class SurveyCategory extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'survey_categories';

    public $timestamps = false;

    protected $fillable = [
        'name',
        'status',
        'description',
    ];

    protected $casts = [
        'status' => 'boolean',
        'deleted_at' => 'datetime',
    ];

    public function surveys(): HasMany
    {
        return $this->hasMany(Survey::class, 'survey_category_id');
    }
}
