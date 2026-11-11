<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class EmailNotification extends Model
{
    use HasFactory;

    protected $table = 'email_notifications';

    // La migración solo define created_at (con default) y NO tiene updated_at.
    public $timestamps = false;

    protected $fillable = [
        'destination_email',
        'subject',
        'status',
        'sent_at',
        'created_at',
        'survey_id',
        'participant_id',
    ];

    protected $casts = [
        'sent_at' => 'datetime',
        'created_at' => 'datetime',
    ];

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class, 'survey_id');
    }

    public function participant(): BelongsTo
    {
        return $this->belongsTo(Participant::class, 'participant_id');
    }
}
