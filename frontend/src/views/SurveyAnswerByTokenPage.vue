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

    <!-- Encuesta: datos del encuestado (si no es anónima) + secciones -->
    <SurveyForm
      v-else
      :survey="survey"
      :participant="participant"
      email-locked
      :submitting="submitting"
      :submit-error="submitError"
      :submit-success="submitSuccess"
      @submit="submitSurvey"
    />
  </v-container>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import axios from "axios";
import SurveyForm from "@/components/SurveyForm.vue";

const route = useRoute();
const baseUrl = import.meta.env.VITE_BACKEND_URL + "/api";

const survey = ref(null);
const participant = ref(null);
const loading = ref(true);
const error = ref(null);

const submitting = ref(false);
const submitError = ref(null);
const submitSuccess = ref(null);

onMounted(async () => {
  try {
    // GET /public/participants/{token}
    const response = await axios.get(`${baseUrl}/public/participants/${route.params.token}`);
    participant.value = response.data.participant;
    // El backend devuelve las secciones aparte; se unen a la encuesta.
    survey.value = { ...response.data.survey, sections: response.data.sections };
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      "Este enlace de invitación no es válido o ya expiró.";
  } finally {
    loading.value = false;
  }
});

async function submitSurvey({ respondent, anonymous, answers }) {
  submitError.value = null;
  submitting.value = true;

  try {
    // POST /public/participants/{token}/submit. El correo es el de la
    // invitación; solo se envían nombre y teléfono si la encuesta no es anónima.
    const body = respondent
      ? { name: respondent.name, phone: respondent.phone, answers }
      : { answers };
    if (anonymous !== undefined) body.anonymous = anonymous;
    await axios.post(`${baseUrl}/public/participants/${route.params.token}/submit`, body);

    submitSuccess.value = "¡Gracias! Tus respuestas fueron registradas correctamente.";
  } catch (e) {
    const errores = e.response?.data?.errors;
    submitError.value =
      (errores && Object.values(errores).flat()[0]) ||
      e.response?.data?.message ||
      "No se pudieron enviar las respuestas. Inténtalo nuevamente.";
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
</style>
