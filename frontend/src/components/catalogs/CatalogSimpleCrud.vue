<!--
  CatalogSimpleCrud.vue
  ------------------------------------------------------------------
  Componente genérico y reutilizable para los catálogos paramétricos
  que solo tienen "name" + "description" (Categorías, Tipos, Estados,
  Roles). Cada pestaña de CatalogsPage.vue instancia este mismo
  componente cambiando únicamente sus props.

  No se reinventa nada por catálogo: se le pasa el endpoint y los
  textos, y el componente hace todo el ciclo listar/crear/editar/borrar
  contra ese endpoint, siguiendo el mismo patrón de backendApi + alert
  que ya usan SurveyListPage.vue / TemplateListPage.vue.
-->
<template>
    <div>
      <v-row class="align-center mb-4" dense>
        <v-col cols="12" sm="auto" class="flex-grow-1">
          <v-text-field
            v-model="busqueda"
            prepend-inner-icon="mdi-magnify"
            :label="`Buscar ${label.plural.toLowerCase()}`"
            variant="outlined"
            density="compact"
            hide-details
            clearable
          />
        </v-col>
        <v-spacer />
        <v-col cols="12" sm="auto">
          <v-btn
            color="primary"
            size="small"
            prepend-icon="mdi-plus"
            class="text-button"
            @click="abrirModalNuevo"
          >
            {{ label.newButton }}
          </v-btn>
        </v-col>
      </v-row>
  
      <v-data-table
        :headers="headers"
        :items="itemsFiltrados"
        :loading="cargando"
        item-value="id"
        class="rounded-lg"
        no-data-text="No hay registros todavía."
        loading-text="Cargando..."
      >
        <template #[`item.description`]="{ item }">
          <span class="text-medium-emphasis">
            {{ item.description || 'Sin descripción' }}
          </span>
        </template>
  
        <template #[`item.actions`]="{ item }">
          <v-icon size="20" class="me-2" icon="mdi-pencil" @click="abrirModalEditar(item)" />
          <v-icon size="20" icon="mdi-delete-outline" color="error" @click="abrirModalEliminar(item)" />
        </template>
      </v-data-table>
  
      <!-- Modal crear / editar -->
      <v-dialog v-model="dialogForm" max-width="480" persistent>
        <v-card>
          <v-card-title class="text-h6">
            {{ editando ? `Editar ${label.singular.toLowerCase()}` : label.newButton }}
          </v-card-title>
  
          <v-card-text>
            <v-row dense>
              <v-col cols="12">
                <v-text-field
                  v-model="form.name"
                  :label="label.nameField"
                  variant="outlined"
                  density="compact"
                  hide-details
                  :rules="[v => !!v?.trim() || 'El nombre es obligatorio']"
                />
              </v-col>
              <v-col cols="12">
                <v-textarea
                  v-model="form.description"
                  label="Descripción"
                  variant="outlined"
                  density="compact"
                  hide-details
                  rows="3"
                />
              </v-col>
            </v-row>
  
            <v-alert v-if="dialogFormError" type="error" variant="tonal" class="mt-3">
              {{ dialogFormError }}
            </v-alert>
          </v-card-text>
  
          <v-card-actions class="pa-4">
            <v-spacer />
            <v-btn variant="outlined" color="secondary" @click="cerrarModalForm">
              Cancelar
            </v-btn>
            <v-btn color="primary" :loading="guardando" @click="guardar">
              Guardar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
  
      <!-- Modal confirmar eliminación -->
      <v-dialog v-model="dialogEliminar" max-width="420" persistent>
        <v-card>
          <v-card-title class="text-h6">Eliminar {{ label.singular.toLowerCase() }}</v-card-title>
          <v-card-text>
            ¿Confirmas que deseas eliminar
            <strong>{{ itemAEliminar?.name }}</strong>? Esta acción no se puede deshacer.
  
            <v-alert v-if="dialogEliminarError" type="error" variant="tonal" class="mt-3">
              {{ dialogEliminarError }}
            </v-alert>
          </v-card-text>
          <v-card-actions class="pa-4">
            <v-spacer />
            <v-btn variant="outlined" color="secondary" @click="cerrarModalEliminar">
              Cancelar
            </v-btn>
            <v-btn color="error" :loading="eliminando" @click="confirmarEliminar">
              Eliminar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, computed, onMounted } from 'vue';
  import backendApi from '@/services/backendApi';
  import useAlert from '@/composables/useAlert';
  
  const props = defineProps({
    // Endpoint base del recurso, ej. '/survey-categories'
    endpoint: { type: String, required: true },
    // Textos que cambian por catálogo
    label: {
      type: Object,
      required: true,
      // { singular: 'Categoría', plural: 'Categorías', newButton: 'Nueva categoría', nameField: 'Nombre de la categoría' }
    },
  });
  
  const { alert } = useAlert();
  
  const items = ref([]);
  const cargando = ref(false);
  const busqueda = ref('');
  
  const headers = [
    { title: 'Nombre', key: 'name' },
    { title: 'Descripción', key: 'description' },
    { title: 'Acciones', key: 'actions', sortable: false, width: 110 },
  ];
  
  const itemsFiltrados = computed(() => {
    if (!busqueda.value) return items.value;
    const texto = busqueda.value.toLowerCase();
    return items.value.filter(
      (i) =>
        i.name?.toLowerCase().includes(texto) ||
        i.description?.toLowerCase().includes(texto)
    );
  });
  
  // ----- Modal crear/editar -----
  const dialogForm = ref(false);
  const dialogFormError = ref(null);
  const guardando = ref(false);
  const editando = ref(false);
  const editandoId = ref(null);
  
  const form = reactive({
    name: '',
    description: '',
  });
  
  function abrirModalNuevo() {
    editando.value = false;
    editandoId.value = null;
    form.name = '';
    form.description = '';
    dialogFormError.value = null;
    dialogForm.value = true;
  }
  
  function abrirModalEditar(item) {
    editando.value = true;
    editandoId.value = item.id;
    form.name = item.name;
    form.description = item.description || '';
    dialogFormError.value = null;
    dialogForm.value = true;
  }
  
  function cerrarModalForm() {
    dialogForm.value = false;
    dialogFormError.value = null;
  }
  
  async function guardar() {
    if (!form.name?.trim()) {
      dialogFormError.value = 'El nombre es obligatorio.';
      return;
    }
  
    guardando.value = true;
    dialogFormError.value = null;
  
    const payload = {
      name: form.name.trim(),
      description: form.description?.trim() || null,
    };
  
    try {
      if (editando.value) {
        await backendApi.put(`${props.endpoint}/${editandoId.value}`, payload);
        alert.success(`${props.label.singular} actualizada correctamente.`);
      } else {
        await backendApi.post(props.endpoint, payload);
        alert.success(`${props.label.singular} creada correctamente.`);
      }
  
      dialogForm.value = false;
      await cargarItems();
    } catch (e) {
      dialogFormError.value =
        e.response?.data?.message ||
        Object.values(e.response?.data?.errors || {})[0]?.[0] ||
        `No se pudo guardar la ${props.label.singular.toLowerCase()}.`;
    } finally {
      guardando.value = false;
    }
  }
  
  // ----- Modal eliminar -----
  const dialogEliminar = ref(false);
  const dialogEliminarError = ref(null);
  const eliminando = ref(false);
  const itemAEliminar = ref(null);
  
  function abrirModalEliminar(item) {
    itemAEliminar.value = item;
    dialogEliminarError.value = null;
    dialogEliminar.value = true;
  }
  
  function cerrarModalEliminar() {
    dialogEliminar.value = false;
    itemAEliminar.value = null;
    dialogEliminarError.value = null;
  }
  
  async function confirmarEliminar() {
    if (!itemAEliminar.value) return;
  
    eliminando.value = true;
    dialogEliminarError.value = null;
  
    try {
      await backendApi.delete(`${props.endpoint}/${itemAEliminar.value.id}`);
      alert.success(`${props.label.singular} eliminada correctamente.`);
      dialogEliminar.value = false;
      await cargarItems();
    } catch (e) {
      // El backend bloquea el borrado si hay dependencias activas
      // (ej. roles con usuarios asignados) y devuelve 422 con mensaje.
      dialogEliminarError.value =
        e.response?.data?.message ||
        `No se pudo eliminar la ${props.label.singular.toLowerCase()}.`;
    } finally {
      eliminando.value = false;
    }
  }
  
  // ----- Carga inicial -----
  async function cargarItems() {
    cargando.value = true;
    try {
      const response = await backendApi.get(props.endpoint);
      items.value = response.data;
    } catch (e) {
      alert.error(`No se pudieron cargar ${props.label.plural.toLowerCase()}.`);
    } finally {
      cargando.value = false;
    }
  }
  
  onMounted(cargarItems);
  
  defineExpose({ cargarItems });
  </script>
  