<template>
  <div class="participants-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <div class="hero__eyebrow">Participantes</div>
          <h1 class="hero__title">Gestión de Participantes</h1>
          <p class="hero__sub">
            {{ hasPermission('surveys.viewAll') ? 'Todas las dependencias' : `Dependencia: ${miDependencia || 'Sin asignar'}` }}
          </p>
        </div>

        <div class="hero__actions">
          <v-btn
            color="white"
            variant="flat"
            prepend-icon="mdi-plus"
            class="text-button hero__cta"
            @click="abrirNuevoGrupo"
          >
            Nuevo grupo
          </v-btn>
        </div>
      </div>
    </div>

    <v-row v-if="hasPermission('surveys.viewAll')" dense class="mb-2">
      <v-col cols="12" sm="4">
        <v-select
          v-model="filtroDependencia"
          :items="opcionesDependencia"
          item-title="name"
          item-value="id"
          label="Filtrar por dependencia"
          variant="outlined"
          density="compact"
          clearable
          hide-details
          @update:model-value="cargarGrupos"
        />
      </v-col>
    </v-row>

    <v-card class="rounded-lg" variant="flat">
      <v-table>
        <thead>
          <tr>
            <th class="text-label">Nombre</th>
            <th class="text-label">Dependencia</th>
            <th class="text-label">Participantes</th>
            <th class="text-label">Creado</th>
            <th class="text-label">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="cargando">
            <td colspan="5" class="text-center py-6">
              <v-progress-circular indeterminate color="primary" size="24" />
            </td>
          </tr>
          <tr v-else-if="!grupos.length">
            <td colspan="5" class="text-center text-medium-emphasis py-6">
              No hay grupos registrados todavía.
            </td>
          </tr>
          <tr v-for="grupo in grupos" :key="grupo.group_id">
            <td class="text-body-small">{{ grupo.name }}</td>
            <td class="text-body-small">{{ grupo.department?.name || '—' }}</td>
            <td class="text-body-small">{{ grupo.group_participants_count }}</td>
            <td class="text-body-small">{{ formatearFecha(grupo.created_at) }}</td>
            <td>
              <v-btn icon size="x-small" variant="text" class="me-1" title="Gestionar participantes" @click="abrirParticipantes(grupo)">
                <v-icon>mdi-account-multiple-outline</v-icon>
              </v-btn>
              <v-btn icon size="x-small" variant="text" class="me-1" title="Editar" @click="abrirEditarGrupo(grupo)">
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
              <v-btn icon size="x-small" variant="text" color="error" title="Eliminar" @click="confirmarEliminar(grupo)">
                <v-icon>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <!-- Diálogo: crear / editar grupo -->
    <v-dialog v-model="dialogGrupo" max-width="480">
      <v-card>
        <v-card-title class="text-h6">{{ grupoEditando ? 'Editar grupo' : 'Nuevo grupo' }}</v-card-title>
        <v-card-text>
          <v-text-field v-model="formGrupo.name" label="Nombre del grupo" variant="outlined" density="compact" class="mb-2" />
          <v-textarea v-model="formGrupo.description" label="Descripción" variant="outlined" density="compact" rows="2" class="mb-2" />
          <v-select
            v-if="!grupoEditando && hasPermission('surveys.viewAll')"
            v-model="formGrupo.dependency_id"
            :items="opcionesDependencia"
            item-title="name"
            item-value="id"
            label="Dependencia"
            variant="outlined"
            density="compact"
          />
          <v-text-field
            v-else-if="!grupoEditando"
            :model-value="miDependencia || 'Sin asignar'"
            label="Dependencia"
            variant="outlined"
            density="compact"
            readonly
          />
          <v-alert v-if="errorGrupo" type="error" variant="tonal" density="compact">{{ errorGrupo }}</v-alert>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogGrupo = false">Cancelar</v-btn>
          <v-btn color="primary" class="text-button" :loading="guardandoGrupo" @click="guardarGrupo">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo: confirmar eliminación -->
    <v-dialog v-model="dialogEliminar" max-width="420">
      <v-card>
        <v-card-title class="text-h6">Eliminar grupo</v-card-title>
        <v-card-text>
          ¿Seguro que deseas eliminar el grupo "{{ grupoAEliminar?.name }}"? Esta acción no se puede deshacer.
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogEliminar = false">Cancelar</v-btn>
          <v-btn color="error" class="text-button" :loading="eliminando" @click="eliminarGrupo">Eliminar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo: gestionar participantes del grupo -->
    <v-dialog v-model="dialogParticipantes" max-width="560">
      <v-card>
        <v-card-title class="text-h6">
          Participantes
          <div class="text-body-small text-medium-emphasis font-weight-regular">{{ grupoSeleccionado?.name }}</div>
        </v-card-title>
        <v-card-text>
          <div class="d-flex ga-2 mb-3">
            <v-text-field
              v-model="nuevoParticipanteEmail"
              label="Correo del participante"
              variant="outlined"
              density="compact"
              hide-details
              type="email"
              @keyup.enter="agregarParticipante"
            />
            <v-btn color="primary" class="text-button" :loading="agregandoParticipante" @click="agregarParticipante">
              Agregar
            </v-btn>
          </div>
          <v-alert v-if="errorParticipante" type="error" variant="tonal" density="compact" class="mb-3">
            {{ errorParticipante }}
          </v-alert>

          <div v-if="cargandoParticipantes" class="text-center py-4">
            <v-progress-circular indeterminate color="primary" size="24" />
          </div>
          <v-table v-else density="compact">
            <tbody>
              <tr v-if="!participantesGrupo.length">
                <td class="text-center text-medium-emphasis py-4">Este grupo todavía no tiene participantes.</td>
              </tr>
              <tr v-for="p in participantesGrupo" :key="p.id">
                <td class="text-body-small">{{ p.user?.name || p.external_email || `Usuario #${p.user_id}` }}</td>
                <td class="text-right">
                  <v-btn icon size="x-small" variant="text" color="error" title="Quitar del grupo" @click="quitarParticipante(p)">
                    <v-icon>mdi-close</v-icon>
                  </v-btn>
                </td>
              </tr>
            </tbody>
          </v-table>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogParticipantes = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import backendApi from '@/services/backendApi';
import useAuth from '@/composables/useAuth';
import useAlert from '@/composables/useAlert';

const { hasPermission } = useAuth();
const { alert } = useAlert();

const miDependencia = JSON.parse(localStorage.getItem('survey_profile') || 'null')?.dependency?.name || null;
const miDependenciaId = JSON.parse(localStorage.getItem('survey_profile') || 'null')?.dependency?.id || null;

const grupos = ref([]);
const cargando = ref(false);
const opcionesDependencia = ref([]);
const filtroDependencia = ref(null);

function formatearFecha(fecha) {
  if (!fecha) return '—';
  return new Date(fecha).toLocaleDateString('es-SV');
}

async function cargarDependencias() {
  if (!hasPermission('surveys.viewAll')) return;
  try {
    const { data } = await backendApi.get('/organizational-units');
    opcionesDependencia.value = data;
  } catch (e) {
    console.error('Error cargando dependencias:', e);
  }
}

async function cargarGrupos() {
  cargando.value = true;
  try {
    const { data } = await backendApi.get('/groups', {
      params: filtroDependencia.value ? { dependency_id: filtroDependencia.value } : {},
    });
    grupos.value = data;
  } catch (e) {
    alert.error('No se pudieron cargar los grupos.');
  } finally {
    cargando.value = false;
  }
}

// =====================================================================
// CREAR / EDITAR GRUPO
// =====================================================================
const dialogGrupo = ref(false);
const grupoEditando = ref(null);
const formGrupo = ref({ name: '', description: '', dependency_id: null });
const guardandoGrupo = ref(false);
const errorGrupo = ref(null);

function abrirNuevoGrupo() {
  grupoEditando.value = null;
  formGrupo.value = {
    name: '',
    description: '',
    dependency_id: hasPermission('surveys.viewAll') ? null : miDependenciaId,
  };
  errorGrupo.value = null;
  dialogGrupo.value = true;
}

function abrirEditarGrupo(grupo) {
  grupoEditando.value = grupo;
  formGrupo.value = { name: grupo.name, description: grupo.description, dependency_id: grupo.dependency_id };
  errorGrupo.value = null;
  dialogGrupo.value = true;
}

async function guardarGrupo() {
  errorGrupo.value = null;
  if (!formGrupo.value.name?.trim()) {
    errorGrupo.value = 'El nombre es obligatorio.';
    return;
  }
  if (!grupoEditando.value && !formGrupo.value.dependency_id) {
    errorGrupo.value = 'Selecciona una dependencia.';
    return;
  }

  guardandoGrupo.value = true;
  try {
    if (grupoEditando.value) {
      await backendApi.put(`/groups/${grupoEditando.value.group_id}`, {
        name: formGrupo.value.name,
        description: formGrupo.value.description,
      });
      alert.success('Grupo actualizado.');
    } else {
      await backendApi.post('/groups', formGrupo.value);
      alert.success('Grupo creado.');
    }
    dialogGrupo.value = false;
    await cargarGrupos();
  } catch (e) {
    errorGrupo.value = e.response?.data?.message || 'No se pudo guardar el grupo.';
  } finally {
    guardandoGrupo.value = false;
  }
}

// =====================================================================
// ELIMINAR GRUPO
// =====================================================================
const dialogEliminar = ref(false);
const grupoAEliminar = ref(null);
const eliminando = ref(false);

function confirmarEliminar(grupo) {
  grupoAEliminar.value = grupo;
  dialogEliminar.value = true;
}

async function eliminarGrupo() {
  eliminando.value = true;
  try {
    await backendApi.delete(`/groups/${grupoAEliminar.value.group_id}`);
    alert.success('Grupo eliminado.');
    dialogEliminar.value = false;
    await cargarGrupos();
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo eliminar el grupo.');
  } finally {
    eliminando.value = false;
  }
}

// =====================================================================
// PARTICIPANTES DEL GRUPO
// =====================================================================
const dialogParticipantes = ref(false);
const grupoSeleccionado = ref(null);
const participantesGrupo = ref([]);
const cargandoParticipantes = ref(false);
const nuevoParticipanteEmail = ref('');
const agregandoParticipante = ref(false);
const errorParticipante = ref(null);

async function abrirParticipantes(grupo) {
  grupoSeleccionado.value = grupo;
  nuevoParticipanteEmail.value = '';
  errorParticipante.value = null;
  dialogParticipantes.value = true;
  await cargarParticipantesGrupo();
}

async function cargarParticipantesGrupo() {
  cargandoParticipantes.value = true;
  try {
    const { data } = await backendApi.get(`/groups/${grupoSeleccionado.value.group_id}`);
    participantesGrupo.value = data.group_participants || [];
  } catch (e) {
    alert.error('No se pudieron cargar los participantes del grupo.');
  } finally {
    cargandoParticipantes.value = false;
  }
}

async function agregarParticipante() {
  errorParticipante.value = null;
  if (!nuevoParticipanteEmail.value?.trim()) {
    errorParticipante.value = 'Ingresa un correo.';
    return;
  }
  agregandoParticipante.value = true;
  try {
    await backendApi.post(`/groups/${grupoSeleccionado.value.group_id}/participants`, {
      external_email: nuevoParticipanteEmail.value.trim(),
    });
    nuevoParticipanteEmail.value = '';
    await cargarParticipantesGrupo();
    await cargarGrupos();
  } catch (e) {
    errorParticipante.value = e.response?.data?.message || 'No se pudo agregar el participante.';
  } finally {
    agregandoParticipante.value = false;
  }
}

async function quitarParticipante(participante) {
  try {
    await backendApi.delete(`/groups/${grupoSeleccionado.value.group_id}/participants/${participante.id}`);
    await cargarParticipantesGrupo();
    await cargarGrupos();
  } catch (e) {
    alert.error('No se pudo quitar el participante.');
  }
}

onMounted(async () => {
  await cargarDependencias();
  await cargarGrupos();
});
</script>

<style scoped>
.participants-page {
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
  background: linear-gradient(135deg, #063456 0%, #2D52A7 100%);
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
  color: #063456 !important;
}

@media (max-width: 600px) {
  .hero__content {
    padding: 22px 20px 20px;
  }
  .hero__title {
    font-size: 24px;
  }
}
</style>