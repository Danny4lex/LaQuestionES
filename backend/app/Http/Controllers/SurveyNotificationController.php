<?php

namespace App\Http\Controllers;

use App\Models\SurveyNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SurveyNotificationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $base = SurveyNotification::where('user_id', $request->user()->id);

        return response()->json([
            'unread_count' => (clone $base)->whereNull('read_at')->count(),
            'data'         => $base->latest()->limit(30)->get(),
        ]);
    }

    public function read(Request $request, SurveyNotification $notification): JsonResponse
    {
        abort_if((int) $notification->user_id !== (int) $request->user()->id, 403);

        if (!$notification->read_at) {
            $notification->update(['read_at' => now()]);
        }

        return response()->json(['ok' => true]);
    }

    public function readAll(Request $request): JsonResponse
    {
        SurveyNotification::where('user_id', $request->user()->id)
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        return response()->json(['ok' => true]);
    }
}