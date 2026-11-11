<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Status extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'statuses';

    public $timestamps = false;

    protected $fillable = [
        'name',
        'slug',
        'description',
    ];

    protected $casts = [
        'deleted_at' => 'datetime',
    ];

    public function surveys(): HasMany
    {
        return $this->hasMany(Survey::class, 'status_id');
    }
}