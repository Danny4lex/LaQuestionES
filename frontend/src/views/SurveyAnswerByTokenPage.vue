<template>
    <v-container class="survey-answer-container">
      <!-- Cargando -->
      <div v-if="loading" class="text-center py-8">
        <v-progress-circular indeterminate color="primary" />
        <p class="mt-3 text-body-2">Cargando encuesta...</p>
      </div>
  
      <!-- Error al cargar (token inválido, encuesta cerrada, ya respondida) -->
      <div v-else-if="error" class="text-center py-8">
        <v-icon size="48" color="error">mdi-alert-circle-outline</v-icon>
        <p class="mt-3 text-body-1">{{ error }}</p>
      </div>
  
      <!-- Formulario de encuesta -->
      <v-card v-else class="survey-card" variant="flat">
        <div class="survey-card-header">
          <h1 class="survey-title">{{ survey.title }}</h1>
          <p v-if="survey.description" class="survey-description">
            {{ survey.description }}
          </p>
          <p v-if="participant?.name || participant?.email" class="survey-participant">
            Invitación para: {{ participant?.name || participant?.email }}
          </p>
        </div>
  
        <v-card-text class="survey-card-body">
          <div v-for="section in survey.sections" :key="section.id" class="survey-section">
            <h2 class="section-title">{{ section.name }}</h2>
            <p v-if="section.description" class="section-description">{{ section.description }}</p>
  
            <div v-for="question in section.questions" :key="question.id" class="survey-question">
              <p class="question-statement">
                {{ question.statement }}
                <span v-if="question.is_mandatory" class="mandatory-mark">*</span>
              </p>
  
              <v-textarea
                v-if="['texto', 'comentario', 'abierta'].includes(question.type) && question.max_length > 200"
                v-model="form[question.id]"
                placeholder="Escribe tu respuesta"
                variant="outlined"
                density="compact"
                rows="3"
                :maxlength="question.max_length"
                counter
                class="survey-input"
              />
              <v-text-field
                v-else-if="['texto', 'comentario', 'abierta'].includes(question.type)"
                v-model="form[question.id]"
                placeholder="Escribe tu respuesta"
                variant="outlined"
                density="compact"
                :maxlength="question.max_length || undefined"
                :counter="!!question.max_length"
                :hide-details="!question.max_length"
                class="survey-input"
              />
  
              <v-radio-group
                v-else-if="question.type === 'opcion_unica'"
                v-model="form[question.id]"
                hide-details
                class="survey-options"
              >
                <v-radio v-for="opt in question.options" :key="opt.id" :value="opt.id" :label="opt.option_text" />
              </v-radio-group>
  
              <div v-else-if="question.type === 'opcion_multiple'">
                <v-checkbox
                  v-for="opt in question.options"
                  :key="opt.id"
                  v-model="form[question.id]"
                  :value="opt.id"
                  :label="opt.option_text"
                  hide-details
                  class="survey-checkbox"
                />
              </div>
  
              <div v-else-if="question.type === 'escala'" class="scale-options">
                <button
                  v-for="n in 5"
                  :key="n"
                  type="button"
                  class="scale-option-btn"
                  :class="{ 'scale-option-btn--selected': form[question.id] === n }"
                  @click="form[question.id] = n"
                >
                  {{ n }}
                </button>
              </div>
  
              <v-radio-group
                v-else-if="question.type === 'si_no'"
                v-model="form[question.id]"
                inline
                hide-details
                class="survey-options"
              >
                <v-radio :value="true" label="Sí" />
                <v-radio :value="false" label="No" />
              </v-radio-group>
  
              <v-checkbox
                v-else-if="question.type === 'casilla'"
                v-model="form[question.id]"
                label="Sí"
                hide-details
                class="survey-checkbox"
              />
            </div>
          </div>
  
          <v-alert v-if="submitError" type="error" class="mt-4" variant="tonal">
            {{ submitError }}
          </v-alert>
          <v-alert v-if="submitSuccess" type="success" class="mt-4" variant="tonal">
            {{ submitSuccess }}
          </v-alert>
  
          <v-btn
            v-if="!submitSuccess"
            color="primary"
            block
            size="large"
            class="survey-submit-btn"
            :loading="submitting"
            @click="submitSurvey"
          >
            Enviar respuestas
          </v-btn>
        </v-card-text>
      </v-card>
    </v-container>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted } from "vue";
  import { useRoute } from "vue-router";
  import axios from "axios";
  
  const route = useRoute();
  
  const survey = ref(null);
  const participant = ref(null);
  const loading = ref(true);
  const error = ref(null);
  
  const form = reactive({});
  const submitting = ref(false);
  const submitError = ref(null);
  const submitSuccess = ref(null);
  
  const baseUrl = import.meta.env.VITE_BACKEND_URL + "/api";
  
  onMounted(async () => {
    const token = route.params.token;
  
    try {
      // GET /public/participants/{token} — ya existía en el backend
      // (SurveyPublicController::showByToken), solo faltaba esta pantalla.
      const response = await axios.get(`${baseUrl}/public/participants/${token}`);
  
      participant.value = response.data.participant;
      survey.value = { ...response.data.survey, sections: response.data.sections };
  
      survey.value.sections.forEach((section) => {
        section.questions.forEach((question) => {
          if (question.type === "opcion_multiple") {
            form[question.id] = [];
          } else if (question.type === "casilla") {
            form[question.id] = false;
          } else {
            form[question.id] = null;
          }
        });
      });
    } catch (e) {
      error.value =
        e.response?.data?.message ||
        "Este enlace de invitación no es válido o ya expiró.";
    } finally {
      loading.value = false;
    }
  });
  
  function validateMandatory() {
    const missing = [];
  
    survey.value.sections.forEach((section) => {
      section.questions.forEach((question) => {
        if (!question.is_mandatory) return;
  
        const value = form[question.id];
  
        if (question.type === "opcion_multiple") {
          if (!value || value.length === 0) missing.push(question.statement);
        } else if (value === null || value === undefined || value === "") {
          missing.push(question.statement);
        }
      });
    });
  
    return missing;
  }
  
  async function submitSurvey() {
    submitError.value = null;
    submitSuccess.value = null;
  
    const missing = validateMandatory();
    if (missing.length > 0) {
      submitError.value = "Faltan responder preguntas obligatorias: " + missing.join(", ");
      return;
    }
  
    const answers = [];
  
    survey.value.sections.forEach((section) => {
      section.questions.forEach((question) => {
        const value = form[question.id];
  
        if (question.type === "opcion_unica") {
          if (value) answers.push({ question_id: question.id, option_ids: [value] });
        } else if (question.type === "opcion_multiple") {
          if (value && value.length > 0) answers.push({ question_id: question.id, option_ids: value });
        } else if (["escala", "si_no", "casilla"].includes(question.type)) {
          if (value !== null && value !== undefined) answers.push({ question_id: question.id, value });
        } else {
          if (value) answers.push({ question_id: question.id, value });
        }
      });
    });
  
    submitting.value = true;
  
    try {
      const token = route.params.token;
  
      // POST /public/participants/{token}/submit — también ya existía.
      await axios.post(`${baseUrl}/public/participants/${token}/submit`, { answers });
  
      submitSuccess.value = "¡Gracias! Tus respuestas fueron registradas correctamente.";
    } catch (e) {
      submitError.value =
        e.response?.data?.message || "No se pudieron enviar las respuestas. Inténtalo nuevamente.";
    } finally {
      submitting.value = false;
    }
  }
  </script>
  
  <style scoped>
  .survey-answer-container {
    max-width: 900px;
    margin: 0 auto;
    padding-top: 24px;
    padding-bottom: 40px;
  }
  
  .survey-card {
    background-color: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  }
  
  .survey-card-header {
    background-color: #2D52A7;
    padding: 24px 28px;
    color: #ffffff;
  }
  
  .survey-title {
    font-size: 1.5rem;
    font-weight: 600;
    line-height: 1.2;
    margin-bottom: 6px;
  }
  
  .survey-description {
    font-size: 0.9rem;
    font-weight: 300;
    opacity: 0.9;
    margin: 0;
  }
  
  .survey-participant {
    font-size: 0.8rem;
    font-weight: 400;
    opacity: 0.85;
    margin-top: 6px;
  }
  
  .survey-card-body {
    padding: 24px 28px;
  }
  
  .survey-section {
    background-color: #F9FBFE;
    border: 1px solid #E3EBF5;
    border-radius: 10px;
    padding: 18px 20px;
    margin-bottom: 18px;
  }
  
  .section-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #1E293B;
    margin-bottom: 4px;
  }
  
  .section-description {
    font-size: 0.8rem;
    color: #64748B;
    margin-bottom: 16px;
  }
  
  .survey-question {
    background-color: #ffffff;
    border-radius: 8px;
    padding: 14px 16px;
    margin-bottom: 12px;
    border-left: 3px solid #4880FF;
  }
  
  .question-statement {
    font-size: 0.9rem;
    font-weight: 500;
    color: #1E293B;
    margin-bottom: 10px;
  }
  
  .mandatory-mark {
    color: #E42716;
    font-weight: 700;
  }
  
  .survey-input :deep(.v-field),
  .survey-checkbox :deep(.v-field),
  .survey-options :deep(.v-field) {
    background-color: #E8F0F8;
    border-radius: 6px;
  }
  
  .scale-options {
    display: flex;
    gap: 8px;
    margin-top: 8px;
  }
  
  .scale-option-btn {
    width: 30px;
    height: 30px;
    border-radius: 4px;
    border: 1px solid #323A45;
    background-color: #ffffff;
    color: #323A45;
    font-size: 0.85rem;
    font-weight: 500;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    transition: background-color 0.2s, color 0.2s;
  }
  
  .scale-option-btn:hover {
    background-color: #E8F0F8;
  }
  
  .scale-option-btn--selected {
    background-color: #4880FF;
    border-color: #4880FF;
    color: #ffffff;
  }
  
  .survey-submit-btn {
    margin-top: 24px;
    border-radius: 50px;
    font-weight: 500;
    letter-spacing: 0;
    text-transform: none;
  }
  </style>
  