<template>
    <div class="time-select">
      <v-select
        :model-value="hora"
        :items="horas"
        label="Hora"
        variant="outlined"
        density="compact"
        hide-details
        class="input-field time-hora"
        @update:model-value="(v) => { hora = v; emitir(); }"
      />
      <v-select
        :model-value="minuto"
        :items="minutos"
        label="Min"
        variant="outlined"
        density="compact"
        hide-details
        class="input-field time-minuto"
        @update:model-value="(v) => { minuto = v; emitir(); }"
      />
      <v-select
        :model-value="periodo"
        :items="['AM', 'PM']"
        label="AM/PM"
        variant="outlined"
        density="compact"
        hide-details
        class="input-field time-periodo"
        @update:model-value="(v) => { periodo = v; emitir(); }"
      />
    </div>
  </template>
  
  <script setup>
  import { ref, watch } from "vue";
  
  // Selector de hora en formato de 12 horas.
  // v-model: texto "HH:mm" en 24 horas (por ejemplo "14:30"), o null.
  const props = defineProps({
    modelValue: { type: String, default: null },
  });
  const emit = defineEmits(["update:modelValue"]);
  
  const horas = Array.from({ length: 12 }, (_, i) => i + 1);
  const minutos = Array.from({ length: 60 }, (_, i) => String(i).padStart(2, "0"));
  
  const hora = ref(null);
  const minuto = ref(null);
  const periodo = ref(null);
  
  // De "14:30" a 2 : 30 PM
  watch(
    () => props.modelValue,
    (valor) => {
      if (!valor) {
        hora.value = null;
        minuto.value = null;
        periodo.value = null;
        return;
      }
      const [h, m] = valor.split(":").map(Number);
      periodo.value = h >= 12 ? "PM" : "AM";
      hora.value = h % 12 || 12;
      minuto.value = String(m).padStart(2, "0");
    },
    { immediate: true }
  );
  
  // De 2 : 30 PM a "14:30". Si falta alguna parte se completa con
  // 12 / 00 / AM para que la hora siempre quede válida.
  function emitir() {
    if (hora.value === null && minuto.value === null && periodo.value === null) {
      emit("update:modelValue", null);
      return;
    }
    const h12 = hora.value ?? 12;
    const m = minuto.value ?? "00";
    const per = periodo.value ?? "AM";
  
    let h24 = h12 % 12;
    if (per === "PM") h24 += 12;
  
    emit("update:modelValue", `${String(h24).padStart(2, "0")}:${m}`);
  }
  </script>
  
  <style scoped>
  .time-select {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  /* Tamaños: ajusta estos tres números si los quieres aún más grandes */
  .time-hora    { width: 110px; }
  .time-minuto  { width: 110px; }
  .time-periodo { width: 118px; }
  
  .time-select :deep(.v-select__selection-text),
  .time-select :deep(.v-field__input) {
    font-size: 14px;
  }
  </style>