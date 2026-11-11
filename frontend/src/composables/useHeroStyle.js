import { reactive, watch } from 'vue';

const STORAGE_KEY = 'hero_styles';

export const HERO_VISTAS = [
  { key: 'dashboard',  label: 'Dashboard',               defecto: 'claro' },
  { key: 'encuestas',  label: 'Encuestas',               defecto: 'degradado' },
  { key: 'plantillas', label: 'Plantillas',              defecto: 'degradado' },
  { key: 'grupos',     label: 'Grupos de participantes', defecto: 'degradado' },
  { key: 'catalogos',  label: 'Catálogos',               defecto: 'degradado' },
];

export const HERO_ESTILOS = [
  { value: 'degradado', label: 'Azul degradado' },
  { value: 'claro',     label: 'Azul con degradado blanco' },
  { value: 'solido',    label: 'Color sólido azul' },
];

function leerGuardado() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
  } catch {
    return {};
  }
}

const guardado = leerGuardado();
const estilos = reactive(
  Object.fromEntries(
    HERO_VISTAS.map(v => [
      v.key,
      HERO_ESTILOS.some(e => e.value === guardado[v.key]) ? guardado[v.key] : v.defecto,
    ])
  )
);

watch(estilos, (val) => localStorage.setItem(STORAGE_KEY, JSON.stringify(val)), { deep: true });

export default function useHeroStyle() {
  const heroClase = (vista) => `hero--${estilos[vista] || 'degradado'}`;
  return { estilos, heroClase };
}