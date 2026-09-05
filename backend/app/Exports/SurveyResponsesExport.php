<?php

namespace App\Exports;

use App\Models\Response as SurveyResponse;
use Illuminate\Contracts\Support\Responsable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;

// =========================================================================
// Traduce la colección de respuestas de una encuesta a filas planas de
// Excel. Se aplana la respuesta polimórfica (text_value/scale_value/
// boolean_value/opciones seleccionadas) a una sola columna "Respuesta"
// legible para quien exporte el reporte, sin exponer el detalle interno
// de diseño de la tabla.
// =========================================================================
class SurveyResponsesExport implements FromCollection, WithHeadings, WithMapping
{
    public function __construct(private readonly int $surveyId) {}

    public function collection()
    {
        return SurveyResponse::with(['question', 'selectedOptions', 'participant'])
            ->where('survey_id', $this->surveyId)
            ->orderBy('submitted_at')
            ->get();
    }

    public function headings(): array
    {
        return ['ID', 'Pregunta', 'Respuesta', 'Participante', 'Anónimo', 'Fecha de envío', 'Completada'];
    }

    public function map($response): array
    {
        return [
            $response->id,
            $response->question->statement ?? '',
            $this->formatAnswer($response),
            $response->participant->name ?? ($response->participant->email ?? '—'),
            $response->participant_id === null ? 'Sí' : 'No',
            optional($response->submitted_at)->format('d/m/Y H:i'),
            $response->is_completed ? 'Sí' : 'No',
        ];
    }

    private function formatAnswer(SurveyResponse $response): string
    {
        if ($response->text_value !== null) {
            return $response->text_value;
        }

        if ($response->scale_value !== null) {
            return (string) $response->scale_value;
        }

        if ($response->boolean_value !== null) {
            return $response->boolean_value ? 'Sí' : 'No';
        }

        if ($response->selectedOptions->isNotEmpty()) {
            return $response->selectedOptions->pluck('option_text')->implode(', ');
        }

        return '';
    }
}
