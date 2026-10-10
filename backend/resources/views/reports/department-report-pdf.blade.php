@extends('reports.layout')

@section('title', 'Reporte por dependencia')
@section('heading', $department->name)
@section('subheading', 'Reporte de encuestas por dependencia')

@section('content')
    @php
        $max = max(1, (int) $surveys->max('responses_count'));
        $activas  = $surveys->filter(fn($s) => ($s->status->slug ?? '') === 'published')->count();
        $cerradas = $surveys->filter(fn($s) => ($s->status->slug ?? '') === 'closed')->count();
    @endphp

    <table class="cards">
        <tr>
            <td>
                <div class="card-value">{{ $surveys->count() }}</div>
                <div class="card-label">Encuestas</div>
            </td>
            <td>
                <div class="card-value">{{ $surveys->sum('responses_count') }}</div>
                <div class="card-label">Respuestas registradas</div>
            </td>
            <td>
                <div class="card-value">{{ $activas }}</div>
                <div class="card-label">Encuestas activas</div>
            </td>
            <td>
                <div class="card-value">{{ $cerradas }}</div>
                <div class="card-label">Encuestas cerradas</div>
            </td>
        </tr>
    </table>

    <h2>Encuestas de la dependencia</h2>

    @if ($surveys->isEmpty())
        <p class="muted">Esta dependencia todavía no tiene encuestas.</p>
    @else
        <table class="data">
            <thead>
                <tr>
                    <th style="width:36%;">Encuesta</th>
                    <th>Categoría</th>
                    <th>Estado</th>
                    <th style="width:24%;">Respuestas</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($surveys as $i => $s)
                    @php
                        $slug = $s->status->slug ?? 'draft';
                        $badge = in_array($slug, ['published', 'scheduled', 'closed'], true)
                            ? 'badge-' . $slug
                            : 'badge-draft';
                        $pct = min(100, ($s->responses_count / $max) * 100);
                    @endphp
                    <tr class="{{ $i % 2 ? 'alt' : '' }}">
                        <td><strong>{{ $s->title }}</strong></td>
                        <td>{{ $s->category->name ?? '—' }}</td>
                        <td><span class="badge {{ $badge }}">{{ $s->status->name ?? '—' }}</span></td>
                        <td>
                            <div class="track" style="width:80px; display:inline-block; vertical-align:middle;">
                                <div class="fill" style="width: {{ $pct * 0.8 }}px;"></div>
                            </div>
                            <strong style="margin-left: 6px;">{{ $s->responses_count }}</strong>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @endif
@endsection