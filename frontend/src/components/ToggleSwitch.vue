<template>
  <label class="custom-switch-wrapper">
    <span class="custom-switch-label text-label">{{ label }}</span>
    <div class="switch-wrap">
      <input
        type="checkbox"
        :checked="modelValue"
        @change="$emit('update:modelValue', $event.target.checked)"
      />
      <div class="switch"></div>
    </div>
  </label>
</template>

<script setup>
// Interruptor con el mismo diseño del botón "Obligatoria" del editor.
defineProps({
  modelValue: { type: Boolean, default: false },
  label: { type: String, required: true },
});
defineEmits(["update:modelValue"]);
</script>

<style scoped>
.custom-switch-wrapper {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}

.custom-switch-label {
  font-size: 10px !important;
  font-weight: 600 !important;
  color: #333;
}

.switch-wrap {
  position: relative;
  cursor: pointer;
  background: #ffffff;
  padding: 3px;
  width: 33px;
  height: 20px;
  border-radius: 10px;
  box-sizing: border-box;
  border: 1px solid #235454;
  transition: background 0.2s;
  flex-shrink: 0;
}

.switch-wrap input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch {
  height: 100%;
  display: grid;
  grid-template-columns: 0fr 1fr 1fr;
  transition: grid-template-columns 0.2s;
}

.switch::after {
  content: '';
  border-radius: 50%;
  background: #235454;
  grid-column: 2;
  transition: background 0.2s;
}

.switch-wrap:has(input:checked) {
  background: #235454;
  border-color: #235454;
}

.switch-wrap:has(input:checked) .switch {
  grid-template-columns: 1fr 1fr 0fr;
}

.switch-wrap:has(input:checked) .switch::after {
  background: #ffffff;
}
</style>