<template>
  <v-card class="survey-card" variant="flat">
    <!-- Cabecera -->
    <div class="survey-card-header">
      <h1 class="survey-title">{{ survey.title }}</h1>
      <p v-if="survey.description" class="survey-description">
        {{ survey.description }}
      </p>
      <p v-if="participant?.email && !esAnonima" class="survey-participant">
        Invitación para: {{ participant.name || participant.email }}
      </p>
    </div>

    <!-- Envío exitoso -->
    <v-card-text v-if="submitSuccess" class="survey-card-body text-center py-8">
      <v-icon size="56" color="success">mdi-check-circle-outline</v-icon>
      <p class="mt-3 text-body-1">{{ submitSuccess }}</p>
    </v-card-text>

    <v-card-text v-else class="survey-card-body">
      <!-- Progreso -->
      <div v-if="steps.length > 1" class="survey-progress mb-4">
        <div class="d-flex justify-space-between text-body-2 mb-1">
          <span class="progress-label">{{ currentStep.title }}</span>
          <span class="text-medium-emphasis">Paso {{ stepIndex + 1 }} de {{ steps.length }}</span>
        </div>
        <v-progress-linear
          :model-value="((stepIndex + 1) / steps.length) * 100"
          color="primary"
          height="6"
          rounded
        />
      </div>

            <!-- ============ Paso: datos del encuestado ============ -->
            <div v-if="currentStep.kind === 'datos'" class="survey-section">
        <h2 class="section-title">Datos del encuestado</h2>

        <!-- Solo si la encuesta permite participantes anónimos -->
        <div v-if="survey.anonymity_mode === 'optional'" class="survey-question">
          <v-switch
            v-model="anonimoElegido"
            color="primary"
            density="compact"
            hide-details
            label="Deseo participar de forma anónima"
          />
          <p class="section-description mt-2 mb-0">
            Si lo activas, no se te pedirán ni se guardarán tus datos personales.
          </p>
        </div>

        <template v-if="!esAnonima">
          <p class="section-description">
            Completa tus datos para comenzar la encuesta. Los campos con * son obligatorios.
          </p>

          <div class="survey-question">
            <p class="question-statement">Nombre completo <span class="mandatory-mark">*</span></p>
            <v-text-field
              v-model="respondent.name"
              placeholder="Escribe tu nombre"
              variant="outlined"
              density="compact"
              maxlength="255"
              hide-details
              class="survey-input"
            />
          </div>

          <div class="survey-question">
            <p class="question-statement">Correo electrónico <span class="mandatory-mark">*</span></p>
            <v-text-field
              v-model="respondent.email"
              type="email"
              placeholder="correo@ejemplo.com"
              variant="outlined"
              density="compact"
              maxlength="255"
              :readonly="emailLocked"
              hide-details
              class="survey-input"
            />
          </div>

          <div class="survey-question">
            <p class="question-statement">Teléfono</p>
            <v-text-field
              v-model="respondent.phone"
              type="tel"
              placeholder="7000-0000"
              variant="outlined"
              density="compact"
              maxlength="50"
              hide-details
              class="survey-input"
            />
          </div>
        </template>
      </div>

      <!-- ============ Paso: sección de la encuesta ============ -->
      <div v-else class="survey-section">
        <h2 class="section-title">{{ currentStep.section.name }}</h2>
        <p v-if="currentStep.section.description" class="section-description">
          {{ currentStep.section.description }}
        </p>

        <div
          v-for="question in currentStep.section.questions"
          :key="question.id"
          class="survey-question"
        >
          <p class="question-statement">
            {{ question.statement }}
            <span v-if="question.is_mandatory" class="mandatory-mark">*</span>
          </p>

          <v-textarea
            v-if="['texto', 'comentario', 'abierta'].includes(question.type) && question.max_length > 200"
            v-model="form[question.id]"
            placeholder="Escribe tu respuesta"
            variant="outlined"
            density="compact"
            rows="3"
            :maxlength="question.max_length"
            counter
            class="survey-input"
          />
          <v-text-field
            v-else-if="['texto', 'comentario', 'abierta'].includes(question.type)"
            v-model="form[question.id]"
            placeholder="Escribe tu respuesta"
            variant="outlined"
            density="compact"
            :maxlength="question.max_length || undefined"
            :counter="!!question.max_length"
            :hide-details="!question.max_length"
            class="survey-input"
          />

          <v-radio-group
            v-else-if="question.type === 'opcion_unica'"
            v-model="form[question.id]"
            hide-details
            class="survey-options"
          >
            <v-radio
              v-for="opt in question.options"
              :key="opt.id"
              :value="opt.id"
              :label="opt.option_text"
            />
          </v-radio-group>

          <div v-else-if="question.type === 'opcion_multiple'">
            <v-checkbox
              v-for="opt in question.options"
              :key="opt.id"
              v-model="form[question.id]"
              :value="opt.id"
              :label="opt.option_text"
              hide-details
              class="survey-checkbox"
            />
          </div>

          <div v-else-if="question.type === 'escala'" class="scale-options">
            <button
              v-for="n in 5"
              :key="n"
              type="button"
              class="scale-option-btn"
              :class="{ 'scale-option-btn--selected': form[question.id] === n }"
              @click="form[question.id] = n"
            >
              {{ n }}
            </button>
          </div>

          <v-radio-group
            v-else-if="question.type === 'si_no'"
            v-model="form[question.id]"
            inline
            hide-details
            class="survey-options"
          >
            <v-radio :value="true" label="Sí" />
            <v-radio :value="false" label="No" />
          </v-radio-group>

          <v-checkbox
            v-else-if="question.type === 'casilla'"
            v-model="form[question.id]"
            label="Sí"
            hide-details
            class="survey-checkbox"
          />
        </div>
      </div>

      <!-- Mensajes -->
      <v-alert v-if="stepError" type="error" class="mt-2" variant="tonal">
        {{ stepError }}
      </v-alert>
      <v-alert v-if="submitError" type="error" class="mt-2" variant="tonal">
        {{ submitError }}
      </v-alert>

      <!-- Navegación -->
      <div class="survey-nav mt-6">
        <v-btn
          v-if="stepIndex > 0"
          variant="outlined"
          color="primary"
          class="survey-nav-btn"
          :disabled="submitting"
          @click="anterior"
        >
          Anterior
        </v-btn>
        <v-spacer />
        <v-btn
          v-if="!esUltimoPaso"
          color="primary"
          class="survey-nav-btn"
          @click="siguiente"
        >
          Siguiente
        </v-btn>
        <v-btn
          v-else
          color="primary"
          class="survey-nav-btn"
          :loading="submitting"
          @click="enviar"
        >
          Enviar respuestas
        </v-btn>
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { ref, reactive, computed } from "vue";

const props = defineProps({
  survey: { type: Object, required: true },
  // Datos ya conocidos del encuestado (enlace de invitación).
  participant: { type: Object, default: null },
  // Si es true, el correo no se puede cambiar (viene de la invitación).
  emailLocked: { type: Boolean, default: false },
  submitting: { type: Boolean, default: false },
  submitError: { type: String, default: null },
  submitSuccess: { type: String, default: null },
});

const emit = defineEmits(["submit"]);

// Secciones con preguntas, con preguntas y opciones en su orden definido.
const porOrden = (a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0);
const sections = computed(() =>
  (props.survey.sections || [])
    .map((section) => ({
      ...section,
      questions: [...(section.questions || [])].sort(porOrden).map((question) => ({
        ...question,
        options: [...(question.options || [])].sort(porOrden),
      })),
    }))
    .filter((section) => section.questions.length > 0)
);

// Privacidad: "identified" pide datos, "optional" deja elegir al encuestado
// y "anonymous" nunca los pide.
const anonimoElegido = ref(false);
const esAnonima = computed(
  () =>
    props.survey.anonymity_mode === "anonymous" ||
    (props.survey.anonymity_mode === "optional" && anonimoElegido.value)
);

// Pasos: 1) datos del encuestado (salvo encuesta totalmente anónima), luego
// una sección de la encuesta por paso.
const steps = computed(() => {
  const list = [];
  if (props.survey.anonymity_mode !== "anonymous") {
    list.push({ kind: "datos", title: "Datos del encuestado" });
  }
  sections.value.forEach((section) => {
    list.push({ kind: "seccion", title: section.name, section });
  });
  return list;
});

const stepIndex = ref(0);
const currentStep = computed(() => steps.value[stepIndex.value]);
const esUltimoPaso = computed(() => stepIndex.value === steps.value.length - 1);
const stepError = ref(null);

const respondent = reactive({
  name: props.participant?.name || "",
  email: props.participant?.email || "",
  phone: props.participant?.phone || "",
});

const form = reactive({});
sections.value.forEach((section) => {
  (section.questions || []).forEach((question) => {
    if (question.type === "opcion_multiple") form[question.id] = [];
    else if (question.type === "casilla") form[question.id] = false;
    else form[question.id] = null;
  });
});

function scrollArriba() {
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function validarDatos() {
  if (esAnonima.value) return null;
  if (!respondent.name.trim()) return "Escribe tu nombre.";
  if (!respondent.email.trim()) return "Escribe tu correo electrónico.";
  if (!/^\S+@\S+\.\S+$/.test(respondent.email.trim())) return "El correo electrónico no es válido.";
  return null;
}

function faltantesDe(section) {
  const missing = [];
  (section.questions || []).forEach((question) => {
    if (!question.is_mandatory) return;
    const value = form[question.id];
    if (question.type === "opcion_multiple") {
      if (!value || value.length === 0) missing.push(question.statement);
    } else if (value === null || value === undefined || value === "") {
      missing.push(question.statement);
    }
  });
  return missing;
}

// Valida solo el paso actual; devuelve el mensaje de error o null.
function validarPaso(step) {
  if (step.kind === "datos") return validarDatos();
  const missing = faltantesDe(step.section);
  return missing.length
    ? "Faltan responder preguntas obligatorias: " + missing.join(", ")
    : null;
}

function siguiente() {
  stepError.value = validarPaso(currentStep.value);
  if (stepError.value) return;
  stepIndex.value += 1;
  scrollArriba();
}

function anterior() {
  stepError.value = null;
  stepIndex.value -= 1;
  scrollArriba();
}

function armarRespuestas() {
  const answers = [];
  sections.value.forEach((section) => {
    (section.questions || []).forEach((question) => {
      const value = form[question.id];
      if (question.type === "opcion_unica") {
        if (value) answers.push({ question_id: question.id, option_ids: [value] });
      } else if (question.type === "opcion_multiple") {
        if (value && value.length > 0) answers.push({ question_id: question.id, option_ids: value });
      } else if (["escala", "si_no", "casilla"].includes(question.type)) {
        if (value !== null && value !== undefined) answers.push({ question_id: question.id, value });
      } else if (value) {
        answers.push({ question_id: question.id, value });
      }
    });
  });
  return answers;
}

function enviar() {
  // Antes de enviar se revalidan todos los pasos, por si se editó uno anterior.
  for (let i = 0; i < steps.value.length; i++) {
    const error = validarPaso(steps.value[i]);
    if (error) {
      stepIndex.value = i;
      stepError.value = error;
      scrollArriba();
      return;
    }
  }
  stepError.value = null;

  const payload = { answers: armarRespuestas() };
  if (props.survey.anonymity_mode === "optional") {
    payload.anonymous = anonimoElegido.value;
  }
  if (!esAnonima.value) {
    payload.respondent = {
      name: respondent.name.trim(),
      email: respondent.email.trim(),
      phone: respondent.phone.trim() || null,
    };
  }
  emit("submit", payload);
}
</script>

<style scoped>
.survey-card {
  background-color: #ffffff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.survey-card-header {
  background-color: #2D52A7;
  padding: 24px 28px;
  color: #ffffff;
}

.survey-title {
  font-size: 1.5rem;
  font-weight: 600;
  line-height: 1.2;
  margin-bottom: 6px;
}

.survey-description {
  font-size: 0.9rem;
  font-weight: 300;
  opacity: 0.9;
  margin: 0;
}

.survey-participant {
  font-size: 0.8rem;
  opacity: 0.85;
  margin: 6px 0 0;
}

.survey-card-body {
  padding: 24px 28px;
}

.progress-label {
  font-weight: 500;
  color: #1E293B;
}

.survey-section {
  background-color: #F9FBFE;
  border: 1px solid #E3EBF5;
  border-radius: 10px;
  padding: 18px 20px;
  margin-bottom: 18px;
}

.section-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1E293B;
  margin-bottom: 4px;
}

.section-description {
  font-size: 0.8rem;
  color: #64748B;
  margin-bottom: 16px;
}

.survey-question {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 3px solid #4880FF;
}

.question-statement {
  font-size: 0.9rem;
  font-weight: 500;
  color: #1E293B;
  margin-bottom: 10px;
}

.mandatory-mark {
  color: #E42716;
  font-weight: 700;
}

.survey-input :deep(.v-field),
.survey-checkbox :deep(.v-field),
.survey-options :deep(.v-field) {
  background-color: #E8F0F8;
  border-radius: 6px;
}

.scale-options {
  display: flex;
  gap: 8px;
  margin-top: 8px;
}

.scale-option-btn {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  border: 1px solid #323A45;
  background-color: #ffffff;
  color: #323A45;
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: background-color 0.2s, color 0.2s;
}

.scale-option-btn:hover {
  background-color: #E8F0F8;
}

.scale-option-btn--selected {
  background-color: #4880FF;
  border-color: #4880FF;
  color: #ffffff;
}

.survey-nav {
  display: flex;
  align-items: center;
  gap: 12px;
}

.survey-nav-btn {
  border-radius: 50px;
  font-weight: 500;
  letter-spacing: 0;
  text-transform: none;
  min-width: 130px;
}
</style>
