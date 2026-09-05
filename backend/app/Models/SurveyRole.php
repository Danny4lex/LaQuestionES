<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

// Catálogo de roles PROPIO de encuestas-mc. Distinto de App\Models\Role
// (el real de base-app-2, tabla "role", que gobierna login/JWT).
class SurveyRole extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'survey_roles';

    public $timestamps = false;

    protected $fillable = [
        'name',
        'description',
        'permissions',
    ];

    protected $casts = [
        'deleted_at'  => 'datetime',
        'permissions' => 'array',
    ];

    public function users(): HasMany
    {
        return $this->hasMany(SurveyUser::class, 'role_id');
    }

    // Habilidades reales que controla este rol. Se usa desde el
    // middleware CheckSurveyPermission y se expone al frontend en el
    // login para que la UI pueda ocultar acciones que el rol no permite.
    public function hasPermission(string $ability): bool
    {
        return in_array($ability, $this->permissions ?? [], true);
    }
}
