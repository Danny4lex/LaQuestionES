<template>
    <v-dialog
      :model-value="modelValue"
      max-width="560"
      scrollable
      @update:model-value="$emit('update:modelValue', $event)"
    >
      <v-card class="rounded-lg">
        <v-card-title class="pt-5 px-6">Ajustes</v-card-title>
        <v-card-text class="px-6">
          <p class="text-body-2 mb-4">
            Elige el estilo de la cabecera de cada vista. Se guarda automáticamente.
          </p>
  
          <div v-for="vista in HERO_VISTAS" :key="vista.key" class="mb-4">
            <div class="font-weight-bold mb-1">{{ vista.label }}</div>
            <v-radio-group v-model="estilos[vista.key]" density="compact" hide-details>
              <v-radio v-for="e in HERO_ESTILOS" :key="e.value" :value="e.value">
                <template #label>
                  <span :class="['swatch', `swatch--${e.value}`]" />
                  {{ e.label }}
                </template>
              </v-radio>
            </v-radio-group>
          </div>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn color="primary" variant="flat" @click="$emit('update:modelValue', false)">Listo</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script setup>
  import useHeroStyle, { HERO_VISTAS, HERO_ESTILOS } from '@/composables/useHeroStyle';
  
  defineProps({ modelValue: { type: Boolean, default: false } });
  defineEmits(['update:modelValue']);
  
  const { estilos } = useHeroStyle();
  </script>
  
  <style scoped>
  .swatch {
    display: inline-block;
    width: 36px;
    height: 16px;
    margin-right: 8px;
    border-radius: 4px;
    border: 1px solid #D2D9DD;
  }
  .swatch--degradado { background: linear-gradient(135deg, #063456, #2D52A7); }
  .swatch--claro     { background: linear-gradient(135deg, #EDF2FF, #F4F6FD, #E8F0FB); }
  .swatch--solido    { background: #2D52A7; }
  </style>