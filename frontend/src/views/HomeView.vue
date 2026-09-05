<template>
  <div>
    <!-- Tarjeta de bienvenida -->
    <v-card color="#2D52A7" class="mt-8 mb-4 rounded-lg" variant="flat">
      <v-card-text class="text-white pa-4">
        <div class="text-body-2 font-weight-light">Hola, Bienvenido</div>
        <div class="text-h6 font-weight-bold">Carlos Méndez</div>
        <div class="text-body-2 font-weight-light">
          Resumen general del sistema de encuestas institucionales
        </div>
      </v-card-text>
    </v-card>

    <!-- Indicadores -->
    <v-row dense class="mb-4">
      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg" variant="flat">
          <v-card-text class="d-flex flex-column">
            <div class="d-flex align-center">
              <v-icon size="small" class="me-2">mdi-file-document-outline</v-icon>
              <span class="text-caption text-medium-emphasis">Total encuestas</span>
            </div>
            <span class="text-h6 font-weight-bold mt-1">101</span>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg" variant="flat">
          <v-card-text class="d-flex flex-column">
            <div class="d-flex align-center">
              <v-icon size="small" class="me-2" color="success">
                mdi-check-circle-outline
              </v-icon>
              <span class="text-caption text-medium-emphasis">Activas</span>
            </div>
            <span class="text-h6 font-weight-bold mt-1">23</span>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg" variant="flat">
          <v-card-text class="d-flex flex-column">
            <div class="d-flex align-center">
              <v-icon size="small" class="me-2" color="grey-darken-1">
                mdi-flag-checkered
              </v-icon>
              <span class="text-caption text-medium-emphasis">Finalizadas</span>
            </div>
            <span class="text-h6 font-weight-bold mt-1">57</span>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-card class="rounded-lg" variant="flat">
          <v-card-text class="d-flex flex-column">
            <div class="d-flex align-center">
              <v-icon size="small" class="me-2" color="info">
                mdi-account-group-outline
              </v-icon>
              <span class="text-caption text-medium-emphasis">Total respuestas</span>
            </div>
            <span class="text-h6 font-weight-bold mt-1">1,101</span>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Botón nueva encuesta (opcional, podría ir en header) -->
    <div class="d-flex justify-end mb-4">
      <v-btn color="primary" size="small" prepend-icon="mdi-plus" @click="goToNewSurvey">
        Nueva encuesta
      </v-btn>
    </div>

    <!-- Gráficos -->
    <v-row dense>
      <v-col cols="12" md="6">
        <LineChart />
      </v-col>
      <v-col cols="12" md="6">
        <DonutChart />
      </v-col>
      <v-col cols="12">
        <RankingList />
      </v-col>
      <v-col cols="12" md="6">
        <BarChart />
      </v-col>
      <v-col cols="12" md="6">
        <RecentSurveys />
      </v-col>
    </v-row>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import LineChart from "@/components/charts/LineChart.vue";
import DonutChart from "@/components/charts/DonutChart.vue";
import BarChart from "@/components/charts/BarChart.vue";
import RankingList from "@/components/charts/RankingList.vue";
import RecentSurveys from "@/components/charts/RecentSurveys.vue";

const router = useRouter();

function goToNewSurvey() {
  router.push("/surveys/new/edit");
}
</script>