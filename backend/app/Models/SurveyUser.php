<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

// Espejo LOCAL del usuario institucional dentro del módulo de encuestas.
// Distinto de App\Models\User (el real de base-app-2, con password/JWT).
// La integración definitiva entre ambos queda pendiente de definición
// institucional — mientras tanto, esta es la fuente de verdad de
// autoría dentro de encuestas-mc.
class SurveyUser extends Model
{
    use HasFactory;

    protected $table = 'survey_users';

    public $timestamps = true;

    protected $fillable = [
        'external_id',
        'name',
        'email',
        'is_active',
        'role_id',
        'dependency_id',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function role(): BelongsTo
    {
        return $this->belongsTo(SurveyRole::class, 'role_id');
    }

    public function dependency(): BelongsTo
    {
        return $this->belongsTo(OrganizationalUnit::class, 'dependency_id');
    }

    public function surveys(): HasMany
    {
        return $this->hasMany(Survey::class, 'user_id');
    }

    public function templates(): HasMany
    {
        return $this->hasMany(Template::class, 'user_id');
    }

    public function groups(): HasMany
    {
        return $this->hasMany(Group::class, 'created_by');
    }

    public function verifications(): HasMany
    {
        return $this->hasMany(Verification::class, 'user_id');
    }

    public function sessionLogs(): HasMany
    {
        return $this->hasMany(SessionLog::class, 'user_id');
    }

    public function changeLogs(): HasMany
    {
        return $this->hasMany(ChangeLog::class, 'user_id');
    }
}
