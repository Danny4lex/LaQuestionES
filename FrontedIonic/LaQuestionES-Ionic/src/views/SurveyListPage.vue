<template>
  <ion-page>
    <ion-content class="survey-page-content" :fullscreen="true">
      <!--Pull to Refresh-->
      <ion-refresher slot="fixed" @ionRefresh="handleRefresh($event)">
        <ion-refresher-content
          pulling-icon="chevron-down-outline"
          pulling-text="Desliza para actualizar"
          refreshing-spinner="crescent"
        />
      </ion-refresher>

      <!---Header Hero-->
      <div class="hero-banner">
        <div class="hero-content">
          <div class="hero-badge">
            <ion-icon :icon="shieldCheckmarkOutline" class="badge-icon" />
            <span>Participación Ciudadana</span>
          </div>
          <h1 class="hero-title">Encuestas Públicas</h1>
          <p class="hero-sub">
            Explora y participa en las encuestas públicas disponibles. Tu
            opinión es valiosa para mejorar los servicios y la toma de
            decisiones.
          </p>
        </div>
      </div>

      <!-- Contenedor Principal -->
      <div class="mobile-container">
        <!-- Métricas Rápidas Minimalistas (Interactivas para filtrar) -->
        <div class="metrics-grid">
          <div
            :class="[
              'metric-card',
              { 'metric-card--selected': statusFilter === 'open' },
            ]"
            @click="statusFilter = 'open'"
          >
            <div class="metric-icon-box metric-icon-box--open">
              <ion-icon :icon="checkmarkCircleOutline" />
            </div>
            <div class="metric-info">
              <div class="metric-number-row">
                <span class="metric-number">{{ countOpen }}</span>
                <span class="pulse-indicator"></span>
              </div>
              <span class="metric-label">Activas</span>
            </div>
          </div>

          <div
            :class="[
              'metric-card',
              { 'metric-card--selected': statusFilter === 'completed' },
            ]"
            @click="statusFilter = 'completed'"
          >
            <div class="metric-icon-box metric-icon-box--completed">
              <ion-icon :icon="checkmarkDoneCircleOutline" />
            </div>
            <div class="metric-info">
              <span class="metric-number">{{ countCompleted }}</span>
              <span class="metric-label">Realizadas</span>
            </div>
          </div>
        </div>

        <!-- Buscador estilizado con icono minimalista -->
        <div class="search-wrapper">
          <div class="search-input-box">
            <ion-icon :icon="searchOutline" class="search-icon" />
            <input
              v-model="search"
              type="text"
              placeholder="Buscar por título, tema o dependencia..."
              class="minimal-input"
            />
            <button
              v-if="search"
              class="clear-btn"
              @click="search = ''"
              aria-label="Limpiar búsqueda"
            >
              <ion-icon :icon="closeCircleOutline" />
            </button>
          </div>
        </div>

        <!-- Barra de herramientas: Filtros y Botón Actualizar -->
        <div class="filter-bar">
          <div class="filter-scroll-wrapper">
            <button
              :class="[
                'filter-chip',
                'filter-chip--active',
                { active: statusFilter === 'open' },
              ]"
              @click="statusFilter = 'open'"
            >
              <span class="status-dot"></span>
              <span>Activas</span>
              <span class="chip-count">{{ countOpen }}</span>
            </button>

            <button
              :class="[
                'filter-chip',
                { active: statusFilter === 'completed' },
              ]"
              @click="statusFilter = 'completed'"
            >
              <ion-icon :icon="checkmarkDoneOutline" class="chip-icon" />
              <span>Realizadas</span>
              <span class="chip-count">{{ countCompleted }}</span>
            </button>
          </div>

          <button
            class="refresh-icon-btn"
            :class="{ 'is-loading': loading }"
            @click="cargarEncuestas"
            title="Actualizar listado"
          >
            <ion-icon :icon="refreshOutline" />
          </button>
        </div>

        <!-- Mensaje de Error con botón de reintento -->
        <div v-if="error && statusFilter === 'open'" class="error-banner">
          <ion-icon :icon="alertCircleOutline" class="error-icon" />
          <div class="error-body">
            <p>{{ error }}</p>
            <button class="retry-btn" @click="cargarEncuestas">
              Reintentar
            </button>
          </div>
        </div>

        <!-- Skeleton Loading elegante -->
        <div
          v-if="statusFilter === 'open' && loading && !surveys.length"
          class="skeleton-list"
        >
          <div v-for="n in 3" :key="n" class="skeleton-card">
            <div class="skeleton-line skeleton-title"></div>
            <div class="skeleton-line skeleton-desc"></div>
            <div class="skeleton-line skeleton-meta"></div>
          </div>
        </div>

        <!-- ================= Listado de Tarjetas Minimalistas ================= -->
        <div v-else-if="filtered.length" class="survey-list">
          <div
            v-for="s in filtered"
            :key="s.id"
            class="survey-card"
            :class="{
              'survey-card--open': statusFilter === 'open',
              'survey-card--completed': statusFilter === 'completed',
            }"
            @click="abrir(s)"
          >
            <!-- Cabecera de la tarjeta -->
            <div class="card-top">
              <h2 class="card-title">{{ getSurveyTitle(s) }}</h2>
              <span
                v-if="statusFilter === 'completed'"
                class="status-pill-badge status-pill--completed"
              >
                <span class="pill-dot pill-dot--completed"></span>
                Realizada
              </span>
              <span
                v-else
                :class="['status-pill-badge', getStatusBadgeClass(s)]"
              >
                <span class="pill-dot" v-if="isSurveyOpen(s)"></span>
                {{ s.status?.name || s.status || "Activa" }}
              </span>
            </div>

            <!-- Descripción (máximo 2 líneas) -->
            <p class="card-desc">
              {{
                s.description ||
                "Sin descripción disponible para esta encuesta."
              }}
            </p>

            <!-- Metadatos con Iconos Minimalistas -->
            <div class="card-meta-row">
              <span
                class="meta-item"
                v-if="s.department?.name"
                :title="s.department.name"
              >
                <ion-icon :icon="businessOutline" class="meta-icon" />
                <span class="meta-text">{{ s.department.name }}</span>
              </span>

              <span class="meta-item" v-if="getQuestionsCount(s)">
                <ion-icon :icon="documentTextOutline" class="meta-icon" />
                <span class="meta-text"
                  >{{ getQuestionsCount(s) }} preguntas</span
                >
              </span>

              <span class="meta-item time-tag" v-if="getQuestionsCount(s)">
                <ion-icon :icon="timeOutline" class="meta-icon" />
                <span class="meta-text">~{{ getEstimatedMinutes(s) }} min</span>
              </span>

              <span
                v-if="statusFilter === 'completed' && s._completedAt"
                class="meta-item completed-tag"
              >
                <ion-icon :icon="checkmarkDoneOutline" class="meta-icon" />
                <span class="meta-text"
                  >Realizada el {{ formatCompletedDate(s._completedAt) }}</span
                >
              </span>
              <span
                v-else-if="statusFilter === 'open' && isSurveyCompleted(s.id)"
                class="meta-item completed-tag"
              >
                <ion-icon :icon="checkmarkDoneOutline" class="meta-icon" />
                <span class="meta-text">Ya realizada</span>
              </span>
            </div>

            <!-- Botón de Acción -->
            <div class="card-action">
              <ion-button
                v-if="statusFilter === 'open'"
                expand="block"
                class="btn-vue-primary action-button"
                @click.stop="abrir(s)"
              >
                <span>Responder encuesta</span>
                <ion-icon :icon="arrowForwardOutline" class="btn-icon" />
              </ion-button>
              <ion-button
                v-else
                expand="block"
                fill="outline"
                class="btn-vue-secondary action-button"
                @click.stop="abrir(s)"
              >
                <span>Ver información</span>
                <ion-icon :icon="eyeOutline" class="btn-icon" />
              </ion-button>
            </div>
          </div>
        </div>

        <!-- Estado vacío -->
        <div
          v-else-if="
            statusFilter === 'completed' || (!loading && !error)
          "
          class="empty-state"
        >
          <template v-if="statusFilter === 'completed' && countCompleted === 0">
            <ion-icon
              :icon="checkmarkDoneCircleOutline"
              class="empty-icon empty-icon--completed"
            />
            <h3 class="empty-title">No has realizado ninguna encuesta</h3>
            <p class="empty-text">
              Cuando completes una encuesta activa, quedará guardada aquí.
            </p>
            <button class="reset-filter-btn" @click="goToActiveSurveys">
              Explorar encuestas activas
            </button>
          </template>

          <template v-else-if="statusFilter === 'completed'">
            <ion-icon :icon="searchOutline" class="empty-icon" />
            <h3 class="empty-title">Sin resultados</h3>
            <p class="empty-text">
              No encontramos encuestas realizadas con ese criterio de búsqueda.
            </p>
            <button class="reset-filter-btn" @click="search = ''">
              Limpiar búsqueda
            </button>
          </template>

          <template v-else-if="countOpen === 0">
            <ion-icon :icon="documentTextOutline" class="empty-icon" />
            <h3 class="empty-title">Sin encuestas activas</h3>
            <p class="empty-text">
              No hay encuestas activas disponibles en este momento.
            </p>
            <button class="reset-filter-btn" @click="cargarEncuestas">
              Actualizar
            </button>
          </template>

          <template v-else>
            <ion-icon :icon="searchOutline" class="empty-icon" />
            <h3 class="empty-title">Sin resultados</h3>
            <p class="empty-text">
              No encontramos encuestas activas con ese criterio de búsqueda.
            </p>
            <button class="reset-filter-btn" @click="search = ''">
              Limpiar búsqueda
            </button>
          </template>
        </div>

        <!-- Footer sutil institucional -->
        <div class="app-footer">
          <p class="footer-text">
            LaQuestionES - Sistema de Gestión de Encuestas
          </p>
        </div>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import {
  IonPage,
  IonContent,
  IonButton,
  IonIcon,
  IonRefresher,
  IonRefresherContent,
  onIonViewWillEnter,
} from "@ionic/vue";
import {
  searchOutline,
  timeOutline,
  businessOutline,
  documentTextOutline,
  arrowForwardOutline,
  alertCircleOutline,
  shieldCheckmarkOutline,
  checkmarkCircleOutline,
  checkmarkDoneOutline,
  checkmarkDoneCircleOutline,
  refreshOutline,
  closeCircleOutline,
  eyeOutline,
} from "ionicons/icons";
import {
  listarEncuestas,
  unwrapList,
  getSurveyTitle,
} from "../services/surveyApi";
import {
  getCompletedSurveys,
  isSurveyCompleted,
  reloadCompletedSurveys,
  formatCompletedDate,
} from "../utils/completedSurveys";

const router = useRouter();
const surveys = ref([]);
const search = ref("");
const statusFilter = ref("open");
const loading = ref(false);
const error = ref("");

function isSurveyOpen(s) {
  const slug = String(s.status?.slug || s.status || "").toLowerCase();
  const name = String(s.status?.name || "").toLowerCase();
  return slug === "published" || name.includes("activa");
}

const activeSurveys = computed(() => surveys.value.filter(isSurveyOpen));

const completedSurveyItems = computed(() => {
  const byId = new Map(surveys.value.map((s) => [String(s.id), s]));

  return getCompletedSurveys().map((entry) => {
    const live = byId.get(String(entry.id));
    if (live) {
      return {
        ...live,
        _completedAt: entry.completedAt,
        _timesCompleted: entry.timesCompleted || 1,
      };
    }
    return {
      id: entry.id,
      title: entry.title,
      description: entry.description,
      department: entry.department,
      category: entry.category,
      status: entry.status || { name: "Realizada", slug: "completed" },
      questions_count: entry.questions_count || 0,
      is_single_response: entry.is_single_response,
      _completedAt: entry.completedAt,
      _timesCompleted: entry.timesCompleted || 1,
    };
  });
});

const countOpen = computed(() => activeSurveys.value.length);
const countCompleted = computed(() => completedSurveyItems.value.length);

const filtered = computed(() => {
  const source =
    statusFilter.value === "completed"
      ? completedSurveyItems.value
      : activeSurveys.value;

  const term = search.value.toLowerCase().trim();
  if (!term) return source;

  return source.filter((s) => {
    const title = getSurveyTitle(s).toLowerCase();
    const desc = (s.description || "").toLowerCase();
    const dept = (s.department?.name || "").toLowerCase();
    const cat = (s.category?.name || "").toLowerCase();
    return (
      title.includes(term) ||
      desc.includes(term) ||
      dept.includes(term) ||
      cat.includes(term)
    );
  });
});

function getQuestionsCount(s) {
  if (Array.isArray(s.sections)) {
    return s.sections.reduce(
      (acc, sec) => acc + (sec.questions_count || sec.questions?.length || 0),
      0,
    );
  }
  return s.questions_count || 0;
}

function getEstimatedMinutes(s) {
  const count = getQuestionsCount(s);
  return Math.max(1, Math.ceil(count * 0.6));
}

function getStatusBadgeClass(s) {
  const slug = String(s.status?.slug || s.status || "").toLowerCase();
  const name = String(s.status?.name || "").toLowerCase();
  if (slug === "published" || name.includes("activa"))
    return "status-pill--active";
  if (slug === "approved" || name.includes("aprobada"))
    return "status-pill--approved";
  if (slug === "review" || name.includes("revis")) return "status-pill--review";
  return "status-pill--closed";
}

function goToActiveSurveys() {
  search.value = "";
  statusFilter.value = "open";
}

async function cargarEncuestas() {
  loading.value = true;
  error.value = "";
  try {
    const data = await listarEncuestas();
    surveys.value = unwrapList(data);
  } catch (e) {
    console.error("Error al cargar encuestas:", e);
    error.value =
      e.response?.data?.message ||
      `No se pudo cargar el listado. Comprueba tu conexión con el backend.`;
  } finally {
    loading.value = false;
  }
}

async function handleRefresh(event) {
  try {
    reloadCompletedSurveys();
    const data = await listarEncuestas();
    surveys.value = unwrapList(data);
  } catch (e) {
    console.error("Error al refrescar:", e);
  } finally {
    event.target.complete();
  }
}

function abrir(s) {
  if (s?.id != null) {
    router.push(`/encuestas/${s.id}`);
  }
}

onMounted(() => {
  reloadCompletedSurveys();
  cargarEncuestas();
});

onIonViewWillEnter(() => {
  reloadCompletedSurveys();
  if (surveys.value.length === 0) {
    cargarEncuestas();
  }
});
</script>

<style scoped>
.survey-page-content {
  --background: #f4f6fd;
}

/* ================= Hero Banner Compacto ================= */
.hero-banner {
  background: linear-gradient(135deg, #1c8686 0%, #157373 100%);
  padding: 18px 16px 22px;
  color: #ffffff;
  border-bottom: 2px solid #1dafaf;
}

.hero-content {
  max-width: 600px;
  margin: 0 auto;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  background: rgba(145, 237, 237, 0.15);
  color: #91eded;
  font-size: 10.5px;
  font-weight: 600;
  padding: 3px 9px;
  border-radius: 12px;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  margin-bottom: 6px;
  border: 1px solid rgba(145, 237, 237, 0.25);
}

.badge-icon {
  font-size: 12px;
}

.hero-title {
  color: #ffffff;
  font-size: 22px;
  font-weight: 700;
  margin: 0 0 4px 0;
  line-height: 1.2;
  letter-spacing: -0.2px;
}

.hero-sub {
  color: #e0f2fe;
  font-size: 12.5px;
  line-height: 1.4;
  margin: 0;
  opacity: 0.92;
}

/* ================= Contenedor Móvil ================= */
.mobile-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 12px 14px 40px;
}

/* ================= Métricas Rápidas Minimalistas ================= */
.metrics-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  margin-bottom: 12px;
}

.metric-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 10px 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  border: 1px solid #e2e8f0;
  box-shadow: 0 1px 4px rgba(28, 134, 134, 0.04);
  cursor: pointer;
  transition: all 0.15s ease;
}

.metric-card:active {
  transform: scale(0.96);
}

.metric-card--selected {
  border-color: #1dafaf;
  background: #f0fdfa;
  box-shadow: 0 2px 8px rgba(29, 175, 175, 0.15);
}

.metric-icon-box {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  margin-bottom: 6px;
}

.metric-icon-box--open {
  background: #ecfdf5;
  color: #059669;
}

.metric-icon-box--completed {
  background: #f0fdfa;
  color: #1c8686;
}

.metric-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  width: 100%;
}

.metric-number-row {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.metric-number {
  font-size: 17px;
  font-weight: 700;
  color: #235454;
  line-height: 1.15;
}

.pulse-indicator {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #10b981;
  animation: pulse-glow 2s infinite ease-in-out;
}

.metric-label {
  font-size: 11px;
  font-weight: 500;
  color: #64748b;
  line-height: 1.2;
  text-align: center;
}

/* ================= Buscador Minimalista ================= */
.search-wrapper {
  margin-bottom: 10px;
}

.search-input-box {
  display: flex;
  align-items: center;
  background: #ffffff;
  border: 1px solid #d2d9dd;
  border-radius: 10px;
  padding: 0 12px;
  height: 42px;
  box-shadow: 0 2px 6px rgba(28, 134, 134, 0.04);
  transition:
    border-color 0.2s ease,
    box-shadow 0.2s ease;
}

.search-input-box:focus-within {
  border-color: #1dafaf;
  box-shadow: 0 0 0 3px rgba(29, 175, 175, 0.15);
}

.search-icon {
  font-size: 18px;
  color: #1c8686;
  margin-right: 8px;
  flex-shrink: 0;
}

.minimal-input {
  border: none;
  background: transparent;
  width: 100%;
  font-size: 13.5px;
  font-family: inherit;
  color: #1e293b;
  outline: none;
}

.minimal-input::placeholder {
  color: #94a3b8;
  font-size: 13px;
}

.clear-btn {
  background: transparent;
  border: none;
  color: #94a3b8;
  font-size: 14px;
  cursor: pointer;
  padding: 4px;
}

/* ================= Barra de Filtro y Refresco ================= */
.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 12px;
}

.filter-scroll-wrapper {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  flex: 1;
}

.filter-scroll-wrapper::-webkit-scrollbar {
  display: none;
}

.refresh-icon-btn {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: #ffffff;
  border: 1px solid #d2d9dd;
  color: #1c8686;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  cursor: pointer;
  flex-shrink: 0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
  transition: all 0.2s ease;
}

.refresh-icon-btn:active {
  transform: scale(0.92);
}

.refresh-icon-btn.is-loading ion-icon {
  animation: spin 1s infinite linear;
}

@keyframes spin {
  100% {
    transform: rotate(360deg);
  }
}

.filter-chip {
  flex-shrink: 0;
  border: 1px solid #d2d9dd;
  background: #ffffff;
  color: #475569;
  padding: 6px 14px;
  border-radius: 50px;
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
  transition: all 0.15s ease;
  font-family: inherit;
  cursor: pointer;
}

.chip-icon {
  font-size: 14px;
}

.chip-count {
  font-size: 11px;
  font-weight: 700;
  background: #f1f5f9;
  color: #64748b;
  padding: 1px 7px;
  border-radius: 10px;
  margin-left: 2px;
}

.filter-chip.active {
  background: #1c8686;
  color: #ffffff;
  border-color: #1c8686;
  box-shadow: 0 2px 8px rgba(28, 134, 134, 0.25);
}

.filter-chip.active .chip-count {
  background: rgba(255, 255, 255, 0.25);
  color: #ffffff;
}

.status-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #10b981;
}

.filter-chip.active .status-dot {
  background: #9ef18d;
}

/* ================= Tarjetas de Encuesta ================= */
.survey-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.survey-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 15px 16px;
  box-shadow: 0 2px 10px rgba(28, 134, 134, 0.05);
  border: 1px solid #d2d9dd;
  border-left: 4px solid #cbd5e1;
  transition:
    transform 0.1s ease,
    box-shadow 0.1s ease;
  cursor: pointer;
}

.survey-card:active {
  transform: scale(0.985);
}

.survey-card--open {
  border-left: 4px solid #1dafaf;
}

.survey-card--completed {
  border-left: 4px solid #10b981;
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 10px;
  margin-bottom: 6px;
}

.card-title {
  margin: 0;
  font-size: 15.5px;
  font-weight: 700;
  color: #235454;
  line-height: 1.3;
  flex: 1;
}

/* Insignias de Estado */
.status-pill-badge {
  font-size: 10.5px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 6px;
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.pill-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #15803d;
}

.status-pill--active {
  background: #9ef18d;
  color: #14532d;
}

.status-pill--approved {
  background: #dbeafe;
  color: #1e40af;
}

.status-pill--review {
  background: #fef3c7;
  color: #92400e;
}

.status-pill--closed {
  background: #f1f5f9;
  color: #64748b;
}

.status-pill--completed {
  background: #dcfce7;
  color: #166534;
}

.pill-dot--completed {
  background: #16a34a;
}

/* Descripción */
.card-desc {
  margin: 0 0 12px 0;
  font-size: 13px;
  line-height: 1.45;
  color: #475569;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Fila de Metadatos */
.card-meta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 11.5px;
  color: #475569;
  background: #f4f6fd;
  border: 1px solid #e2e8f0;
  padding: 3px 8px;
  border-radius: 6px;
  max-width: 100%;
}

.meta-icon {
  font-size: 13px;
  color: #1c8686;
  flex-shrink: 0;
}

.meta-text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.time-tag {
  color: #0369a1;
  background: #f0f9ff;
  border-color: #bae6fd;
}

.time-tag .meta-icon {
  color: #0284c7;
}

.completed-tag {
  color: #166534;
  background: #f0fdf4;
  border-color: #bbf7d0;
}

.completed-tag .meta-icon {
  color: #16a34a;
}

/* Botón de acción */
.card-action {
  border-top: 1px solid #f1f5f9;
  padding-top: 8px;
}

.action-button {
  --min-height: 40px;
  font-size: 13.5px;
  margin: 0;
}

.btn-icon {
  font-size: 15px;
  margin-left: 6px;
}

/* ================= Skeleton Loading ================= */
.skeleton-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.skeleton-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #e2e8f0;
}

.skeleton-line {
  background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}

.skeleton-title {
  height: 18px;
  width: 65%;
  margin-bottom: 10px;
}

.skeleton-desc {
  height: 12px;
  width: 90%;
  margin-bottom: 12px;
}

.skeleton-meta {
  height: 24px;
  width: 45%;
}

@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

/* ================= Estado Vacío ================= */
.empty-state {
  background: #ffffff;
  border-radius: 12px;
  padding: 36px 16px;
  text-align: center;
  border: 1px solid #d2d9dd;
  margin-top: 12px;
}

.empty-icon {
  font-size: 38px;
  color: #94a3b8;
  margin-bottom: 6px;
}

.empty-icon--completed {
  color: #1dafaf;
}

.empty-title {
  font-size: 16px;
  font-weight: 700;
  color: #235454;
  margin: 0 0 4px 0;
}

.empty-text {
  font-size: 13px;
  color: #64748b;
  margin: 0 0 16px 0;
}

.reset-filter-btn {
  background: #f4f6fd;
  color: #1c8686;
  border: 1px solid #1dafaf;
  padding: 7px 16px;
  border-radius: 50px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
}

/* ================= Footer ================= */
.app-footer {
  text-align: center;
  padding: 28px 16px 10px;
}

.footer-text {
  font-size: 11.5px;
  font-weight: 600;
  color: #64748b;
  margin: 0 0 2px 0;
}

.footer-sub {
  font-size: 10.5px;
  color: #94a3b8;
  margin: 0;
}

/* ================= Error Banner ================= */
.error-banner {
  background: #fef2f2;
  color: #991b1b;
  padding: 12px 14px;
  border-radius: 8px;
  margin-bottom: 14px;
  border-left: 4px solid #e42716;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.error-icon {
  font-size: 20px;
  color: #e42716;
  flex-shrink: 0;
}

.error-body {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.error-body p {
  margin: 0;
}

.retry-btn {
  background: #e42716;
  color: #ffffff;
  border: none;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  margin-left: 8px;
  cursor: pointer;
}
</style>
