<template>
  <v-app-bar app color="#F4F6FD" height="58" elevation="0" class="app-header">
    <v-btn v-if="showMenuToggle" icon variant="text" color="#2D52A7" class="my-auto me-2" @click="toggleMenu">
      <v-icon>
        {{ stateSideBar === 'active' ? 'mdi-chevron-left' : 'mdi-chevron-right' }}
      </v-icon>
    </v-btn>

    <div class="d-flex align-center">
      
      <span class="text-body-2 font-weight-medium" style="color: #2D52A7;">
        República de El Salvador - Sistema de Encuestas
      </span>
    </div>

    <v-spacer />

    <template v-if="isLoggedIn">
      <v-icon icon="mdi-bell" class="me-4" color="#2D52A7" />

      <div class="d-flex align-center me-4">
        <div class="me-2 text-right">
          <div class="text-body-2 font-weight-bold" style="color: #2D52A7; line-height: 1.1;">
            {{ user.name }}
          </div>
          <div v-if="surveyProfile?.role" class="text-caption" style="color: #374957; line-height: 1.1;">
            {{ surveyProfile.role }}
          </div>
        </div>
        <v-avatar color="#2D52A7" size="32">
          <span class="text-white font-weight">{{ initials }}</span>
        </v-avatar>
      </div>
    </template>
  </v-app-bar>
</template>


<script setup>
import { computed } from "vue";
import useAuth from "@/composables/useAuth";
import useMenu from "@/composables/useMenu";

// Cuando App.vue no monta <TheMenu /> (login, callback, respuesta pública
// de encuesta), tampoco tiene sentido mostrar el botón que lo colapsa —
// por defecto en true para no romper ningún otro lugar donde se use este
// componente sin pasar el prop.
defineProps({
  showMenuToggle: { type: Boolean, default: true },
});

const { isLoggedIn, user, surveyProfile } = useAuth();
const { stateSideBar } = useMenu();

const initials = computed(() => {
  if (!user.value?.name) return "";
  const parts = user.value.name.split(" ");
  const first = parts[0]?.[0] || "";
  const last = parts[1]?.[0] || "";
  return `${first}${last}`.toUpperCase();
});

function toggleMenu() {
  stateSideBar.value = stateSideBar.value === "active" ? "inactive" : "active";
}
</script>

<style scoped>
.app-header {
  border-bottom: 1px solid #2D52A7;
}

/* Forzar centrado vertical en el contenido interno de Vuetify */
.app-header :deep(.v-toolbar__content) {
  display: flex !important;
  align-items: center !important;
  height: 100% !important;
}
</style>