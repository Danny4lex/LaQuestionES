<template>
  <ion-page>
    <ion-content class="answer-page-content" :fullscreen="true">
      <!-- Barra Superior de Navegación -->
      <div class="nav-bar">
        <button class="back-link-btn" @click="router.push(`/encuestas/${id}`)">
          <ion-icon :icon="arrowBackOutline" class="back-icon" />
          <span>Volver al detalle</span>
        </button>
      </div>

      <!-- Spinner de Carga -->
      <div v-if="loading" class="center-loading">
        <ion-spinner name="crescent" color="secondary" />
        <p>Cargando formulario...</p>
      </div>

      <!-- Mensaje de Error -->
      <div v-else-if="error && !survey" class="error-container">
        <ion-icon :icon="alertCircleOutline" class="err-icon" />
        <p>{{ error }}</p>
        <button class="retry-action-btn" @click="router.push(`/encuestas/${id}`)">
          Volver a la encuesta
        </button>
      </div>

      <template v-else-if="survey">
        <!-- Hero Header -->
        <div class="answer-hero">
          <div class="hero-inner">
            <span class="answer-hero-eyebrow">FORMULARIO OFICIAL</span>
            <h1 class="answer-hero-title">{{ getSurveyTitle(survey) }}</h1>
            <p class="answer-hero-sub">
              Por favor completa todas las preguntas obligatorias marcadas con *.
            </p>
          </div>
        </div>

        <div class="answer-body">
          <!-- Pantalla de Éxito al Enviar -->
          <div v-if="success" class="success-card">
            <div class="success-icon-badge">
              <ion-icon :icon="checkmarkOutline" />
            </div>
            <h2 class="success-title">¡Respuestas Enviadas!</h2>
            <p class="success-desc">{{ success }}</p>
            <p class="success-sub">Tu aporte ayuda a mejorar los servicios y programas culturales de El Salvador.</p>
            <button class="return-home-btn" @click="router.push('/encuestas')">
              <ion-icon :icon="arrowBackOutline" />
              <span>Volver a Encuestas</span>
            </button>
          </div>

          <!-- Formulario de Respuesta -->
          <form v-else @submit.prevent="enviar">
            <!-- Barra de Progreso Minimalista -->
            <div class="progress-bar-card" v-if="questions.length">
              <div class="progress-header">
                <span class="progress-label">Progreso de la encuesta</span>
                <span class="progress-stats">{{ answeredCount }} de {{ questions.length }} respondidas ({{ progressPercent }}%)</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: progressPercent + '%' }"></div>
              </div>
            </div>

            <!-- Datos del participante (si no es anónima) -->
            <div v-if="requiresIdentity" class="form-card identity-card">
              <div class="card-section-header">
                <ion-icon :icon="personOutline" class="header-icon" />
                <h3 class="card-section-title">Datos del Participante</h3>
              </div>
              <p class="card-section-hint">Tus datos serán tratados con confidencialidad institucional.</p>

              <div class="input-group">
                <label class="form-label">
                  <ion-icon :icon="personOutline" class="field-icon" />
                  <span>Nombre completo <span class="required">*</span></span>
                </label>
                <input
                  v-model="identity.name"
                  type="text"
                  placeholder="Ej. Carlos Mendoza"
                  required
                  class="custom-field-input"
                />
              </div>

              <div class="input-group">
                <label class="form-label">
                  <ion-icon :icon="mailOutline" class="field-icon" />
                  <span>Correo electrónico <span class="required">*</span></span>
                </label>
                <input
                  v-model="identity.email"
                  type="email"
                  placeholder="ejemplo@correo.gob.sv"
                  required
                  class="custom-field-input"
                />
              </div>

              <div class="input-group">
                <label class="form-label">
                  <ion-icon :icon="callOutline" class="field-icon" />
                  <span>Teléfono de contacto (opcional)</span>
                </label>
                <input
                  v-model="identity.phone"
                  type="tel"
                  placeholder="Ej. 7000-0000"
                  class="custom-field-input"
                />
              </div>
            </div>

            <!-- Listado de Preguntas -->
            <div class="questions-list">
              <div
                v-for="(q, i) in questions"
                :key="q.id ?? i"
                class="form-card question-card"
                :class="{ 'question-card--answered': isAnswered(q) }"
              >
                <!-- Cabecera de la pregunta -->
                <div class="question-header">
                  <span class="q-badge">#{{ i + 1 }}</span>
                  <div class="q-statement-box">
                    <label class="q-statement">
                      {{ q.statement || q.title || q.titulo || `Pregunta ${i + 1}` }}
                      <span v-if="q.is_mandatory" class="required">*</span>
                    </label>
                    <span v-if="q.is_mandatory" class="mandatory-pill">Obligatoria</span>
                  </div>
                </div>

                <!-- Campo de Texto / Abierta -->
                <div v-if="isText(q)" class="input-wrapper">
                  <textarea
                    v-model="answers[q.id]"
                    :required="!!q.is_mandatory"
                    :maxlength="q.max_length || undefined"
                    rows="3"
                    placeholder="Escribe tu respuesta aquí..."
                    class="custom-textarea"
                  ></textarea>
                  <span v-if="q.max_length" class="char-count">
                    Máx. {{ q.max_length }} caracteres
                  </span>
                </div>

                <!-- Opción Múltiple (Checkbox Chips) -->
                <div v-else-if="isMultiple(q)" class="options-selection-grid">
                  <div
                    v-for="o in getQuestionOptions(q)"
                    :key="o.id"
                    :class="['option-select-pill', { selected: isMultipleSelected(q.id, o.id) }]"
                    @click="toggleMultipleOption(q.id, o.id)"
                  >
                    <div class="pill-check-indicator">
                      <ion-icon :icon="checkmarkOutline" v-if="isMultipleSelected(q.id, o.id)" />
                    </div>
                    <span class="pill-text">{{ o.option_text || o.text || o.label }}</span>
                  </div>
                </div>

                <!-- Opción Única (Radio Chips) -->
                <div v-else-if="isSingle(q)" class="options-selection-grid">
                  <div
                    v-for="o in getQuestionOptions(q)"
                    :key="o.id"
                    :class="['option-select-pill', { selected: answers[q.id] === o.id }]"
                    @click="answers[q.id] = o.id"
                  >
                    <div class="pill-radio-indicator">
                      <span class="pill-radio-dot" v-if="answers[q.id] === o.id"></span>
                    </div>
                    <span class="pill-text">{{ o.option_text || o.text || o.label }}</span>
                  </div>
                </div>

                <!-- Sí / No (Botones Segmentados Táctiles) -->
                <div v-else-if="isYesNo(q)" class="yes-no-group">
                  <button
                    type="button"
                    :class="['yes-no-btn', { selected: answers[q.id] === true || answers[q.id] === 'si' || answers[q.id] === 1 }]"
                    @click="answers[q.id] = true"
                  >
                    <ion-icon :icon="checkmarkOutline" class="yn-icon" />
                    <span>Sí</span>
                  </button>
                  <button
                    type="button"
                    :class="['yes-no-btn', { selected: answers[q.id] === false || answers[q.id] === 'no' || answers[q.id] === 0 }]"
                    @click="answers[q.id] = false"
                  >
                    <ion-icon :icon="closeOutline" class="yn-icon" />
                    <span>No</span>
                  </button>
                </div>

                <!-- Escala Numérica (1 a 5) -->
                <div v-else-if="isScale(q)" class="scale-section">
                  <div class="scale-chips-row">
                    <button
                      v-for="n in 5"
                      :key="n"
                      type="button"
                      :class="['scale-chip', { selected: answers[q.id] === n }]"
                      @click="answers[q.id] = n"
                    >
                      {{ n }}
                    </button>
                  </div>
                  <div class="scale-legend">
                    <span>1 (Bajo / Insatisfecho)</span>
                    <span>5 (Excelente / Satisfecho)</span>
                  </div>
                </div>

                <!-- Campo General de Respaldo -->
                <div v-else class="input-wrapper">
                  <input
                    v-model="answers[q.id]"
                    :required="!!q.is_mandatory"
                    placeholder="Tu respuesta..."
                    class="custom-field-input"
                  />
                </div>
              </div>
            </div>

            <!-- Error de envío si ocurre -->
            <div v-if="error" class="error-banner">
              <ion-icon :icon="alertCircleOutline" class="error-icon" />
              <span>{{ error }}</span>
            </div>

            <!-- Botón Principal de Envío -->
            <div class="submit-section">
              <ion-button
                type="submit"
                expand="block"
                size="large"
                class="btn-vue-primary submit-action-btn"
                :disabled="sending || !questions.length"
              >
                <ion-spinner v-if="sending" name="crescent" />
                <span v-else class="btn-inner-content">
                  <span>Enviar Mis Respuestas</span>
                  <ion-icon :icon="paperPlaneOutline" class="submit-icon" />
                </span>
              </ion-button>
            </div>
          </form>
        </div>
      </template>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
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
  personOutline,
  mailOutline,
  callOutline,
  checkmarkOutline,
  closeOutline,
  paperPlaneOutline,
  alertCircleOutline,
} from "ionicons/icons";
import {
  obtenerEncuestaPublica,
  enviarRespuestas,
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
const sending = ref(false);
const error = ref("");
const success = ref("");

const answers = reactive({});
const identity = reactive({ name: "", email: "", phone: "" });

const questions = computed(() => getSurveyQuestions(survey.value));
const requiresIdentity = computed(
  () => survey.value?.anonymity_mode !== "anonymous"
);

const type = (q) => String(q?.type || "").toLowerCase();
const isText = (q) => ["texto", "comentario", "abierta"].includes(type(q));
const isMultiple = (q) => type(q) === "opcion_multiple";
const isSingle = (q) => type(q) === "opcion_unica";
const isYesNo = (q) => type(q) === "si_no";
const isScale = (q) => type(q) === "escala";

function toggleMultipleOption(questionId, optionId) {
  if (!Array.isArray(answers[questionId])) {
    answers[questionId] = [];
  }
  const idx = answers[questionId].indexOf(optionId);
  if (idx >= 0) {
    answers[questionId].splice(idx, 1);
  } else {
    answers[questionId].push(optionId);
  }
}

function isMultipleSelected(questionId, optionId) {
  return Array.isArray(answers[questionId]) && answers[questionId].includes(optionId);
}

function isAnswered(q) {
  const v = answers[q.id];
  if (v === undefined || v === null || v === "") return false;
  if (Array.isArray(v)) return v.length > 0;
  return true;
}

const answeredCount = computed(() => {
  if (!questions.value.length) return 0;
  return questions.value.filter(isAnswered).length;
});

const progressPercent = computed(() => {
  if (!questions.value.length) return 0;
  return Math.min(100, Math.round((answeredCount.value / questions.value.length) * 100));
});

onMounted(async () => {
  loading.value = true;
  try {
    survey.value = unwrapSurvey(await obtenerEncuestaPublica(id));
  } catch (e) {
    console.error("Error cargando formulario:", e);
    error.value =
      e.response?.data?.message ||
      `No se pudo cargar el formulario. Comprueba la conexión con el servidor.`;
  } finally {
    loading.value = false;
  }
});

async function enviar() {
  sending.value = true;
  error.value = "";
  success.value = "";
  try {
    const payload = {
      ...(requiresIdentity.value
        ? { name: identity.name, email: identity.email, phone: identity.phone }
        : { anonymous: true }),
      answers: questions.value.map((q) => {
        const v = answers[q.id];
        const a = { question_id: q.id };
        if (isSingle(q)) a.option_ids = v == null || v === "" ? [] : [v];
        else if (isMultiple(q)) a.option_ids = Array.isArray(v) ? v : [];
        else a.value = v ?? null;
        return a;
      }),
    };
    const result = await enviarRespuestas(id, payload);
    success.value = result?.message || "Tus respuestas han sido recibidas satisfactoriamente.";
  } catch (e) {
    console.error("Error al enviar respuestas:", e);
    error.value =
      e.response?.data?.message ||
      `No se pudieron enviar las respuestas. Verifica que las preguntas obligatorias estén contestadas.`;
  } finally {
    sending.value = false;
  }
}
</script>

<style scoped>
.answer-page-content {
  --background: #F4F6FD;
}

/* ================= Barra de Navegación ================= */
.nav-bar {
  padding: 10px 14px 4px;
}

.back-link-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: transparent;
  border: none;
  color: #1C8686;
  font-size: 13.5px;
  font-weight: 600;
  font-family: inherit;
  cursor: pointer;
  padding: 6px 8px;
  border-radius: 6px;
  transition: background 0.15s ease;
}

.back-link-btn:active {
  background: rgba(28, 134, 134, 0.08);
}

.back-icon {
  font-size: 16px;
}

/* ================= Hero Header ================= */
.answer-hero {
  background: linear-gradient(135deg, #1C8686 0%, #166f6f 100%);
  padding: 16px 16px 20px;
  color: #ffffff;
  border-bottom: 2px solid #1DAFAF;
}

.hero-inner {
  max-width: 600px;
  margin: 0 auto;
}

.answer-hero-eyebrow {
  color: #91EDED;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.8px;
  display: block;
  margin-bottom: 4px;
}

.answer-hero-title {
  color: #ffffff;
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 6px 0;
  line-height: 1.25;
}

.answer-hero-sub {
  color: #e0f2fe;
  font-size: 12.5px;
  line-height: 1.4;
  margin: 0;
  opacity: 0.92;
}

.answer-body {
  max-width: 600px;
  margin: 0 auto;
  padding: 14px 14px 40px;
}

/* ================= Barra de Progreso ================= */
.progress-bar-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 12px 14px;
  border: 1px solid #D2D9DD;
  margin-bottom: 12px;
  box-shadow: 0 1px 4px rgba(28, 134, 134, 0.04);
}

.progress-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.progress-label {
  font-size: 12px;
  font-weight: 600;
  color: #235454;
}

.progress-stats {
  font-size: 11px;
  font-weight: 600;
  color: #1C8686;
}

.progress-track {
  height: 6px;
  background: #E2E8F0;
  border-radius: 6px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #1C8686, #1DAFAF);
  border-radius: 6px;
  transition: width 0.3s ease;
}

/* ================= Tarjetas ================= */
.form-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #D2D9DD;
  box-shadow: 0 2px 8px rgba(28, 134, 134, 0.04);
  margin-bottom: 12px;
  transition: border-color 0.2s ease;
}

.question-card--answered {
  border-left: 3.5px solid #10b981;
}

.card-section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.header-icon {
  font-size: 17px;
  color: #1C8686;
}

.card-section-title {
  margin: 0;
  font-size: 15px;
  font-weight: 700;
  color: #235454;
}

.card-section-hint {
  font-size: 12px;
  color: #64748b;
  margin: 0 0 14px 0;
}

/* ================= Inputs ================= */
.input-group {
  margin-bottom: 12px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12.5px;
  font-weight: 600;
  color: #374957;
  margin-bottom: 6px;
}

.field-icon {
  font-size: 14px;
  color: #1C8686;
}

.required {
  color: #E42716;
  font-weight: 700;
}

.custom-field-input {
  width: 100%;
  border: 1px solid #D2D9DD;
  background: #f8fafc;
  border-radius: 8px;
  padding: 9px 12px;
  font-size: 13.5px;
  color: #1e293b;
  font-family: inherit;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.15s ease, box-shadow 0.15s ease;
}

.custom-field-input:focus {
  border-color: #1DAFAF;
  background: #ffffff;
  box-shadow: 0 0 0 3px rgba(29, 175, 175, 0.15);
}

.custom-textarea {
  width: 100%;
  border: 1px solid #D2D9DD;
  background: #f8fafc;
  border-radius: 8px;
  padding: 10px 12px;
  font-size: 13.5px;
  color: #1e293b;
  font-family: inherit;
  outline: none;
  resize: vertical;
  min-height: 80px;
  box-sizing: border-box;
  transition: border-color 0.15s ease, box-shadow 0.15s ease;
}

.custom-textarea:focus {
  border-color: #1DAFAF;
  background: #ffffff;
  box-shadow: 0 0 0 3px rgba(29, 175, 175, 0.15);
}

.char-count {
  font-size: 11px;
  color: #94a3b8;
  display: block;
  margin-top: 4px;
  text-align: right;
}

/* ================= Cabecera de Pregunta ================= */
.question-header {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin-bottom: 12px;
}

.q-badge {
  background: #E9EDFD;
  color: #1C8686;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 6px;
  flex-shrink: 0;
}

.q-statement-box {
  flex: 1;
}

.q-statement {
  font-size: 14.5px;
  font-weight: 600;
  color: #235454;
  line-height: 1.35;
  display: block;
  margin-bottom: 4px;
}

.mandatory-pill {
  font-size: 10px;
  font-weight: 600;
  color: #dc2626;
  background: #fef2f2;
  border: 1px solid #fecaca;
  padding: 1px 6px;
  border-radius: 4px;
  display: inline-block;
}

/* ================= Selección de Opciones (Chips Minimalistas) ================= */
.options-selection-grid {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.option-select-pill {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #f8fafc;
  border: 1px solid #D2D9DD;
  border-radius: 10px;
  padding: 10px 12px;
  cursor: pointer;
  transition: all 0.15s ease;
}

.option-select-pill:active {
  transform: scale(0.985);
}

.option-select-pill.selected {
  background: #f0fdfa;
  border-color: #1DAFAF;
  box-shadow: 0 2px 6px rgba(29, 175, 175, 0.12);
}

.pill-radio-indicator {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  border: 1.5px solid #94a3b8;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: border-color 0.15s ease;
}

.option-select-pill.selected .pill-radio-indicator {
  border-color: #1C8686;
}

.pill-radio-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: #1C8686;
}

.pill-check-indicator {
  width: 18px;
  height: 18px;
  border-radius: 4px;
  border: 1.5px solid #94a3b8;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 13px;
  color: #ffffff;
  transition: all 0.15s ease;
}

.option-select-pill.selected .pill-check-indicator {
  background: #1C8686;
  border-color: #1C8686;
}

.pill-text {
  font-size: 13px;
  color: #334155;
  line-height: 1.35;
  flex: 1;
}

.option-select-pill.selected .pill-text {
  color: #235454;
  font-weight: 600;
}

/* ================= Sí / No ================= */
.yes-no-group {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.yes-no-btn {
  background: #f8fafc;
  border: 1.5px solid #D2D9DD;
  border-radius: 10px;
  padding: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 600;
  color: #475569;
  font-family: inherit;
  cursor: pointer;
  transition: all 0.15s ease;
}

.yes-no-btn:active {
  transform: scale(0.97);
}

.yes-no-btn.selected {
  background: #f0fdfa;
  border-color: #1DAFAF;
  color: #1C8686;
  box-shadow: 0 2px 6px rgba(29, 175, 175, 0.15);
}

.yn-icon {
  font-size: 16px;
}

/* ================= Escala ================= */
.scale-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.scale-chips-row {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 6px;
}

.scale-chip {
  background: #f8fafc;
  border: 1px solid #D2D9DD;
  border-radius: 8px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 15px;
  font-weight: 700;
  color: #475569;
  cursor: pointer;
  transition: all 0.15s ease;
  font-family: inherit;
}

.scale-chip:active {
  transform: scale(0.94);
}

.scale-chip.selected {
  background: #1C8686;
  border-color: #1C8686;
  color: #ffffff;
  box-shadow: 0 2px 6px rgba(28, 134, 134, 0.25);
}

.scale-legend {
  display: flex;
  justify-content: space-between;
  font-size: 10.5px;
  color: #64748b;
  margin-top: 2px;
}

/* ================= Error Banner ================= */
.error-banner {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  padding: 10px 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12.5px;
  margin-bottom: 12px;
}

.error-icon {
  font-size: 17px;
  color: #E42716;
  flex-shrink: 0;
}

/* ================= Botón de Envío ================= */
.submit-section {
  margin: 22px 0 36px;
}

.submit-action-btn {
  --min-height: 46px;
  font-size: 15px;
  font-weight: 600;
  border-radius: 10px;
}

.btn-inner-content {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.submit-icon {
  font-size: 17px;
}

/* ================= Pantalla de Éxito ================= */
.success-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 32px 20px;
  text-align: center;
  border: 1.5px solid #a7f3d0;
  box-shadow: 0 4px 20px rgba(16, 185, 129, 0.1);
  margin-top: 10px;
}

.success-icon-badge {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: #ecfdf5;
  border: 2px solid #10b981;
  color: #059669;
  font-size: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 14px;
}

.success-title {
  color: #065f46;
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 8px 0;
}

.success-desc {
  font-size: 13.5px;
  color: #047857;
  line-height: 1.4;
  margin: 0 0 6px 0;
}

.success-sub {
  font-size: 12px;
  color: #64748b;
  margin: 0 0 24px 0;
}

.return-home-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: #1C8686;
  color: #ffffff;
  border: none;
  border-radius: 50px;
  padding: 10px 22px;
  font-size: 13.5px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(28, 134, 134, 0.25);
  transition: all 0.15s ease;
}

.return-home-btn:active {
  transform: scale(0.96);
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
  padding: 16px;
  border-radius: 8px;
  text-align: center;
  margin: 16px;
  border: 1px solid #fecaca;
  font-size: 13px;
}

.err-icon {
  font-size: 28px;
  color: #E42716;
  margin-bottom: 6px;
}

.retry-action-btn {
  margin-top: 10px;
  background: #E42716;
  color: #ffffff;
  border: none;
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
}
</style>