<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class SessionLog extends Model
{
    use HasFactory;

    protected $table = 'session_logs';

    // La migración usa access_date, no tiene created_at/updated_at de Laravel.
    public $timestamps = false;

    protected $fillable = [
        'ip_address',
        'device',
        'access_date',
        'status',
        'user_id',
    ];

    protected $casts = [
        'access_date' => 'datetime',
    ];

    // CORRECCIÓN: mismo patrón de bug ya corregido en Group::creator(),
    // Template::user() y ChangeLog::user() — apuntaba a App\Models\User
    // pero la migración liga user_id contra "survey_users".
    public function user(): BelongsTo
    {
        return $this->belongsTo(SurveyUser::class, 'user_id');
    }
}
