import { defineStore } from "pinia";
import { ref } from "vue";

export const useAuthStore = defineStore("auth", () => {
  const state = ref(null);
  const verifier = ref(null);
  const challenge = ref(null);
  const accessToken = ref(null);
  const refreshToken = ref(null);
  const user = ref(null);
  const isLoggedIn = ref(false);
  // Identidad y permisos reales dentro del módulo de encuestas (viene de
  // AuthController::login -> data.survey_profile). Es lo que la UI
  // consulta para mostrar/ocultar botones según el rol (Administrador,
  // Encuestador/Creador, Respondedor).
  const surveyProfile = ref(null);

  return {
    state,
    verifier,
    challenge,
    accessToken,
    refreshToken,
    user,
    isLoggedIn,
    surveyProfile,
  };
});
