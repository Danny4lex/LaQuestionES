<template>
  <div class="dashboard-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero" :class="heroClase('dashboard')">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <span class="hero__eyebrow">Panel principal</span>
          <h1 class="text-page-title hero__title">
            Hola, {{ nombreUsuario }}
          </h1>
          <p class="text-subtitle hero__subtitle">
            Resumen general del sistema de encuestas institucionales
          </p>
        </div>

        <div class="hero__actions">
          <v-btn
            
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

    <!-- ================= Filtros ================= -->
    <v-card class="filter-card mb-5" variant="flat">
      <v-card-text class="pa-5">
        <div class="section-title">
          <v-icon size="16" color="#4880FF">mdi-filter-variant</v-icon>
          Filtros
        </div>

        <v-row dense align="center">
          <v-col cols="12" sm="6" md="3">
            <v-text-field
              v-model="filtros.start_date"
              type="date"
              label="Desde"
              variant="outlined"
              density="compact"
              hide-details
            />
          </v-col>
          <v-col cols="12" sm="6" md="3">
            <v-text-field
              v-model="filtros.end_date"
              type="date"
              label="Hasta"
              variant="outlined"
              density="compact"
              hide-details
            />
          </v-col>
          <v-col cols="12" sm="6" md="2">
            <v-select
              v-model="filtros.dependency_id"
              :items="opcionesDependencia"
              item-title="name"
              item-value="id"
              label="Dependencia"
              variant="outlined"
              density="compact"
              clearable
              hide-details
            />
          </v-col>
          <v-col cols="12" sm="6" md="2">
            <v-select
              v-model="filtros.survey_category_id"
              :items="opcionesCategoria"
              item-title="name"
              item-value="id"
              label="Categoría"
              variant="outlined"
              density="compact"
              clearable
              hide-details
            />
          </v-col>
          <v-col cols="12" md="2" class="d-flex justify-end" style="gap: 12px;">
            <v-btn
              color="primary"
              size="small"
              variant="flat"
              :loading="cargando"
              @click="cargarDashboard"
              title="Aplicar filtros"
            >
              <v-icon start size="16">mdi-magnify</v-icon>
              Aplicar
            </v-btn>
            <v-btn
              size="small"
              variant="outlined"
              @click="limpiarFiltros"
              title="Limpiar filtros"
            >
              <v-icon size="16">mdi-filter-off-outline</v-icon>
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- ================= Indicadores (KPI Grid) ================= -->
    <div class="section-title">Indicadores</div>
    <div class="kpi-grid mb-6">
      <div class="kpi-card kpi-card--primary">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-file-document-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.total_surveys }}</div>
        <div class="kpi-card__label">Total encuestas</div>
      </div>

      <div class="kpi-card kpi-card--success">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-check-circle-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.active_surveys }}</div>
        <div class="kpi-card__label">Activas</div>
      </div>

      <div class="kpi-card kpi-card--accent">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-flag-checkered</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.completed_surveys }}</div>
        <div class="kpi-card__label">Finalizadas</div>
      </div>

      <div class="kpi-card kpi-card--primary">
        <div class="kpi-card__icon">
          <v-icon size="20">mdi-account-group-outline</v-icon>
        </div>
        <div class="kpi-card__value">{{ cards.total_responses }}</div>
        <div class="kpi-card__label">Total respuestas</div>
      </div>
    </div>

    <!-- ================= Gráficos ================= -->
    <div class="section-title">Analítica</div>
    <v-row dense class="mb-4">
      <v-col cols="12" md="6">
        <div class="chart-card">
          <LineChart :labels="lineLabels" :values="lineValues" />
        </div>
      </v-col>
      <v-col cols="12" md="6">
        <div class="chart-card">
          <DonutChart :labels="donutLabels" :values="donutValues" />
        </div>
      </v-col>
    </v-row>

    <v-row dense>
      <v-col cols="12">
        <div class="chart-card">
          <RankingList :items="topSurveys" />
        </div>
      </v-col>
      <v-col cols="12" md="6">
        <div class="chart-card">
          <BarChart :labels="barLabels" :values="barValues" />
        </div>
      </v-col>
      <v-col cols="12" md="6">
        <div class="chart-card">
          <RecentSurveys :surveys="latestSurveys" />
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import LineChart from "@/components/charts/LineChart.vue";
import DonutChart from "@/components/charts/DonutChart.vue";
import BarChart from "@/components/charts/BarChart.vue";
import RankingList from "@/components/charts/RankingList.vue";
import RecentSurveys from "@/components/charts/RecentSurveys.vue";
import backendApi from "@/services/backendApi";
import useAuth from "@/composables/useAuth";
import useHeroStyle from '@/composables/useHeroStyle';

const { heroClase } = useHeroStyle();
const router = useRouter();
const { user } = useAuth();
const nombreUsuario = computed(() => user.value?.name || 'Usuario');

const cards = ref({
  total_surveys: 0,
  active_surveys: 0,
  completed_surveys: 0,
  total_responses: 0,
});
const distribution = ref([]);
const responsesPerDay = ref([]);
const topSurveys = ref([]);
const latestSurveys = ref([]);

const cargando = ref(false);
const filtros = ref({
  start_date: '',
  end_date: '',
  dependency_id: null,
  survey_category_id: null,
});
const opcionesDependencia = ref([]);
const opcionesCategoria = ref([]);

// Computed para props de gráficos
const lineLabels = computed(() =>
  responsesPerDay.value.map(item => item.date)
);
const lineValues = computed(() =>
  responsesPerDay.value.map(item => item.total)
);

const donutLabels = computed(() =>
  distribution.value.map(item => item.type_name)
);
const donutValues = computed(() =>
  distribution.value.map(item => item.total)
);

const barLabels = computed(() =>
  topSurveys.value.map(item => item.title)
);
const barValues = computed(() =>
  topSurveys.value.map(item => item.responses_count)
);

function goToNewSurvey() {
  router.push("/surveys/new/edit");
}

function limpiarFiltros() {
  filtros.value = {
    start_date: '',
    end_date: '',
    dependency_id: null,
    survey_category_id: null,
  };
  cargarDashboard();
}

async function cargarCatalogosFiltro() {
  try {
    // Carga secuencial suave para no congestionar el servidor local
    const dependenciasRes = await backendApi.get('/organizational-units');
    opcionesDependencia.value = dependenciasRes.data;

    const categoriasRes = await backendApi.get('/survey-categories');
    opcionesCategoria.value = categoriasRes.data;
  } catch (error) {
    console.error('Error cargando catálogos de filtro:', error);
  }
}

async function cargarDashboard() {
  cargando.value = true;
  try {
    const params = Object.fromEntries(
      Object.entries(filtros.value).filter(([, value]) => value !== null && value !== '')
    );

    const response = await backendApi.get("/dashboard/summary", { params });
    const data = response.data;

    cards.value = data.cards;
    distribution.value = data.charts.distribution_by_type;
    responsesPerDay.value = data.charts.responses_per_day;
    topSurveys.value = data.charts.top_participated_surveys;
    latestSurveys.value = data.charts.latest_surveys || [];
  } catch (error) {
    console.error("Error cargando dashboard:", error);
  } finally {
    cargando.value = false;
  }
}

onMounted(async () => {
  // Primero se cargan los métricos principales del Dashboard
  await cargarDashboard();
  // Luego se poblan los selects de los filtros
  await cargarCatalogosFiltro();
});
</script>

<style scoped>
.dashboard-page {
  padding-bottom: 32px;
}

/* ============================================= */
/* HERO HEADER                                    */
/* ============================================= */
.hero {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  margin: 32px 0 20px;
  background: linear-gradient(135deg, #EDF2FF 0%, #F4F6FD 60%, #E8F0FB 100%);
  border: 1px solid #E3EBF5;
}

.hero__bg {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 90% -20%, rgba(72, 128, 255, 0.18), transparent 45%),
    radial-gradient(circle at -10% 120%, rgba(72, 128, 255, 0.10), transparent 40%);
  pointer-events: none;
}

.hero__content {
  position: relative;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-end;
  gap: 16px;
  padding: 26px 28px;
}

.hero__text {
  min-width: 0;
}

.hero__eyebrow {
  display: inline-block;
  font-family: Poppins;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #4880FF;
  background: rgba(72, 128, 255, 0.10);
  padding: 4px 10px;
  border-radius: 999px;
  margin-bottom: 10px;
}

.hero__title {
  margin: 0 0 6px 0;
  line-height: 1.15;
  color: #063456;
}

.hero__subtitle {
  margin: 0;
  line-height: 1.4;
  color: #4a5b6b;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
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
/* FILTROS                                        */
/* ============================================= */
.filter-card {
  border: 1px solid #E3EBF5;
  background: #ffffff;
  border-radius: 8px;
}

/* ============================================= */
/* KPI GRID / CARDS                               */
/* ============================================= */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
/* TARJETAS DE GRÁFICOS                           */
/* ============================================= */
.chart-card {
  height: 100%;
  border: 1px solid #E3EBF5;
  border-radius: 8px;
  background: #ffffff;
  padding: 6px;
  transition: box-shadow 0.22s ease;
}

.chart-card:hover {
  box-shadow: 0 4px 14px rgba(72, 128, 255, 0.08);
}
</style>