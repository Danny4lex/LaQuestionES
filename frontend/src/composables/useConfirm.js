import { storeToRefs } from "pinia";
import { useConfirmStore } from "../stores/confirm";

// Uso:
//   const { confirm } = useConfirm();
//   const ok = await confirm('¿Eliminar la encuesta "X"? Esta acción no se puede deshacer.');
//   if (!ok) return;
//
// Devuelve una Promise<boolean> — true si el usuario presionó "Sí",
// false si presionó "No" o cerró el diálogo de cualquier otra forma.
const useConfirm = () => {
  const confirmStore = useConfirmStore();
  const { show, title, message, confirmText, cancelText, resolver } = storeToRefs(confirmStore);

  function confirm(msg, options = {}) {
    title.value = options.title || "¿Estás seguro?";
    message.value = msg;
    confirmText.value = options.confirmText || "Sí, eliminar";
    cancelText.value = options.cancelText || "No";
    show.value = true;

    return new Promise((resolve) => {
      resolver.value = resolve;
    });
  }

  function resolve(valor) {
    show.value = false;
    if (resolver.value) {
      resolver.value(valor);
      resolver.value = null;
    }
  }

  return { show, title, message, confirmText, cancelText, confirm, resolve };
};

export default useConfirm;
