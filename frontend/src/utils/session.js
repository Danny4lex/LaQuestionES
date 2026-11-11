// Preferencias que NO se borran al cerrar sesión
const CLAVES_A_CONSERVAR = ['hero_styles'];

// Reemplaza a localStorage.clear(): limpia la sesión pero conserva las preferencias
export function limpiarSesion() {
  const conservar = {};
  CLAVES_A_CONSERVAR.forEach((clave) => {
    const valor = localStorage.getItem(clave);
    if (valor !== null) conservar[clave] = valor;
  });

  localStorage.clear();

  Object.entries(conservar).forEach(([clave, valor]) => {
    localStorage.setItem(clave, valor);
  });
}