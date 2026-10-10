@extends('reports.layout')

@section('title', 'Resultados de encuesta')
@section('heading', $survey->title)
@section('subheading', 'Resultados de la encuesta')

@section('content')
    @php
        $slug = $survey->status->slug ?? 'draft';
        $badge = in_array($slug, ['published', 'scheduled', 'closed'], true)
            ? 'badge-' . $slug
            : 'badge-draft';
        $fmt = fn($d) => $d ? $d->format('d/m/Y') : '—';
    @endphp

    {{-- Indicadores principales --}}
    <table class="cards">
        <tr>
            <td>
                <div class="card-value">{{ $results['respondents'] }}</div>
                <div class="card-label">Encuestados</div>
            </td>
            <td>
                <div class="card-value">{{ $results['answers'] }}</div>
                <div class="card-label">Respuestas registradas</div>
            </td>
            <td>
                <div class="card-value">{{ $results['completion_rate'] }}%</div>
                <div class="card-label">Tasa de finalización</div>
            </td>
            <td>
                <div class="card-value">
                    {{ $results['satisfaction_avg'] !== null ? $results['satisfaction_avg'] . ' / 5' : '—' }}
                </div>
                <div class="card-label">Satisfacción promedio</div>
            </td>
        </tr>
    </table>

    {{-- Datos generales --}}
    <h2>Datos de la encuesta</h2>
    <table class="info">
        <tr>
            <td class="k">Dependencia</td><td class="v">{{ $survey->department->name ?? '—' }}</td>
            <td class="k">Categoría</td><td class="v">{{ $survey->category->name ?? '—' }}</td>
        </tr>
        <tr>
            <td class="k">Tipo de acceso</td><td class="v">{{ $survey->type->name ?? '—' }}</td>
            <td class="k">Estado</td>
            <td class="v"><span class="badge {{ $badge }}">{{ $survey->status->name ?? '—' }}</span></td>
        </tr>
        <tr>
            <td class="k">Vigencia</td>
            <td class="v">{{ $fmt($survey->start_date) }} al {{ $fmt($survey->end_date) }}</td>
            <td class="k">Modalidad</td>
            <td class="v">{{ $survey->is_anonymous ? 'Anónima' : 'Identificada' }}</td>
        </tr>
    </table>

    @if ($survey->description)
        <p class="muted" style="margin-top:8px; font-size:9px;">{{ $survey->description }}</p>
    @endif

    {{-- Resultados por pregunta --}}
    <h2>Resultados por pregunta</h2>
    @forelse ($results['questions'] as $q)
        <div class="question">
            <div class="q-head">
                <span class="q-num">{{ $q['number'] }}.</span> {{ $q['statement'] }}
                @if ($q['mandatory']) <span style="color:#E42716;">*</span>@endif
            </div>
            <div class="q-meta">
                {{ $q['section'] }} · {{ $q['type_label'] }} ·
                {{ $q['total'] }} {{ $q['total'] === 1 ? 'respuesta' : 'respuestas' }}
            </div>

            @if ($q['type'] === 'escala' && $q['total'] > 0)
                <p class="avg">
                    {{ $q['average'] }}
                    <span>promedio (escala 1-5)</span>
                </p>
            @endif

            @if (isset($q['bars']) && $q['total'] > 0)
                <table class="bars">
                    @foreach ($q['bars'] as $b)
                        <tr>
                            <td class="bar-label">{{ $b['label'] }}</td>
                            <td class="bar-track">
                                <div class="track">
                                    <div class="fill" style="width: {{ max(0, min(100, $b['pct'])) * 2.1 }}px;"></div>
                                </div>
                            </td>
                            <td class="bar-value">{{ $b['count'] }} ({{ $b['pct'] }}%)</td>
                        </tr>
                    @endforeach
                </table>
            @elseif (isset($q['samples']) && count($q['samples']))
                <p class="muted" style="font-size:8px; margin-bottom:4px;">Últimas respuestas:</p>
                @foreach ($q['samples'] as $texto)
                    <div class="quote">{{ $texto }}</div>
                @endforeach
            @else
                <p class="muted">Sin respuestas todavía.</p>
            @endif
        </div>
    @empty
        <p class="muted">Esta encuesta todavía no tiene preguntas.</p>
    @endforelse

    {{-- Detalle de respuestas --}}
    <h2>Detalle de respuestas</h2>
    @if (count($detail['rows']))
        <table class="data">
            <thead>
                <tr>
                    <th style="width:34%;">Pregunta</th>
                    <th>Respuesta</th>
                    @unless ($survey->is_anonymous)
                        <th style="width:20%;">Encuestado</th>
                    @endunless
                    <th style="width:14%;">Fecha</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($detail['rows'] as $i => $response)
                    <tr class="{{ $i % 2 ? 'alt' : '' }}">
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
                        @unless ($survey->is_anonymous)
                            <td>
                                {{ $response->participant->name
                                    ?? ($response->participant->email ?? 'Anónimo') }}
                            </td>
                        @endunless
                        <td>{{ optional($response->submitted_at)->format('d/m/Y H:i') }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        @if ($detail['truncated'])
            <div class="note">
                Se muestran las primeras {{ $detail['limit'] }} de {{ $detail['total'] }} respuestas.
                El detalle completo está disponible en la exportación a Excel.
            </div>
        @endif
    @else
        <p class="muted">Todavía no hay respuestas registradas.</p>
    @endif
@endsection