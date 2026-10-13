<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class OrganizationalUnit extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'organizational_units';

    public $timestamps = true;

    protected $fillable = [
        'name',
        'code',
        'description',
        'status',
        'parent_id',
    ];

    protected $casts = [
        'status' => 'boolean',
        'parent_id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'deleted_at' => 'datetime',
    ];

    // ==========================================
    // JERARQUÍA (Autorreferencia)
    // ==========================================

    public function parent(): BelongsTo
    {
        return $this->belongsTo(OrganizationalUnit::class, 'parent_id');
    }

    /**
     * Hijos directos, un solo nivel. Se usa en el día a día (formularios,
     * listados simples) donde NO se necesita el árbol completo — así se
     * evita el costo de cargar toda la descendencia cuando no hace falta.
     */
    public function children(): HasMany
    {
        return $this->hasMany(OrganizationalUnit::class, 'parent_id');
    }

    /**
     * Hijos con TODA su descendencia cargada, sin importar la profundidad.
     * Patrón estándar de Laravel para árboles recursivos: la propia
     * relación se pide a sí misma vía with('childrenRecursive'), y Eloquent
     * repite el proceso automáticamente hasta que un nodo ya no tenga hijos.
     * NOTA: Laravel convierte este nombre a snake_case ("children_recursive")
     * al serializar a JSON — eso se corrige en el Controller, no aquí.
     * Úsala solo donde de verdad necesites el árbol completo (ej. el
     * endpoint /organizational-units/tree), porque carga TODOS los niveles de una vez.
     */
    public function childrenRecursive(): HasMany
    {
        return $this->hasMany(OrganizationalUnit::class, 'parent_id')->with('childrenRecursive');
    }



        // ==========================================
    // IDs de una unidad y de TODA su descendencia (sin importar la
    // profundidad). Se usa para invitar a una organización completa con
    // sus sub-dependencias. Protegido contra ciclos en la jerarquía.
    // ==========================================
    public static function idsWithDescendants(int $rootId): array
    {
        $ids = [$rootId];
        $frontier = [$rootId];

        while (!empty($frontier)) {
            $hijos = static::whereIn('parent_id', $frontier)->pluck('id')->all();
            $frontier = array_values(array_diff($hijos, $ids));
            $ids = array_merge($ids, $frontier);
        }

        return $ids;
    }
    // ==========================================
    // RELACIONES INVERSAS
    // ==========================================

    public function users(): HasMany
    {
        return $this->hasMany(User::class, 'dependency_id');
    }

    public function surveys(): HasMany
    {
        return $this->hasMany(Survey::class, 'dependency_id');
    }

    public function groups(): HasMany
    {
        return $this->hasMany(Group::class, 'dependency_id');
    }
}
