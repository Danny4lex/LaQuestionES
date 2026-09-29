<template>
  <div class="loading-state" role="status" aria-live="polite">
    <div class="loading-ring">
      <span class="loading-ring-track" />
      <span class="loading-ring-arc" />
    </div>
    <p class="loading-text">
      {{ message }}<span class="dots"><span>.</span><span>.</span><span>.</span></span>
    </p>
  </div>
</template>

<script setup>
// Indicador de carga con el estilo del proyecto (azul #4880FF).
// Uso: <LoadingState message="Cargando encuestas" /> -> "Cargando encuestas..."
defineProps({
  message: { type: String, default: "Cargando" },
});
</script>

<style scoped>
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 14px;
  padding: 48px 16px;
}

.loading-ring {
  position: relative;
  width: 44px;
  height: 44px;
}

.loading-ring-track,
.loading-ring-arc {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  border: 4px solid #E8F0F8;
}

.loading-ring-arc {
  border-color: transparent;
  border-top-color: #4880FF;
  animation: loading-spin 0.9s linear infinite;
}

.loading-text {
  margin: 0;
  font-size: 0.95rem;
  font-weight: 500;
  color: #2D52A7;
}

.dots span {
  animation: loading-dot 1.2s infinite;
  opacity: 0.2;
}
.dots span:nth-child(2) { animation-delay: 0.2s; }
.dots span:nth-child(3) { animation-delay: 0.4s; }

@keyframes loading-spin {
  to { transform: rotate(360deg); }
}

@keyframes loading-dot {
  0%, 80%, 100% { opacity: 0.2; }
  40% { opacity: 1; }
}

@media (prefers-reduced-motion: reduce) {
  .loading-ring-arc { animation-duration: 2.4s; }
}
</style>
