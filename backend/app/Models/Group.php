<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Group extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'groups';

    protected $primaryKey = 'group_id';

    public $incrementing = true;

    // Deshabilitado: El diccionario no especifica timestamps nativos (created_at/updated_at de Laravel)
    public $timestamps = false;

    protected $fillable = [
        'name',
        'description',
        'created_at',
        'created_by',
        'dependency_id',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'dependency_id' => 'integer',
        'created_by' => 'integer',
        'deleted_at' => 'datetime',
    ];

    /**
     * Usuario del módulo de encuestas que registró el grupo (created_by).
     * FIX: apuntaba a App\Models\User (tabla "users", login de base-app-2),
     * pero la migración de "groups" define created_by como FK hacia
     * "survey_users" (constrained('survey_users')), igual que en Survey y
     * Template. Con el modelo equivocado, ->load('creator') consultaba el
     * id correcto en la tabla equivocada y devolvía null o un usuario
     * distinto al real.
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(SurveyUser::class, 'created_by');
    }

    /**
     * Dependencia dueña del grupo (dependency_id -> organizational_units.id).
     */
    public function department(): BelongsTo
    {
        return $this->belongsTo(OrganizationalUnit::class, 'dependency_id');
    }

    /**
     * Listado directo de los integrantes/filas del directorio de este grupo.
     */
    public function groupParticipants(): HasMany
    {
        return $this->hasMany(GroupParticipant::class, 'group_id', 'group_id');
    }
}
