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
    <div>
      <h3 class="text-page-title mb-4 mt-8">Catálogos</h3>
      <p class="text-subtitle mb-4">
        Valores de configuración que alimentan los formularios y filtros del resto del sistema
      </p>
  
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
  
  const tab = ref('categorias');
  </script>
  