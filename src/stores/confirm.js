import { defineStore } from "pinia";
import { ref } from "vue";

// Estado global del diálogo de confirmación (Sí/No) reutilizable en toda
// la app — mismo patrón que stores/alert.js. Se usa vía el composable
// useConfirm(), que además expone la función confirm() basada en
// Promise para poder hacer "await confirm('¿Seguro?')" desde cualquier
// vista.
export const useConfirmStore = defineStore("confirm", () => {
  const show = ref(false);
  const title = ref("¿Estás seguro?");
  const message = ref("");
  const confirmText = ref("Sí, eliminar");
  const cancelText = ref("No");
  const resolver = ref(null);

  return { show, title, message, confirmText, cancelText, resolver };
});
