<template>
  <div>
    <h3 class="text-page-title mt-8">Editar encuesta</h3>
    <p class="text-subtitle mb-4">Modifica los datos de la encuesta</p>

    <!-- Cargando -->
    <div v-if="loading" class="text-center py-8">
      <v-progress-circular indeterminate color="primary" />
      <p class="mt-3">Cargando encuesta...</p>
    </div>

    <template v-else>
      <!-- Mensajes -->
      <v-alert v-if="errorMsg" type="error" variant="tonal" class="mb-4" dismissible>
        {{ errorMsg }}
      </v-alert>

      <!-- Botones superiores -->
      <v-row dense class="mb-4">
        <v-col cols="12" sm="auto">
          <v-btn
            color="primary"
            variant="outlined"
            prepend-icon="mdi-content-copy"
            class="text-button"
          >
            Guardar como plantilla
          </v-btn>
        </v-col>

        <v-col cols="12" sm="auto">
          <v-btn
            color="primary"
            variant="outlined"
            prepend-icon="mdi-content-save"
            class="text-button"
            @click="guardarEncuesta"
          >
            Guardar
          </v-btn>
        </v-col>

        <v-col cols="12" sm="auto">
          <v-btn
            color="primary"
            variant="flat"
            prepend-icon="mdi-eye-outline"
            class="text-button"
            @click="previewDialog = true"
          >
            Visualizar boletín completo
          </v-btn>
        </v-col>

        <v-col v-if="(esEstadoDraft || estadoActualSlug === 'needs_correction') && hasPermission('status.submitForReview')" cols="12" sm="auto">
            <v-btn
              color="primary"
              variant="flat"
              prepend-icon="mdi-file-search-outline"
              class="text-button"
              @click="enviarRevision"
            >
              {{ estadoActualSlug === 'needs_correction' ? 'Reenviar a revisión' : 'Enviar a revisión' }}
            </v-btn>
        </v-col>

        <!-- Encuestador: solo puede publicar una vez que el Administrador
             ya aprobó la encuesta (estadoActualSlug === 'approved'). -->
        <v-col v-if="estadoActualSlug === 'approved' && hasPermission('status.publish')" cols="12" sm="auto">
          <v-btn
            color="success"
            variant="flat"
            prepend-icon="mdi-rocket-launch-outline"
            class="text-button"
            @click="cambiarEstadoPorSlug('published', 'Encuesta publicada correctamente.')"
          >
            Publicar
          </v-btn>
        </v-col>

        <!-- Administrador: modera las encuestas que llegaron a "En revisión" -->
        <template v-if="estadoActualSlug === 'review' && hasPermission('status.moderate')">
          <v-col cols="12" sm="auto">
            <v-btn
              color="success"
              variant="flat"
              prepend-icon="mdi-check-circle-outline"
              class="text-button"
              @click="cambiarEstadoPorSlug('approved', 'Encuesta aprobada.')"
            >
              Aprobar
            </v-btn>
          </v-col>
          <v-col cols="12" sm="auto">
            <v-btn
              color="warning"
              variant="flat"
              prepend-icon="mdi-file-edit-outline"
              class="text-button"
              @click="cambiarEstadoPorSlug('needs_correction', 'Se solicitaron correcciones al Encuestador.')"
            >
              Solicitar correcciones
            </v-btn>
          </v-col>
          <v-col cols="12" sm="auto">
            <v-btn
              color="error"
              variant="flat"
              prepend-icon="mdi-close-circle-outline"
              class="text-button"
              @click="cambiarEstadoPorSlug('rejected', 'Encuesta rechazada.')"
            >
              Rechazar
            </v-btn>
          </v-col>
        </template>

<!-- Administrador: con correcciones solicitadas, la encuesta sigue
     pudiendo aprobarse o publicarse sin esperar un nuevo ciclo. -->
     <template v-if="estadoActualSlug === 'needs_correction' && hasPermission('status.moderate')">
  <v-col cols="12" sm="auto">
    <v-btn
      color="success"
      variant="flat"
      prepend-icon="mdi-check-circle-outline"
      class="text-button"
      @click="cambiarEstadoPorSlug('approved', 'Encuesta aprobada.')"
    >
      Aprobar
    </v-btn>
  </v-col>
  <v-col cols="12" sm="auto">
    <v-btn
      color="success"
      variant="flat"
      prepend-icon="mdi-rocket-launch-outline"
      class="text-button"
      @click="cambiarEstadoPorSlug('published', 'Encuesta publicada correctamente.')"
    >
      Publicar
    </v-btn>
  </v-col>
</template>

        <!-- Administrador: puede seguir moviendo el ESTADO de la encuesta
             aunque ya no pueda tocar su contenido (Publicada/Cerrada
             incluidas) — el bloqueo de "campos-bloqueados" solo aplica al
             formulario de abajo, nunca a estos botones. -->
        <template v-if="hasPermission('status.moderate')">
          <v-col v-if="estadoActualSlug === 'scheduled'" cols="12" sm="auto">
            <v-btn color="success" variant="flat" prepend-icon="mdi-rocket-launch-outline" class="text-button"
              @click="cambiarEstadoPorSlug('published', 'Encuesta publicada.')">
              Publicar ahora
            </v-btn>
          </v-col>
          <v-col v-if="estadoActualSlug === 'published'" cols="12" sm="auto">
            <v-btn color="warning" variant="flat" prepend-icon="mdi-pause-circle-outline" class="text-button"
              @click="cambiarEstadoPorSlug('paused', 'Encuesta pausada.')">
              Pausar
            </v-btn>
          </v-col>
          <v-col v-if="['published', 'paused'].includes(estadoActualSlug)" cols="12" sm="auto">
            <v-btn color="error" variant="flat" prepend-icon="mdi-lock-outline" class="text-button"
              @click="cambiarEstadoPorSlug('closed', 'Encuesta cerrada.')">
              Cerrar
            </v-btn>
          </v-col>
          <v-col v-if="estadoActualSlug === 'paused'" cols="12" sm="auto">
            <v-btn color="success" variant="flat" prepend-icon="mdi-play-circle-outline" class="text-button"
              @click="cambiarEstadoPorSlug('published', 'Encuesta reanudada.')">
              Reanudar
            </v-btn>
          </v-col>
          <v-col v-if="estadoActualSlug === 'closed'" cols="12" sm="auto">
            <v-btn color="secondary" variant="flat" prepend-icon="mdi-archive-outline" class="text-button"
              @click="cambiarEstadoPorSlug('archived', 'Encuesta archivada.')">
              Archivar
            </v-btn>
          </v-col>
        </template>
      </v-row>

      <v-alert
        v-if="esEdicion && !esEditable"
        type="warning"
        variant="tonal"
        class="mb-4"
      >
        Esta encuesta está en estado "{{ estados.find(e => e.id === estadoId)?.name }}" y ya no se puede editar,
        para no alterar resultados en curso. Solo se puede modificar en Borrador, En revisión, Aprobada, Rechazada o Corregida.
      </v-alert>

      <v-form ref="formRef" @submit.prevent="guardarEncuesta">
        <!-- Datos generales -->
        <v-card
          variant="flat"
          border="0"
          class="rounded-lg pa-3 section-card mb-4"
          :class="{ 'campos-bloqueados': !esEditable }"
        >
          <v-row dense>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="titulo"
                label="Título"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
                :rules="[v => !!v || 'El título es obligatorio']"
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-select
                v-model="tipoId"
                :items="tipos"
                item-title="name"
                item-value="id"
                label="Tipo"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
                :rules="[v => !!v || 'Selecciona un tipo']"
              />
            </v-col>

            <v-col cols="12">
              <v-textarea
                v-model="descripcion"
                label="Descripción"
                variant="outlined"
                density="compact"
                rows="2"
                hide-details
                class="input-field"
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-switch
                v-model="esAnonima"
                color="primary"
                density="compact"
                hide-details
                label="Encuesta anónima (no pide datos del encuestado)"
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-switch
                v-model="unicaRespuesta"
                color="primary"
                density="compact"
                hide-details
                label="Permitir una sola respuesta por persona"
              />
            </v-col>

            <v-col cols="12" md="4">
              <v-text-field
                v-model="fechaInicio"
                label="Fecha inicio"
                type="date"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
              />
            </v-col>

            <v-col cols="12" md="4">
              <v-text-field
                v-model="fechaFin"
                label="Fecha fin"
                type="date"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
              />
            </v-col>

            <v-col cols="12" md="4">
              <v-select
                v-model="categoriaId"
                :items="categorias"
                item-title="name"
                item-value="id"
                label="Categoría"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
                :rules="[v => !!v || 'Selecciona una categoría']"
              />
            </v-col>

            <v-col cols="12" md="4">
              <v-select
                v-model="dependenciaId"
                :items="dependencias"
                item-title="name"
                item-value="id"
                label="Dependencia"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
                :disabled="esEdicion"
                :rules="esEdicion ? [] : [v => !!v || 'Selecciona una dependencia']"
              />
            </v-col>

            <v-col cols="12" md="4">
              <v-select
                v-model="estadoId"
                :items="estados"
                item-title="name"
                item-value="id"
                label="Estado"
                variant="outlined"
                density="compact"
                hide-details
                class="input-field"
                :disabled="esEdicion"
                :rules="esEdicion ? [] : [v => !!v || 'Selecciona un estado']"
              />
            </v-col>
          </v-row>
        </v-card>

        <!-- Estructura solo en edición -->
        <template v-if="esEdicion">
          <v-divider class="my-4" />
          <h5 class="text-section-title mb-3">Estructura de la encuesta</h5>

          <div :class="{ 'campos-bloqueados': !esEditable }">
          <!-- Secciones -->
          <div v-for="(seccion, sIndex) in secciones" :key="sIndex" class="form-section mb-4">
            <v-card variant="flat" border="0" class="rounded-lg pa-3 section-card">
              <v-row class="align-center mb-2">
                <v-col cols="12" sm="auto">
                  <h6 class="text-subsection-title">Sección {{ sIndex + 1 }}</h6>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model="seccion.name"
                    variant="outlined"
                    density="compact"
                    hide-details
                    placeholder="Nombre de la sección"
                    class="input-field"
                  />
                </v-col>
                <v-col cols="12" sm="auto" class="d-flex justify-end ga-2">
                  <v-btn
                    v-if="seccion.backendId"
                    color="#FFF4D6"
                    variant="flat"
                    size="small"
                    class="text-button permite-interaccion"
                    @click="abrirComentarios(seccion)"
                  >
                    <template #prepend>
                      <v-icon color="#8A6D00">mdi-note-text-outline</v-icon>
                    </template>
                    Comentarios
                    <v-badge
                      v-if="seccion.comentariosCount"
                      :content="seccion.comentariosCount"
                      color="#8A6D00"
                      inline
                    />
                  </v-btn>
                  <v-btn
                    color="#F4F7FD"
                    variant="flat"
                    size="small"
                    class="text-button"
                    @click="eliminarSeccion(sIndex)"
                  >
                    <template #prepend>
                      <v-icon color="red">mdi-delete</v-icon>
                    </template>
                    Eliminar sección
                  </v-btn>
                </v-col>
              </v-row>

              <v-text-field
                v-model="seccion.description"
                placeholder="Descripción"
                variant="outlined"
                density="compact"
                hide-details
                class="mb-3 input-field"
              />

              <!-- Preguntas -->
              <div
                v-for="(pregunta, pIndex) in seccion.questions"
                :key="pregunta.id"
                class="question-item pa-2 mb-3"
                draggable="true"
                @dragstart="onDragStart($event, sIndex, pIndex)"
                @dragover.prevent="onDragOver($event)"
                @dragenter.prevent
                @drop="onDrop($event, sIndex, pIndex)"
                @dragend="onDragEnd"
              >
                <v-row class="align-center">
                  <v-col cols="12" md="5" class="d-flex align-center">
                    <v-icon class="me-2 drag-handle" @mousedown.prevent>mdi-drag-vertical</v-icon>
                    <v-text-field
                      v-model="pregunta.statement"
                      variant="outlined"
                      density="compact"
                      hide-details
                      placeholder="Enunciado"
                      class="input-field"
                    />
                  </v-col>
                  <v-col cols="12" md="3">
                    <v-select
                      v-model="pregunta.type"
                      :items="tiposPregunta"
                      variant="outlined"
                      density="compact"
                      hide-details
                      class="input-field"
                      @update:model-value="onCambioTipoPregunta(pregunta, $event)"
                    />
                  </v-col>
                  <v-col cols="12" md="3" class="d-flex align-center">
                    <label class="custom-switch-wrapper">
                      <span class="custom-switch-label text-label">Obligatoria</span>
                      <div class="switch-wrap">
                        <input type="checkbox" v-model="pregunta.isMandatory" />
                        <div class="switch"></div>
                      </div>
                    </label>
                  </v-col>
                  <v-col cols="12" md="1" class="d-flex justify-end">
                    <v-btn
                      icon
                      size="x-small"
                      color="error"
                      variant="tonal"
                      @click="eliminarPregunta(sIndex, pIndex)"
                    >
                      <v-icon>mdi-close</v-icon>
                    </v-btn>
                  </v-col>
                </v-row>

                <!-- Opciones -->
                <div v-if="mostrarOpciones(pregunta.type)" class="ms-4 mt-2">
                  <div v-for="(opcion, oIndex) in pregunta.options" :key="opcion.id" class="d-flex align-center mb-2">
                    <v-text-field
                      v-model="opcion.text"
                      variant="outlined"
                      density="compact"
                      hide-details
                      class="me-2 input-field"
                    />
                    <v-btn
                      icon
                      size="x-small"
                      color="error"
                      variant="tonal"
                      @click="eliminarOpcion(sIndex, pIndex, oIndex)"
                    >
                      <v-icon>mdi-minus</v-icon>
                    </v-btn>
                  </div>
                  <v-btn
                      size="small"
                      variant="flat"
                      color="#F4F7FD"
                      class="text-button"
                      @click="agregarOpcion(sIndex, pIndex)"
                    >
                      <template #prepend>
                        <v-icon>mdi-plus</v-icon>
                      </template>
                      Agregar opción
                    </v-btn>
                </div>

                <!-- Límite de caracteres (solo texto corto/largo) -->
                <div v-if="['Texto corto', 'Texto largo'].includes(pregunta.type)" class="ms-4 mt-2">
                  <v-text-field
                    v-model.number="pregunta.maxLength"
                    label="Límite de caracteres"
                    type="number"
                    min="1"
                    max="5000"
                    variant="outlined"
                    density="compact"
                    style="max-width: 220px;"
                    hide-details
                    class="input-field"
                  />
                  <p class="text-caption text-medium-emphasis mt-1 mb-0">
                    Quien responda verá cuántos caracteres le quedan mientras escribe.
                  </p>
                </div>

                <!-- Escala -->
                <div v-if="pregunta.type === 'Escala de satisfacción'" class="ms-4 mt-2">
                  <v-row dense>
                    <v-col cols="6" md="2">
                      <v-text-field
                        v-model="pregunta.scaleMin"
                        label="Valor mínimo"
                        type="number"
                        variant="outlined"
                        density="compact"
                        hide-details
                        class="input-field"
                      />
                    </v-col>
                    <v-col cols="6" md="2">
                      <v-text-field
                        v-model="pregunta.scaleMax"
                        label="Valor máximo"
                        type="number"
                        variant="outlined"
                        density="compact"
                        hide-details
                        class="input-field"
                      />
                    </v-col>
                    <v-col cols="12" md="4">
                      <v-text-field
                        v-model="pregunta.scaleLabelMin"
                        label="Etiqueta mínima"
                        variant="outlined"
                        density="compact"
                        hide-details
                        class="input-field"
                      />
                    </v-col>
                    <v-col cols="12" md="4">
                      <v-text-field
                        v-model="pregunta.scaleLabelMax"
                        label="Etiqueta máxima"
                        variant="outlined"
                        density="compact"
                        hide-details
                        class="input-field"
                      />
                    </v-col>
                  </v-row>
                </div>
              </div>

              <!-- Agregar pregunta -->
              <div class="question-type-picker">
                <div class="question-type-picker-header">
                  Agregar pregunta
                </div>

                <div class="question-type-menu">
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Texto corto')"
                  >
                    Texto corto
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Texto largo')"
                  >
                    Texto largo
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Opción única')"
                  >
                    Opción única
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Opción múltiple')"
                  >
                    Opción múltiple
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Escala de satisfacción')"
                  >
                    Escala de satisfacción
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Sí/No')"
                  >
                    Sí/No
                  </v-btn>
                  <v-btn
                    size="small"
                    variant="flat"
                    class="question-type-btn text-button"
                    @click="agregarPregunta(sIndex, 'Casilla de verificación')"
                  >
                    Casilla de verificación
                  </v-btn>
                </div>
              </div>
            </v-card>
          </div>

          <v-btn
            color="#063456"
            size="small"
            variant="flat"
            class="text-button mb-4 text-white"
            @click="agregarSeccion"
          >
            <template #prepend>
              <v-icon color="white">mdi-plus</v-icon>
            </template>
            Agregar sección
          </v-btn>
          </div>
        </template>

        <!-- Botones guardar/cancelar -->
        <div class="d-flex mt-4">
          <v-btn type="submit" color="primary" class="me-2 text-button" :disabled="!esEditable">
            Guardar
          </v-btn>
          <v-btn color="secondary" variant="flat" class="text-button" @click="cancelar">
            Cancelar
          </v-btn>
        </div>
      </v-form>

      <v-dialog v-model="previewDialog" max-width="900">
        <v-card class="preview-card" variant="flat">
          <!-- Cabecera -->
          <div class="preview-card-header">
            <h2 class="preview-title">{{ titulo || 'Sin título' }}</h2>
            <p v-if="descripcion" class="preview-description">{{ descripcion }}</p>
          </div>

          <v-card-text class="preview-card-body">
            <div v-if="secciones.length === 0" class="text-center py-4 text-body-2 text-medium-emphasis">
              La encuesta no tiene secciones todavía.
            </div>

            <div
              v-for="(seccion, sIndex) in secciones"
              :key="sIndex"
              class="preview-section"
            >
              <h3 class="preview-section-title">
                {{ seccion.name || `Sección ${sIndex + 1}` }}
              </h3>
              <p v-if="seccion.description" class="preview-section-description">
                {{ seccion.description }}
              </p>

              <div
                v-for="(pregunta, pIndex) in seccion.questions"
                :key="pIndex"
                class="preview-question"
              >
                <p class="preview-question-statement">
                  {{ pregunta.statement }}
                  <span v-if="pregunta.isMandatory" class="preview-mandatory">*</span>
                </p>

                <!-- Opciones -->
                <ul v-if="mostrarOpciones(pregunta.type)" class="preview-options">
                  <li v-for="opcion in pregunta.options" :key="opcion.id">
                    <v-icon size="small" class="me-1">mdi-checkbox-blank-circle-outline</v-icon>
                    {{ opcion.text }}
                  </li>
                </ul>

                <!-- Escala -->
                <div v-else-if="pregunta.type === 'Escala de satisfacción'" class="preview-scale">
                  <button
                    v-for="n in 5"
                    :key="n"
                    type="button"
                    class="preview-scale-btn"
                    disabled
                  >
                    {{ n }}
                  </button>
                </div>

                <!-- Texto / sí-no / casilla -->
                <p v-else class="preview-field-hint">
                  Campo de respuesta tipo {{ pregunta.type }}
                </p>
              </div>
            </div>
          </v-card-text>

          <v-card-actions class="pa-4">
            <v-spacer />
            <v-btn color="primary" variant="outlined" class="text-button" @click="previewDialog = false">
              Cerrar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- Diálogo: comentarios/correcciones por sección ("papelito") -->
      <v-dialog v-model="dialogComentarios" max-width="560">
        <v-card>
          <v-card-title class="text-h6">
            <h3 class="text-page-title mt-8">Editar encuesta</h3>
            <div class="text-body-small text-medium-emphasis font-weight-regular">
              {{ seccionComentarios?.name || '(sin nombre)' }}
            </div>
          </v-card-title>
          <v-card-text>
            <p class="text-caption text-medium-emphasis mb-3">
              Solo el Administrador y el Encuestador de esta encuesta pueden ver este hilo.
            </p>

            <div v-if="cargandoComentarios" class="text-center py-4">
              <v-progress-circular indeterminate color="primary" size="24" />
            </div>

            <div v-else-if="!comentarios.length" class="text-center text-medium-emphasis py-4">
              Todavía no hay comentarios en esta sección.
            </div>

            <div v-else class="comentarios-lista mb-3">
              <div
                v-for="c in comentarios"
                :key="c.id"
                class="comentario-card mb-3"
                :class="esAdministrador(c) ? 'comentario-card--admin' : 'comentario-card--encuestador'"
              >
                <div class="comentario-fila">
                  <v-avatar :color="esAdministrador(c) ? '#8A6D00' : '#2D52A7'" size="32" class="flex-shrink-0">
                    <span class="text-white text-caption font-weight-bold">{{ inicialesComentario(c) }}</span>
                  </v-avatar>
                  <div class="flex-grow-1">
                    <div class="d-flex justify-space-between align-center comentario-header">
                      <span class="text-body-small font-weight-bold comentario-nombre">
                        {{ c.user?.name || 'Usuario' }}
                        <v-chip
                          v-if="c.user?.role?.name"
                          size="x-small"
                          :color="esAdministrador(c) ? '#8A6D00' : '#2D52A7'"
                          variant="flat"
                          class="text-white"
                        >
                          {{ c.user.role.name }}
                        </v-chip>
                      </span>
                      <span class="text-caption text-medium-emphasis">
                        {{ formatearFechaComentario(c.created_at) }}
                      </span>
                    </div>
                    <p class="text-body-small mb-0 comentario-texto">{{ c.comment }}</p>
                  </div>
                </div>
              </div>
            </div>

            <v-alert v-if="errorComentario" type="error" variant="tonal" density="compact" class="mb-3">
              {{ errorComentario }}
            </v-alert>

            <v-textarea
              v-model="nuevoComentario"
              label="Agregar comentario"
              placeholder="Ej: falta agregar una pregunta sobre..."
              variant="outlined"
              density="compact"
              rows="2"
              hide-details
            />
          </v-card-text>
          <v-card-actions class="pa-4">
            <v-spacer />
            <v-btn variant="outlined" color="secondary" class="text-button" @click="dialogComentarios = false">
              Cerrar
            </v-btn>
            <v-btn color="primary" class="text-button" :loading="enviandoComentario" @click="agregarComentario">
              Agregar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

    </template>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import backendApi from '@/services/backendApi';
import useAuth from '@/composables/useAuth';
import useAlert from '@/composables/useAlert';
import useConfirm from '@/composables/useConfirm';

const { hasPermission } = useAuth();
const { alert } = useAlert();
const { confirm } = useConfirm();

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const errorMsg = ref(null);
const previewDialog = ref(false);
const formRef = ref(null);

// =====================================================================
// COMENTARIOS POR SECCIÓN ("papelito" de correcciones)
// =====================================================================
const dialogComentarios = ref(false);
const seccionComentarios = ref(null);
const comentarios = ref([]);
const cargandoComentarios = ref(false);
const nuevoComentario = ref('');
const enviandoComentario = ref(false);
const errorComentario = ref(null);

function formatearFechaComentario(fecha) {
  if (!fecha) return '';
  return new Date(fecha).toLocaleString('es-SV', { dateStyle: 'short', timeStyle: 'short' });
}

// El "papelito" distingue visualmente si el comentario lo dejó el
// Administrador (quien pide la corrección) o el Encuestador (quien
// responde) — por nombre de rol, ya que es lo único que trae el
// endpoint de comentarios.
function esAdministrador(comentario) {
  return comentario.user?.role?.name?.toLowerCase().includes('administrador');
}

function inicialesComentario(comentario) {
  const nombre = comentario.user?.name || '';
  return nombre
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((p) => p[0]?.toUpperCase())
    .join('') || '?';
}

async function abrirComentarios(seccion) {
  seccionComentarios.value = seccion;
  nuevoComentario.value = '';
  errorComentario.value = null;
  dialogComentarios.value = true;
  await cargarComentarios();
}

async function cargarComentarios() {
  if (!seccionComentarios.value?.backendId) return;
  cargandoComentarios.value = true;
  try {
    const { data } = await backendApi.get(`/sections/${seccionComentarios.value.backendId}/comments`);
    comentarios.value = data;
    seccionComentarios.value.comentariosCount = data.length;
  } catch (e) {
    errorComentario.value = 'No se pudieron cargar los comentarios.';
  } finally {
    cargandoComentarios.value = false;
  }
}

async function agregarComentario() {
  errorComentario.value = null;
  if (!nuevoComentario.value?.trim()) {
    errorComentario.value = 'Escribe un comentario antes de agregarlo.';
    return;
  }
  enviandoComentario.value = true;
  try {
    await backendApi.post(`/sections/${seccionComentarios.value.backendId}/comments`, {
      comment: nuevoComentario.value.trim(),
    });
    nuevoComentario.value = '';
    await cargarComentarios();
  } catch (e) {
    errorComentario.value = e.response?.data?.message || 'No se pudo agregar el comentario.';
  } finally {
    enviandoComentario.value = false;
  }
}

const esEdicion = computed(() => !!route.params.id);
const esEstadoDraft = computed(() => {
  if (!esEdicion.value || !estadoId.value) return false;
  const estado = estados.value.find(e => e.id === estadoId.value);
  return estado?.slug === 'draft';
});
const estadoActualSlug = computed(() => {
  if (!estadoId.value) return null;
  return estados.value.find(e => e.id === estadoId.value)?.slug ?? null;
});

// Espejo de SurveyStatusFlowService::EDITABLE_STATUSES en el backend.
// Una encuesta nueva (aún sin estado_id, esEdicion=false) siempre es
// editable. El backend es quien realmente hace cumplir esta regla — esto
// es solo para no mostrar controles que el usuario no podrá usar.
// NOTA: el CAMBIO DE ESTADO (Aprobar/Rechazar/Publicar/Pausar/etc.) no
// depende de esta lista — esos botones viven fuera del bloque
// "campos-bloqueados" y el Administrador puede usarlos en cualquier
// estado válido según el flujo (ver botones más abajo en el template).
const ESTADOS_EDITABLES = ['draft', 'review', 'approved', 'rejected', 'needs_correction'];
const esEditable = computed(() => {
  if (!esEdicion.value) return true;
  return ESTADOS_EDITABLES.includes(estadoActualSlug.value);
});

// Datos generales
const titulo = ref('');
const descripcion = ref('');
const tipoId = ref(null);
const esAnonima = ref(false);
const unicaRespuesta = ref(false);
const categoriaId = ref(null);
const estadoId = ref(null);
const dependenciaId = ref(null);
const fechaInicio = ref(null);
const fechaFin = ref(null);

// Catálogos reales
const tipos = ref([]);
const categorias = ref([]);
const estados = ref([]);
const dependencias = ref([]);

const tiposPregunta = [
  'Texto corto',
  'Texto largo',
  'Opción única',
  'Opción múltiple',
  'Escala de satisfacción',
  'Sí/No',
  'Casilla de verificación'
];

// Estructura
const secciones = reactive([]);
const deletedSections = ref([]);
const deletedQuestions = ref([]);
const deletedOptions = ref([]);

let nextQuestionId = 1;
let nextOptionId = 1;

// Mapeo backend <-> frontend
const typeLabelMap = {
  texto: 'Texto corto',
  opcion_unica: 'Opción única',
  opcion_multiple: 'Opción múltiple',
  escala: 'Escala de satisfacción',
  si_no: 'Sí/No',
  casilla: 'Casilla de verificación',
};

const labelTypeMap = {
  'Texto corto': 'texto',
  'Texto largo': 'texto',
  'Opción única': 'opcion_unica',
  'Opción múltiple': 'opcion_multiple',
  'Escala de satisfacción': 'escala',
  'Sí/No': 'si_no',
  'Casilla de verificación': 'casilla',
};

// Drag & Drop
let draggedSectionIndex = null;
let draggedQuestionIndex = null;

function mostrarOpciones(tipo) {
  return ['Opción única', 'Opción múltiple', 'Casilla de verificación'].includes(tipo);
}

function onCambioTipoPregunta(pregunta, nuevoTipo) {
  if (['Texto corto', 'Texto largo'].includes(nuevoTipo) && !pregunta.maxLength) {
    pregunta.maxLength = MAX_LENGTH_DEFAULT[nuevoTipo];
  }
}

function onDragStart(event, sIndex, pIndex) {
  draggedSectionIndex = sIndex;
  draggedQuestionIndex = pIndex;
  event.dataTransfer.effectAllowed = 'move';
  event.dataTransfer.setData('text/plain', pIndex);
  event.currentTarget.style.opacity = '0.4';
}

function onDragOver(event) {
  event.dataTransfer.dropEffect = 'move';
}

function onDrop(event, targetSectionIndex, targetQuestionIndex) {
  const sourceSection = draggedSectionIndex;
  const sourceIndex = draggedQuestionIndex;

  if (sourceSection !== targetSectionIndex) {
    resetDrag();
    return;
  }

  if (sourceIndex !== targetQuestionIndex && sourceSection === targetSectionIndex) {
    const questions = secciones[sourceSection].questions;
    const [movedQuestion] = questions.splice(sourceIndex, 1);
    questions.splice(targetQuestionIndex, 0, movedQuestion);
    updateSortOrders(sourceSection);
  }

  resetDrag();
}

function onDragEnd(event) {
  event.currentTarget.style.opacity = '1';
  resetDrag();
}

function resetDrag() {
  draggedSectionIndex = null;
  draggedQuestionIndex = null;
}

function updateSortOrders(sectionIndex) {
  const questions = secciones[sectionIndex].questions;
  questions.forEach((q, idx) => {
    q.sortOrder = idx + 1;
  });
}

function agregarSeccion() {
  secciones.push({
    backendId: null,
    name: '',
    description: '',
    questions: []
  });
}

async function eliminarSeccion(sIndex) {
  const seccion = secciones[sIndex];
  const ok = await confirm(
    `¿Eliminar la sección "${seccion.name || 'sin nombre'}"? Se eliminarán también todas sus preguntas. Esta acción no se puede deshacer.`
  );
  if (!ok) return;

  if (seccion.backendId) {
    deletedSections.value.push(seccion.backendId);
  }
  secciones.splice(sIndex, 1);
}

// Límite de caracteres por defecto según el tipo de texto elegido — el
// usuario puede ajustarlo libremente en el campo numérico del editor.
// El umbral de 200 es el mismo que usan las pantallas de respuesta para
// decidir si renderizan un campo de una línea o un textarea.
const UMBRAL_TEXTO_LARGO = 200;
const MAX_LENGTH_DEFAULT = {
  'Texto corto': 150,
  'Texto largo': 1000,
};

// El backend solo guarda type="texto" para ambos casos (no distingue
// corto/largo como columna aparte) — se infiere la etiqueta a mostrar a
// partir de max_length, usando el mismo umbral que el resto del sistema.
function etiquetaTipoTexto(maxLength) {
  return maxLength && maxLength > UMBRAL_TEXTO_LARGO ? 'Texto largo' : 'Texto corto';
}

function agregarPregunta(sIndex, tipo = 'Texto corto') {
  const nextOrder = secciones[sIndex].questions.length + 1;
  const nuevaPregunta = {
    id: nextQuestionId++,
    backendId: null,
    statement: '',
    type: tipo,
    isMandatory: false,
    sortOrder: nextOrder,
    options: [],
    maxLength: MAX_LENGTH_DEFAULT[tipo] ?? null,
  };

  if (tipo === 'Escala de satisfacción') {
    nuevaPregunta.scaleMin = 1;
    nuevaPregunta.scaleMax = 5;
    nuevaPregunta.scaleLabelMin = '';
    nuevaPregunta.scaleLabelMax = '';
  }

  secciones[sIndex].questions.push(nuevaPregunta);
}

async function eliminarPregunta(sIndex, pIndex) {
  const pregunta = secciones[sIndex].questions[pIndex];
  const ok = await confirm(
    `¿Eliminar la pregunta "${pregunta.statement || 'sin enunciado'}"? Esta acción no se puede deshacer.`
  );
  if (!ok) return;

  if (pregunta.backendId) {
    deletedQuestions.value.push(pregunta.backendId);
  }
  secciones[sIndex].questions.splice(pIndex, 1);
  updateSortOrders(sIndex);
}

function agregarOpcion(sIndex, pIndex) {
  const opcion = {
    id: nextOptionId++,
    backendId: null,
    text: ''
  };
  secciones[sIndex].questions[pIndex].options.push(opcion);
}

function eliminarOpcion(sIndex, pIndex, oIndex) {
  const opcion = secciones[sIndex].questions[pIndex].options[oIndex];
  if (opcion.backendId) {
    deletedOptions.value.push(opcion.backendId);
  }
  secciones[sIndex].questions[pIndex].options.splice(oIndex, 1);
}

async function cargarCatalogos() {
  // 1. Si ya los tenemos guardados en la memoria del navegador, usarlos al instante (0 ms)
  const cachedTipos = localStorage.getItem('cat_tipos');
  const cachedCat = localStorage.getItem('cat_categorias');
  const cachedEst = localStorage.getItem('cat_estados');
  const cachedDep = localStorage.getItem('cat_dependencias');

  if (cachedTipos && cachedCat && cachedEst && cachedDep) {
    tipos.value = JSON.parse(cachedTipos);
    categorias.value = JSON.parse(cachedCat);
    estados.value = JSON.parse(cachedEst);
    dependencias.value = JSON.parse(cachedDep);
    return;
  }

  // 2. Si es la primera vez que se entra, pedir de a uno para no ahogar a PHP
  try {
    if (!tipos.value.length) {
      const res = await backendApi.get('/types');
      tipos.value = res.data;
      localStorage.setItem('cat_tipos', JSON.stringify(res.data));
    }
    if (!categorias.value.length) {
      const res = await backendApi.get('/survey-categories');
      categorias.value = res.data;
      localStorage.setItem('cat_categorias', JSON.stringify(res.data));
    }
    if (!estados.value.length) {
      const res = await backendApi.get('/statuses');
      estados.value = res.data;
      localStorage.setItem('cat_estados', JSON.stringify(res.data));
    }
    if (!dependencias.value.length) {
      const res = await backendApi.get('/organizational-units');
      dependencias.value = res.data;
      localStorage.setItem('cat_dependencias', JSON.stringify(res.data));
    }
  } catch (e) {
    console.error('Error al cargar catálogos:', e);
  }
}

function cargarEstructura(survey) {
  secciones.length = 0;

  survey.sections.forEach(section => {
    secciones.push({
      backendId: section.id,
      name: section.name,
      description: section.description || '',
      questions: section.questions.map(q => {
        const options = (q.options || []).map(o => ({
          id: o.id,
          backendId: o.id,
          text: o.option_text,
        }));
        return {
          id: q.id,
          backendId: q.id,
          statement: q.statement,
          type: q.type === 'texto' ? etiquetaTipoTexto(q.max_length) : (typeLabelMap[q.type] || q.type),
          isMandatory: q.is_mandatory,
          sortOrder: q.sort_order,
          options,
          maxLength: q.max_length ?? null,
          scaleMin: q.type === 'escala' ? 1 : 1,
          scaleMax: q.type === 'escala' ? 5 : 5,
          scaleLabelMin: '',
          scaleLabelMax: '',
        };
      })
    });
  });

  const allQuestions = survey.sections.flatMap(s => s.questions);
  if (allQuestions.length > 0) {
    nextQuestionId = Math.max(...allQuestions.map(q => q.id)) + 1;
  }

  const allOptions = allQuestions.flatMap(q => q.options || []);
  if (allOptions.length > 0) {
    nextOptionId = Math.max(...allOptions.map(o => o.id)) + 1;
  }
}

async function cargarEncuesta(id) {
  const response = await backendApi.get(`/surveys/${id}`);
  const survey = response.data;

  // Asignación inmediata de cabecera
  titulo.value = survey.title;
  descripcion.value = survey.description || '';
  tipoId.value = survey.type_id;
  esAnonima.value = !!survey.is_anonymous;
  unicaRespuesta.value = !!survey.is_single_response;
  categoriaId.value = survey.survey_category_id;
  estadoId.value = survey.status_id;
  dependenciaId.value = survey.dependency_id;
  fechaInicio.value = survey.start_date ? survey.start_date.slice(0, 10) : null;
  fechaFin.value = survey.end_date ? survey.end_date.slice(0, 10) : null;

  // Carga reactiva de la estructura
  cargarEstructura(survey);
}

async function syncStructure(surveyId) {
  for (const seccion of secciones) {
    let sectionId = seccion.backendId;

    if (sectionId) {
      await backendApi.put(`/sections/${sectionId}`, {
        name: seccion.name,
        description: seccion.description || null,
      });
    } else {
      const res = await backendApi.post('/sections', {
        survey_id: surveyId,
        name: seccion.name,
        description: seccion.description || null,
      });
      sectionId = res.data.id;
      seccion.backendId = sectionId;
    }

    for (const pregunta of seccion.questions) {
      let questionId = pregunta.backendId;
      // Solo tiene sentido para texto libre; para el resto de tipos se
      // manda null explícito (por si el usuario cambió el tipo después
      // de haber tenido un límite configurado).
      const maxLengthPayload = ['Texto corto', 'Texto largo'].includes(pregunta.type)
        ? (pregunta.maxLength || null)
        : null;

      if (questionId) {
        await backendApi.put(`/questions/${questionId}`, {
          type: labelTypeMap[pregunta.type] || 'texto',
          statement: pregunta.statement,
          is_mandatory: pregunta.isMandatory,
          max_length: maxLengthPayload,
        });
      } else {
        const res = await backendApi.post('/questions', {
          section_id: sectionId,
          template_id: null,
          type: labelTypeMap[pregunta.type] || 'texto',
          statement: pregunta.statement,
          is_mandatory: pregunta.isMandatory,
          max_length: maxLengthPayload,
          sort_order: pregunta.sortOrder || (seccion.questions.indexOf(pregunta) + 1),
        });
        questionId = res.data.id;
        pregunta.backendId = questionId;
      }

      if (mostrarOpciones(pregunta.type)) {
        for (let oIndex = 0; oIndex < pregunta.options.length; oIndex++) {
          const opcion = pregunta.options[oIndex];
          if (opcion.backendId) {
            await backendApi.put(`/question-options/${opcion.backendId}`, {
              option_text: opcion.text,
            });
          } else {
            const res = await backendApi.post('/question-options', {
              question_id: questionId,
              option_text: opcion.text,
              sort_order: oIndex + 1,
            });
            opcion.backendId = res.data.id;
          }
        }
      }
    }
  }

  for (const optionId of deletedOptions.value) {
    await backendApi.delete(`/question-options/${optionId}`);
  }
  for (const questionId of deletedQuestions.value) {
    await backendApi.delete(`/questions/${questionId}`);
  }
  for (const sectionId of deletedSections.value) {
    await backendApi.delete(`/sections/${sectionId}`);
  }

  deletedOptions.value = [];
  deletedQuestions.value = [];
  deletedSections.value = [];
}

async function enviarRevision() {
  errorMsg.value = null;

  const estadoRevision = estados.value.find(e => e.slug === 'review');

  if (!estadoRevision) {
    errorMsg.value = 'No se encontró el estado "En revisión".';
    return;
  }

  try {
    const response = await backendApi.patch(`/surveys/${route.params.id}/status`, {
      status_id: estadoRevision.id,
    });

    alert.success(response.data.message || 'Encuesta enviada a revisión.');
    estadoId.value = estadoRevision.id;
  } catch (e) {
    errorMsg.value = e.response?.data?.message || 'No se pudo enviar a revisión.';
  }
}

// Genérica: usada por "Publicar" (Encuestador) y "Aprobar"/"Rechazar"
// (Administrador). El backend valida por su cuenta, con su propia
// máquina de estados, si la transición es realmente válida y si el rol
// tiene el permiso puntual para hacerla (ver
// SurveyController::habilidadRequerida) — esto es solo la UI.
async function cambiarEstadoPorSlug(slug, mensajeExito) {
  errorMsg.value = null;

  const estadoDestino = estados.value.find(e => e.slug === slug);
  if (!estadoDestino) {
    errorMsg.value = `No se encontró el estado "${slug}" en el catálogo.`;
    return;
  }

  try {
    await backendApi.patch(`/surveys/${route.params.id}/status`, {
      status_id: estadoDestino.id,
    });
    alert.success(mensajeExito);
    estadoId.value = estadoDestino.id;
  } catch (e) {
    errorMsg.value = e.response?.data?.message || 'No se pudo cambiar el estado.';
  }
}

async function guardarEncuesta() {
  errorMsg.value = null;

  // Validación visual con Vuetify
  const { valid } = await formRef.value.validate();
  if (!valid) {
    errorMsg.value = 'Por favor completa los campos obligatorios.';
    return;
  }

  const payload = {
    title: titulo.value,
    description: descripcion.value,
    is_single_response: unicaRespuesta.value,
    is_anonymous: esAnonima.value,
    survey_category_id: categoriaId.value,
    type_id: tipoId.value,
    start_date: fechaInicio.value || null,
    end_date: fechaFin.value || null,
  };

  if (!esEdicion.value) {
    payload.status_id = estadoId.value;
    payload.dependency_id = dependenciaId.value;
  }

  try {
    if (esEdicion.value) {
      const id = route.params.id;
      await backendApi.put(`/surveys/${id}`, payload);
      await syncStructure(id);
      alert.success('Encuesta guardada correctamente.');
    } else {
      const response = await backendApi.post('/surveys', payload);
      const nuevaId = response.data.id;
      router.push(`/surveys/${nuevaId}/edit`);
    }
  } catch (e) {
    errorMsg.value = e.response?.data?.message || 'No se pudo guardar la encuesta.';
  }
}

function cancelar() {
  router.push('/surveys');
}

onMounted(async () => {
  try {
    if (esEdicion.value) {
      const surveyId = route.params.id;

      // 1. Cargar la encuesta e inmediatamente quitar la pantalla de carga ("loading")
      await cargarEncuesta(surveyId);
      loading.value = false;

      // 2. Cargar los catálogos en segundo plano sin bloquear la UI
      cargarCatalogos();
    } else {
      await cargarCatalogos();
      secciones.length = 0;
      loading.value = false;
    }
  } catch (e) {
    errorMsg.value = e.response?.data?.message || 'No se pudo cargar la encuesta.';
    loading.value = false;
  }
});
</script>

<style scoped>
.section-card {
  background-color: #ffffff !important;
}

/* Encuestas no editables (ej. Publicada): se ve el contenido pero no se
   puede interactuar con él, sin tener que deshabilitar campo por campo.
   El backend es quien realmente hace cumplir la regla (ver
   SurveyController::update, SectionController, QuestionController);
   esto es solo para que la UI no invite a hacer algo que será rechazado. */
.campos-bloqueados {
  pointer-events: none;
  opacity: 0.6;
  user-select: none;
}

/* Excepción: los comentarios de corrección deben poder verse/agregarse
   incluso cuando la encuesta NO es editable — de hecho es justo en
   "En revisión" (no editable) cuando el Administrador más los necesita. */
.campos-bloqueados .permite-interaccion {
  pointer-events: auto;
  opacity: 1;
}

/* =============================================
   TARJETAS DE COMENTARIOS DEL "PAPELITO"
   Todas las reglas usan !important y valores en píxeles para que no
   las pise ninguna clase utilitaria de Vuetify ni estilos heredados.
============================================= */
.comentario-card {
  background-color: #FAFAFA;
  border-radius: 8px;
  padding: 16px 18px !important;
  border-left: 4px solid #B4B2A9;
}

.comentario-card--admin {
  background-color: #FFF8E6;
  border-left-color: #8A6D00;
}

.comentario-card--encuestador {
  background-color: #EEF3FC;
  border-left-color: #2D52A7;
}

/* Círculo de iniciales | nombre y comentario */
.comentario-fila {
  display: flex;
  align-items: flex-start;
  gap: 9px !important;
}

/* El encabezado mide más que el círculo (32px), así el comentario
   empieza debajo de él, no a su altura. */
.comentario-header {
  min-height: 33px !important;
}

/* Nombre y cargo con espacio entre ellos */
.comentario-nombre {
  display: inline-flex;
  align-items: center;
  flex-wrap: wrap;
  font-size: 14px !important;
  gap: 12px !important;
  line-height: 1.4 !important;
}

.comentario-texto {
  margin-top: 10px !important;
  line-height: 1.6 !important;
  white-space: pre-wrap;
  word-break: break-word;
}

:deep(.v-field) {
  background-color: #E8F0F8 !important;
  border-radius: 4px !important;
  
}

:deep(.v-field--variant-outlined .v-field__outline) {
  display: none;
}

:deep(.v-field--variant-outlined) {
  border: none !important;
  box-shadow: none !important;
}

:deep(.input-field .v-label) {
  font-size: 10px !important;
  font-weight: 600 !important;
  letter-spacing: 0 !important;
  line-height: 100% !important;
}

:deep(.input-field input),
:deep(.input-field textarea),
:deep(.input-field .v-select__selection-text) {
  font-size: 12px !important;
  font-weight: 400 !important;
  letter-spacing: 0 !important;
}

.question-item {
  background: #ffffff;
  border-left: 3px solid #4880FF;
  border-radius: 4px;
  cursor: default;
}

.drag-handle {
  cursor: grab;
}
.drag-handle:active {
  cursor: grabbing;
}

.custom-switch-wrapper {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}

.custom-switch-label {
  font-size: 10px !important;
  font-weight: 600 !important;
  color: #333;
}

.switch-wrap {
  position: relative;
  cursor: pointer;
  background: #ffffff;
  padding: 3px;
  width: 38px;
  height: 20px;
  border-radius: 10px;
  box-sizing: border-box;
  border: 1px solid #063456;
  transition: background 0.2s;
}

.switch-wrap input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch {
  height: 100%;
  display: grid;
  grid-template-columns: 0fr 1fr 1fr;
  transition: grid-template-columns 0.2s;
}

.switch::after {
  content: '';
  border-radius: 50%;
  background: #063456;
  grid-column: 2;
  transition: background 0.2s;
}

.switch-wrap:has(input:checked) {
  background: #063456;
  border-color: #063456;
}

.switch-wrap:has(input:checked) .switch {
  grid-template-columns: 1fr 1fr 0fr;
}

.switch-wrap:has(input:checked) .switch::after {
  background: #ffffff;
}

.text-button {
  font-weight: 400 !important;
}

.question-type-picker {
  border: 1px solid #D9E2F0;
  border-radius: 10px;
  padding: 10px;
  margin-top: 8px;
  background-color: #F9FBFE;
}

.question-type-picker-header {
  font-size: 12px;
  font-weight: 600;
  color: #313845;
  margin-bottom: 8px;
  letter-spacing: 0;
}

.question-type-menu {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.question-type-btn {
  background-color: #4880FF75 !important;
  color: #313845 !important;
  font-weight: 400 !important;
  border-radius: 6px !important;
  padding: 0 12px !important;
  min-height: 23px !important;
  height: auto !important;
  box-shadow: none !important;
  text-transform: none !important;
}

/* =============================================
   PREVIEW BOLETÍN COMPLETO
============================================= */
.preview-card {
  border-radius: 12px;
  overflow: hidden;
}

.preview-card-header {
  background-color: #2D52A7;
  padding: 24px 28px;
  color: #ffffff;
}

.preview-title {
  font-size: 1.4rem;
  font-weight: 600;
  line-height: 1.2;
  margin-bottom: 6px;
}

.preview-description {
  font-size: 0.9rem;
  font-weight: 300;
  opacity: 0.9;
  margin: 0;
}

.preview-card-body {
  background-color: #F4F7FD;
  padding: 24px 28px;
}

.preview-section {
  background-color: #ffffff;
  border: 1px solid #E3EBF5;
  border-radius: 10px;
  padding: 18px 20px;
  margin-bottom: 18px;
}

.preview-section-title {
  font-size: 1rem;
  font-weight: 600;
  color: #1E293B;
  margin-bottom: 4px;
}

.preview-section-description {
  font-size: 0.8rem;
  color: #64748B;
  margin-bottom: 16px;
}

.preview-question {
  background-color: #ffffff;
  border-left: 3px solid #4880FF;
  border-radius: 8px;
  padding: 12px 14px;
  margin-bottom: 12px;
}

.preview-question-statement {
  font-size: 0.85rem;
  font-weight: 500;
  color: #1E293B;
  margin-bottom: 8px;
}

.preview-mandatory {
  color: #E42716;
  font-weight: 700;
}

.preview-options {
  list-style: none;
  padding-left: 0;
  margin: 0;
}

.preview-options li {
  font-size: 0.8rem;
  color: #313845;
  padding: 3px 0;
  display: flex;
  align-items: center;
}

.preview-scale {
  display: flex;
  gap: 8px;
  margin-top: 6px;
}

.preview-scale-btn {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  border: 1px solid #323A45;
  background-color: #ffffff;
  color: #323A45;
  font-size: 0.85rem;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.7;
  cursor: not-allowed;
}

.preview-field-hint {
  font-size: 0.75rem;
  color: #64748B;
  margin: 0;
}
</style>