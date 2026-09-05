<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Template extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'templates';

    protected $fillable = [
        'name',
        'description',
        'is_public',
        'user_id',
    ];

    protected $casts = [
        'is_public' => 'boolean',
        'deleted_at' => 'datetime',
    ];

    /**
     * FIX: apuntaba a App\Models\User (tabla "users" de base-app-2), pero
     * la migración de "templates" define user_id como FK hacia
     * "survey_users" (constrained('survey_users')) — mismo tipo de
     * mismatch que Group::creator(). Con el modelo equivocado,
     * Template::with('user') resolvía el id contra la tabla equivocada.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(SurveyUser::class, 'user_id');
    }

    public function questions(): HasMany
    {
        return $this->hasMany(Question::class, 'template_id');
    }
}
