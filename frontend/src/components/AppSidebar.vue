<template>
  <v-navigation-drawer
    :model-value="stateSideBar === 'active'"
    permanent
    color="#1C8686"
    width="240"
    class="app-sidebar"
  >
    <v-list nav>
      <v-list-item to="/" prepend-icon="mdi-home" title="Dashboard" />
      <v-list-item to="/surveys" prepend-icon="mdi-file-document-outline" title="Gestión de encuestas" />
      <v-list-item to="/templates" prepend-icon="mdi-content-copy" title="Plantillas" />
      <v-list-item to="/groups" prepend-icon="mdi-account-multiple-outline" title="Grupos de participantes" />
      <!-- FIX: la ruta /catalogs y su permiso "catalogs.manage" ya
           existían (ver router/index.js), pero nunca se enlazó aquí —
           mismo tipo de bug que el del dashboard (#1). -->
      <v-list-item
        v-if="hasPermission('catalogs.manage')"
        to="/catalogs"
        prepend-icon="mdi-format-list-bulleted"
        title="Catálogos"
      />
    </v-list>

    <template v-slot:append>
      <v-list nav>
        <v-list-item prepend-icon="mdi-cog" title="Ajustes" />
        <v-list-item prepend-icon="mdi-logout" title="Salir" @click="logout" />
      </v-list>
    </template>
  </v-navigation-drawer>
</template>

<script setup>
import { computed } from 'vue';
import useMenu from '@/composables/useMenu';
import useAuth from '@/composables/useAuth';

const { stateSideBar } = useMenu();
const { logout, hasPermission } = useAuth();

const drawerVisible = computed(() => stateSideBar.value === 'active');
</script>

<style scoped>
.app-sidebar {
  border-radius: 0;
}
</style>