<!--
  OrganizationalUnitsTree.vue
  ------------------------------------------------------------------
  Pestaña "Dependencias" del catálogo. A diferencia de los otros 4
  catálogos, el organigrama tiene hasta 4 niveles de profundidad, así
  que en vez de una tabla plana se usa GET /organizational-units/tree
  (ya devuelve la jerarquía completa anidada en "children", ver
  OrganizationalUnitController@tree) y se renderiza con <v-treeview>.

  El CRUD (crear/editar/eliminar) sigue pegando contra el recurso
  plano /organizational-units — el árbol es solo la vista de lectura.
-->
<template>
    <div>
      <v-row class="align-center mb-4" dense>
        <v-col cols="12" sm="auto" class="flex-grow-1">
          <v-text-field
            v-model="busqueda"
            prepend-inner-icon="mdi-magnify"
            label="Buscar dependencia"
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
            @click="abrirModalNuevo(null)"
          >
            Nueva dependencia
          </v-btn>
        </v-col>
      </v-row>
  
      <div v-if="cargando" class="text-center py-8">
        <v-progress-circular indeterminate color="primary" />
        <p class="mt-3">Cargando organigrama...</p>
      </div>
  
      <v-card v-else variant="flat" class="rounded-lg section-card pa-2">
        <OrganizationalUnitNode
          v-for="raiz in arbolFiltrado"
          :key="raiz.id"
          :node="raiz"
          @nuevo="abrirModalNuevo"
          @editar="abrirModalEditar"
          @eliminar="abrirModalEliminar"
        />
  
        <p v-if="!arbolFiltrado.length" class="text-center text-medium-emphasis py-6">
          {{ arbol.length ? 'Ninguna dependencia coincide con la búsqueda.' : 'No hay dependencias registradas todavía.' }}
        </p>
      </v-card>
  
      <!-- Modal crear / editar -->
      <v-dialog v-model="dialogForm" max-width="480" persistent>
        <v-card>
          <v-card-title class="text-h6">
            {{ editando ? 'Editar dependencia' : 'Nueva dependencia' }}
          </v-card-title>
  
          <v-card-text>
            <v-row dense>
              <v-col cols="12">
                <v-text-field
                  v-model="form.name"
                  label="Nombre de la dependencia"
                  variant="outlined"
                  density="compact"
                  hide-details
                />
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="form.code"
                  label="Código"
                  variant="outlined"
                  density="compact"
                  hide-details
                />
              </v-col>
              <v-col cols="12">
                <v-textarea
                  v-model="form.description"
                  label="Descripción"
                  variant="outlined"
                  density="compact"
                  hide-details
                  rows="2"
                />
              </v-col>
              <v-col cols="12">
                <v-select
                  v-model="form.parent_id"
                  :items="opcionesPadre"
                  item-title="name"
                  item-value="id"
                  label="Dependencia superior (opcional)"
                  variant="outlined"
                  density="compact"
                  hide-details
                  clearable
                />
              </v-col>
              <v-col v-if="editando" cols="12">
                <v-switch
                  v-model="form.status"
                  color="primary"
                  label="Dependencia activa"
                  hide-details
                  inset
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
          <v-card-title class="text-h6">Eliminar dependencia</v-card-title>
          <v-card-text>
            ¿Confirmas que deseas eliminar
            <strong>{{ itemAEliminar?.name }}</strong>?
  
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
  import OrganizationalUnitNode from './OrganizationalUnitNode.vue';
  
  const { alert } = useAlert();
  
  const arbol = ref([]);
  const planaParaSelect = ref([]); // lista plana, solo para el <v-select> de "dependencia superior"
  const cargando = ref(false);
  const busqueda = ref('');
  
  // Filtra el árbol conservando una rama completa si el propio nodo o
  // alguno de sus descendientes coincide con la búsqueda (para no perder
  // el contexto jerárquico de un resultado profundo).
  function filtrarNodos(nodos, texto) {
    if (!texto) return nodos;
    const t = texto.toLowerCase();
  
    return nodos.reduce((acc, nodo) => {
      const hijosFiltrados = filtrarNodos(nodo.children || [], texto);
      const coincide = nodo.name?.toLowerCase().includes(t) || nodo.code?.toLowerCase().includes(t);
  
      if (coincide || hijosFiltrados.length) {
        acc.push({ ...nodo, children: hijosFiltrados });
      }
      return acc;
    }, []);
  }
  
  const arbolFiltrado = computed(() => filtrarNodos(arbol.value, busqueda.value));
  
  // v-treeview espera "children"; el endpoint /tree ya lo entrega así
  // (ver OrganizationalUnitController@tree, que renombra
  // children_recursive -> children antes de responder).
  async function cargarArbol() {
    cargando.value = true;
    try {
      const response = await backendApi.get('/organizational-units/tree');
      arbol.value = response.data;
      planaParaSelect.value = aplanar(response.data);
    } catch (e) {
      alert.error('No se pudo cargar el organigrama.');
    } finally {
      cargando.value = false;
    }
  }
  
  function aplanar(nodos, acc = []) {
    for (const nodo of nodos) {
      acc.push({ id: nodo.id, name: nodo.name });
      if (nodo.children?.length) aplanar(nodo.children, acc);
    }
    return acc;
  }
  
  // ----- Modal crear/editar -----
  const dialogForm = ref(false);
  const dialogFormError = ref(null);
  const guardando = ref(false);
  const editando = ref(false);
  const editandoId = ref(null);
  const opcionesPadre = ref([]);
  
  const form = reactive({
    name: '',
    code: '',
    description: '',
    parent_id: null,
    status: true,
  });
  
  function abrirModalNuevo(padre) {
    editando.value = false;
    editandoId.value = null;
    form.name = '';
    form.code = '';
    form.description = '';
    form.parent_id = padre?.id ?? null;
    form.status = true;
    opcionesPadre.value = planaParaSelect.value;
    dialogFormError.value = null;
    dialogForm.value = true;
  }
  
  function abrirModalEditar(item) {
    editando.value = true;
    editandoId.value = item.id;
    form.name = item.name;
    form.code = item.code;
    form.description = item.description || '';
    form.parent_id = item.parent_id;
    form.status = item.status !== false;
    // Una dependencia no puede ser padre de sí misma.
    opcionesPadre.value = planaParaSelect.value.filter((o) => o.id !== item.id);
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
    if (!editando.value && !form.code?.trim()) {
      dialogFormError.value = 'El código es obligatorio.';
      return;
    }
  
    guardando.value = true;
    dialogFormError.value = null;
  
    try {
      if (editando.value) {
        await backendApi.put(`/organizational-units/${editandoId.value}`, {
          name: form.name.trim(),
          code: form.code?.trim(),
          description: form.description?.trim() || null,
          parent_id: form.parent_id || null,
          status: form.status,
        });
        alert.success('Dependencia actualizada correctamente.');
      } else {
        await backendApi.post('/organizational-units', {
          name: form.name.trim(),
          code: form.code.trim(),
          description: form.description?.trim() || null,
          parent_id: form.parent_id || null,
        });
        alert.success('Dependencia creada correctamente.');
      }
  
      dialogForm.value = false;
      await cargarArbol();
    } catch (e) {
      dialogFormError.value =
        e.response?.data?.message ||
        Object.values(e.response?.data?.errors || {})[0]?.[0] ||
        'No se pudo guardar la dependencia.';
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
      await backendApi.delete(`/organizational-units/${itemAEliminar.value.id}`);
      alert.success('Dependencia eliminada correctamente.');
      dialogEliminar.value = false;
      await cargarArbol();
    } catch (e) {
      // El backend bloquea el borrado si tiene dependencias hijas activas
      // (ver OrganizationalUnitController@destroy).
      dialogEliminarError.value =
        e.response?.data?.message || 'No se pudo eliminar la dependencia.';
    } finally {
      eliminando.value = false;
    }
  }
  
  onMounted(cargarArbol);
  
  defineExpose({ cargarArbol });
  </script>
  