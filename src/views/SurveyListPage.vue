<template>
  <div>
    <v-row class="align-center mt-8 mb-4">
      <v-col cols="auto">
        <h3 class="text-page-title">Gestión de encuestas</h3><br>
        <div class="summary-label">
          {{ hasPermission('surveys.viewAll') ? 'Todas las dependencias' : `Dependencia: ${miDependencia || 'Sin asignar'}` }}
        </div>
      </v-col>
      <v-spacer />
      <v-col cols="12" sm="auto">
        <v-btn color="primary" size="small" prepend-icon="mdi-plus" class="text-button" @click="goToNewSurvey" v-if="hasPermission('surveys.create')">
          Nueva encuesta
        </v-btn>
      </v-col>
    </v-row>

    <!-- Tarjetas resumen -->
    <v-row dense class="mb-4 summary-row">
      <v-col cols="12" sm="6" md="auto" class="summary-col">
        <v-card class="summary-card" variant="flat">
          <v-card-text class="summary-card-content pa-4">
            <div>
              <div class="summary-label">Total encuestas</div>
              <h2 class="summary-value mt-1">{{ cards.total }}</h2>
            </div>
            <div class="summary-icon-box">
              <v-icon class="summary-icon" color="#063456" size="24">mdi-file-document-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="auto" class="summary-col">
        <v-card class="summary-card" variant="flat">
          <v-card-text class="summary-card-content pa-4">
            <div>
              <div class="summary-label">Activas</div>
              <h2 class="summary-value mt-1">{{ cards.activas }}</h2>
            </div>
            <div class="summary-icon-box">
              <v-icon class="summary-icon" color="#063456" size="24">mdi-check-circle-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="auto" class="summary-col">
        <v-card class="summary-card" variant="flat">
          <v-card-text class="summary-card-content pa-4">
            <div>
              <div class="summary-label">Borradores</div>
              <h2 class="summary-value mt-1">{{ cards.borradores }}</h2>
            </div>
            <div class="summary-icon-box">
              <v-icon class="summary-icon" color="#063456" size="24">mdi-pencil-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="auto" class="summary-col">
        <v-card class="summary-card" variant="flat">
          <v-card-text class="summary-card-content pa-4">
            <div>
              <div class="summary-label">Finalizadas</div>
              <h2 class="summary-value mt-1">{{ cards.finalizadas }}</h2>
            </div>
            <div class="summary-icon-box">
              <v-icon class="summary-icon" color="#063456" size="24">mdi-flag-checkered</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="auto" class="summary-col">
        <v-card class="summary-card" variant="flat">
          <v-card-text class="summary-card-content pa-4">
            <div>
              <div class="summary-label">Total respuestas</div>
              <h2 class="summary-value mt-1">{{ cards.totalRespuestas }}</h2>
            </div>
            <div class="summary-icon-box">
              <v-icon class="summary-icon" color="#063456" size="24">mdi-account-group-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Filtros (nuevo diseño) -->
    <v-row dense class="mb-4 align-center filter-row">
      <v-col cols="12" sm="6" md="6" class="filter-col-search">
        <v-text-field
          v-model="filtroBusqueda"
          placeholder="Buscar encuesta..."
          variant="outlined"
          density="compact"
          hide-details
          class="input-field filter-control"
          @keyup.enter="filtrar"
        />
      </v-col>
      <v-col cols="auto" class="d-flex align-center gap-2">
        <v-btn
          size="small"
          class="text-button filter-btn"
          @click="dialogFiltros = true"
        >
          <v-icon start>mdi-filter-variant</v-icon>
          Filtros
        </v-btn>
        <v-btn
          v-for="estado in filtrosRapidos"
          :key="estado.value"
          size="small"
          :class="[
            'text-button quick-filter-btn',
            { 'quick-filter-btn--active': filtroEstado === estado.value }
          ]"
          @click="setFiltroEstado(estado.value)"
        >
          {{ estado.title }}
        </v-btn>
      </v-col>
    </v-row>

    <!-- Diálogo filtros adicionales -->
    <v-dialog v-model="dialogFiltros" max-width="500">
      <v-card>
        <v-card-title class="text-h6">Filtros adicionales</v-card-title>
        <v-card-text>
          <v-row dense>
            <v-col cols="12">
              <v-select
                v-model="filtroTipo"
                :items="tipos"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field filter-control"
                label="Tipo"
              />
            </v-col>
            <v-col v-if="hasPermission('surveys.viewAll')" cols="12">
              <v-select
                v-model="filtroDependencia"
                :items="opcionesDependencia"
                item-title="name"
                item-value="id"
                label="Dependencia"
                variant="outlined"
                density="compact"
                hide-details
                clearable
                class="input-field filter-control"
                @update:model-value="cargarEncuestas"
              />
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-btn variant="outlined" color="secondary" class="text-button" @click="limpiarFiltrosAdicionales">
            Limpiar
          </v-btn>
          <v-spacer />
          <v-btn color="primary" class="text-button" @click="dialogFiltros = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Tabla -->
    <v-card class="mb-4" variant="flat">
      <v-table>
        <thead>
          <tr>
            <th class="text-label">Nombre</th>
            <th class="text-label">Encargado</th>
            <th class="text-label">Estado</th>
            <th class="text-label">Vigencia</th>
            <th class="text-label">Tipo</th>
            <th class="text-label">Respuestas</th>
            <th class="text-label">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="survey in filteredSurveys" :key="survey.id">
            <td class="text-body-small">{{ survey.title }}</td>
            <td class="text-body-small">{{ survey.owner?.name || '—' }}</td>
            <td>
              <v-btn
                :color="estadoColor(survey.status?.slug)"
                variant="flat"
                size="small"
                :class="['estado-btn', `estado-btn--${survey.status?.slug || 'default'}`]"
              >
                {{ survey.status?.name || '—' }}
              </v-btn>
            </td>
            <td class="text-body-small">{{ formatVigencia(survey) }}</td>
            <td>
              <v-chip color="info" size="small" variant="tonal" class="text-body-small">
                {{ survey.type?.name || '—' }}
              </v-chip>
            </td>
            <td class="text-body-small">{{ survey.responses_count }}</td>
            <td>
              <v-btn
                icon size="x-small" variant="text" class="me-1 action-icon-btn"
                title="Refrescar esta encuesta"
                :loading="refrescandoId === survey.id"
                @click="refrescarFila(survey)"
              >
                <v-icon>mdi-refresh</v-icon>
              </v-btn>
              <v-btn icon size="x-small" variant="text" class="me-1 action-icon-btn" title="Editar" @click="editarEncuesta(survey.id)">
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
              <v-btn
                icon size="x-small" variant="text" class="me-1 action-icon-btn"
                title="Duplicar encuesta"
                :loading="duplicandoId === survey.id"
                :disabled="!hasPermission('surveys.create')"
                @click="duplicarEncuesta(survey)"
              >
                <v-icon>mdi-content-copy</v-icon>
              </v-btn>
              <v-btn icon size="x-small" variant="text" class="me-1 action-icon-btn" title="Ver resultados" @click="verResultados(survey.id)">
                <v-icon>mdi-chart-box-outline</v-icon>
              </v-btn>
              <v-btn
                icon size="x-small" variant="text" class="me-1 action-icon-btn"
                title="Distribuir / obtener enlaces"
                :disabled="!['approved', 'scheduled', 'published'].includes(survey.status?.slug)"
                @click="abrirDistribucion(survey)"
              >
                <v-icon>mdi-share-variant-outline</v-icon>
              </v-btn>
              <v-btn
                icon size="x-small" variant="text" class="me-1 action-icon-btn"
                title="Historial de cambios"
                :disabled="!hasPermission('changelogs.view')"
                @click="abrirHistorial(survey)"
              >
                <v-icon>mdi-history</v-icon>
              </v-btn>
              <v-btn
                icon size="x-small" variant="text" class="action-icon-btn"
                title="Eliminar"
                :disabled="!hasPermission('surveys.delete')"
                @click="abrirModalEliminar(survey)"
              >
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <!-- Diálogo confirmación eliminar encuesta -->
    <v-dialog v-model="dialogEliminar" max-width="420" persistent>
      <v-card>
        <v-card-title class="text-h6">Eliminar encuesta</v-card-title>
        <v-card-text>
          ¿Confirmas que deseas eliminar <strong>{{ encuestaAEliminar?.title }}</strong>? Esta acción no se puede deshacer.
          <v-alert v-if="dialogEliminarError" type="error" variant="tonal" class="mt-3">
            {{ dialogEliminarError }}
          </v-alert>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="cerrarModalEliminar">
            Cancelar
          </v-btn>
          <v-btn color="error" class="text-button" :loading="eliminando" @click="confirmarEliminar">
            Eliminar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo historial de cambios -->
    <v-dialog v-model="dialogHistorial" max-width="640">
      <v-card>
        <v-card-title class="text-h6">
          Historial de cambios
          <div class="text-body-small text-medium-emphasis font-weight-regular">
            {{ encuestaHistorial?.title }}
          </div>
        </v-card-title>

        <v-card-text style="max-height: 480px; overflow-y: auto;">
          <div v-if="cargandoHistorial" class="text-center py-8">
            <v-progress-circular indeterminate color="primary" />
          </div>
          <div v-else-if="!historial.length" class="text-center text-medium-emphasis py-8">
            Todavía no hay cambios registrados para esta encuesta.
          </div>
          <v-timeline v-else density="compact" side="end">
            <v-timeline-item
              v-for="log in historial"
              :key="log.action_id"
              size="x-small"
              :dot-color="colorAccion(log.action)"
            >
              <div class="text-body-small font-weight-bold">{{ log.action }}</div>
              <div class="text-body-small">{{ log.description }}</div>
              <div class="text-caption text-medium-emphasis">
                {{ formatFecha(log.action_date) }} · {{ log.user?.name || 'Usuario desconocido' }}
              </div>
            </v-timeline-item>
          </v-timeline>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogHistorial = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo Distribuir encuesta -->
    <v-dialog v-model="dialogDistribucion" max-width="620">
      <v-card>
        <v-card-title class="text-h6">
          Distribuir encuesta
          <div class="text-body-small text-medium-emphasis font-weight-regular">
            {{ encuestaDistribucion?.title }}
          </div>
        </v-card-title>

        <v-card-text>
          <template v-if="encuestaDistribucion?.type?.name?.toLowerCase().includes('públic')">
            <p class="text-body-small mb-2">
              Esta encuesta es <strong>Pública</strong>: cualquier persona con el siguiente enlace puede responderla.
            </p>
            <v-text-field
              :model-value="enlacePublico"
              readonly
              variant="outlined"
              density="compact"
              append-inner-icon="mdi-content-copy"
              @click:append-inner="copiarAlPortapapeles(enlacePublico)"
            />

            <v-divider class="my-3" />
            <div class="text-body-small font-weight-bold mb-2">Código QR</div>

            <div v-if="cargandoQr" class="text-center py-4">
              <v-progress-circular indeterminate color="primary" size="24" />
            </div>

            <div v-else-if="qrImageUrl" class="d-flex flex-column align-center">
              <img :src="qrImageUrl" alt="Código QR de la encuesta" width="180" height="180" />
              <div class="d-flex gap-2 mt-2">
                <v-btn size="small" variant="outlined" class="text-button" :href="qrImageUrl" download="qr-encuesta.svg">
                  Descargar
                </v-btn>
                <v-btn size="small" variant="outlined" color="secondary" class="text-button" :loading="regenerandoQr" @click="regenerarQr">
                  Regenerar
                </v-btn>
              </div>
            </div>

            <div v-else class="text-center py-2">
              <p class="text-body-small text-medium-emphasis mb-2">Esta encuesta todavía no tiene un código QR.</p>
              <v-btn size="small" color="primary" class="text-button" :loading="generandoQr" @click="generarQr">
                Generar código QR
              </v-btn>
            </div>
          </template>
          <template v-else>
            <p class="text-body-small mb-3">
              Esta encuesta es <strong>Privada</strong>: cada persona necesita una invitación individual con su propio enlace.
            </p>
            <v-textarea
              v-model="emailsInvitar"
              label="Correos a invitar (uno por línea)"
              variant="outlined"
              density="compact"
              rows="2"
              hint="ejemplo1@cultura.gob.sv&#10;ejemplo2@cultura.gob.sv"
              persistent-hint
            />
            <v-btn
              color="primary"
              size="small"
              class="text-button mt-2 mb-4"
              :loading="invitando"
              @click="invitarParticipantes"
            >
              Agregar e invitar
            </v-btn>
            <v-divider class="mb-3" />
            <div class="d-flex align-center justify-space-between mb-2">
              <span class="text-body-small font-weight-bold">Participantes</span>
              <v-btn
                size="small" variant="outlined" color="secondary" class="text-button"
                :loading="enviandoCorreos"
                @click="enviarInvitacionesPendientes"
              >
                Enviar pendientes
              </v-btn>
            </div>
            <div v-if="cargandoParticipantes" class="text-center py-4">
              <v-progress-circular indeterminate color="primary" size="24" />
            </div>
            <div v-else-if="!participantes.length" class="text-body-small text-medium-emphasis py-2">
              Todavía no hay participantes invitados.
            </div>
            <v-table v-else density="compact">
              <thead>
                <tr>
                  <th class="text-label">Correo</th>
                  <th class="text-label">Estado</th>
                  <th class="text-label">Enlace</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="p in participantes" :key="p.id">
                  <td class="text-body-small">{{ p.email }}</td>
                  <td>
                    <v-chip size="x-small" :color="colorInvitacion(p.invitation_status)" variant="tonal">
                      {{ p.invitation_status }}
                    </v-chip>
                  </td>
                  <td>
                    <v-btn size="x-small" variant="text" icon @click="copiarAlPortapapeles(enlaceParticipante(p))" title="Copiar enlace">
                      <v-icon size="16">mdi-content-copy</v-icon>
                    </v-btn>
                  </td>
                </tr>
              </tbody>
            </v-table>
          </template>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="cerrarDistribucion">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-row class="align-center">
      <v-col cols="auto">
        <span class="text-body-small text-medium-emphasis">
          Mostrando {{ filteredSurveys.length }} encuestas
        </span>
      </v-col>
      <v-spacer />
      <v-col cols="auto">
        <v-pagination :length="1" size="small" />
      </v-col>
    </v-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import backendApi from '@/services/backendApi';
import useAuth from '@/composables/useAuth';
import useAlert from '@/composables/useAlert';

const router = useRouter();
const { hasPermission } = useAuth();
const { alert } = useAlert();

const surveys = ref([]);
const filtroBusqueda = ref('');
const filtroEstado = ref('all');
const filtroTipo = ref('all');
const filtroDependencia = ref(null);
const opcionesDependencia = ref([]);
const dialogFiltros = ref(false);

const miDependencia = JSON.parse(localStorage.getItem('survey_profile') || 'null')?.dependency?.name || null;

const estados = [
  { title: 'Todos los estados', value: 'all' },
  { title: 'Activa', value: 'published' },
  { title: 'Finalizada', value: 'closed' },
  { title: 'Borrador', value: 'draft' },
  { title: 'Programada', value: 'scheduled' },
];

const tipos = [
  { title: 'Todos los tipos', value: 'all' },
  { title: 'Pública', value: 'Pública' },
  { title: 'Privada', value: 'Privada' },
];

const filtrosRapidos = [
  { title: 'Todos', value: 'all' },
  { title: 'Borrador', value: 'draft' },
  { title: 'Activas', value: 'published' },
  { title: 'Finalizadas', value: 'closed' },
];

const cards = computed(() => {
  const activas = surveys.value.filter(s => s.status?.slug === 'published').length;
  const finalizadas = surveys.value.filter(s => s.status?.slug === 'closed').length;
  const borradores = surveys.value.filter(s => s.status?.slug === 'draft').length;
  const totalRespuestas = surveys.value.reduce((sum, s) => sum + (s.responses_count || 0), 0);
  return {
    total: surveys.value.length,
    activas,
    finalizadas,
    borradores,
    totalRespuestas,
  };
});

const filteredSurveys = computed(() => {
  return surveys.value.filter(s => {
    const texto = s.title?.toLowerCase() || '';
    const coincideBusqueda = !filtroBusqueda.value || texto.includes(filtroBusqueda.value.toLowerCase());
    const coincideEstado = filtroEstado.value === 'all' || s.status?.slug === filtroEstado.value;
    const coincideTipo = filtroTipo.value === 'all' || s.type?.name === filtroTipo.value;
    return coincideBusqueda && coincideEstado && coincideTipo;
  });
});

function estadoColor(slug) {
  switch (slug) {
    case 'published': return 'default';
    case 'scheduled': return 'default';
    case 'closed': return 'default';
    case 'draft': return 'default';
    case 'approved': return 'default';        
    case 'review': return 'default';              
    case 'rejected': return 'default';           
    case 'needs_correction': return 'default'; 
    case 'archived': return 'default';   
    case 'paused': return 'dedault';
    default: return 'default';


    // case 'published': return 'success';
    // case 'scheduled': return 'warning';
    // case 'closed': return 'error';
    // case 'draft': return 'grey';
    // case 'approved': return 'success';        
    // case 'review': return 'info';              
    // case 'rejected': return 'error';           
    // case 'needs_correction': return 'warning'; 
    // case 'archived': return 'grey-darken-1';   
    // case 'paused': return 'orange';            
    
  }
}

function formatVigencia(survey) {
  const inicio = survey.start_date ? new Date(survey.start_date).toLocaleDateString('es-SV') : 'Sin fecha';
  const fin = survey.end_date ? new Date(survey.end_date).toLocaleDateString('es-SV') : 'Sin fecha';
  return `${inicio} - ${fin}`;
}

function filtrar() {}

function setFiltroEstado(value) {
  filtroEstado.value = value;
}

function limpiarFiltrosAdicionales() {
  filtroTipo.value = 'all';
  filtroDependencia.value = null;
}

function goToNewSurvey() {
  router.push('/surveys/new/edit');
}

function editarEncuesta(id) {
  router.push(`/surveys/${id}/edit`);
}

function verResultados(id) {
  router.push(`/surveys/${id}/results`);
}

async function cargarEncuestas() {
  try {
    const response = await backendApi.get('/surveys', {
      params: filtroDependencia.value ? { dependency_id: filtroDependencia.value } : {},
    });
    surveys.value = response.data;
  } catch (error) {
    console.error('Error cargando encuestas:', error);
  }
}

const refrescandoId = ref(null);
const duplicandoId = ref(null);
let estadoBorradorId = null;

// El endpoint /surveys/{id}/duplicate exige status_id (a qué estado nace
// la copia). Siempre nace como Borrador, así que resolvemos ese id una
// sola vez y lo cacheamos.
async function resolverEstadoBorradorId() {
  if (estadoBorradorId) return estadoBorradorId;
  const { data } = await backendApi.get('/statuses');
  const borrador = data.find((s) => s.slug === 'draft');
  estadoBorradorId = borrador?.id ?? null;
  return estadoBorradorId;
}

async function duplicarEncuesta(survey) {
  duplicandoId.value = survey.id;
  try {
    const statusId = await resolverEstadoBorradorId();
    if (!statusId) {
      alert.error('No se encontró el estado "Borrador" en el catálogo de estados.');
      return;
    }
    const response = await backendApi.post(`/surveys/${survey.id}/duplicate`, {
      status_id: statusId,
    });
    alert.success(`Se creó la copia "${response.data.title}" como borrador.`);
    await cargarEncuestas();
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo duplicar la encuesta.');
  } finally {
    duplicandoId.value = null;
  }
}

async function refrescarFila(survey) {
  refrescandoId.value = survey.id;
  try {
    await cargarEncuestas();
  } finally {
    refrescandoId.value = null;
  }
}

async function cargarDependencias() {
  if (!hasPermission('surveys.viewAll')) return;
  try {
    const response = await backendApi.get('/organizational-units');
    opcionesDependencia.value = response.data;
  } catch (e) {
    // silencioso
  }
}

const dialogEliminar = ref(false);
const dialogEliminarError = ref(null);
const eliminando = ref(false);
const encuestaAEliminar = ref(null);

function abrirModalEliminar(survey) {
  encuestaAEliminar.value = survey;
  dialogEliminarError.value = null;
  dialogEliminar.value = true;
}

function cerrarModalEliminar() {
  dialogEliminar.value = false;
  encuestaAEliminar.value = null;
  dialogEliminarError.value = null;
}

async function confirmarEliminar() {
  if (!encuestaAEliminar.value) return;

  eliminando.value = true;
  dialogEliminarError.value = null;

  try {
    await backendApi.delete(`/surveys/${encuestaAEliminar.value.id}`);
    alert.success('Encuesta eliminada correctamente.');
    dialogEliminar.value = false;
    await cargarEncuestas();
  } catch (e) {
    dialogEliminarError.value = e.response?.data?.message || 'No se pudo eliminar la encuesta.';
  } finally {
    eliminando.value = false;
  }
}

const dialogHistorial = ref(false);
const cargandoHistorial = ref(false);
const historial = ref([]);
const encuestaHistorial = ref(null);

async function abrirHistorial(survey) {
  encuestaHistorial.value = survey;
  dialogHistorial.value = true;
  cargandoHistorial.value = true;
  historial.value = [];

  try {
    const response = await backendApi.get('/change-logs', {
      params: { survey_id: survey.id, per_page: 50 },
    });
    historial.value = response.data.data || [];
  } catch (e) {
    alert.error('No se pudo cargar el historial de cambios.');
  } finally {
    cargandoHistorial.value = false;
  }
}

function colorAccion(action) {
  switch (action) {
    case 'Creación': return 'success';
    case 'Cambio de estado': return 'warning';
    case 'Eliminación': return 'error';
    case 'Duplicación': return 'info';
    default: return 'primary';
  }
}

function formatFecha(fecha) {
  if (!fecha) return '—';
  return new Date(fecha).toLocaleString('es-SV', {
    day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit',
  });
}

const dialogDistribucion = ref(false);
const encuestaDistribucion = ref(null);
const emailsInvitar = ref('');
const invitando = ref(false);
const enviandoCorreos = ref(false);
const cargandoParticipantes = ref(false);
const participantes = ref([]);

const cargandoQr = ref(false);
const generandoQr = ref(false);
const regenerandoQr = ref(false);
const qrImageUrl = ref(null);

const enlacePublico = computed(() => {
  if (!encuestaDistribucion.value) return '';
  return `${window.location.origin}/survey/${encuestaDistribucion.value.id}/answer`;
});

function enlaceParticipante(participante) {
  return `${window.location.origin}/responder/${participante.access_token}`;
}

function cerrarDistribucion() {
  dialogDistribucion.value = false;
  liberarQrPrevio();
}

async function abrirDistribucion(survey) {
  encuestaDistribucion.value = survey;
  emailsInvitar.value = '';
  dialogDistribucion.value = true;

  if (survey.type?.name?.toLowerCase().includes('públic')) {
    await cargarQr(survey.id);
  } else {
    await cargarParticipantes(survey.id);
  }
}

async function cargarParticipantes(surveyId) {
  cargandoParticipantes.value = true;
  try {
    const response = await backendApi.get('/participants', { params: { survey_id: surveyId } });
    participantes.value = response.data;
  } catch (e) {
    alert.error('No se pudieron cargar los participantes.');
  } finally {
    cargandoParticipantes.value = false;
  }
}

// La ruta de imagen del QR es administrativa (requiere el Bearer token),
// así que no se puede usar directo en un <img src="..."> — se descarga
// como blob con backendApi (que ya manda el token) y se arma una URL de
// objeto local para mostrarla/descargarla.
function liberarQrPrevio() {
  if (qrImageUrl.value) {
    URL.revokeObjectURL(qrImageUrl.value);
    qrImageUrl.value = null;
  }
}

async function cargarQr(surveyId) {
  cargandoQr.value = true;
  liberarQrPrevio();
  try {
    const response = await backendApi.get(`/surveys/${surveyId}/qr-code/image`, {
      responseType: 'blob',
    });
    qrImageUrl.value = URL.createObjectURL(response.data);
  } catch (e) {
    // 404 = todavía no existe el QR; se muestra el botón "Generar".
    if (e.response?.status !== 404) {
      alert.error('No se pudo cargar el código QR.');
    }
  } finally {
    cargandoQr.value = false;
  }
}

async function generarQr() {
  generandoQr.value = true;
  try {
    await backendApi.post(`/surveys/${encuestaDistribucion.value.id}/qr-code`);
    await cargarQr(encuestaDistribucion.value.id);
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo generar el código QR.');
  } finally {
    generandoQr.value = false;
  }
}

async function regenerarQr() {
  regenerandoQr.value = true;
  try {
    await backendApi.put(`/surveys/${encuestaDistribucion.value.id}/qr-code`);
    await cargarQr(encuestaDistribucion.value.id);
    alert.success('Código QR regenerado.');
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo regenerar el código QR.');
  } finally {
    regenerandoQr.value = false;
  }
}

async function invitarParticipantes() {
  const emails = emailsInvitar.value
    .split('\n')
    .map((e) => e.trim())
    .filter(Boolean);

  if (!emails.length) {
    alert.error('Escribe al menos un correo.');
    return;
  }

  invitando.value = true;
  try {
    await backendApi.post('/participants/invite', {
      survey_id: encuestaDistribucion.value.id,
      emails,
    });
    alert.success('Participantes agregados. Ahora presiona "Enviar pendientes" para mandar los correos.');
    emailsInvitar.value = '';
    await cargarParticipantes(encuestaDistribucion.value.id);
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo invitar a los participantes.');
  } finally {
    invitando.value = false;
  }
}

async function enviarInvitacionesPendientes() {
  enviandoCorreos.value = true;
  try {
    const response = await backendApi.post('/email-notifications/send', {
      survey_id: encuestaDistribucion.value.id,
    });
    alert.success(response.data.message);
    await cargarParticipantes(encuestaDistribucion.value.id);
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudieron enviar los correos.');
  } finally {
    enviandoCorreos.value = false;
  }
}

function colorInvitacion(status) {
  switch (status) {
    case 'respondido': return 'success';
    case 'enviado': return 'info';
    case 'fallido': return 'error';
    default: return 'grey';
  }
}

function copiarAlPortapapeles(texto) {
  navigator.clipboard.writeText(texto);
  alert.success('Enlace copiado al portapapeles.');
}

onMounted(async () => {
  await cargarDependencias();
  await cargarEncuestas();
});
</script>

<style scoped>
/* ===================== TARJETAS RESUMEN ===================== */
.summary-row {
  flex-wrap: nowrap;
  justify-content: space-between;
}

.summary-col {
  flex: 1 1 0;
  min-width: 160px;
  width: auto;
}

.summary-card {
  height: 115px;
  border-radius: 7px !important;
  width: 100%;
  max-width: 100%;
  margin: 0;
}

.summary-card-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.summary-label {
  font-family: 'Poppins', sans-serif;
  font-weight: 500;
  font-size: 12px;
  line-height: 100%;
  letter-spacing: 0%;
  color: #063456;
}

.summary-value {
  font-family: 'Poppins', sans-serif;
  font-weight: 500;
  font-size: 36px;
  line-height: 100%;
  letter-spacing: 0%;
}

.summary-icon-box {
  background: #E9EDFD;
  width: 55px;
  height: 54px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.summary-icon {
  font-size: 24px !important;
  width: 24px !important;
  height: 24px !important;
}

/* ===================== FILTROS ===================== */
.filter-row {
  flex-wrap: nowrap;
}

.filter-col-search {
  min-width: 0;
  flex: 1 1 auto;
}

/* Input de búsqueda con fondo azul claro */
.filter-control :deep(.v-field) {
  background-color: #E8F0F8 !important;
  border-radius: 6px !important;
}

.filter-control :deep(.v-field--variant-outlined .v-field__outline) {
  display: none;
}

.filter-control :deep(.v-field__input) {
  min-height: 30px !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}

/* Botones de filtro */
.filter-btn,
.quick-filter-btn {
  height: 36px !important;
  border-radius: 6px !important;
  background-color: #ffffff !important;
  box-shadow: none !important;
  border: none !important;
  font-size: 10px !important;
  font-weight: 500 !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
  padding: 0 16px !important;
  min-width: 100px !important;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #374957 !important;
}

.filter-btn .v-icon,
.quick-filter-btn .v-icon {
  color: #374957 !important;
}

.filter-btn:hover,
.quick-filter-btn:hover {
  background-color: #F0F2F5 !important;
}

.quick-filter-btn--active {
  background-color: #447AF4 !important;
  color: #ffffff !important;
}

.quick-filter-btn--active .v-icon {
  color: #ffffff !important;
}

.quick-filter-btn--active:hover {
  background-color: #447AF4 !important;
}

/* ===================== BOTONES DE ESTADO ===================== */
.estado-btn {
  height: 23px !important;
  min-width: 70px !important;
  padding: 0 8px !important;
  border-radius: 6px !important;
  font-size: 10px !important;
  font-weight: 500 !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.estado-btn--published {
  min-width: 70px !important;
}

.estado-btn--draft {
  min-width: 70px !important;
  
  color: #313845 !important;
}

.estado-btn--scheduled {
  min-width: 85px !important;
}

.estado-btn--closed {
  min-width: 70px !important;
}

.estado-btn--default {
  min-width: 70px !important;
}

/* ===================== ÍCONOS DE ACCIONES ===================== */
.action-icon-btn {
  color: #374957 !important;
  background-color: transparent !important;
  box-shadow: none !important;
}

.action-icon-btn.v-btn--disabled {
  color: #B0B8C1 !important;
  opacity: 1 !important;
}

/* Responsive */
@media (max-width: 600px) {
  .filter-row {
    flex-wrap: wrap;
  }
  .filter-col-search {
    flex: 1 1 100%;
  }
}
</style>