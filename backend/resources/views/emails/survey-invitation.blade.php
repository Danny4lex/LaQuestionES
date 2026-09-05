<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{ $surveyTitle }}</title>
    <style>
        body { font-family: sans-serif; background-color: #f4f4f4; padding: 20px; }
        .card { background: #ffffff; border-radius: 8px; padding: 24px; max-width: 500px; margin: 0 auto; }
        h1 { font-size: 18px; color: #222; }
        p { color: #444; line-height: 1.5; }
        .btn { display: inline-block; margin-top: 16px; padding: 12px 24px; background-color: #2563eb; color: #ffffff; text-decoration: none; border-radius: 6px; }
        .footer { font-size: 12px; color: #999; margin-top: 24px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>{{ $surveyTitle }}</h1>
        <p>{{ $participantName }},</p>
        <p>Le invitamos a participar en la siguiente encuesta institucional del Ministerio de Cultura:</p>
        @if ($surveyDescription)
            <p>{{ $surveyDescription }}</p>
        @endif
        <a href="{{ $accessUrl }}" class="btn">Responder encuesta</a>
        <p class="footer">Si no puede hacer clic en el botón, copie y pegue este enlace en su navegador:<br>{{ $accessUrl }}</p>
    </div>
</body>
</html>
