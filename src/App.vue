<script setup>
import { onMounted } from "vue";
import { useRoute } from "vue-router";
import TheFooter from "./components/TheFooter.vue";
import TheHeader from "./components/TheHeader.vue";
import useAuth from "./composables/useAuth";
import TheMenu from "./components/TheMenu.vue";
import Alert from "@/components/Alert.vue";
import ConfirmDialog from "@/components/ConfirmDialog.vue";
import useMenu from "@/composables/useMenu";

const { accessToken, refreshToken, user, isLoggedIn, surveyProfile, getUserInfo } = useAuth();
const { stateSideBar } = useMenu();
const route = useRoute();

onMounted(async () => {
  accessToken.value = localStorage.getItem("access_token");
  refreshToken.value = localStorage.getItem("refresh_token");
  user.value = JSON.parse(localStorage.getItem("user"));
  surveyProfile.value = JSON.parse(localStorage.getItem("survey_profile"));
  isLoggedIn.value = user.value ? true : false;

  if (isLoggedIn.value) {
    stateSideBar.value = "active";
    await getUserInfo();
  }
});
</script>

<template>
  <v-app>
    <!-- El menú lateral y el header administrativo solo tienen sentido
         dentro del panel autenticado. En login/callback y en las
         pantallas públicas de respuesta de encuesta se ocultan por
         completo, ver meta.hideChrome en router/index.js. -->
    <TheMenu v-if="!route.meta.hideChrome" />
    <TheHeader v-if="!route.meta.hideChrome" />
    <v-main style="background-color: #F4F7FD;">
      <v-container fluid style="padding-left: 32px; padding-right: 32px;">
        <Alert />
        <ConfirmDialog />
        <RouterView />
      </v-container>
    </v-main>
    <TheFooter />
  </v-app>
</template>

<style scoped>
.global-separator {
  position: fixed;
  top: 58px;
  left: 0;
  right: 0;
  height: 1px;
  z-index: 999;
}

.v-main {
  background-color: #E8F0F8;
}
</style>

<style>
/* Estilos globales */
body {
  font-family: 'Poppins', sans-serif;
}

* {
  font-family: 'Poppins', sans-serif;
}
</style>
