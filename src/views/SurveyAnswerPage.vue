<template>
  <v-container class="survey-answer-container">
    <!-- Cargando -->
    <div v-if="loading" class="text-center py-8">
      <v-progress-circular indeterminate color="primary" />
      <p class="mt-3 text-body-2">Cargando encuesta...</p>
    </div>

    <!-- Error al cargar la encuesta -->
    <div v-else-if="error" class="text-center py-8">
      <v-icon size="48" color="error">mdi-alert-circle-outline</v-icon>
      <p class="mt-3 text-body-1">{{ error }}</p>
    </div>

    <!-- Encuesta: datos del encuestado (si no es anónima) + secciones -->
    <SurveyForm
      v-else
      :survey="survey"
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
const loading = ref(true);
const error = ref(null);

const submitting = ref(false);
const submitError = ref(null);
const submitSuccess = ref(null);

onMounted(async () => {
  try {
    const response = await axios.get(`${baseUrl}/public/surveys/${route.params.id}`);
    survey.value = response.data;
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      "No se pudo cargar la encuesta. Verifica el enlace.";
  } finally {
    loading.value = false;
  }
});

async function submitSurvey({ respondent, answers }) {
  submitError.value = null;
  submitting.value = true;

  try {
    // Encuesta anónima: no se envía ningún dato personal.
    const body = respondent ? { ...respondent, answers } : { answers };
    await axios.post(`${baseUrl}/public/surveys/${route.params.id}/submit`, body);

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
