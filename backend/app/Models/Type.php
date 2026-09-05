<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Type extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'types';

    public $timestamps = false;

    protected $casts = [
        'deleted_at' => 'datetime',
    ];
    protected $fillable = [
        'name',
        'description',
    ];

    public function surveys(): HasMany
    {
        return $this->hasMany(Survey::class, 'type_id');
    }
}
