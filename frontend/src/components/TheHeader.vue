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
      <v-menu
  v-model="menuNotif"
  :close-on-content-click="false"
  location="bottom end"
  @update:model-value="(abierto) => abierto && cargarNotificaciones()"
>
  <template #activator="{ props }">
    <v-btn v-bind="props" icon variant="text" color="#2D52A7" class="me-2">
      <v-badge :content="noLeidas" :model-value="noLeidas > 0" color="error" floating>
        <v-icon>mdi-bell</v-icon>
      </v-badge>
    </v-btn>
  </template>

  <v-card width="360" max-height="440" class="overflow-y-auto">
    <div class="d-flex align-center px-4 py-3">
      <span class="font-weight-bold" style="color: #063456;">Notificaciones</span>
      <v-spacer />
      <v-btn v-if="noLeidas > 0" size="small" variant="text" color="primary" @click="marcarTodas">
        Marcar todas
      </v-btn>
    </div>
    <v-divider />

    <div v-if="!notificaciones.length" class="pa-6 text-center text-medium-emphasis text-body-2">
      No tienes notificaciones.
    </div>

    <v-list v-else lines="three" density="compact">
      <v-list-item
        v-for="n in notificaciones"
        :key="n.id"
        :class="{ 'notif-sin-leer': !n.read_at }"
        @click="abrirNotificacion(n)"
      >
        <v-list-item-title class="font-weight-bold">{{ n.title }}</v-list-item-title>
        <v-list-item-subtitle class="text-wrap">{{ n.message }}</v-list-item-subtitle>
        <div class="text-caption text-medium-emphasis mt-1">{{ formatoFecha(n.created_at) }}</div>
      </v-list-item>
    </v-list>
  </v-card>
</v-menu>

<v-snackbar v-model="mostrarAviso" :timeout="3000" color="primary" location="bottom right">
  Tienes una nueva notificación

  <template #actions>
    <v-btn variant="text" @click="mostrarAviso = false">Cerrar</v-btn>
  </template>
</v-snackbar>

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

import useAuth from "@/composables/useAuth";
import useMenu from "@/composables/useMenu";
import { computed, ref, watch, onBeforeUnmount } from "vue";
import { useRouter } from "vue-router";
import backendApi from "@/services/backendApi";
import usePolling from "@/composables/usePolling";

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
const router = useRouter();
const menuNotif = ref(false);
const notificaciones = ref([]);
const noLeidas = ref(0);

let inicializado = false;
const mostrarAviso = ref(false);

async function cargarNotificaciones() {
  if (!isLoggedIn.value) return;
  try {
    const { data } = await backendApi.get("/notifications");
    if (inicializado && data.unread_count > noLeidas.value) {
      mostrarAviso.value = true; // llegó una notificación nueva
    }
    notificaciones.value = data.data;
    noLeidas.value = data.unread_count;
    inicializado = true;
  } catch {
    /* silencioso */
  }
}

async function abrirNotificacion(n) {
  if (!n.read_at) {
    try { await backendApi.patch(`/notifications/${n.id}/read`); } catch { /* sin acción */ }
  }
  menuNotif.value = false;
  await cargarNotificaciones();
  if (n.survey_id) router.push(`/surveys/${n.survey_id}/edit`);
}

async function marcarTodas() {
  try { await backendApi.patch("/notifications/read-all"); } catch { /* sin acción */ }
  await cargarNotificaciones();
}

function formatoFecha(valor) {
  return new Date(valor).toLocaleString("es-SV", { dateStyle: "short", timeStyle: "short" });
}

// Carga al iniciar sesión y se actualiza solo cada minuto
watch(isLoggedIn, (conectado) => {
  if (conectado) cargarNotificaciones();
}, { immediate: true });

usePolling(cargarNotificaciones, 10000);

onBeforeUnmount(() => clearInterval(temporizador));
</script>

<style scoped>
.app-header {
  border-bottom: 1px solid #2D52A7;
}

.notif-sin-leer { background: #EDF2FF; }
/* Forzar centrado vertical en el contenido interno de Vuetify */
.app-header :deep(.v-toolbar__content) {
  display: flex !important;
  align-items: center !important;
  height: 100% !important;
}
</style>