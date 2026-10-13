<template>
  <div class="surveys-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero" :class="heroClase('encuestas')">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <div class="hero__eyebrow">Encuestas</div>
          <h1 class="hero__title">Gestión de encuestas</h1>
          <p class="hero__sub">
            {{ hasPermission('surveys.viewAll') ? 'Todas las dependencias' : `Dependencia: ${miDependencia || 'Sin asignar'}` }}
          </p>
        </div>

        <div class="hero__actions">
          
  <v-btn
    v-if="hasPermission('surveys.create')"
    color="white"
    variant="flat"
    prepend-icon="mdi-plus"
    class="text-button hero__cta"
    @click="goToNewSurvey"
  >
    Nueva encuesta
  </v-btn>
</div>
      </div>
    </div>

    <!-- ================= Tarjetas resumen ================= -->
    <div class="section-title">Resumen</div>
    <div class="kpi-grid mb-6">
      <div class="kpi-card kpi-card--primary">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-file-document-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.total }}</div>
        <div class="kpi-card__label">Total encuestas</div>
      </div>

      <div class="kpi-card kpi-card--success">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-check-circle-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.activas }}</div>
        <div class="kpi-card__label">Activas</div>
      </div>

      <div class="kpi-card kpi-card--accent">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-pencil-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.borradores }}</div>
        <div class="kpi-card__label">Borradores</div>
      </div>

      <div class="kpi-card kpi-card--muted">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-flag-checkered</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.finalizadas }}</div>
        <div class="kpi-card__label">Finalizadas</div>
      </div>

      <div class="kpi-card kpi-card--primary">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-account-group-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.totalRespuestas }}</div>
        <div class="kpi-card__label">Total respuestas</div>
      </div>
    </div>

    <!-- ================= Filtros ================= -->
    <v-card class="filter-card mb-5" variant="flat">
      <v-card-text class="pa-5">
        <div class="section-title">
          <v-icon size="16" color="#4880FF">mdi-filter-variant</v-icon>
          Búsqueda y filtros
        </div>

        <v-row dense class="align-center">
          <v-col cols="12" md="6" class="filter-col-search">
            <v-text-field
              v-model="filtroBusqueda"
              placeholder="Buscar encuesta..."
              variant="outlined"
              density="compact"
              hide-details
              prepend-inner-icon="mdi-magnify"
              class="input-field filter-control"
              @keyup.enter="filtrar"
            />
          </v-col>

          <v-col cols="auto" class="d-flex align-center filter-actions">
            <v-btn
              size="small"
              class="text-button filter-btn"
              @click="dialogFiltros = true"
            >
              <v-icon start>mdi-filter-variant</v-icon>
              Filtros
            </v-btn>

            <div class="quick-filters">
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
            </div>
            <v-btn
  icon
  size="small"
  variant="text"
  color="#2D52A7"
  class="ms-1"
  title="Refrescar encuestas"
  aria-label="Refrescar encuestas"
  :loading="cargandoEncuestas"
  @click="cargarEncuestas"
>
  <v-icon size="18">mdi-refresh</v-icon>
</v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Diálogo filtros adicionales -->
    <v-dialog v-model="dialogFiltros" max-width="500">
      <v-card>
        <v-card-title class="text-h6">Filtros adicionales</v-card-title>
        <v-card-text>
          <v-row dense>
            <v-col cols="12">
              <v-select
                v-model="filtroEstado"
                :items="estados"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field filter-control"
                label="Estado"
              />
            </v-col>
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

    <!-- ================= Tabla ================= -->
    <div class="section-title">Listado</div>
    <v-card class="table-card mb-4" variant="flat">
      <LoadingState v-if="cargandoEncuestas" message="Cargando encuestas" />
      <v-table v-else class="survey-table">
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
          <tr v-for="survey in encuestasPagina" :key="survey.id">
            <td class="text-body-small col-nombre" :title="survey.title">{{ survey.title }}</td>
            <td class="text-body-small">{{ survey.owner?.name || '—' }}</td>
            <td>
              <v-btn
                :color="estadoColor(survey.status?.slug)"
                variant="flat"
                size="small"
                :class="['estado-btn', `estado-btn--${faseEncuesta(survey).slug || 'default'}`]"
              >
                {{ faseEncuesta(survey).nombre || '—' }}
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
              <v-menu location="bottom end" content-class="acciones-menu">
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon
                    size="x-small"
                    variant="text"
                    class="action-icon-btn"
                    title="Acciones"
                    :loading="refrescandoId === survey.id || duplicandoId === survey.id"
                  >
                    <v-icon>mdi-dots-vertical</v-icon>
                  </v-btn>
                </template>

                <v-list density="compact" min-width="220">
                  <template v-for="accion in accionesDe(survey)" :key="accion.key">
                    <v-divider v-if="accion.danger" class="my-1" />
                    <v-list-item
                      :prepend-icon="accion.icon"
                      :title="accion.title"
                      :class="{ 'text-error': accion.danger }"
                      @click="accion.handler()"
                    />
                  </template>
                </v-list>
              </v-menu>
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
              <v-alert
                v-if="qrAdvertencia"
                type="warning"
                variant="tonal"
                density="compact"
                class="mb-3 text-body-small"
              >
                {{ qrAdvertencia }}
              </v-alert>
              <img :src="qrImageUrl" alt="Código QR de la encuesta" width="200" height="200" />
              <p class="text-body-small text-medium-emphasis mt-2 mb-0 text-center" style="word-break: break-all;">
                Al escanearlo abre: {{ qrPublicUrl }}
              </p>
              <div class="d-flex flex-wrap justify-center gap-2 mt-2">
                <v-btn size="small" variant="outlined" class="text-button" @click="descargarQrPng(qrImageUrl, `qr-encuesta-${encuestaDistribucion.id}.png`)">
                  Descargar PNG
                </v-btn>
                <v-btn size="small" variant="outlined" class="text-button" :href="qrImageUrl" :download="`qr-encuesta-${encuestaDistribucion.id}.svg`">
                  Descargar SVG
                </v-btn>
                <v-btn size="small" variant="outlined" class="text-button" @click="copiarAlPortapapeles(qrPublicUrl || enlacePublico)">
                  Copiar enlace
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
            <div class="mb-4">
              <div class="text-body-small font-weight-bold mb-1">Compartir con la organización</div>
              <p class="text-body-small text-medium-emphasis mb-2">
                Invita a todas las personas de
                <strong>{{ encuestaDistribucion?.department?.name || 'la organización' }}</strong>
                con su propio enlace.
              </p>
              <v-switch
                v-model="incluirSubdependencias"
                color="primary"
                density="compact"
                hide-details
                label="Incluir sus sub-dependencias"
              />
              <p v-if="cargandoOrganizacion" class="text-body-small text-medium-emphasis my-2">
                Calculando...
              </p>
              <p v-else-if="resumenOrganizacion" class="text-body-small my-2">
                {{ resumenOrganizacion.total_members }} miembros ·
                {{ resumenOrganizacion.already_invited }} ya invitados ·
                <strong>{{ resumenOrganizacion.to_invite }} por invitar</strong>
              </p>
              <v-btn
                color="primary"
                size="small"
                class="text-button"
                :disabled="!resumenOrganizacion || resumenOrganizacion.to_invite === 0"
                :loading="invitandoOrganizacion"
                @click="invitarOrganizacion"
              >
                Invitar a toda la organización
              </v-btn>
            </div>
            <v-divider class="mb-3" />

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
                    <v-btn
                      v-if="p.invitation_status !== 'respondido'"
                      size="x-small" variant="text" icon
                      title="Ver código QR"
                      @click="abrirQrParticipante(p)"
                    >
                      <v-icon size="16">mdi-qrcode</v-icon>
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

    <!-- Diálogo: guardar la encuesta como plantilla -->
    <v-dialog v-model="dialogPlantilla" max-width="480" persistent>
      <v-card>
        <v-card-title class="text-h6">Guardar como plantilla</v-card-title>
        <v-card-text>
          <v-text-field
            v-model="plantillaForm.name"
            label="Nombre de la plantilla"
            variant="outlined"
            density="compact"
            maxlength="255"
            class="mb-3"
            hide-details="auto"
          />
          <v-select
              v-model="plantillaForm.survey_category_id"
              :items="categoriasPlantilla"
              item-title="name"
              item-value="id"
              label="Categoría de la plantilla"
              variant="outlined"
              density="compact"
              class="mb-3"
              hide-details="auto"
            />
          <v-textarea
            v-model="plantillaForm.description"
            label="Descripción (opcional)"
            variant="outlined"
            density="compact"
            rows="3"
            class="mb-2"
            hide-details="auto"
          />
          <v-switch
            v-model="plantillaForm.is_public"
            color="primary"
            density="compact"
            hide-details
            label="Compartir con toda la institución"
          />
          <p class="text-body-small text-medium-emphasis mt-2 mb-0">
            Se guardan las secciones, preguntas y opciones. No se copian respuestas,
            fechas ni participantes. Si no la compartes, solo tú (y un administrador) la verás.
          </p>
          <v-alert v-if="errorPlantilla" type="error" variant="tonal" density="compact" class="mt-3">
            {{ errorPlantilla }}
          </v-alert>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" :disabled="guardandoPlantilla" @click="dialogPlantilla = false">
            Cancelar
          </v-btn>
          <v-btn color="primary" variant="flat" class="text-button" :loading="guardandoPlantilla" @click="guardarPlantilla">
            Guardar plantilla
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo QR individual de un invitado -->
    <v-dialog v-model="dialogQrParticipante" max-width="360">
      <v-card>
        <v-card-title class="text-h6">
          Código QR del invitado
          <div class="text-body-small text-medium-emphasis font-weight-regular">
            {{ participanteQr?.email }}
          </div>
        </v-card-title>
        <v-card-text class="d-flex flex-column align-center">
          <v-progress-circular v-if="cargandoQrParticipante" indeterminate color="primary" size="24" />
          <template v-else-if="qrParticipanteUrl">
            <img :src="qrParticipanteUrl" alt="Código QR del invitado" width="220" height="220" />
            <p class="text-body-small text-medium-emphasis mt-2 mb-0 text-center">
              Este QR abre el enlace individual de esta persona. No lo compartas con nadie más.
            </p>
          </template>
        </v-card-text>
        <v-card-actions class="pa-4">
          <v-btn
            v-if="qrParticipanteUrl"
            variant="outlined" class="text-button"
            @click="descargarQrPng(qrParticipanteUrl, `qr-invitado-${participanteQr.id}.png`)"
          >
            Descargar PNG
          </v-btn>
          <v-spacer />
          <v-btn variant="outlined" color="secondary" class="text-button" @click="cerrarQrParticipante">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Paginación -->
    <div class="pagination-footer">
      <span class="text-body-small text-medium-emphasis">
        Mostrando {{ rangoMostrado.desde }}–{{ rangoMostrado.hasta }} de {{ filteredSurveys.length }} encuestas
      </span>
      <v-pagination v-model="paginaActual" :length="totalPaginas" :total-visible="5" size="small" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import backendApi from '@/services/backendApi';
import useAuth from '@/composables/useAuth';
import useAlert from '@/composables/useAlert';
import LoadingState from '@/components/LoadingState.vue';
import useHeroStyle from '@/composables/useHeroStyle';

const { heroClase } = useHeroStyle();

const router = useRouter();
const { hasPermission } = useAuth();
const { alert } = useAlert();

const surveys = ref([]);
const cargandoEncuestas = ref(true);
const filtroBusqueda = ref('');
const filtroEstado = ref('all');
const filtroTipo = ref('all');
const filtroDependencia = ref(null);
const opcionesDependencia = ref([]);
const dialogFiltros = ref(false);

const miDependencia = JSON.parse(localStorage.getItem('survey_profile') || 'null')?.dependency?.name || null;

const estados = [

  { title: 'Todos los estados', value: 'all' },
  { title: 'Borrador', value: 'draft' },
  { title: 'En revisión', value: 'review' },
  { title: 'Correcciones solicitadas', value: 'needs_correction' },
  { title: 'Aprobada', value: 'approved' },
  { title: 'Rechazada', value: 'rejected' },
  { title: 'Programada', value: 'scheduled' },
  { title: 'Activa', value: 'published' },
  { title: 'En pausa', value: 'paused' },
  { title: 'Finalizada', value: 'closed' },
  { title: 'Archivada', value: 'archived' },
];

const tipos = [
  { title: 'Todos los tipos', value: 'all' },
  { title: 'Pública', value: 'Pública' },
  { title: 'Privada', value: 'Privada' },
];

const filtrosRapidos = [
  { title: 'Todos', value: 'all' },
  { title: 'Activas', value: 'published' },
  { title: 'Finalizadas', value: 'closed' },
  { title: 'En revisión', value: 'review' },
];

const cards = computed(() => {
  const activas = surveys.value.filter(s => faseEncuesta(s).slug === 'published').length;
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
    const coincideEstado = filtroEstado.value === 'all' || faseEncuesta(s).slug === filtroEstado.value;
    const coincideTipo = filtroTipo.value === 'all' || s.type?.name === filtroTipo.value;
    return coincideBusqueda && coincideEstado && coincideTipo;
  });
});

// ===================== PAGINACIÓN EN EL NAVEGADOR =====================
const POR_PAGINA = 10;
const paginaActual = ref(1);

const totalPaginas = computed(() =>
  Math.max(1, Math.ceil(filteredSurveys.value.length / POR_PAGINA))
);

const encuestasPagina = computed(() => {
  const inicio = (paginaActual.value - 1) * POR_PAGINA;
  return filteredSurveys.value.slice(inicio, inicio + POR_PAGINA);
});

const rangoMostrado = computed(() => {
  const total = filteredSurveys.value.length;
  if (total === 0) return { desde: 0, hasta: 0 };
  const desde = (paginaActual.value - 1) * POR_PAGINA + 1;
  return { desde, hasta: Math.min(desde + POR_PAGINA - 1, total) };
});

watch([filtroBusqueda, filtroEstado, filtroTipo, filtroDependencia], () => {
  paginaActual.value = 1;
});

watch(totalPaginas, (total) => {
  if (paginaActual.value > total) paginaActual.value = total;
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
    case 'paused': return 'default';
    default: return 'default';
  }
}

function faseEncuesta(survey) {
  return { slug: survey.status?.slug, nombre: survey.status?.name };
}

function formatVigencia(survey) {
  const inicio = survey.start_date ? new Date(survey.start_date).toLocaleDateString('es-SV') : 'Sin fecha';
  const fin = survey.end_date ? new Date(survey.end_date).toLocaleDateString('es-SV') : 'Sin fecha';
  return `${inicio} - ${fin}`;
}

function accionesDe(survey) {
  const slug = survey.status?.slug;
  const acciones = [];

  acciones.push({ key: 'editar', title: 'Editar', icon: 'mdi-pencil', handler: () => editarEncuesta(survey.id) });
  acciones.push({ key: 'resultados', title: 'Ver resultados', icon: 'mdi-chart-box-outline', handler: () => verResultados(survey.id) });

  if (['approved', 'scheduled', 'published'].includes(slug)) {
    acciones.push({ key: 'compartir', title: 'Compartir / enlaces', icon: 'mdi-share-variant-outline', handler: () => abrirDistribucion(survey) });
  }

  if (hasPermission('surveys.create')) {
    acciones.push({ key: 'duplicar', title: 'Duplicar', icon: 'mdi-content-copy', handler: () => duplicarEncuesta(survey) });
  }
  if (hasPermission('surveys.create')) {
    acciones.push({ key: 'plantilla', title: 'Guardar como plantilla', icon: 'mdi-content-save-outline', handler: () => abrirGuardarPlantilla(survey) });
  }

  if (hasPermission('changelogs.view')) {
    acciones.push({ key: 'historial', title: 'Historial de cambios', icon: 'mdi-history', handler: () => abrirHistorial(survey) });
  }

  acciones.push({ key: 'refrescar', title: 'Refrescar', icon: 'mdi-refresh', handler: () => refrescarFila(survey) });

  if (hasPermission('surveys.delete')) {
    acciones.push({ key: 'eliminar', title: 'Eliminar', icon: 'mdi-delete', danger: true, handler: () => abrirModalEliminar(survey) });
  }

  return acciones;
}

function filtrar() {}

function setFiltroEstado(value) {
  filtroEstado.value = value;
}

function limpiarFiltrosAdicionales() {
  filtroEstado.value = 'all';
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

async function cargarEncuestas(opciones) {
  const silencioso = opciones?.silencioso === true;
  if (!silencioso) cargandoEncuestas.value = true;
  try {
    const response = await backendApi.get('/surveys', {
      params: filtroDependencia.value ? { dependency_id: filtroDependencia.value } : {},
    });
    surveys.value = response.data;
  } catch (error) {
    console.error('Error cargando encuestas:', error);
  } finally {
    if (!silencioso) cargandoEncuestas.value = false;
  }
}

// Mantiene la lista al día sin recargar la página
usePolling(() => cargarEncuestas({ silencioso: true }), 15000);

const refrescandoId = ref(null);
const duplicandoId = ref(null);
let estadoBorradorId = null;

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
const incluirSubdependencias = ref(false);
const resumenOrganizacion = ref(null);
const cargandoOrganizacion = ref(false);
const invitandoOrganizacion = ref(false);
import usePolling from '@/composables/usePolling';

async function cargarResumenOrganizacion() {
  if (!encuestaDistribucion.value) return;

  cargandoOrganizacion.value = true;
  try {
    const response = await backendApi.get(
      `/surveys/${encuestaDistribucion.value.id}/organization-members`,
      { params: { include_children: incluirSubdependencias.value ? 1 : 0 } }
    );
    resumenOrganizacion.value = response.data;
  } catch (e) {
    resumenOrganizacion.value = null;
  } finally {
    cargandoOrganizacion.value = false;
  }
}

async function invitarOrganizacion() {
  invitandoOrganizacion.value = true;
  try {
    const response = await backendApi.post(
      `/surveys/${encuestaDistribucion.value.id}/invite-organization`,
      { include_children: incluirSubdependencias.value }
    );
    alert.success(response.data.message);
    await Promise.all([
      cargarParticipantes(encuestaDistribucion.value.id),
      cargarResumenOrganizacion(),
    ]);
  } catch (e) {
    alert.error(e.response?.data?.message || 'No se pudo invitar a la organización.');
  } finally {
    invitandoOrganizacion.value = false;
  }
}

watch(incluirSubdependencias, cargarResumenOrganizacion);

const invitando = ref(false);
const enviandoCorreos = ref(false);
const cargandoParticipantes = ref(false);
const participantes = ref([]);

const cargandoQr = ref(false);
const generandoQr = ref(false);
const regenerandoQr = ref(false);
const qrImageUrl = ref(null);
const qrPublicUrl = ref('');

const qrAdvertencia = computed(() => {
  if (!qrPublicUrl.value) return '';
  try {
    const destino = new URL(qrPublicUrl.value);
    const actual = window.location;
    const esLocal = ['localhost', '127.0.0.1'].includes(destino.hostname);
    const adminEsLocal = ['localhost', '127.0.0.1'].includes(actual.hostname);
    if (esLocal && !adminEsLocal) {
      return 'Este QR apunta a "' + destino.host + '", que solo funciona en tu propio equipo. Configura FRONTEND_URL en el .env del backend con la dirección real del sistema.';
    }
    if (destino.origin !== actual.origin && !adminEsLocal) {
      return 'Este QR apunta a "' + destino.origin + '", distinto a la dirección desde la que estás trabajando (' + actual.origin + '). Verifica FRONTEND_URL en el backend.';
    }
  } catch (e) {
    return '';
  }
  return '';
});

const dialogPlantilla = ref(false);
const guardandoPlantilla = ref(false);
const errorPlantilla = ref(null);
const encuestaPlantilla = ref(null);
const plantillaForm = ref({ name: '', description: '', is_public: false, survey_category_id: null });
const categoriasPlantilla = ref([]);

async function abrirGuardarPlantilla(survey) {
  encuestaPlantilla.value = survey;
  plantillaForm.value = {
    name: survey.title,
    description: survey.description || '',
    is_public: false,
    survey_category_id: survey.survey_category_id ?? null,
  };
  errorPlantilla.value = null;
  dialogPlantilla.value = true;

  if (!categoriasPlantilla.value.length) {
    try {
      const { data } = await backendApi.get('/survey-categories');
      categoriasPlantilla.value = data;
    } catch {
      /* el select queda vacío; el servidor usa la categoría de la encuesta */
    }
  }
}

async function guardarPlantilla() {
  if (!plantillaForm.value.name.trim()) {
    errorPlantilla.value = 'Escribe un nombre para la plantilla.';
    return;
  }
  if (!plantillaForm.value.survey_category_id) {
  errorPlantilla.value = 'Selecciona una categoría para la plantilla.';
  return;
}

  guardandoPlantilla.value = true;
  errorPlantilla.value = null;

  try {
    const response = await backendApi.post(
      `/surveys/${encuestaPlantilla.value.id}/save-as-template`,
      {
        name: plantillaForm.value.name.trim(),
        description: plantillaForm.value.description?.trim() || null,
        is_public: plantillaForm.value.is_public,
        survey_category_id: plantillaForm.value.survey_category_id,
      }
    );
    alert.success(response.data.message || 'Plantilla guardada correctamente.');
    dialogPlantilla.value = false;
  } catch (e) {
    errorPlantilla.value =
      e.response?.data?.message || 'No se pudo guardar la plantilla.';
  } finally {
    guardandoPlantilla.value = false;
  }
}

const dialogQrParticipante = ref(false);
const participanteQr = ref(null);
const qrParticipanteUrl = ref(null);
const cargandoQrParticipante = ref(false);

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
    incluirSubdependencias.value = false;
    resumenOrganizacion.value = null;
    await cargarParticipantes(survey.id);
    cargarResumenOrganizacion();
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

function liberarQrPrevio() {
  if (qrImageUrl.value) {
    URL.revokeObjectURL(qrImageUrl.value);
    qrImageUrl.value = null;
  }
  qrPublicUrl.value = '';
}

async function cargarQr(surveyId) {
  cargandoQr.value = true;
  liberarQrPrevio();
  try {
    const response = await backendApi.get(`/surveys/${surveyId}/qr-code/image`, {
      responseType: 'blob',
    });
    qrImageUrl.value = URL.createObjectURL(response.data);

    const info = await backendApi.get(`/surveys/${surveyId}/qr-code`);
    qrPublicUrl.value = info.data.public_url;
  } catch (e) {
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

async function copiarAlPortapapeles(texto) {
  try {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(texto);
    } else {
      const area = document.createElement('textarea');
      area.value = texto;
      area.style.position = 'fixed';
      area.style.opacity = '0';
      document.body.appendChild(area);
      area.select();
      document.execCommand('copy');
      area.remove();
    }
    alert.success('Enlace copiado al portapapeles.');
  } catch (e) {
    alert.error('No se pudo copiar el enlace.');
  }
}

function descargarQrPng(svgUrl, nombreArchivo) {
  const img = new Image();
  img.onload = () => {
    const tamano = 1024;
    const canvas = document.createElement('canvas');
    canvas.width = tamano;
    canvas.height = tamano;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, tamano, tamano);
    ctx.drawImage(img, 0, 0, tamano, tamano);
    canvas.toBlob((blob) => {
      if (!blob) {
        alert.error('No se pudo generar la imagen PNG.');
        return;
      }
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = nombreArchivo;
      document.body.appendChild(link);
      link.click();
      link.remove();
      URL.revokeObjectURL(url);
    }, 'image/png');
  };
  img.onerror = () => alert.error('No se pudo generar la imagen PNG.');
  img.src = svgUrl;
}

async function abrirQrParticipante(participante) {
  participanteQr.value = participante;
  dialogQrParticipante.value = true;
  cargandoQrParticipante.value = true;
  cerrarQrParticipante(false);
  try {
    const response = await backendApi.get(`/participants/${participante.id}/qr-code/image`, {
      responseType: 'blob',
    });
    qrParticipanteUrl.value = URL.createObjectURL(response.data);
  } catch (e) {
    alert.error('No se pudo cargar el código QR del invitado.');
  } finally {
    cargandoQrParticipante.value = false;
  }
}

function cerrarQrParticipante(cerrar = true) {
  if (qrParticipanteUrl.value) {
    URL.revokeObjectURL(qrParticipanteUrl.value);
    qrParticipanteUrl.value = null;
  }
  if (cerrar === true) {
    dialogQrParticipante.value = false;
  }
}

onMounted(async () => {
  await Promise.all([cargarDependencias(), cargarEncuestas()]);
});
</script>

<style scoped>
.surveys-page {
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

/* ============================================= */
/* TÍTULOS DE SECCIÓN CON ACENTO                  */
/* ============================================= */
.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: Poppins;
  font-weight: 600;
  font-size: 14px;
  color: #313845;
  margin-bottom: 14px;
}

.section-title::before {
  content: "";
  width: 3px;
  height: 14px;
  border-radius: 2px;
  background: #4880FF;
}

/* ============================================= */
/* KPI GRID / CARDS                               */
/* ============================================= */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.kpi-card {
  position: relative;
  border: 1px solid #E3EBF5;
  border-radius: 8px;
  padding: 16px 18px 14px;
  background: #ffffff;
  overflow: hidden;
  transition: box-shadow 0.22s ease, transform 0.22s ease;
}

.kpi-card:hover {
  box-shadow: 0 6px 16px rgba(72, 128, 255, 0.10);
  transform: translateY(-1px);
}

.kpi-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
}

.kpi-card--primary::before { background: #4880FF; }
.kpi-card--success::before { background: #2FB56B; }
.kpi-card--accent::before  { background: #2D52A7; }
.kpi-card--muted::before   { background: #D9D9D9; }

.kpi-card__icon {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background: #E9EDFD;
  color: #063456;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.kpi-card--success .kpi-card__icon {
  background: #E4F7EC;
  color: #1F8F51;
}

.kpi-card--accent .kpi-card__icon {
  background: #E4EAF7;
  color: #2D52A7;
}

.kpi-card--muted .kpi-card__icon {
  background: #F1F3F6;
  color: #6b7986;
}

.kpi-card__value {
  font-family: Poppins;
  font-weight: 700;
  font-size: 26px;
  color: #063456;
  line-height: 1;
  margin-bottom: 4px;
}

.kpi-card__label {
  font-size: 11px;
  font-weight: 500;
  color: #6b7986;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

/* ============================================= */
/* FILTROS                                        */
/* ============================================= */
.filter-card {
  border: 1px solid #E3EBF5;
  background: #ffffff;
  border-radius: 8px;
}

.filter-col-search {
  min-width: 0;
}

/* Input de búsqueda con fondo azul claro */
.filter-control :deep(.v-field) {
  background-color: #F4F7FE !important;
  border-radius: 6px !important;
}

.filter-control :deep(.v-field--variant-outlined .v-field__outline) {
  display: none;
}

.filter-control :deep(.v-field__input) {
  min-height: 32px !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}

/* Layout de acciones de filtro */
.filter-actions {
  gap: 14px;
}

.quick-filters {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* Botones de filtro */
.filter-btn,
.quick-filter-btn {
  height: 36px !important;
  border-radius: 6px !important;
  background-color: #ffffff !important;
  box-shadow: none !important;
  border: 1px solid #D9E2F0 !important;
  font-family: Poppins;
  font-size: 11px !important;
  font-weight: 500 !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
  padding: 0 14px !important;
  min-width: 90px !important;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #374957 !important;
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}

.filter-btn .v-icon,
.quick-filter-btn .v-icon {
  color: #374957 !important;
}

.filter-btn:hover,
.quick-filter-btn:hover {
  background-color: #F0F4FB !important;
  border-color: #4880FF !important;
}

.quick-filter-btn--active {
  background-color: #4880FF !important;
  border-color: #4880FF !important;
  color: #ffffff !important;
}

.quick-filter-btn--active .v-icon {
  color: #ffffff !important;
}

.quick-filter-btn--active:hover {
  background-color: #2D52A7 !important;
  border-color: #2D52A7 !important;
}

/* ============================================= */
/* TABLA                                          */
/* ============================================= */
.table-card {
  border: 1px solid #E3EBF5;
  background: #ffffff;
  border-radius: 8px;
  overflow: hidden;
}

.survey-table :deep(th) {
  background: #F8FAFF;
  font-family: Poppins;
  font-weight: 600;
  font-size: 11px;
  color: #313845;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #E3EBF5 !important;
}

.survey-table :deep(th),
.survey-table :deep(td) {
  white-space: nowrap;
}

.survey-table :deep(.v-table__wrapper) {
  overflow-x: auto;
}

.survey-table :deep(tbody tr) {
  transition: background-color 0.15s ease;
}

.survey-table :deep(tbody tr:hover) {
  background-color: #F8FAFF;
}

.col-nombre {
  max-width: 320px;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ============================================= */
/* BOTONES DE ESTADO                              */
/* ============================================= */
.estado-btn {
  height: 23px !important;
  min-width: 90px !important;
  padding: 0 8px !important;
  border-radius: 6px !important;
  font-size: 10px !important;
  font-weight: 500 !important;
  text-transform: none !important;
  text-align: left;
  letter-spacing: 0 !important;
  white-space: nowrap;
  background-color: #F4F6FD !important;
  color: #313845 !important;
  border: 1px solid #D2D9DD;
  display: inline-flex;
  align-items: center;
  justify-content: flex-start !important;
}

.estado-btn :deep(.v-btn__content) {
  justify-content: flex-start;
  width: 100%;
}

.estado-btn :deep(.v-btn__content)::before {
  content: '';
  display: inline-block;
  width: 7px;
  height: 7px;
  margin-right: 6px;
  border-radius: 50%;
  background-color: #D9D9D9;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.12);
}

.estado-btn--published :deep(.v-btn__content)::before { background-color: #9EF18D; }
.estado-btn--scheduled :deep(.v-btn__content)::before { background-color: #F1B550; }
.estado-btn--closed :deep(.v-btn__content)::before,
.estado-btn--rejected :deep(.v-btn__content)::before { background-color: #E42716; }

.estado-btn--review :deep(.v-btn__content)::before,
.estado-btn--needs_correction :deep(.v-btn__content)::before,
.estado-btn--paused :deep(.v-btn__content)::before { background-color: #4880FF; }

.estado-btn--approved :deep(.v-btn__content)::before { background-color: #2D52A7; }

.estado-btn--draft :deep(.v-btn__content)::before,
.estado-btn--archived :deep(.v-btn__content)::before,
.estado-btn--default :deep(.v-btn__content)::before { background-color: #D9D9D9; }
.estado-btn--published_waiting :deep(.v-btn__content)::before { background-color: #4880FF; }

/* ============================================= */
/* ÍCONOS DE ACCIONES                             */
/* ============================================= */
.action-icon-btn {
  color: #374957 !important;
  background-color: transparent !important;
  box-shadow: none !important;
}

.action-icon-btn.v-btn--disabled {
  color: #B0B8C1 !important;
  opacity: 1 !important;
}

/* ============================================= */
/* PAGINACIÓN                                     */
/* ============================================= */
.pagination-footer {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 8px 4px 0;
}

/* ============================================= */
/* RESPONSIVE                                     */
/* ============================================= */
@media (max-width: 600px) {
  .hero__content {
    padding: 22px 20px 20px;
  }
  .hero__title {
    font-size: 24px;
  }
  .pagination-footer {
    justify-content: center;
  }
}
</style>

<!-- ============================================================
     MENÚ DE ACCIONES (v-menu) — azul claro translúcido
     Va SIN scoped porque el menú se dibuja fuera del componente
     ============================================================ -->
<style>
.acciones-menu .v-list {
  background:
    linear-gradient(rgba(72, 128, 255, 0.14), rgba(72, 128, 255, 0.14)),
    rgba(255, 255, 255, 0.88) !important;
  backdrop-filter: blur(8px);
  border: 1px solid rgba(72, 128, 255, 0.35);
  border-radius: 7px;
  padding: 4px;
}

.acciones-menu .v-list-item {
  min-height: 34px;
  border-radius: 4px;
  color: #2D52A7;
}

.acciones-menu .v-list-item:hover {
  background: rgba(72, 128, 255, 0.22);
}

.acciones-menu .v-list-item-title {
  font-family: 'Poppins', sans-serif;
  font-size: 12px;
  font-weight: 500;
  line-height: 1.2;
}

.acciones-menu .v-list-item .v-icon {
  font-size: 16px;
  opacity: 1;
}

.acciones-menu .v-list-item__spacer {
  width: 10px !important;
}

.acciones-menu .v-divider {
  border-color: rgba(72, 128, 255, 0.35);
  opacity: 1;
}

.acciones-menu .v-list-item.text-error {
  color: #E42716 !important;
}
</style>