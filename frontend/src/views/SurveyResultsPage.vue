<template>
  <div>
    <!-- Encabezado -->
    <v-row class="align-center mt-8 mb-4">
      <v-col cols="auto">
        <h3 class="text-page-title">Resultados de encuesta</h3><br>
        <p class="text-subtitle mb-0">{{ survey?.title }}</p>
      </v-col>
      <v-spacer />
      <v-col cols="12" sm="auto" class="d-flex flex-wrap gap-2">
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
          variant="outlined"
          prepend-icon="mdi-arrow-left"
          class="text-button"
          @click="$router.push('/surveys')"
        >
          Volver al listado
        </v-btn>
      </v-col>
    </v-row>

    <!-- Cargando -->
    <div v-if="loading" class="text-center py-8">
      <v-progress-circular indeterminate color="primary" />
      <p class="mt-3 text-body-small">Cargando resultados...</p>
    </div>

    <!-- Error -->
    <div v-else-if="error" class="text-center py-8">
      <v-icon size="48" color="error">mdi-alert-circle-outline</v-icon>
      <p class="mt-3 text-body-1">{{ error }}</p>
    </div>

    <!-- Contenido -->
    <template v-else>
      <v-tabs v-model="tabActiva" color="primary" class="mb-4 results-tabs">
        <v-tab value="boletin" class="text-button">Boletín</v-tab>
        <v-tab value="general" class="text-button">Resultados general</v-tab>
        <v-tab value="por-encuestado" class="text-button" @click="asegurarCargaPorEncuestado">
          Por encuestado
        </v-tab>
      </v-tabs>

      <v-window v-model="tabActiva">
        <!-- ============================================================ -->
        <!-- PESTAÑA: BOLETÍN — resumen condensado, pensado para imprimir  -->
        <!-- o compartir en una sola vista, sin tener que navegar todas    -->
        <!-- las tarjetas de la pestaña general.                          -->
        <!-- ============================================================ -->
        <v-window-item value="boletin">
          <v-card class="rounded-lg boletin-card" variant="flat">
            <v-card-text class="pa-6">
              <div class="d-flex justify-space-between align-start mb-4 no-print">
                <div />
                <v-btn variant="outlined" color="secondary" size="small" class="text-button" prepend-icon="mdi-printer-outline" @click="imprimirBoletin">
                  Imprimir boletín
                </v-btn>
              </div>

              <div class="text-center mb-6">
                <div class="text-caption text-medium-emphasis text-uppercase">Boletín de resultados</div>
                <h2 class="text-page-title mb-1">{{ survey?.title }}</h2>
                <p class="text-body-small text-medium-emphasis mb-0">{{ survey?.description }}</p>
              </div>

              <v-row dense class="mb-5">
                <v-col cols="6" sm="3">
                  <div class="summary-label">Dependencia</div>
                  <div class="text-body-small">{{ survey?.department?.name || '—' }}</div>
                </v-col>
                <v-col cols="6" sm="3">
                  <div class="summary-label">Categoría</div>
                  <div class="text-body-small">{{ survey?.category?.name || '—' }}</div>
                </v-col>
                <v-col cols="6" sm="3">
                  <div class="summary-label">Vigencia</div>
                  <div class="text-body-small">{{ formatearFecha(survey?.start_date) }} — {{ formatearFecha(survey?.end_date) }}</div>
                </v-col>
                <v-col cols="6" sm="3">
                  <div class="summary-label">Estado</div>
                  <div class="text-body-small">{{ survey?.status?.name || '—' }}</div>
                </v-col>
              </v-row>

              <v-row dense class="mb-6 text-center">
                <v-col cols="4">
                  <div class="summary-value">{{ metrics.total_responses }}</div>
                  <div class="summary-label">Respuestas totales</div>
                </v-col>
                <v-col cols="4">
                  <div class="summary-value">{{ metrics.completed_responses }}</div>
                  <div class="summary-label">Respuestas completas</div>
                </v-col>
                <v-col cols="4">
                  <div class="summary-value">{{ metrics.completion_rate }}%</div>
                  <div class="summary-label">Tasa de finalización</div>
                </v-col>
              </v-row>

              <template v-if="satisfaction.length">
                <div class="text-subtitle mb-2">Indicadores de satisfacción</div>
                <div v-for="indicator in satisfaction" :key="indicator.question_id" class="mb-3">
                  <div class="d-flex align-center justify-space-between mb-1">
                    <p class="text-body-small mb-0">{{ indicator.statement }}</p>
                    <span class="summary-value">{{ indicator.average_score ?? '—' }} / 5</span>
                  </div>
                  <v-progress-linear :model-value="((indicator.average_score || 0) / 5) * 100" color="#4880FF" height="6" rounded bg-color="#E8F0F8" />
                </div>
                <v-divider class="my-4" />
              </template>

              <div class="text-subtitle mb-2">Resumen por pregunta</div>
              <div v-for="(resumen, index) in resumenCompacto" :key="resumen.id" class="d-flex justify-space-between py-2 boletin-fila">
                <span class="text-body-small">{{ index + 1 }}. {{ resumen.statement }}</span>
                <span class="text-body-small text-medium-emphasis text-right ms-3">{{ resumen.texto }}</span>
              </div>
            </v-card-text>
          </v-card>
        </v-window-item>

        <!-- ============================================================ -->
        <!-- PESTAÑA: RESULTADOS GENERAL — el detalle que ya existía       -->
        <!-- ============================================================ -->
        <v-window-item value="general">
          <!-- Tarjeta de métricas generales -->
          <v-card class="mb-4 rounded-lg" variant="flat">
            <v-card-text class="pa-4">
              <div class="text-subtitle mb-2">Resumen general</div>
              <v-row dense>
                <v-col cols="12" sm="4">
                  <div class="d-flex align-center">
                    <div class="metric-icon-box">
                      <v-icon color="#063456" size="24">mdi-account-group-outline</v-icon>
                    </div>
                    <div class="ms-3">
                      <div class="summary-label">Total respuestas</div>
                      <div class="summary-value">{{ metrics.total_responses }}</div>
                    </div>
                  </div>
                </v-col>
                <v-col cols="12" sm="4">
                  <div class="d-flex align-center">
                    <div class="metric-icon-box">
                      <v-icon color="#063456" size="24">mdi-check-circle-outline</v-icon>
                    </div>
                    <div class="ms-3">
                      <div class="summary-label">Respuestas completas</div>
                      <div class="summary-value">{{ metrics.completed_responses }}</div>
                    </div>
                  </div>
                </v-col>
                <v-col cols="12" sm="4">
                  <div class="d-flex align-center">
                    <div class="metric-icon-box">
                      <v-icon color="#063456" size="24">mdi-percent-outline</v-icon>
                    </div>
                    <div class="ms-3">
                      <div class="summary-label">Tasa de finalización</div>
                      <div class="summary-value">{{ metrics.completion_rate }}%</div>
                    </div>
                  </div>
                </v-col>
              </v-row>
            </v-card-text>
          </v-card>

          <!-- Indicadores de satisfacción (promedio de preguntas tipo escala) -->
          <v-card v-if="satisfaction.length" class="mb-4 rounded-lg" variant="flat">
            <v-card-text class="pa-4">
              <div class="text-subtitle mb-3">Indicadores de satisfacción</div>
              <div v-for="indicator in satisfaction" :key="indicator.question_id" class="mb-3">
                <div class="d-flex align-center justify-space-between mb-1">
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

          <!-- Comparar períodos y reporte por dependencia -->
          <v-row dense class="mb-4">
            <v-col cols="12" sm="auto">
              <v-btn variant="outlined" color="secondary" class="text-button" prepend-icon="mdi-calendar-range" @click="dialogComparar = true">
                Comparar períodos
              </v-btn>
            </v-col>
            <v-col cols="12" sm="auto">
              <v-btn
                variant="outlined" color="secondary" class="text-button" prepend-icon="mdi-domain"
                :loading="cargandoReporteDependencia"
                @click="abrirReporteDependencia"
              >
                Reporte por dependencia
              </v-btn>
            </v-col>
          </v-row>

          <!-- Resumen por pregunta -->
          <v-card
            v-for="(question, index) in questionsWithSummary"
            :key="question.id"
            class="mb-3 rounded-lg question-card"
            variant="flat"
          >
            <v-card-text class="pa-4">
              <div class="d-flex align-center mb-3">
                <span class="question-number">{{ index + 1 }}</span>
                <p class="text-body-small font-weight-medium mb-0 ms-2">
                  {{ question.statement }}
                </p>
              </div>

              <!-- Escala -->
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

              <!-- Sí / No o casilla -->
              <div v-else-if="['si_no', 'casilla'].includes(question.type)">
                <BarChart
                  :labels="['Sí', 'No']"
                  :values="[question.summary.true_count, question.summary.false_count]"
                />
              </div>

              <!-- Opción única / múltiple -->
              <div v-else-if="['opcion_unica', 'opcion_multiple'].includes(question.type)">
                <DonutChart
                  :labels="optionLabels(question)"
                  :values="optionValues(question)"
                />
              </div>

              <!-- Texto libre -->
              <div v-else>
                <div class="d-flex align-center">
                  <v-icon class="me-2" color="#4880FF">mdi-text-box-outline</v-icon>
                  <p class="text-body-small mb-0">
                    {{ question.summary.total_responses }} respuestas de texto.
                    Consulte la pestaña "Por encuestado" para revisarlas una a una.
                  </p>
                </div>
              </div>
            </v-card-text>
          </v-card>
        </v-window-item>

        <!-- ============================================================ -->
        <!-- PESTAÑA: POR ENCUESTADO — hoja de respuestas individual,      -->
        <!-- paginada de 5 en 5 (ver ReportController::byParticipant).    -->
        <!-- ============================================================ -->
        <v-window-item value="por-encuestado">
          <div v-if="cargandoPorEncuestado" class="text-center py-8">
            <v-progress-circular indeterminate color="primary" />
          </div>

          <div v-else-if="!encuestados.length" class="text-center text-medium-emphasis py-8">
            Todavía no hay respuestas registradas para esta encuesta.
          </div>

          <template v-else>
            <p class="text-caption text-medium-emphasis mb-3">
              {{ totalEncuestados }} encuestado(s) en total — página {{ paginaEncuestados }} de {{ ultimaPaginaEncuestados }}.
            </p>

            <v-expansion-panels variant="accordion" class="mb-4">
              <v-expansion-panel v-for="(encuestado, i) in encuestados" :key="encuestado.encuestado_key">
                <v-expansion-panel-title>
                  <div class="d-flex align-center justify-space-between" style="width: 100%;">
                    <span class="text-body-small font-weight-medium">
                      Encuestado {{ (paginaEncuestados - 1) * 5 + i + 1 }}
                      <span v-if="encuestado.participant" class="text-medium-emphasis">
                        — {{ encuestado.participant.name || encuestado.participant.email }}
                      </span>
                      <span v-else class="text-medium-emphasis">— Anónimo</span>
                    </span>
                    <span class="text-caption text-medium-emphasis me-3">
                      {{ formatearFechaHora(encuestado.submitted_at) }}
                    </span>
                  </div>
                </v-expansion-panel-title>
                <v-expansion-panel-text>
                  <div v-for="respuesta in encuestado.answers" :key="respuesta.question_id" class="mb-3">
                    <p class="text-body-small font-weight-medium mb-1">{{ respuesta.statement }}</p>
                    <p class="text-body-small text-medium-emphasis mb-0">
                      {{ formatearValorRespuesta(respuesta) }}
                    </p>
                  </div>
                </v-expansion-panel-text>
              </v-expansion-panel>
            </v-expansion-panels>

            <div class="d-flex justify-center">
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

// Línea de una sola frase por pregunta, para el Boletín — reutiliza el
// mismo "summary" ya calculado por el backend para la pestaña general,
// solo lo condensa a texto en vez de un gráfico.
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

// =====================================================================
// POR ENCUESTADO — paginado, 5 por página (ver ReportController::byParticipant)
// =====================================================================
const encuestados = ref([]);
const cargandoPorEncuestado = ref(false);
const paginaEncuestados = ref(1);
const totalEncuestados = ref(0);
const ultimaPaginaEncuestados = ref(1);
let porEncuestadoCargadoAlMenosUnaVez = false;

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

// Carga perezosa: solo la primera vez que se entra a esta pestaña, para
// no pedir datos que tal vez el usuario nunca revise.
function asegurarCargaPorEncuestado() {
  if (porEncuestadoCargadoAlMenosUnaVez) return;
  porEncuestadoCargadoAlMenosUnaVez = true;
  cargarPorEncuestado();
}

onMounted(async () => {
  try {
    const surveyResponse = await backendApi.get(`/surveys/${surveyId}`);
    survey.value = surveyResponse.data;

    const metricsResponse = await backendApi.get(`/reports/surveys/${surveyId}`);
    metrics.value = metricsResponse.data;

    // Indicadores de satisfacción (promedio de preguntas tipo "escala").
    // Si la encuesta no tiene preguntas de ese tipo, el arreglo llega
    // vacío y la tarjeta simplemente no se muestra (ver v-if en el
    // template).
    try {
      const satisfactionResponse = await backendApi.get(
        `/reports/surveys/${surveyId}/satisfaction`
      );
      satisfaction.value = satisfactionResponse.data.indicators || [];
    } catch (e) {
      console.warn('No se pudieron cargar los indicadores de satisfacción', e);
    }

    const allQuestions = [];
    survey.value.sections.forEach((section) => {
      section.questions.forEach((question) => {
        allQuestions.push(question);
      });
    });

    const summaryPromises = allQuestions.map(async (question) => {
      try {
        const summaryResponse = await backendApi.get(
          `/surveys/${surveyId}/questions/${question.id}/summary`
        );
        return {
          ...question,
          summary: summaryResponse.data,
        };
      } catch (e) {
        console.warn(`No se pudo cargar resumen de pregunta ${question.id}`, e);
        return {
          ...question,
          summary: {
            type: question.type,
            total_responses: 0,
          },
        };
      }
    });

    questionsWithSummary.value = await Promise.all(summaryPromises);
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      "No se pudieron cargar los resultados de la encuesta.";
  } finally {
    loading.value = false;
  }
});

// =====================================================================
// EXPORTACIÓN — los endpoints devuelven el archivo directamente (no
// JSON), y como son rutas administrativas (requieren el Bearer token)
// no se pueden usar en un <a href="..."> plano: se piden como blob con
// backendApi (que ya manda el token) y se dispara la descarga a mano.
// =====================================================================
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
    descargarBlob(response.data, `respuestas-encuesta-${surveyId}.pdf`);
  } catch (e) {
    alert.error('No se pudo exportar el archivo PDF.');
  } finally {
    exportandoPdf.value = false;
  }
}

// =====================================================================
// COMPARAR PERÍODOS
// =====================================================================
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

// =====================================================================
// REPORTE POR DEPENDENCIA — usa la dependencia dueña de esta encuesta.
// =====================================================================
async function abrirReporteDependencia() {
  dialogDependencia.value = true;

  if (reporteDependencia.value) return; // ya cargado, no repetir la llamada

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
.metric-icon-box {
  width: 55px;
  height: 54px;
  background: #E9EDFD;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

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

.boletin-card {
  border: 1px solid #E3EBF5;
  background-color: #ffffff;
}

.boletin-fila {
  border-bottom: 1px solid #F0F3F9;
}

@media print {
  .results-tabs,
  .no-print {
    display: none !important;
  }
}
</style>
