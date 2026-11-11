<template>
  <div class="plantillas-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero" :class="heroClase('plantillas')">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <div class="hero__eyebrow">Plantillas</div>
          <h1 class="hero__title">Plantillas de encuestas</h1>
          <p class="hero__sub">Reutiliza estructuras de encuestas ya creadas</p>
        </div>

        <div class="hero__actions">
          <v-btn
            color="white"
            variant="flat"
            prepend-icon="mdi-plus"
            class="text-button hero__cta"
            @click="abrirModalNueva"
          >
            Nueva plantilla
          </v-btn>
        </div>
      </div>
    </div>

    <!-- Mensaje de éxito -->
    <v-alert v-if="mensajeExito" type="success" variant="tonal" class="mb-4" dismissible>
      {{ mensajeExito }}
    </v-alert>

    <!-- Filtros -->
    <v-row dense class="mb-2">
      <v-col cols="12" sm="4">
        <v-select
          v-model="filtroCategoria"
          :items="categorias"
          item-title="name"
          item-value="id"
          label="Filtrar por categoría"
          variant="outlined"
          density="compact"
          clearable
          hide-details
        />
      </v-col>
    </v-row>

    <!-- Cargando -->
    <div v-if="loading" class="text-center py-8">
      <v-progress-circular indeterminate color="primary" />
      <p class="mt-3">Cargando plantillas...</p>
    </div>

    <!-- Error -->
    <div v-else-if="error" class="text-center py-8">
      <v-icon size="48" color="error">mdi-alert-circle-outline</v-icon>
      <p class="mt-3">{{ error }}</p>
    </div>

    <!-- Listado -->
    <v-row v-else dense>
      <v-col
        v-for="plantilla in plantillasFiltradas"
        :key="plantilla.id"
        cols="12"
        sm="6"
        md="4"
      >
        <v-card class="rounded-lg" variant="flat">
          <v-card-text>
            <v-card-title class="px-0 text-subsection-title">
              {{ plantilla.name }}
            </v-card-title>

            <p class="text-body-small text-medium-emphasis mb-3">
              {{ plantilla.description || 'Sin descripción' }}
            </p>

            <div class="d-flex flex-wrap" style="gap: 12px;">
              <v-btn
                variant="outlined"
                color="primary"
                size="small"
                class="text-button px-3"
                title="Vista previa"
                aria-label="Vista previa"
                @click="abrirPreview(plantilla)"
              >
                <v-icon size="18">mdi-eye-outline</v-icon>
              </v-btn>
              <v-btn color="primary" size="small" class="text-button" @click="abrirModalUsar(plantilla)">
                Usar plantilla
              </v-btn>
            </div>


          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Modal para crear plantilla -->
    <v-dialog v-model="dialogNueva" max-width="500" persistent>
      <v-card class="dialog-card">
        <v-card-title class="dialog-header">
          <div class="dialog-title">Nueva plantilla</div>
          <div class="dialog-subtitle">Crea una plantilla reutilizable</div>
        </v-card-title>
        <v-card-text class="dialog-body">
          <v-row dense>
            <v-col cols="12">
              <v-text-field
                v-model="nuevaForm.name"
                label="Nombre de la plantilla"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>
            <v-col cols="12">
              <v-textarea
                v-model="nuevaForm.description"
                label="Descripción"
                variant="outlined"
                density="compact"
                hide-details
                rows="3"
              />
            </v-col>
            <v-col cols="12">
              <v-select
                v-model="nuevaForm.survey_category_id"
                :items="categorias"
                item-title="name"
                item-value="id"
                label="Categoría (opcional)"
                variant="outlined"
                density="compact"
                clearable
                hide-details
              />
            </v-col>
            <v-col cols="12">
              <v-checkbox
                v-model="nuevaForm.is_public"
                label="Plantilla pública"
                hide-details
              />
            </v-col>
          </v-row>

          <v-alert v-if="dialogNuevaError" type="error" variant="tonal" class="mt-3">
            {{ dialogNuevaError }}
          </v-alert>
        </v-card-text>
        <v-card-actions class="dialog-actions">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="cerrarModalNueva">
            Cancelar
          </v-btn>
          <v-btn color="primary" class="text-button" :loading="creando" @click="crearPlantilla">
            Guardar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Modal para convertir plantilla en encuesta -->
    <v-dialog v-model="dialogUsar" max-width="550" persistent>
      <v-card class="dialog-card">
        <v-card-title class="dialog-header">
          <div class="dialog-title">Convertir plantilla en encuesta</div>
          <div class="dialog-subtitle">{{ plantillaSeleccionada?.name }}</div>
        </v-card-title>
        <v-card-text class="dialog-body">
          <v-row dense>
            <v-col cols="12">
              <v-select
                v-model="usarForm.dependency_id"
                :items="hasPermission('surveys.viewAll') ? dependencias : dependencias.filter(d => d.id === miDependenciaId)"
                :disabled="!hasPermission('surveys.viewAll')"
                item-title="name"
                item-value="id"
                label="Dependencia responsable"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>

            <v-col cols="12" sm="6">
              <v-select
                v-model="usarForm.survey_category_id"
                :items="categorias"
                item-title="name"
                item-value="id"
                label="Categoría"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>

            <v-col cols="12" sm="6">
              <v-select
                v-model="usarForm.type_id"
                :items="tipos"
                item-title="name"
                item-value="id"
                label="Tipo de acceso"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>

            <v-col cols="12" sm="6">
              <v-text-field
                v-model="usarForm.start_date"
                type="date"
                label="Fecha de inicio"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>

            <v-col cols="12" sm="6">
              <v-text-field
                v-model="usarForm.end_date"
                type="date"
                label="Fecha de fin"
                variant="outlined"
                density="compact"
                hide-details
              />
            </v-col>
          </v-row>
          <p class="text-body-small text-medium-emphasis mt-3 mb-0">
            La encuesta se creará en estado <strong>Borrador</strong>.
          </p>
          <v-alert v-if="dialogUsarError" type="error" variant="tonal" class="mt-3">
            {{ dialogUsarError }}
          </v-alert>
        </v-card-text>

        <v-card-actions class="dialog-actions">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="cerrarModalUsar">
            Cancelar
          </v-btn>
          <v-btn color="primary" class="text-button" :loading="convirtiendo" @click="convertir">
            Convertir
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Modal: vista previa de la plantilla -->
    <v-dialog v-model="dialogPreview" max-width="760" scrollable>
      <v-card class="preview-card" variant="flat">
        <div class="preview-header">
          <h2 class="preview-title">{{ plantillaPreview?.name }}</h2>
          <p v-if="plantillaPreview?.description" class="preview-description">
            {{ plantillaPreview.description }}
          </p>
        </div>

        <v-card-text class="preview-body">
          <div v-if="cargandoPreview" class="text-center py-6">
            <v-progress-circular indeterminate color="primary" />
          </div>

          <v-alert v-else-if="errorPreview" type="error" variant="tonal" density="compact">
            {{ errorPreview }}
          </v-alert>

          <div v-else-if="!seccionesPreview.length" class="text-center py-4 text-medium-emphasis">
            Esta plantilla todavía no tiene preguntas.
          </div>

          <div v-else>
            <div v-for="(seccion, sIndex) in seccionesPreview" :key="sIndex" class="preview-section">
              <h3 class="preview-section-title">{{ seccion.nombre }}</h3>

              <div v-for="pregunta in seccion.preguntas" :key="pregunta.id" class="preview-question">
                <p class="preview-question-statement">
                  {{ pregunta.statement }}
                  <span v-if="pregunta.is_mandatory" class="preview-mandatory">*</span>
                </p>

                <ul v-if="['opcion_unica', 'opcion_multiple'].includes(pregunta.type)" class="preview-options">
                  <li v-for="op in (pregunta.options || [])" :key="op.id">
                    <v-icon size="small" class="me-1">
                      {{ pregunta.type === 'opcion_unica' ? 'mdi-radiobox-blank' : 'mdi-checkbox-blank-outline' }}
                    </v-icon>
                    {{ op.option_text }}
                  </li>
                </ul>

                <div v-else-if="pregunta.type === 'escala'" class="preview-scale">
                  <span v-for="n in 5" :key="n" class="preview-scale-item">{{ n }}</span>
                </div>

                <p v-else class="preview-field-hint">
                  {{ TIPOS_PREGUNTA[pregunta.type] || pregunta.type }}
                </p>
              </div>
            </div>
          </div>
        </v-card-text>

        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" @click="dialogPreview = false">Cerrar</v-btn>
          <v-btn color="primary" :disabled="cargandoPreview" @click="usarDesdePreview">Usar plantilla</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import backendApi from '@/services/backendApi';
import useAuth from '@/composables/useAuth';
import useHeroStyle from '@/composables/useHeroStyle';

const router = useRouter();
const { hasPermission } = useAuth();
const { heroClase } = useHeroStyle();
const miDependenciaId =
  JSON.parse(localStorage.getItem('survey_profile') || 'null')?.dependency?.id || null;

const plantillas = ref([]);
const loading = ref(true);
const error = ref(null);
const mensajeExito = ref(null);

// ----- Modal nueva plantilla -----
const dialogNueva = ref(false);
const dialogNuevaError = ref(null);
const creando = ref(false);

const nuevaForm = reactive({
  name: '',
  description: '',
  is_public: true,
  survey_category_id: null,
});

// ----- Modal usar plantilla -----
const dialogUsar = ref(false);
const dialogUsarError = ref(null);
const convirtiendo = ref(false);
const plantillaSeleccionada = ref(null);

const dependencias = ref([]);
const categorias = ref([]);
const tipos = ref([]);
const estados = ref([]);


const filtroCategoria = ref(null);

const plantillasFiltradas = computed(() =>
  plantillas.value.filter(p =>
    !filtroCategoria.value || p.survey_category_id === filtroCategoria.value
  )
);

const usarForm = reactive({
  dependency_id: null,
  survey_category_id: null,
  type_id: null,
  start_date: null,
  end_date: null,
});

// ====================
// Funciones modal nueva
// ====================
function abrirModalNueva() {
  dialogNuevaError.value = null;
  nuevaForm.name = '';
  nuevaForm.description = '';
  nuevaForm.is_public = true;
  nuevaForm.survey_category_id = null;
  dialogNueva.value = true;
}

function cerrarModalNueva() {
  dialogNueva.value = false;
  dialogNuevaError.value = null;
}

async function crearPlantilla() {
  if (!nuevaForm.name.trim()) {
    dialogNuevaError.value = 'El nombre es obligatorio.';
    return;
  }

  creando.value = true;
  dialogNuevaError.value = null;

  try {
    await backendApi.post('/templates', {
      name: nuevaForm.name,
      description: nuevaForm.description,
      is_public: nuevaForm.is_public,
      survey_category_id: nuevaForm.survey_category_id,
    });

    dialogNueva.value = false;
    mensajeExito.value = 'Plantilla creada correctamente.';
    await cargarPlantillas();
  } catch (e) {
    dialogNuevaError.value =
      e.response?.data?.message || 'No se pudo crear la plantilla.';
  } finally {
    creando.value = false;
  }
}

// ====================
// Vista previa de plantilla
// ====================
const dialogPreview = ref(false);
const cargandoPreview = ref(false);
const errorPreview = ref(null);
const plantillaPreview = ref(null);
const seccionesPreview = ref([]);

const TIPOS_PREGUNTA = {
  texto: 'Respuesta de texto',
  opcion_unica: 'Opción única',
  opcion_multiple: 'Opción múltiple',
  escala: 'Escala',
  si_no: 'Sí / No',
  casilla: 'Casilla',
};

async function abrirPreview(plantilla) {
  plantillaPreview.value = plantilla;
  seccionesPreview.value = [];
  errorPreview.value = null;
  dialogPreview.value = true;
  cargandoPreview.value = true;
  try {
    const { data } = await backendApi.get(`/templates/${plantilla.id}`);
    const preguntas = [...(data.questions || [])]
      .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0));

    // Agrupa por el nombre de sección guardado en la plantilla
    const grupos = new Map();
    for (const p of preguntas) {
      const nombre = p.template_section_name || 'General';
      if (!grupos.has(nombre)) grupos.set(nombre, []);
      grupos.get(nombre).push(p);
    }
    seccionesPreview.value = [...grupos].map(([nombre, items]) => ({ nombre, preguntas: items }));
  } catch (e) {
    errorPreview.value = e.response?.data?.message || 'No se pudo cargar la vista previa.';
  } finally {
    cargandoPreview.value = false;
  }
}

function usarDesdePreview() {
  const plantilla = plantillaPreview.value;
  dialogPreview.value = false;
  abrirModalUsar(plantilla);
}

// ====================
// Funciones modal usar (OPTIMIZADO: Lazy Loading)
// ====================
async function abrirModalUsar(plantilla) {
  plantillaSeleccionada.value = plantilla;
  dialogUsarError.value = null;
  usarForm.dependency_id = hasPermission('surveys.viewAll') ? null : miDependenciaId;
  usarForm.survey_category_id = null;
  usarForm.type_id = null;
  
  usarForm.start_date = null;
  usarForm.end_date = null;
  dialogUsar.value = true;

  if (dependencias.value.length === 0) {
    await cargarCatalogos();
  }
}

function cerrarModalUsar() {
  dialogUsar.value = false;
  plantillaSeleccionada.value = null;
  dialogUsarError.value = null;
}

async function cargarCatalogos() {
  try {
    const depRes = await backendApi.get('/organizational-units');
    dependencias.value = depRes.data;

    const catRes = await backendApi.get('/survey-categories');
    categorias.value = catRes.data;

    const tipoRes = await backendApi.get('/types');
    tipos.value = tipoRes.data;

    const estRes = await backendApi.get('/statuses');
    estados.value = estRes.data;
  } catch (e) {
    dialogUsarError.value = 'No se pudieron cargar los catálogos del formulario.';
  }
}

async function convertir() {
  if (!plantillaSeleccionada.value) return;

  if (!usarForm.dependency_id || !usarForm.survey_category_id || !usarForm.type_id) {
    dialogUsarError.value = 'Todos los campos obligatorios deben estar completos.';
    return;
  }

  convirtiendo.value = true;
  dialogUsarError.value = null;

  try {
    const response = await backendApi.post(
      `/templates/${plantillaSeleccionada.value.id}/convert`,
      {
        dependency_id: usarForm.dependency_id,
        survey_category_id: usarForm.survey_category_id,
        type_id: usarForm.type_id,
        start_date: usarForm.start_date || null,
        end_date: usarForm.end_date || null,
      }
    );

    dialogUsar.value = false;
    router.push(`/surveys/${response.data.survey_id}/edit`);
  } catch (e) {
    dialogUsarError.value =
      e.response?.data?.message || 'No se pudo convertir la plantilla.';
  } finally {
    convirtiendo.value = false;
  }
}

// ====================
// Carga inicial
// ====================
async function cargarPlantillas() {
  try {
    const response = await backendApi.get('/templates');
    plantillas.value = response.data;
  } catch (e) {
    error.value = 'No se pudieron cargar las plantillas.';
  }
}

onMounted(async () => {
  cargarCatalogos(); // los filtros necesitan dependencias y categorías desde el inicio
  try {
    await cargarPlantillas();
  } catch (e) {
    // ya se manejó en cargarPlantillas
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.plantillas-page {
  padding-bottom: 24px;
}

/* ============================================= */
/* HERO HEADER — estilo “boletín” azul oscuro    */
/* ============================================= */
.hero {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  margin: 32px 0 20px;
  background: linear-gradient(135deg, #1C8686 0%, #1DAFAF 100%) !important;
  color: #ffffff;
}

.hero__bg {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 90% -20%, rgba(255, 255, 255, 0.10), transparent 45%),
    radial-gradient(circle at -10% 120%, rgba(255, 255, 255, 0.06), transparent 40%);
  pointer-events: none;
}

.hero__content {
  position: relative;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-end;
  gap: 16px;
  padding: 28px 28px 24px;
}

.hero__text { min-width: 0; }

.hero__eyebrow {
  font-family: Poppins;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  opacity: 0.75;
  margin-bottom: 8px;
}

.hero__title {
  font-family: Poppins;
  font-weight: 700;
  font-size: 30px;
  line-height: 1.2;
  letter-spacing: 0;
  margin: 0 0 6px 0;
  color: #ffffff;
}

.hero__sub {
  font-size: 12px;
  font-weight: 300;
  opacity: 0.85;
  margin: 0;
  line-height: 1.4;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.hero__cta {
  color: #235454 !important;
}

@media (max-width: 600px) {
  .hero__content {
    padding: 22px 20px 20px;
  }
  .hero__title {
    font-size: 24px;
  }
}

/* ---------- Vista previa de plantilla ---------- */
.preview-header {
  background: linear-gradient(135deg, #1C8686 0%, #1DAFAF 100%) !important;
  color: #ffffff;
  padding: 24px 28px;
}
.preview-title { font-family: Poppins; font-size: 20px; font-weight: 600; margin: 0; }
.preview-description { margin: 8px 0 0; opacity: 0.85; font-size: 14px; }
.preview-body { background: #F4F6FD; padding: 20px 28px; }
.preview-section { background: #ffffff; border-radius: 7px; padding: 16px; margin-bottom: 12px; }
.preview-section-title { color: #1C8686; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
.preview-question { padding: 10px 0; border-top: 1px solid #D2D9DD; }
.preview-section-title + .preview-question { border-top: none; }
.preview-question-statement { font-weight: 500; color: #313845; margin: 0 0 6px; }
.preview-mandatory { color: #E42716; margin-left: 4px; }
.preview-options { list-style: none; padding: 0; margin: 0; color: #374957; }
.preview-options li { padding: 2px 0; }
.preview-scale { display: flex; gap: 8px; }
.preview-scale-item {
  width: 34px; height: 34px;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid #D2D9DD; border-radius: 6px; color: #374957;
}
.preview-field-hint { color: #7a8794; font-size: 13px; font-style: italic; margin: 0; }

/* ============================================= */
/* DIÁLOGOS — estilo unificado con el hero       */
/* ============================================= */
.dialog-card {
  border-radius: 12px !important;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(35, 84, 84, 0.22) !important;
}

.dialog-card :deep(.v-card-title.dialog-header) {
  background: linear-gradient(135deg, #1C8686 0%, #1DAFAF 100%) !important;
  padding: 20px 24px !important;
  display: block !important;
  color: #ffffff !important;
  font-size: inherit !important;
  font-weight: inherit !important;
  line-height: inherit !important;
}

.dialog-title {
  font-family: 'Poppins', sans-serif;
  font-weight: 700;
  font-size: 18px;
  line-height: 1.2;
  color: #ffffff;
  margin: 0;
}

.dialog-subtitle {
  font-family: 'Poppins', sans-serif;
  font-weight: 300;
  font-size: 12px;
  line-height: 1.4;
  color: #ffffff;
  opacity: 0.85;
  margin: 4px 0 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dialog-card :deep(.v-card-text.dialog-body) {
  background-color: #ffffff;
  padding: 20px 24px !important;
}

.dialog-card :deep(.v-card-actions.dialog-actions) {
  padding: 14px 24px 18px !important;
  background-color: #ffffff;
  border-top: 1px solid #E3EBF5;
}
</style>