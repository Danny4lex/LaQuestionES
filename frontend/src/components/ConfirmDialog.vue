<template>
  <v-dialog v-model="show" max-width="420" persistent>
    <v-card>
      <v-card-title class="text-h6 d-flex align-center ga-2">
        <v-icon color="warning">mdi-alert-outline</v-icon>
        {{ title }}
      </v-card-title>
      <v-card-text class="text-body-small">
        {{ message }}
      </v-card-text>
      <v-card-actions class="pa-4">
        <v-spacer />
        <v-btn variant="outlined" color="secondary" class="text-button" @click="resolve(false)">
          {{ cancelText }}
        </v-btn>
        <v-btn color="error" variant="flat" class="text-button" @click="resolve(true)">
          {{ confirmText }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import useConfirm from "@/composables/useConfirm";

const { show, title, message, confirmText, cancelText, resolve } = useConfirm();
</script>
