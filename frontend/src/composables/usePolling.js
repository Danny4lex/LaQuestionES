import { onMounted, onBeforeUnmount } from 'vue';

// Ejecuta `tarea` cada `intervaloMs` mientras la pantalla esté abierta y visible.
export default function usePolling(tarea, intervaloMs = 10000) {
  let temporizador = null;
  let ejecutando = false;

  async function ejecutar() {
    if (ejecutando || document.hidden) return; // evita solapes y pestañas ocultas
    ejecutando = true;
    try {
      await tarea();
    } catch {
      /* silencioso: un fallo de red no debe romper la pantalla */
    } finally {
      ejecutando = false;
    }
  }

  function alVolverALaPestana() {
    if (!document.hidden) ejecutar();
  }

  function detener() {
    clearInterval(temporizador);
    temporizador = null;
    document.removeEventListener('visibilitychange', alVolverALaPestana);
  }

  function iniciar() {
    detener();
    temporizador = setInterval(ejecutar, intervaloMs);
    document.addEventListener('visibilitychange', alVolverALaPestana);
  }

  onMounted(iniciar);
  onBeforeUnmount(detener);

  return { iniciar, detener, ejecutar };
}