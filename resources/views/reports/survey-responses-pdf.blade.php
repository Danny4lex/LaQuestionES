<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Reporte de Respuestas</title>
    <style>
        body {
            font-family: sans-serif;
            font-size: 11px;
        }

        h1 {
            font-size: 16px;
            margin-bottom: 4px;
        }

        p.subtitle {
            color: #555;
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        th,
        td {
            border: 1px solid #ccc;
            padding: 5px 8px;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
        }
    </style>
</head>

<body>
    <h1>{{ $survey->title }}</h1>
    <p class="subtitle">Reporte de respuestas — generado el {{ now()->format('d/m/Y H:i') }}</p>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Pregunta</th>
                <th>Respuesta</th>
                <th>Participante</th>
                <th>Anónimo</th>
                <th>Fecha de envío</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($responses as $response)
            <tr>
                <td>{{ $response->id }}</td>
                <td>{{ $response->question->statement ?? '' }}</td>
                <td>
                    @if ($response->text_value !== null)
                    {{ $response->text_value }}
                    @elseif ($response->scale_value !== null)
                    {{ $response->scale_value }}
                    @elseif ($response->boolean_value !== null)
                    {{ $response->boolean_value ? 'Sí' : 'No' }}
                    @elseif ($response->selectedOptions->isNotEmpty())
                    {{ $response->selectedOptions->pluck('option_text')->implode(', ') }}
                    @endif
                </td>
                <td>{{ $response->participant->name ?? ($response->participant->email ?? '—') }}</td>
                <td>{{ $response->participant_id === null ? 'Sí' : 'No' }}</td>
                <td>{{ optional($response->submitted_at)->format('d/m/Y H:i') }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</body>

</html>