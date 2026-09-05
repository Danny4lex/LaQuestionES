<template>
  <div>
    <v-row class="align-center mt-8 mb-4">
      <v-col cols="auto">
        <h3 class="text-page-title">Plantillas de encuestas</h3>
      </v-col>
      <v-spacer />
      <v-col cols="auto">
        <v-btn color="primary" size="small" prepend-icon="mdi-plus" class="text-button" @click="abrirModalNueva">
          Nueva plantilla
        </v-btn>
      </v-col>
    </v-row>

    <!-- Mensaje de éxito -->
    <v-alert v-if="mensajeExito" type="success" variant="tonal" class="mb-4" dismissible>
      {{ mensajeExito }}
    </v-alert>

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
        v-for="plantilla in plantillas"
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

            <v-btn color="primary" size="small" class="text-button" @click="abrirModalUsar(plantilla)">
              Usar plantilla
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Modal para crear plantilla -->
    <v-dialog v-model="dialogNueva" max-width="500" persistent>
      <v-card>
        <v-card-title class="text-h6">Nueva plantilla</v-card-title>
        <v-card-text>
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
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" @click="cerrarModalNueva">
            Cancelar
          </v-btn>
          <v-btn color="primary" :loading="creando" @click="crearPlantilla">
            Guardar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Modal para convertir plantilla en encuesta -->
    <v-dialog v-model="dialogUsar" max-width="550" persistent>
      <v-card>
        <v-card-title class="text-h6">
          Convertir plantilla en encuesta
        </v-card-title>
        <v-card-text>
          <p class="text-body-small text-medium-emphasis mb-4">
            {{ plantillaSeleccionada?.name }}
          </p>

          <v-row dense>
            <v-col cols="12">
              <v-select
                v-model="usarForm.dependency_id"
                :items="dependencias"
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
              <v-select
                v-model="usarForm.status_id"
                :items="estados"
                item-title="name"
                item-value="id"
                label="Estado inicial"
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

          <v-alert v-if="dialogUsarError" type="error" variant="tonal" class="mt-3">
            {{ dialogUsarError }}
          </v-alert>
        </v-card-text>

        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" @click="cerrarModalUsar">
            Cancelar
          </v-btn>
          <v-btn color="primary" :loading="convirtiendo" @click="convertir">
            Convertir
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import backendApi from '@/services/backendApi';

const router = useRouter();

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

const usarForm = reactive({
  dependency_id: null,
  survey_category_id: null,
  type_id: null,
  status_id: null,
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
// Funciones modal usar (OPTIMIZADO: Lazy Loading)
// ====================
async function abrirModalUsar(plantilla) {
  plantillaSeleccionada.value = plantilla;
  dialogUsarError.value = null;
  usarForm.dependency_id = null;
  usarForm.survey_category_id = null;
  usarForm.type_id = null;
  usarForm.status_id = null;
  usarForm.start_date = null;
  usarForm.end_date = null;
  dialogUsar.value = true;

  // Carga secuencial bajo demanda solo al abrir el modal
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

  if (!usarForm.dependency_id || !usarForm.survey_category_id || !usarForm.type_id || !usarForm.status_id) {
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
        status_id: usarForm.status_id,
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
  try {
    // ÚNICAMENTE pedimos las plantillas al ingresar a la pantalla
    await cargarPlantillas();
  } catch (e) {
    // ya se manejó en cargarPlantillas
  } finally {
    loading.value = false;
  }
});
</script>