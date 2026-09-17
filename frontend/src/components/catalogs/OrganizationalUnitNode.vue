<!--
  OrganizationalUnitNode.vue
  ------------------------------------------------------------------
  Nodo recursivo del árbol de dependencias. Se usa en vez de
  <v-treeview> porque la versión de Vuetify instalada en el proyecto
  (3.1.14) todavía no trae ese componente labs disponible.

  Cada nodo se dibuja a sí mismo y, si tiene "children", se vuelve a
  invocar a sí mismo por cada hijo — patrón estándar para renderizar
  árboles en Vue con un componente que se importa a sí mismo.
-->
<template>
    <div>
      <div class="d-flex align-center node-row" :style="{ paddingLeft: `${nivel * 24}px` }">
        <v-btn
          v-if="node.children?.length"
          icon
          size="x-small"
          variant="text"
          class="me-1"
          @click="abierto = !abierto"
        >
          <v-icon size="18">{{ abierto ? 'mdi-chevron-down' : 'mdi-chevron-right' }}</v-icon>
        </v-btn>
        <span v-else class="me-1" style="width: 28px; display: inline-block" />
  
        <v-icon size="18" class="me-2" :color="node.status === false ? 'grey' : 'primary'">
          mdi-office-building-outline
        </v-icon>
  
        <span :class="{ 'text-medium-emphasis': node.status === false }">
          {{ node.name }}
          <span class="text-caption text-medium-emphasis">({{ node.code }})</span>
        </span>
  
        <v-chip v-if="node.status === false" size="x-small" color="grey" class="ms-2">
          Inactiva
        </v-chip>
  
        <v-spacer />
  
        <v-icon size="18" class="me-3" icon="mdi-plus" title="Agregar dependencia hija"
          @click="$emit('nuevo', node)" />
        <v-icon size="18" class="me-3" icon="mdi-pencil" title="Editar"
          @click="$emit('editar', node)" />
        <!-- <v-icon size="18" icon="mdi-delete-outline" color="error" title="Eliminar"
          @click="$emit('eliminar', node)" /> -->
      </div>
  
      <template v-if="abierto">
        <OrganizationalUnitNode
          v-for="hijo in node.children"
          :key="hijo.id"
          :node="hijo"
          :nivel="nivel + 1"
          @nuevo="$emit('nuevo', $event)"
          @editar="$emit('editar', $event)"
          @eliminar="$emit('eliminar', $event)"
        />
      </template>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  defineProps({
    node: { type: Object, required: true },
    nivel: { type: Number, default: 0 },
  });
  
  defineEmits(['nuevo', 'editar', 'eliminar']);
  
  // Abierto por defecto para que el organigrama se vea completo al entrar.
  const abierto = ref(true);
  </script>
  
  <style scoped>
  .node-row {
    min-height: 40px;
    border-bottom: 1px solid #F4F7FD;
  }
  .node-row:hover {
    background-color: #F8FAFF;
  }
  </style>
  