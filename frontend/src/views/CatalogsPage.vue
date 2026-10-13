<!--
  CatalogsPage.vue
  ------------------------------------------------------------------
  PANTALLA: GESTIÓN DE CATÁLOGOS PARAMÉTRICOS
  Una sola vista con pestañas, una por catálogo, tal como se acordó
  en el plan original de vistas. Cuatro pestañas son el mismo CRUD
  simple (CatalogSimpleCrud.vue) apuntando a un endpoint distinto;
  "Dependencias" usa el árbol jerárquico (OrganizationalUnitsTree.vue)
  porque el organigrama tiene hasta 4 niveles de profundidad.
-->
<template>
  <div class="catalogs-page">
    <!-- ================= Hero Header ================= -->
    <div class="hero" :class="heroClase('catalogos')">
      <div class="hero__bg" />
      <div class="hero__content">
        <div class="hero__text">
          <div class="hero__eyebrow">Configuración</div>
          <h1 class="hero__title">Catálogos</h1>
          <p class="hero__sub">
            Valores de configuración que alimentan los formularios y filtros del resto del sistema
          </p>
        </div>
      </div>
    </div>

    <v-card variant="flat" class="rounded-lg mb-4">
      <v-tabs v-model="tab" color="primary" density="comfortable">
        <v-tab value="categorias">Categorías</v-tab>
        <v-tab value="tipos">Tipos de acceso</v-tab>
        <v-tab value="estados">Estados</v-tab>
        <v-tab value="roles">Roles</v-tab>
        <v-tab value="dependencias">Dependencias</v-tab>
      </v-tabs>
    </v-card>

    <v-window v-model="tab">
      <v-window-item value="categorias">
        <CatalogSimpleCrud
          endpoint="/survey-categories"
          :label="{
            singular: 'Categoría',
            plural: 'Categorías',
            newButton: 'Nueva categoría',
            nameField: 'Nombre de la categoría',
          }"
        />
      </v-window-item>

      <v-window-item value="tipos">
        <CatalogSimpleCrud
          endpoint="/types"
          :label="{
            singular: 'Tipo',
            plural: 'Tipos de acceso',
            newButton: 'Nuevo tipo',
            nameField: 'Nombre del tipo (ej. Pública / Privada)',
          }"
        />
      </v-window-item>

      <v-window-item value="estados">
        <CatalogSimpleCrud
          endpoint="/statuses"
          :label="{
            singular: 'Estado',
            plural: 'Estados',
            newButton: 'Nuevo estado',
            nameField: 'Nombre del estado (ej. Borrador, Publicada)',
          }"
        />
      </v-window-item>

      <v-window-item value="roles">
        <CatalogSimpleCrud
          endpoint="/survey-roles"
          :label="{
            singular: 'Rol',
            plural: 'Roles',
            newButton: 'Nuevo rol',
            nameField: 'Nombre del rol (ej. Administrador, Encuestador)',
          }"
        />
      </v-window-item>

      <v-window-item value="dependencias">
        <OrganizationalUnitsTree />
      </v-window-item>
    </v-window>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import CatalogSimpleCrud from '@/components/catalogs/CatalogSimpleCrud.vue';
import OrganizationalUnitsTree from '@/components/catalogs/OrganizationalUnitsTree.vue';
import useHeroStyle from '@/composables/useHeroStyle';

const { heroClase } = useHeroStyle();

const tab = ref('categorias');
</script>

<style scoped>
.catalogs-page {
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

@media (max-width: 600px) {
  .hero__content {
    padding: 22px 20px 20px;
  }
  .hero__title {
    font-size: 24px;
  }
}
</style>