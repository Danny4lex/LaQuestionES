import axios from "axios";

import { useAuthStore } from "../stores/auth";
import { storeToRefs } from "pinia";
import { useRouter } from "vue-router";

import backendApi from "@/services/backendApi.js"

const userApiEndpoint = import.meta.env.VITE_BACKEND_USER_API_ENDPOINT;
const refreshTokenEndpoint = import.meta.env.VITE_BACKEND_REFRESH_TOKEN_ENDPOINT;

const useAuth = () => {
  const authStore = useAuthStore();
  const {
    accessToken,
    refreshToken,
    user,
    isLoggedIn,
    surveyProfile,
  } = storeToRefs(authStore);
  const router = useRouter();

  const getUserInfo = async () => {
    const { data } = await backendApi
      .post(userApiEndpoint, null, {
        headers: {
          Authorization: `Bearer ${accessToken.value}`,
        },
      });

    user.value = data.user;
    surveyProfile.value = data.survey_profile;
    localStorage.setItem('user', JSON.stringify(data.user));
    localStorage.setItem('survey_profile', JSON.stringify(data.survey_profile));
    isLoggedIn.value = true;
  };

  const refreshAccessToken = async () => {
    const response = await axios
      .post(refreshTokenEndpoint, null, {
        headers: {
          Authorization: `Bearer ${accessToken.value}`,
        },
      })
      .catch((error) => {
        console.log(error);
        logout();
      });

    accessToken.value = response.data.access_token;
    refreshToken.value = response.data.refresh_token;

    return response;
  };

  const logout = () => {
    localStorage.clear();
    isLoggedIn.value = false;
    router.push("/login");
  };

  const login = async (credentials) => {
    const { data } = await backendApi.post('/auth/login', credentials)

    localStorage.setItem('access_token', data.data.backend.access_token)
    localStorage.setItem('refresh_token', data.data.backend.refresh_token)
    localStorage.setItem('user', JSON.stringify(data.data.user))
    localStorage.setItem('survey_profile', JSON.stringify(data.data.survey_profile))

    user.value = data.data.user;
    surveyProfile.value = data.data.survey_profile;
    isLoggedIn.value = true;
  }

  // Permiso real del rol (Administrador/Encuestador/Respondedor), tal
  // como lo devuelve el backend en survey_profile.permissions. Se usa en
  // toda la UI para mostrar/ocultar botones — nunca se hardcodea el rol
  // por nombre, siempre por la habilidad puntual (ej. 'surveys.delete').
  const hasPermission = (ability) => {
    return !!surveyProfile.value?.permissions?.includes(ability);
  };

  return {
    // Variables
    accessToken,
    refreshToken,
    user,
    isLoggedIn,
    surveyProfile,
    // Functions
    login,
    getUserInfo,
    refreshAccessToken,
    logout,
    hasPermission,
  };
};

export default useAuth;
