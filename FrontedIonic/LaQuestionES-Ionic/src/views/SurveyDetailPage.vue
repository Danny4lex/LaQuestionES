<template>
  <ion-page>
    <ion-content class="detail-page-content" :fullscreen="true">
      <!-- Barra Superior de Navegación -->
      <div class="nav-bar">
        <button class="back-link-btn" @click="router.push('/encuestas')">
          <ion-icon :icon="arrowBackOutline" class="back-icon" />
          <span>Volver al listado</span>
        </button>
      </div>

      <!-- Spinner de carga -->
      <div v-if="loading" class="center-loading">
        <ion-spinner name="crescent" color="secondary" />
        <p>Cargando información...</p>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="error-container">
        <ion-icon :icon="alertCircleOutline" class="err-icon" />
        <p>{{ error }}</p>
        <button class="retry-action-btn" @click="router.push('/encuestas')">
          Volver a encuestas
        </button>
      </div>

      <template v-else-if="survey">
        <!-- Hero Header -->
        <div class="detail-hero">
          <span class="detail-hero-eyebrow">DETALLE DE LA ENCUESTA</span>
          <h1 class="detail-hero-title">{{ getSurveyTitle(survey) }}</h1>
          <p class="detail-hero-desc">
            {{ survey.description || "Esta encuesta no cuenta con una descripción detallada." }}
          </p>
        </div>

        <div class="detail-body">
          <!-- Tarjeta de Información General -->
          <div class="info-card">
            <h3 class="info-card-title">Información Institucional</h3>

            <div class="info-list">
              <div class="info-row">
                <span class="info-label">
                  <ion-icon :icon="businessOutline" class="row-icon" />
                  Dependencia:
                </span>
                <span class="info-val">{{ survey.department?.name || "Sin dependencia" }}</span>
              </div>

              <div class="info-row">
                <span class="info-label">
                  <ion-icon :icon="pricetagOutline" class="row-icon" />
                  Categoría:
                </span>
                <span class="info-val">{{ survey.category?.name || "General" }}</span>
              </div>

              <div class="info-row">
                <span class="info-label">
                  <ion-icon :icon="timeOutline" class="row-icon" />
                  Tiempo estimado:
                </span>
                <span class="info-val">~{{ estimatedMinutes }} minutos</span>
              </div>

              <div class="info-row">
                <span class="info-label">
                  <ion-icon :icon="documentTextOutline" class="row-icon" />
                  Preguntas:
                </span>
                <span class="info-val">{{ questions.length }} preguntas</span>
              </div>

              <div class="info-row">
                <span class="info-label">
                  <ion-icon :icon="shieldCheckmarkOutline" class="row-icon" />
                  Modalidad:
                </span>
                <span class="info-val">{{ survey.anonymity_mode === 'anonymous' ? 'Participación anónima' : 'Requiere identificación' }}</span>
              </div>

              <div class="info-row status-row">
                <span class="info-label">Estado:</span>
                <span :class="['badge-status', getStatusClass(survey)]">
                  {{ survey.status?.name || (canRespond ? 'Activa' : 'Finalizada') }}
                </span>
              </div>
            </div>
          </div>

          <!-- Botón Principal Móvil -->
          <div class="action-section">
            <ion-button
              expand="block"
              size="large"
              :disabled="!canRespond"
              @click="router.push(`/encuestas/${id}/responder`)"
              class="btn-vue-primary main-action-btn"
            >
              <span>{{ canRespond ? "Responder Encuesta Ahora" : "Encuesta no disponible" }}</span>
              <ion-icon :icon="arrowForwardOutline" class="btn-icon" v-if="canRespond" />
            </ion-button>
            <p v-if="!canRespond" class="sub-hint">
              Solo las encuestas activas dentro de su período de vigencia reciben respuestas.
            </p>
          </div>

          <!-- Listado de Preguntas -->
          <div class="questions-section">
            <h2 class="questions-title">Preguntas incluidas ({{ questions.length }})</h2>

            <div v-if="questions.length" class="questions-container">
              <div v-for="(q, i) in questions" :key="q.id ?? i" class="question-card">
                <div class="question-header">
                  <span class="q-num">#{{ i + 1 }}</span>
                  <div class="q-text">
                    <h4>{{ q.statement || q.title || q.titulo || `Pregunta ${i + 1}` }}</h4>
                    <span v-if="q.is_mandatory" class="mandatory-tag">Obligatoria</span>
                  </div>
                </div>

                <div class="question-type-tag">
                  <span class="type-pill">{{ formatType(q.type) }}</span>
                </div>

                <div v-if="getQuestionOptions(q).length" class="options-block">
                  <span class="options-title">Opciones:</span>
                  <div class="options-chips">
                    <span v-for="o in getQuestionOptions(q)" :key="o.id" class="option-chip">
                      <span class="bullet-dot"></span> {{ o.option_text || o.text || o.label }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div v-else class="empty-questions">
              <p>Esta encuesta no contiene preguntas registradas actualmente.</p>
            </div>
          </div>
        </div>
      </template>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import {
  IonPage,
  IonContent,
  IonButton,
  IonSpinner,
  IonIcon,
} from "@ionic/vue";
import {
  arrowBackOutline,
  arrowForwardOutline,
  businessOutline,
  pricetagOutline,
  documentTextOutline,
  timeOutline,
  alertCircleOutline,
  shieldCheckmarkOutline,
} from "ionicons/icons";
import {
  obtenerEncuestaPublica,
  unwrapSurvey,
  getSurveyTitle,
  getSurveyQuestions,
  getQuestionOptions,
} from "../services/surveyApi";

const route = useRoute();
const router = useRouter();
const id = route.params.id;

const survey = ref(null);
const loading = ref(false);
const error = ref("");

const questions = computed(() => getSurveyQuestions(survey.value));
const estimatedMinutes = computed(() => Math.max(1, Math.ceil(questions.value.length * 0.6)));

const canRespond = computed(() => {
  if (!survey.value) return false;
  if (survey.value.is_open === true) return true;
  const slug = String(survey.value?.status?.slug || "").toLowerCase();
  const name = String(survey.value?.status?.name || "").toLowerCase();
  return slug === "published" || name.includes("activa");
});

function getStatusClass(s) {
  const slug = String(s?.status?.slug || s?.status || "").toLowerCase();
  const name = String(s?.status?.name || "").toLowerCase();
  if (slug === "published" || name.includes("activa")) return "badge-status--active";
  if (slug === "approved" || name.includes("aprobada")) return "badge-status--approved";
  return "badge-status--closed";
}

function formatType(t) {
  const types = {
    texto: "Texto libre",
    comentario: "Comentario",
    abierta: "Pregunta abierta",
    opcion_unica: "Selección única",
    opcion_multiple: "Selección múltiple",
    si_no: "Sí / No",
    escala: "Escala numérica",
    casilla: "Casilla de verificación"
  };
  return types[t] || t || "Texto";
}

onMounted(async () => {
  loading.value = true;
  try {
    survey.value = unwrapSurvey(await obtenerEncuestaPublica(id));
  } catch (e) {
    console.error("Error al obtener detalle:", e);
    error.value =
      e.response?.data?.message ||
      `No se pudo cargar la información de la encuesta.`;
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.detail-page-content {
  --background: #F4F6FD;
}

.nav-bar {
  padding: 10px 14px 4px;
}

.back-link-btn {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  background: transparent;
  border: none;
  color: #1C8686;
  font-weight: 600;
  font-size: 13px;
  cursor: pointer;
  padding: 4px 6px;
  font-family: inherit;
}

.back-icon {
  font-size: 16px;
}

/* ================= Hero Banner ================= */
.detail-hero {
  background: linear-gradient(135deg, #1C8686 0%, #157373 100%);
  padding: 16px 16px 20px;
  color: #ffffff;
  border-bottom: 2px solid #1DAFAF;
}

.detail-hero-eyebrow {
  color: #91EDED;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1px;
  display: block;
  margin-bottom: 4px;
}

.detail-hero-title {
  color: #ffffff;
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 6px 0;
  line-height: 1.25;
}

.detail-hero-desc {
  color: #e0f2fe;
  font-size: 13px;
  line-height: 1.45;
  margin: 0;
  opacity: 0.92;
}

.detail-body {
  max-width: 600px;
  margin: 0 auto;
  padding: 14px 14px 40px;
}

/* ================= Tarjeta de Información ================= */
.info-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 14px 16px;
  border: 1px solid #D2D9DD;
  box-shadow: 0 2px 8px rgba(28, 134, 134, 0.05);
  margin-bottom: 16px;
}

.info-card-title {
  margin: 0 0 10px 0;
  font-size: 14px;
  font-weight: 700;
  color: #235454;
  border-bottom: 1px solid #f1f5f9;
  padding-bottom: 6px;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 9px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  gap: 8px;
}

.info-label {
  color: #64748b;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  flex-shrink: 0;
}

.row-icon {
  font-size: 14px;
  color: #1C8686;
}

.info-val {
  font-weight: 600;
  color: #374957;
  text-align: right;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Badges */
.badge-status {
  font-size: 10.5px;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 6px;
  text-transform: capitalize;
}

.badge-status--active {
  background: #9EF18D;
  color: #14532d;
}

.badge-status--approved {
  background: #dbeafe;
  color: #1e40af;
}

.badge-status--closed {
  background: #f1f5f9;
  color: #64748b;
}

/* ================= Botón Acción ================= */
.action-section {
  margin-bottom: 20px;
}

.main-action-btn {
  --min-height: 44px;
  font-size: 14px;
}

.btn-icon {
  font-size: 16px;
  margin-left: 6px;
}

.sub-hint {
  text-align: center;
  font-size: 11.5px;
  color: #64748b;
  margin-top: 6px;
}

/* ================= Preguntas ================= */
.questions-title {
  font-size: 15px;
  font-weight: 700;
  color: #235454;
  margin-bottom: 10px;
}

.questions-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.question-card {
  background: #ffffff;
  border-radius: 10px;
  padding: 14px;
  border: 1px solid #D2D9DD;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.03);
}

.question-header {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 6px;
}

.q-num {
  background: #E9EDFD;
  color: #1C8686;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
  flex-shrink: 0;
}

.q-text h4 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #235454;
  line-height: 1.35;
}

.mandatory-tag {
  color: #E42716;
  font-size: 10.5px;
  font-weight: 600;
  margin-top: 2px;
  display: inline-block;
}

.question-type-tag {
  margin-bottom: 8px;
}

.type-pill {
  font-size: 10.5px;
  background: #f8fafc;
  color: #475569;
  border: 1px solid #e2e8f0;
  padding: 2px 7px;
  border-radius: 4px;
  font-weight: 500;
}

.options-block {
  background: #F4F6FD;
  padding: 8px 10px;
  border-radius: 6px;
  border: 1px solid #e2e8f0;
}

.options-title {
  font-size: 11px;
  font-weight: 600;
  color: #475569;
  display: block;
  margin-bottom: 5px;
}

.options-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.option-chip {
  font-size: 11px;
  background: #ffffff;
  color: #334155;
  border: 1px solid #cbd5e1;
  padding: 2px 8px;
  border-radius: 50px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.bullet-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #1DAFAF;
  display: inline-block;
}

.center-loading {
  text-align: center;
  padding: 50px 16px;
  color: #1C8686;
  font-size: 13px;
}

.error-container {
  background: #fef2f2;
  color: #991b1b;
  padding: 20px;
  border-radius: 10px;
  text-align: center;
  margin: 16px;
  border: 1px solid #fecaca;
  font-size: 13px;
}

.err-icon {
  font-size: 28px;
  margin-bottom: 6px;
}

.retry-action-btn {
  background: #1C8686;
  color: #ffffff;
  border: none;
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  margin-top: 10px;
}
</style>
