<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SurveyNotification extends Model
{
    protected $table = 'survey_notifications';

    protected $fillable = ['user_id', 'survey_id', 'type', 'title', 'message', 'read_at'];

    protected $casts = ['read_at' => 'datetime'];
}