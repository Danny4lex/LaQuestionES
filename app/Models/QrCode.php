<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class QrCode extends Model
{
    use HasFactory;

    protected $table = 'qr_codes';

    // La migración usa generated_at, no tiene created_at/updated_at de Laravel.
    public $timestamps = false;

    protected $fillable = [
        'public_url',
        'generated_at',
        'survey_id',
    ];

    protected $casts = [
        'generated_at' => 'datetime',
    ];

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }
}
