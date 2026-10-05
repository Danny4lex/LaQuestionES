<template>
  <v-navigation-drawer
    :rail="stateSideBar !== 'active'"
    permanent
    app
    color="#2D52A7"
    width="240"
    rail-width="80"
    class="app-sidebar"
  >
<!-- Logo -->
    <template #prepend>
      <div class="sidebar-logo">
        <v-img
          :src="logoUrl"
          alt="Logo"
          width="40"
          height="40"
          class="sidebar-logo-img"
        />

        <div v-if="stateSideBar === 'active'" class="ms-3 text-white">
          <div class="text-caption font-weight-bold">
            Gobierno de El Salvador
          </div>

          <div class="text-caption font-weight-light">
            Panel Administrativo
          </div>
        </div>
      </div>
    </template>

    <!-- Menú principal -->
    <v-list nav class="mt-4">
      <v-list-item
        to="/dashboard"
        prepend-icon="mdi-home"
        title="Dashboard"
        class="sidebar-item"
        active-color="#4880FF"
      />

      <v-list-item
        to="/surveys"
        prepend-icon="mdi-file-document-outline"
        title="Gestión de encuestas"
        class="sidebar-item"
        active-color="#4880FF"
      />

      <v-list-item
        to="/templates"
        prepend-icon="mdi-content-copy"
        title="Plantillas"
        class="sidebar-item"
        active-color="#4880FF"
      />

      <!-- FIX: la ruta /groups y su vista (GroupListPage) ya existían,
           pero nunca se enlazaron en el sidebar real (TheMenu.vue) — el
           componente AppSidebar.vue donde se había agregado antes no se
           usa en ningún lado de la app. -->
      <v-list-item
        to="/groups"
        prepend-icon="mdi-account-multiple-outline"
        title="Grupos de participantes"
        class="sidebar-item"
        active-color="#4880FF"
      />

      <v-list-item
        v-if="hasPermission('catalogs.manage')"
        to="/catalogs"
        prepend-icon="mdi-format-list-bulleted-square"
        title="Catálogos"
        class="sidebar-item"
        active-color="#4880FF"
      />
    </v-list>

    <!-- Parte inferior -->
    <template #append>
      <v-list nav>
        <v-list-item
          prepend-icon="mdi-cog"
          title="Ajustes"
          class="sidebar-item"
        />

        <v-list-item
          prepend-icon="mdi-logout"
          title="Salir"
          class="sidebar-item"
          @click="logout"
        />
      </v-list>
    </template>
  </v-navigation-drawer>
</template>

<script setup>
import useMenu from "@/composables/useMenu";
import useAuth from "@/composables/useAuth";
import logoUrl from "@/assets/logo.png";

const { stateSideBar } = useMenu();
const { logout, hasPermission } = useAuth();
</script>

<style scoped>
.app-sidebar {
  border-radius: 0;
}


/* Logo: misma altura y misma posición con el menú plegado o desplegado */
.sidebar-logo {
  display: flex;
  align-items: center;
  height: 90px;
  padding-left: 20px;
  border-bottom: 1px solid #ACD7FF;
  overflow: hidden;
  white-space: nowrap;
}

.sidebar-logo-img {
  flex: 0 0 40px;
}
/* =====================================================
   ITEMS DEL MENÚ
===================================================== */
.sidebar-item {
  color: white !important;
}

/* =====================================================
   HOVER
===================================================== */
.sidebar-item:hover {
  background-color: #4880FF !important;
}

.sidebar-item:hover::before {
  opacity: 0 !important;
}

/* =====================================================
   ICONO
===================================================== */
.sidebar-item:hover :deep(.v-icon) {
  color: inherit !important;
}

/* =====================================================
   TEXTO
===================================================== */
.sidebar-item:hover :deep(.v-list-item-title) {
  color: white !important;
}

/* =====================================================
   ELEMENTO ACTIVO
===================================================== */
.sidebar-item.v-list-item--active {
  background-color: #4880FF !important;
  color: white !important;
}

.sidebar-item.v-list-item--active :deep(.v-icon) {
  color: #FFFFFF !important;
}

.sidebar-item.v-list-item--active :deep(.v-list-item-title) {
  color: #FFFFFF !important;
}
</style>