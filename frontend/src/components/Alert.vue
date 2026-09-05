<template>
  <!-- Toast flotante (antes era un banner inline empujado dentro del
       contenido de la página — con v-snackbar aparece sobre todo lo
       demás, en la esquina, y no desplaza nada). Mantiene la misma API
       de useAlert() (alert.success/alert.error) para no romper ninguna
       de las llamadas ya existentes en el resto de la app. -->
  <v-snackbar
    v-model="show"
    :color="type === 'alert-error' ? 'error' : 'success'"
    location="bottom right"
    :timeout="time"
    variant="elevated"
    class="app-toast"
  >
    <div class="d-flex align-center ga-2">
      <v-icon :icon="type === 'alert-error' ? 'mdi-alert-circle-outline' : 'mdi-check-circle-outline'" />
      <span>{{ message }}</span>
    </div>
    <template #actions>
      <v-btn icon="mdi-close" variant="text" size="small" @click="show = false" />
    </template>
  </v-snackbar>
</template>

<script setup>
import useAlert from "@/composables/useAlert";

const { message, type, show } = useAlert();
</script>

<style scoped>
.app-toast :deep(.v-snackbar__wrapper) {
  font-weight: 600;
  border-radius: 8px;
}
</style>