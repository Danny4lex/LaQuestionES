<template>
  <div class="results-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <span class="hero__eyebrow">Encuestas</span>
          <h1 class="text-page-title hero__title">Resultados de encuesta</h1>
          <p class="text-subtitle hero__subtitle">{{ survey?.title }}</p>
        </div>

        <div class="hero__actions">
          <v-btn
            color="secondary"
            variant="outlined"
            prepend-icon="mdi-file-excel-outline"
            class="text-button"
            :loading="exportandoExcel"
            :disabled="loading || !!error"
            @click="exportarExcel"
          >
            Exportar Excel
          </v-btn>
          <v-btn
            color="secondary"
            variant="outlined"
            prepend-icon="mdi-file-pdf-box"
            class="text-button"
            :loading="exportandoPdf"
            :disabled="loading || !!error"
            @click="exportarPdf"
          >
            Exportar PDF
          </v-btn>
          <v-btn
            color="primary"
            variant="flat"
            prepend-icon="mdi-arrow-left"
            class="text-button"
            @click="$router.push('/surveys')"
          >
            Volver al listado
          </v-btn>
        </div>
      </div>
    </div>

    <!-- Cargando -->
    <LoadingState v-if="loading" message="Cargando resultados" />

    <!-- Error -->
    <div v-else-if="error" class="text-center py-8">
      <v-icon size="48" color="error">mdi-alert-circle-outline</v-icon>
      <p class="mt-3 text-body-1">{{ error }}</p>
    </div>

    <!-- Contenido -->
    <template v-else>
      <v-tabs v-model="tabActiva" color="primary" class="mb-5 results-tabs">
        <v-tab value="boletin" class="text-button">Boletín</v-tab>
        <v-tab value="general" class="text-button">Resultados general</v-tab>
        <v-tab value="por-encuestado" class="text-button" @click="asegurarCargaPorEncuestado">
          Por encuestado
        </v-tab>
      </v-tabs>

      <v-window v-model="tabActiva">
        <!-- ============================================================ -->
        <!-- PESTAÑA: BOLETÍN                                              -->
        <!-- ============================================================ -->
        <v-window-item value="boletin">
          <v-card class="boletin-card" variant="flat">
            <div class="boletin-hero">
              <div class="boletin-hero__eyebrow">Boletín de resultados</div>
              <h2 class="boletin-hero__title">{{ survey?.title }}</h2>
              <p class="boletin-hero__sub">{{ survey?.description }}</p>

              <div class="boletin-hero__meta">
                <span><v-icon size="14">mdi-domain</v-icon> {{ survey?.department?.name || '—' }}</span>
                <span><v-icon size="14">mdi-tag-outline</v-icon> {{ survey?.category?.name || '—' }}</span>
                <span>
                  <v-icon size="14">mdi-calendar-range</v-icon>
                  {{ formatearFecha(survey?.start_date) }} — {{ formatearFecha(survey?.end_date) }}
                </span>
                <span><v-icon size="14">mdi-information-outline</v-icon> {{ survey?.status?.name || '—' }}</span>
              </div>
            </div>

            <v-card-text class="pa-7">
              <div class="d-flex justify-end mb-5 no-print">
                <v-btn
                  variant="outlined"
                  color="secondary"
                  size="small"
                  class="text-button"
                  prepend-icon="mdi-printer-outline"
                  @click="imprimirBoletin"
                >
                  Imprimir boletín
                </v-btn>
              </div>

              <div class="kpi-grid mb-8">
                <div class="kpi-card kpi-card--primary">
                  <div class="kpi-card__icon">
                    <v-icon size="20">mdi-account-group-outline</v-icon>
                  </div>
                  <div class="kpi-card__value">{{ metrics.total_responses }}</div>
                  <div class="kpi-card__label">Respuestas totales</div>
                </div>
                <div class="kpi-card kpi-card--success">
                  <div class="kpi-card__icon">
                    <v-icon size="20">mdi-check-circle-outline</v-icon>
                  </div>
                  <div class="kpi-card__value">{{ metrics.completed_responses }}</div>
                  <div class="kpi-card__label">Respuestas completas</div>
                </div>
                <div class="kpi-card kpi-card--accent">
                  <div class="kpi-card__icon">
                    <v-icon size="20">mdi-percent-outline</v-icon>
                  </div>
                  <div class="kpi-card__value">{{ metrics.completion_rate }}%</div>
                  <div class="kpi-card__label">Tasa de finalización</div>
                </div>
              </div>

              <template v-if="satisfaction.length">
                <div class="section-title">Indicadores de satisfacción</div>
                <div v-for="indicator in satisfaction" :key="indicator.question_id" class="mb-4">
                  <div class="d-flex align-center justify-space-between mb-2">
                    <p class="text-body-small mb-0">{{ indicator.statement }}</p>
                    <span class="summary-value">{{ indicator.average_score ?? '—' }} / 5</span>
                  </div>
                  <v-progress-linear
                    :model-value="((indicator.average_score || 0) / 5) * 100"
                    color="#4880FF"
                    height="6"
                    rounded
                    bg-color="#E8F0F8"
                  />
                </div>
                <v-divider class="my-6" />
              </template>

              <div class="section-title">Resumen por pregunta</div>
              <div
                v-for="(resumen, index) in resumenCompacto"
                :key="resumen.id"
                class="boletin-fila d-flex justify-space-between py-3"
              >
                <span class="text-body-small boletin-fila__q">
                  {{ index + 1 }}. {{ resumen.statement }}
                </span>
                <span class="text-body-small text-medium-emphasis text-right ms-3">
                  {{ resumen.texto }}
                </span>
              </div>
            </v-card-text>
          </v-card>
        </v-window-item>

        <!-- ============================================================ -->
        <!-- PESTAÑA: RESULTADOS GENERAL                                   -->
        <!-- ============================================================ -->
        <v-window-item value="general">
          <div class="section-title">Resumen general</div>
          <div class="kpi-grid mb-5">
            <div class="kpi-card kpi-card--primary">
              <div class="kpi-card__icon">
                <v-icon size="20">mdi-account-group-outline</v-icon>
              </div>
              <div class="kpi-card__value">{{ metrics.total_responses }}</div>
              <div class="kpi-card__label">Respuestas totales</div>
            </div>
            <div class="kpi-card kpi-card--success">
              <div class="kpi-card__icon">
                <v-icon size="20">mdi-check-circle-outline</v-icon>
              </div>
              <div class="kpi-card__value">{{ metrics.completed_responses }}</div>
              <div class="kpi-card__label">Respuestas completas</div>
            </div>
            <div class="kpi-card kpi-card--accent">
              <div class="kpi-card__icon">
                <v-icon size="20">mdi-percent-outline</v-icon>
              </div>
              <div class="kpi-card__value">{{ metrics.completion_rate }}%</div>
              <div class="kpi-card__label">Tasa de finalización</div>
            </div>
          </div>

          <v-card v-if="satisfaction.length" class="mb-4 rounded-lg" variant="flat">
            <v-card-text class="pa-5">
              <div class="section-title">Indicadores de satisfacción</div>
              <div v-for="indicator in satisfaction" :key="indicator.question_id" class="mb-4">
                <div class="d-flex align-center justify-space-between mb-2">
                  <p class="text-body-small mb-0">{{ indicator.statement }}</p>
                  <span class="summary-value">{{ indicator.average_score ?? '—' }} / 5</span>
                </div>
                <v-progress-linear
                  :model-value="((indicator.average_score || 0) / 5) * 100"
                  color="#4880FF"
                  height="6"
                  rounded
                  bg-color="#E8F0F8"
                />
                <div class="text-caption text-medium-emphasis mt-1">
                  {{ indicator.total_responses }} respuestas
                </div>
              </div>
            </v-card-text>
          </v-card>

          <div class="action-strip mb-4">
            <v-btn
              variant="outlined"
              color="secondary"
              class="text-button"
              prepend-icon="mdi-calendar-range"
              @click="dialogComparar = true"
            >
              Comparar períodos
            </v-btn>
            <v-btn
              variant="outlined"
              color="secondary"
              class="text-button"
              prepend-icon="mdi-domain"
              :loading="cargandoReporteDependencia"
              @click="abrirReporteDependencia"
            >
              Reporte por dependencia
            </v-btn>
          </div>

          <v-card
            v-for="(question, index) in questionsWithSummary"
            :key="question.id"
            class="mb-3 rounded-lg question-card"
            variant="flat"
          >
            <v-card-text class="pa-5">
              <div class="question-head">
                <span class="question-number">{{ index + 1 }}</span>
                <p class="text-body-small font-weight-medium mb-0">
                  {{ question.statement }}
                </p>
              </div>

              <div v-if="question.type === 'escala'" class="mt-2">
                <div class="d-flex align-center mb-2">
                  <span class="summary-value me-2">{{ question.summary.average }}</span>
                  <span class="text-body-small">promedio (escala 1-5)</span>
                </div>
                <v-progress-linear
                  :model-value="(question.summary.average / 5) * 100"
                  color="#4880FF"
                  height="8"
                  rounded
                  bg-color="#E8F0F8"
                />
                <div class="text-body-small mt-2">
                  {{ question.summary.total_responses }} respuestas
                </div>
              </div>

              <div v-else-if="['si_no', 'casilla'].includes(question.type)">
                <BarChart
                  :labels="['Sí', 'No']"
                  :values="[question.summary.true_count, question.summary.false_count]"
                />
              </div>

              <div v-else-if="['opcion_unica', 'opcion_multiple'].includes(question.type)">
                <DonutChart
                  :labels="optionLabels(question)"
                  :values="optionValues(question)"
                />
              </div>

              <div v-else class="d-flex align-center">
                <v-icon class="me-2" color="#4880FF">mdi-text-box-outline</v-icon>
                <p class="text-body-small mb-0">
                  {{ question.summary.total_responses }} respuestas de texto.
                  Consulte la pestaña "Por encuestado" para revisarlas una a una.
                </p>
              </div>
            </v-card-text>
          </v-card>
        </v-window-item>

        <!-- ============================================================ -->
        <!-- PESTAÑA: POR ENCUESTADO                                       -->
        <!-- ============================================================ -->
        <v-window-item value="por-encuestado">
          <LoadingState v-if="cargandoPorEncuestado" message="Cargando resultados" />

          <div v-else-if="!encuestados.length" class="empty-respondents">
            <v-icon size="42" color="#B7C2D0">mdi-account-off-outline</v-icon>
            <p class="text-body-small text-medium-emphasis mt-3 mb-0">
              Todavía no hay respuestas registradas para esta encuesta.
            </p>
          </div>

          <template v-else>
            <div class="respondents-header">
              <div class="respondents-header__text">
                <div class="section-title mb-1">Encuestados</div>
                <p class="text-caption text-medium-emphasis mb-0">
                  {{ totalEncuestados }} en total — página
                  {{ paginaEncuestados }} de {{ ultimaPaginaEncuestados }}
                </p>
              </div>
              <div class="respondents-header__badge">
                <v-icon size="14">mdi-account-multiple-outline</v-icon>
                <span>{{ totalEncuestados }}</span>
              </div>
            </div>

            <div class="respondents-grid">
              <div
                v-for="(encuestado, i) in encuestados"
                :key="encuestado.encuestado_key"
                class="respondent-card"
                :class="{ 'respondent-card--open': estaExpandido(encuestado.encuestado_key) }"
              >
                <div
                  class="respondent-card__head"
                  @click="toggleEncuestado(encuestado.encuestado_key)"
                >
                  <div class="respondent-avatar">
                    {{ iniciales(encuestado.participant) }}
                  </div>

                  <div class="respondent-info">
                    <div class="respondent-name">
                      {{ nombreEncuestado(encuestado.participant) }}
                    </div>
                    <div class="respondent-meta">
                      <span class="respondent-meta__pill">
                        #{{ (paginaEncuestados - 1) * 5 + i + 1 }}
                      </span>
                      <span class="respondent-meta__dot">·</span>
                      <v-icon size="12">mdi-clock-outline</v-icon>
                      <span>{{ formatearFechaHora(encuestado.submitted_at) }}</span>
                    </div>
                  </div>

                  <v-btn
                    icon
                    variant="text"
                    size="small"
                    class="respondent-toggle"
                    :ripple="false"
                  >
                    <v-icon size="20">
                      {{ estaExpandido(encuestado.encuestado_key) ? 'mdi-chevron-up' : 'mdi-chevron-down' }}
                    </v-icon>
                  </v-btn>
                </div>

                <v-expand-transition>
                  <div
                    v-if="estaExpandido(encuestado.encuestado_key)"
                    class="respondent-card__body"
                  >
                    <div
                      v-for="(respuesta, idx) in encuestado.answers"
                      :key="respuesta.question_id"
                      class="answer-item"
                    >
                      <div class="answer-item__q">
                        <span class="answer-item__num">{{ idx + 1 }}</span>
                        {{ respuesta.statement }}
                      </div>
                      <div class="answer-item__a">
                        {{ formatearValorRespuesta(respuesta) }}
                      </div>
                    </div>
                  </div>
                </v-expand-transition>
              </div>
            </div>

            <div class="respondents-pagination">
              <v-pagination
                v-model="paginaEncuestados"
                :length="ultimaPaginaEncuestados"
                :total-visible="5"
                density="comfortable"
                @update:model-value="cargarPorEncuestado"
              />
            </div>
          </template>
        </v-window-item>
      </v-window>
    </template>

    <!-- Diálogo: comparar períodos -->
    <v-dialog v-model="dialogComparar" max-width="520">
      <v-card>
        <v-card-title class="text-h6">Comparar períodos</v-card-title>
        <v-card-text>
          <p class="text-body-small text-medium-emphasis mb-3">
            Respuestas recibidas en dos rangos de fecha distintos, para esta encuesta.
          </p>
          <v-row dense>
            <v-col cols="6">
              <v-text-field v-model="periodo1Inicio" type="date" label="Período 1 — inicio" variant="outlined" density="compact" />
            </v-col>
            <v-col cols="6">
              <v-text-field v-model="periodo1Fin" type="date" label="Período 1 — fin" variant="outlined" density="compact" />
            </v-col>
            <v-col cols="6">
              <v-text-field v-model="periodo2Inicio" type="date" label="Período 2 — inicio" variant="outlined" density="compact" />
            </v-col>
            <v-col cols="6">
              <v-text-field v-model="periodo2Fin" type="date" label="Período 2 — fin" variant="outlined" density="compact" />
            </v-col>
          </v-row>

          <v-btn color="primary" size="small" class="text-button mb-4" :loading="comparando" @click="compararPeriodos">
            Comparar
          </v-btn>

          <v-alert v-if="comparacionError" type="error" variant="tonal" class="mb-3">
            {{ comparacionError }}
          </v-alert>

          <div v-if="comparacion" class="d-flex justify-space-around text-center">
            <div>
              <div class="summary-label">Período 1</div>
              <div class="summary-value">{{ comparacion.period_1.total_responses }}</div>
              <div class="text-caption text-medium-emphasis">respuestas</div>
            </div>
            <div>
              <div class="summary-label">Período 2</div>
              <div class="summary-value">{{ comparacion.period_2.total_responses }}</div>
              <div class="text-caption text-medium-emphasis">respuestas</div>
            </div>
          </div>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogComparar = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo: reporte por dependencia -->
    <v-dialog v-model="dialogDependencia" max-width="620">
      <v-card>
        <v-card-title class="text-h6">
          Reporte por dependencia
          <div class="text-body-small text-medium-emphasis font-weight-regular">
            {{ survey?.department?.name }}
          </div>
        </v-card-title>
        <v-card-text>
          <div v-if="cargandoReporteDependencia" class="text-center py-6">
            <v-progress-circular indeterminate color="primary" />
          </div>
          <template v-else-if="reporteDependencia">
            <v-row dense class="mb-3">
              <v-col cols="6">
                <div class="summary-label">Total encuestas</div>
                <div class="summary-value">{{ reporteDependencia.total_surveys }}</div>
              </v-col>
              <v-col cols="6">
                <div class="summary-label">Total respuestas</div>
                <div class="summary-value">{{ reporteDependencia.total_responses }}</div>
              </v-col>
            </v-row>
            <v-table density="compact">
              <thead>
                <tr>
                  <th class="text-label">Encuesta</th>
                  <th class="text-label">Estado</th>
                  <th class="text-label">Respuestas</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="s in reporteDependencia.surveys" :key="s.id">
                  <td class="text-body-small">{{ s.title }}</td>
                  <td class="text-body-small">{{ s.status?.name || '—' }}</td>
                  <td class="text-body-small">{{ s.responses_count }}</td>
                </tr>
              </tbody>
            </v-table>
          </template>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-btn
            v-if="reporteDependencia"
            variant="outlined"
            color="secondary"
            class="text-button"
            prepend-icon="mdi-file-pdf-box"
            :loading="exportandoReporteDependencia"
            @click="exportarReporteDependenciaPdf"
          >
            Descargar PDF
          </v-btn>
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogDependencia = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRoute } from "vue-router";
import backendApi from "@/services/backendApi";
import DonutChart from "@/components/charts/DonutChart.vue";
import BarChart from "@/components/charts/BarChart.vue";
import LoadingState from "@/components/LoadingState.vue";
import useAlert from "@/composables/useAlert";

const { alert } = useAlert();
const route = useRoute();
const surveyId = route.params.id;

const survey = ref(null);
const metrics = ref({
  total_responses: 0,
  completed_responses: 0,
  completion_rate: 0,
});
const questionsWithSummary = ref([]);
const loading = ref(true);
const error = ref(null);

const tabActiva = ref('boletin');

const exportandoExcel = ref(false);
const exportandoPdf = ref(false);
const exportandoReporteDependencia = ref(false);

const satisfaction = ref([]);

const dialogComparar = ref(false);
const periodo1Inicio = ref('');
const periodo1Fin = ref('');
const periodo2Inicio = ref('');
const periodo2Fin = ref('');
const comparando = ref(false);
const comparacion = ref(null);
const comparacionError = ref(null);

const dialogDependencia = ref(false);
const cargandoReporteDependencia = ref(false);
const reporteDependencia = ref(null);

function optionLabels(question) {
  return question.summary.options?.map(opt => opt.option_text) || [];
}

function optionValues(question) {
  return question.summary.options?.map(opt => opt.responses_count || 0) || [];
}

function formatearFecha(fecha) {
  if (!fecha) return '—';
  return new Date(fecha).toLocaleDateString('es-SV');
}

function formatearFechaHora(fecha) {
  if (!fecha) return '—';
  return new Date(fecha).toLocaleString('es-SV', { dateStyle: 'short', timeStyle: 'short' });
}

function imprimirBoletin() {
  window.print();
}

const resumenCompacto = computed(() => questionsWithSummary.value.map((q) => {
  let texto = '—';
  if (q.type === 'escala') {
    texto = `Promedio ${q.summary.average ?? '—'} / 5 (${q.summary.total_responses} respuestas)`;
  } else if (['si_no', 'casilla'].includes(q.type)) {
    texto = `Sí: ${q.summary.true_count ?? 0} · No: ${q.summary.false_count ?? 0}`;
  } else if (['opcion_unica', 'opcion_multiple'].includes(q.type)) {
    const opciones = q.summary.options || [];
    const top = [...opciones].sort((a, b) => (b.responses_count || 0) - (a.responses_count || 0))[0];
    texto = top ? `Más elegida: "${top.option_text}" (${top.responses_count || 0})` : 'Sin respuestas';
  } else {
    texto = `${q.summary.total_responses ?? 0} respuestas de texto`;
  }
  return { id: q.id, statement: q.statement, texto };
}));

const encuestados = ref([]);
const cargandoPorEncuestado = ref(false);
const paginaEncuestados = ref(1);
const totalEncuestados = ref(0);
const ultimaPaginaEncuestados = ref(1);
let porEncuestadoCargadoAlMenosUnaVez = false;

// =============================================
// Estado de expansión de cada tarjeta de encuestado
// =============================================
const expandidos = ref({});

function estaExpandido(key) {
  return !!expandidos.value[key];
}

function toggleEncuestado(key) {
  expandidos.value = {
    ...expandidos.value,
    [key]: !expandidos.value[key],
  };
}

function nombreEncuestado(participant) {
  if (!participant) return 'Anónimo';
  return participant.name || participant.email || 'Anónimo';
}

function iniciales(participant) {
  const nombre = nombreEncuestado(participant);
  if (nombre === 'Anónimo') return '?';
  const partes = nombre.trim().split(/\s+/);
  if (partes.length === 1) return partes[0].charAt(0).toUpperCase();
  return (partes[0].charAt(0) + partes[partes.length - 1].charAt(0)).toUpperCase();
}

function formatearValorRespuesta(respuesta) {
  const valor = respuesta.value;
  if (valor === null || valor === undefined || valor === '') return 'Sin respuesta';
  if (respuesta.type === 'si_no') return valor ? 'Sí' : 'No';
  if (Array.isArray(valor)) return valor.length ? valor.join(', ') : 'Sin respuesta';
  return String(valor);
}

async function cargarPorEncuestado() {
  cargandoPorEncuestado.value = true;
  try {
    const { data } = await backendApi.get(`/reports/surveys/${surveyId}/by-participant`, {
      params: { page: paginaEncuestados.value },
    });
    encuestados.value = data.data;
    totalEncuestados.value = data.total;
    ultimaPaginaEncuestados.value = data.last_page;
  } catch (e) {
    alert.error('No se pudieron cargar los resultados por encuestado.');
  } finally {
    cargandoPorEncuestado.value = false;
  }
}

function asegurarCargaPorEncuestado() {
  if (porEncuestadoCargadoAlMenosUnaVez) return;
  porEncuestadoCargadoAlMenosUnaVez = true;
  cargarPorEncuestado();
}

onMounted(async () => {
  try {
    const [surveyResponse, resultsResponse] = await Promise.all([
      backendApi.get(`/surveys/${surveyId}`),
      backendApi.get(`/reports/surveys/${surveyId}/results`),
    ]);

    survey.value = surveyResponse.data;
    metrics.value = resultsResponse.data.metrics;
    satisfaction.value = resultsResponse.data.satisfaction || [];

    const summaries = resultsResponse.data.summaries || {};
    const allQuestions = [];
    survey.value.sections.forEach((section) => {
      section.questions.forEach((question) => {
        allQuestions.push({
          ...question,
          summary: summaries[question.id] || { type: question.type, total_responses: 0 },
        });
      });
    });

    questionsWithSummary.value = allQuestions;
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      "No se pudieron cargar los resultados de la encuesta.";
  } finally {
    loading.value = false;
  }
});

function descargarBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

async function exportarExcel() {
  exportandoExcel.value = true;
  try {
    const response = await backendApi.get(`/reports/surveys/${surveyId}/export-excel`, {
      responseType: 'blob',
    });
    descargarBlob(response.data, `respuestas-encuesta-${surveyId}.xlsx`);
  } catch (e) {
    alert.error('No se pudo exportar el archivo Excel.');
  } finally {
    exportandoExcel.value = false;
  }
}

async function exportarPdf() {
  exportandoPdf.value = true;
  try {
    const response = await backendApi.get(`/reports/surveys/${surveyId}/export-pdf`, {
      responseType: 'blob',
    });
    descargarBlob(response.data, `resultados-encuesta-${surveyId}.pdf`);
  } catch (e) {
    alert.error('No se pudo exportar el archivo PDF.');
  } finally {
    exportandoPdf.value = false;
  }
}

async function compararPeriodos() {
  comparacionError.value = null;
  comparacion.value = null;

  if (!periodo1Inicio.value || !periodo1Fin.value || !periodo2Inicio.value || !periodo2Fin.value) {
    comparacionError.value = 'Completa las cuatro fechas para comparar.';
    return;
  }

  comparando.value = true;
  try {
    const response = await backendApi.get('/reports/compare-periods', {
      params: {
        survey_id: surveyId,
        period_1_start: periodo1Inicio.value,
        period_1_end: periodo1Fin.value,
        period_2_start: periodo2Inicio.value,
        period_2_end: periodo2Fin.value,
      },
    });
    comparacion.value = response.data;
  } catch (e) {
    comparacionError.value = e.response?.data?.message || 'No se pudo comparar los períodos.';
  } finally {
    comparando.value = false;
  }
}

async function exportarReporteDependenciaPdf() {
  exportandoReporteDependencia.value = true;
  try {
    const dependencyId = survey.value?.dependency_id;
    const response = await backendApi.get('/reports/departments/export-pdf', {
      params: { dependency_id: dependencyId },
      responseType: 'blob',
    });
    descargarBlob(response.data, `reporte-dependencia-${dependencyId}.pdf`);
  } catch (e) {
    alert.error('No se pudo exportar el reporte por dependencia.');
  } finally {
    exportandoReporteDependencia.value = false;
  }
}

async function abrirReporteDependencia() {
  dialogDependencia.value = true;

  if (reporteDependencia.value) return;

  cargandoReporteDependencia.value = true;
  try {
    const response = await backendApi.get('/reports/departments', {
      params: { dependency_id: survey.value?.dependency_id },
    });
    reporteDependencia.value = response.data;
  } catch (e) {
    alert.error('No se pudo cargar el reporte por dependencia.');
  } finally {
    cargandoReporteDependencia.value = false;
  }
}
</script>

<style scoped>
.results-page {
  padding-bottom: 24px;
}

/* ---------- Hero Header ---------- */
.hero {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  margin: 32px 0 20px;
  background: linear-gradient(135deg, #EDF2FF 0%, #F4F6FD 60%, #E8F0FB 100%);
  border: 1px solid #E3EBF5;
}

.hero__bg {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 90% -20%, rgba(72, 128, 255, 0.18), transparent 45%),
    radial-gradient(circle at -10% 120%, rgba(72, 128, 255, 0.10), transparent 40%);
  pointer-events: none;
}

.hero__content {
  position: relative;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-end;
  gap: 16px;
  padding: 26px 28px;
}

.hero__text { min-width: 0; }

.hero__eyebrow {
  display: inline-block;
  font-family: Poppins;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #4880FF;
  background: rgba(72, 128, 255, 0.10);
  padding: 4px 10px;
  border-radius: 999px;
  margin-bottom: 10px;
}

.hero__title {
  margin: 0 0 6px 0;
  line-height: 1.15;
  color: #063456;
}

.hero__subtitle {
  margin: 0;
  line-height: 1.4;
  color: #4a5b6b;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

/* ---------- Título de sección con acento ---------- */
.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: Poppins;
  font-weight: 600;
  font-size: 14px;
  color: #313845;
  margin-bottom: 14px;
}

.section-title::before {
  content: "";
  width: 3px;
  height: 14px;
  border-radius: 2px;
  background: #4880FF;
}

/* ---------- KPI grid / cards ---------- */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.kpi-card {
  position: relative;
  border: 1px solid #E3EBF5;
  border-radius: 8px;
  padding: 16px 18px 14px;
  background: #ffffff;
  overflow: hidden;
}

.kpi-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
}

.kpi-card--primary::before { background: #4880FF; }
.kpi-card--success::before { background: #2FB56B; }
.kpi-card--accent::before  { background: #2D52A7; }

.kpi-card__icon {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background: #E9EDFD;
  color: #063456;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.kpi-card--success .kpi-card__icon {
  background: #E4F7EC;
  color: #1F8F51;
}

.kpi-card--accent .kpi-card__icon {
  background: #E4EAF7;
  color: #2D52A7;
}

.kpi-card__value {
  font-family: Poppins;
  font-weight: 700;
  font-size: 26px;
  color: #063456;
  line-height: 1;
  margin-bottom: 4px;
}

.kpi-card__label {
  font-size: 11px;
  font-weight: 500;
  color: #6b7986;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

/* ---------- Boletín ---------- */
.boletin-card {
  overflow: hidden;
  border: 1px solid #E3EBF5;
  border-radius: 7px;
  background-color: #ffffff;
}

.boletin-hero {
  padding: 28px 28px 22px;
  background: linear-gradient(135deg, #063456 0%, #2D52A7 100%);
  color: #ffffff;
}

.boletin-hero__eyebrow {
  font-size: 11px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  opacity: 0.75;
  margin-bottom: 8px;
}

.boletin-hero__title {
  font-family: Poppins;
  font-weight: 700;
  font-size: 26px;
  line-height: 1.2;
  margin: 0 0 6px 0;
}

.boletin-hero__sub {
  font-size: 12px;
  opacity: 0.85;
  margin: 0 0 18px 0;
  line-height: 1.4;
}

.boletin-hero__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 18px;
  font-size: 11.5px;
  opacity: 0.92;
}

.boletin-hero__meta span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.boletin-fila {
  border-bottom: 1px solid #F0F3F9;
}

.boletin-fila:last-child {
  border-bottom: none;
}

.boletin-fila__q {
  padding-right: 12px;
}

/* ---------- General ---------- */
.action-strip {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.question-head {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}

/* ---------- Componentes ---------- */
.question-number {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background-color: #4880FF;
  color: #ffffff;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.question-card {
  border: 1px solid #E3EBF5;
  background-color: #ffffff;
  transition: box-shadow 0.2s;
}

.question-card:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

/* ============================================= */
/* POR ENCUESTADO — tarjetas                     */
/* ============================================= */

.respondents-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 16px;
}

.respondents-header__badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  border-radius: 999px;
  background: #EDF2FF;
  color: #2D52A7;
  font-family: Poppins;
  font-size: 12px;
  font-weight: 600;
}

.respondents-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;
  margin-bottom: 20px;
}

.respondent-card {
  border: 1px solid #E3EBF5;
  border-radius: 8px;
  background: #ffffff;
  overflow: hidden;
  transition: box-shadow 0.22s ease, border-color 0.22s ease, transform 0.22s ease;
}

.respondent-card:hover {
  box-shadow: 0 4px 14px rgba(72, 128, 255, 0.10);
  border-color: #CFE0FF;
}

.respondent-card--open {
  border-color: #4880FF;
  box-shadow: 0 6px 18px rgba(72, 128, 255, 0.12);
}

.respondent-card__head {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 16px;
  cursor: pointer;
  user-select: none;
}

.respondent-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: #4880FF;
  color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: Poppins;
  font-weight: 600;
  font-size: 14px;
  letter-spacing: 0.03em;
  flex-shrink: 0;
  box-shadow: 0 2px 6px rgba(72, 128, 255, 0.25);
}

.respondent-info {
  flex: 1;
  min-width: 0;
}

.respondent-name {
  font-family: Poppins;
  font-weight: 600;
  font-size: 13px;
  color: #313845;
  line-height: 1.3;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.respondent-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 11.5px;
  color: #8a97a3;
  margin-top: 4px;
  flex-wrap: wrap;
}

.respondent-meta__pill {
  display: inline-flex;
  align-items: center;
  padding: 1px 7px;
  border-radius: 999px;
  background: #F0F4FB;
  color: #4880FF;
  font-weight: 600;
  font-size: 10.5px;
}

.respondent-meta__dot { opacity: 0.5; }

.respondent-toggle {
  flex-shrink: 0;
  color: #8a97a3 !important;
  transition: transform 0.2s ease, color 0.2s ease;
}

.respondent-card--open .respondent-toggle {
  color: #4880FF !important;
}

.respondent-card__body {
  border-top: 1px solid #F0F3F9;
  padding: 8px 18px 14px;
  background: linear-gradient(180deg, #FAFBFF 0%, #FFFFFF 100%);
}

.answer-item {
  padding: 12px 0;
  border-bottom: 1px dashed #EAEFF7;
}

.answer-item:last-child {
  border-bottom: none;
  padding-bottom: 4px;
}

.answer-item__q {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-family: Poppins;
  font-size: 12px;
  font-weight: 500;
  color: #4a5b6b;
  line-height: 1.4;
  margin-bottom: 6px;
}

.answer-item__num {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #E9EDFD;
  color: #4880FF;
  font-size: 10px;
  font-weight: 700;
  flex-shrink: 0;
  margin-top: 1px;
}

.answer-item__a {
  font-family: Poppins;
  font-size: 12px;
  color: #313845;
  line-height: 1.5;
  padding-left: 14px;
  border-left: 2px solid #4880FF;
  margin-left: 8px;
}

.empty-respondents {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 56px 24px;
  border: 1px dashed #D9E2F0;
  border-radius: 10px;
  background: #FAFBFF;
}

.respondents-pagination {
  display: flex;
  justify-content: center;
  padding-top: 4px;
}

@media (min-width: 700px) {
  .respondents-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media print {
  .results-tabs,
  .no-print {
    display: none !important;
  }

  .hero,
  .hero__actions {
    display: none !important;
  }

  .boletin-hero {
    background: #ffffff !important;
    color: #063456 !important;
  }
}
</style>