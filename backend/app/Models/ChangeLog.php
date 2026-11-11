<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ChangeLog extends Model
{
    use HasFactory;

    protected $table = 'change_logs';

    protected $primaryKey = 'action_id';

    public $timestamps = false;

    protected $fillable = [
        'module',
        'action',
        'description',
        'action_date',
        'user_id',
        'survey_id',
    ];

    protected $casts = [
        'action_date' => 'datetime',
    ];

    // CORRECCIÓN: apuntaba a App\Models\User (login/JWT de base-app-2),
    // pero la migración declara la FK contra "survey_users". Con la
    // clase equivocada, el eager-load ->with('user') nunca resolvía al
    // autor real del cambio.
    public function user(): BelongsTo
    {
        return $this->belongsTo(SurveyUser::class, 'user_id');
    }

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }
}
