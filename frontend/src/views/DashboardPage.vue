<template>
  <div>
    <!-- Tarjeta de bienvenida -->
    <v-card color="#2D52A7" class="mt-8 mb-4 rounded-lg" variant="flat">
      <v-card-text class="text-white pa-4">
        <div class="text-subtitle">Hola, Bienvenido</div>
        <div class="text-page-title">{{ nombreUsuario }}</div>
        <div class="text-body-small">
          Resumen general del sistema de encuestas institucionales
        </div>
      </v-card-text>
    </v-card>

    <!-- Filtros -->
    <v-card class="rounded-lg mb-4" variant="flat">
      <v-card-text class="pa-4">
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
          <v-col cols="12" sm="6" md="3">
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
          <v-col cols="12" md="1" class="d-flex ga-2">
            <v-btn color="primary" size="small" variant="flat" :loading="cargando" @click="cargarDashboard" title="Aplicar filtros">
              <v-icon>mdi-magnify</v-icon>
            </v-btn>
            <v-btn size="small" variant="outlined" @click="limpiarFiltros" title="Limpiar filtros">
              <v-icon>mdi-filter-off-outline</v-icon>
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Indicadores -->
    <v-row dense class="mb-4">
      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg kpi-card" variant="flat">
          <v-card-text class="d-flex align-center justify-space-between">
            <div class="d-flex flex-column">
              <span class="text-label text-medium-emphasis">Total encuestas</span>
              <span class="kpi-number mt-1">{{ cards.total_surveys }}</span>
            </div>
            <div class="kpi-icon-box">
              <v-icon size="small" color="primary">mdi-file-document-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg kpi-card" variant="flat">
          <v-card-text class="d-flex align-center justify-space-between">
            <div class="d-flex flex-column">
              <span class="text-label text-medium-emphasis">Activas</span>
              <span class="kpi-number mt-1">{{ cards.active_surveys }}</span>
            </div>
            <div class="kpi-icon-box">
              <v-icon size="small" color="success">mdi-check-circle-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg kpi-card" variant="flat">
          <v-card-text class="d-flex align-center justify-space-between">
            <div class="d-flex flex-column">
              <span class="text-label text-medium-emphasis">Finalizadas</span>
              <span class="kpi-number mt-1">{{ cards.completed_surveys }}</span>
            </div>
            <div class="kpi-icon-box">
              <v-icon size="small" color="grey-darken-1">mdi-flag-checkered</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg kpi-card" variant="flat">
          <v-card-text class="d-flex align-center justify-space-between">
            <div class="d-flex flex-column">
              <span class="text-label text-medium-emphasis">Total respuestas</span>
              <span class="kpi-number mt-1">{{ cards.total_responses }}</span>
            </div>
            <div class="kpi-icon-box">
              <v-icon size="small" color="primary">mdi-account-group-outline</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Botón nueva encuesta -->
    <div class="d-flex justify-end mb-4">
      <v-btn color="primary" size="small" prepend-icon="mdi-plus" class="text-button" @click="goToNewSurvey">
        Nueva encuesta
      </v-btn>
    </div>

    <!-- Gráficos -->
    <v-row dense>
      <v-col cols="12" md="6">
        <LineChart :labels="lineLabels" :values="lineValues" />
      </v-col>
      <v-col cols="12" md="6">
        <DonutChart :labels="donutLabels" :values="donutValues" />
      </v-col>
      <v-col cols="12">
        <RankingList :items="topSurveys" />
      </v-col>
      <v-col cols="12" md="6">
        <BarChart :labels="barLabels" :values="barValues" />
      </v-col>
      <v-col cols="12" md="6">
        <RecentSurveys :surveys="latestSurveys" />
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
.kpi-card {
  border-radius: 7px !important;
}

.kpi-number {
  font-family: Poppins;
  font-weight: 700;
  font-size: 28px;
  line-height: 100%;
  color: #063456;
}

.kpi-icon-box {
  width: 40px;
  height: 40px;
  border-radius: 7px;
  background-color: #E9EDFD;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
</style>