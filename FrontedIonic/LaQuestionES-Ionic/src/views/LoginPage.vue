<template>
  <ion-page>
    <ion-content class="ion-padding auth-content">
      <div class="auth-wrapper">
        <ion-card class="auth-card">
          <ion-card-header class="ion-text-center">
            <ion-card-title class="title">LaQuestionES</ion-card-title>
            <ion-card-subtitle class="subtitle">
              Sistema de Gestión de Encuestas
            </ion-card-subtitle>
          </ion-card-header>

          <ion-card-content>
            <p class="hint">
              Ingresa con tus credenciales institucionales para consultar y gestionar las encuestas.
            </p>

            <form @submit.prevent="handleLogin">
              <ion-item lines="inset" class="form-item">
                <ion-label position="stacked">Correo electrónico</ion-label>
                <ion-input
                  v-model="email"
                  type="email"
                  placeholder="ejemplo@cultura.gob.sv"
                  required
                  :disabled="loading"
                  autocomplete="username"
                />
              </ion-item>

              <ion-item lines="inset" class="form-item ion-margin-top">
                <ion-label position="stacked">Contraseña</ion-label>
                <ion-input
                  v-model="password"
                  type="password"
                  placeholder="••••••••"
                  required
                  :disabled="loading"
                  autocomplete="current-password"
                />
              </ion-item>

              <ion-text color="danger" v-if="error" class="error-msg">
                <p>{{ error }}</p>
              </ion-text>

              <ion-button
                type="submit"
                expand="block"
                class="ion-margin-top login-btn"
                :disabled="loading || !email || !password"
              >
                <ion-spinner v-if="loading" name="crescent" />
                <span v-else>Iniciar Sesión</span>
              </ion-button>
            </form>

            <div class="quick-access ion-margin-top">
              <p class="quick-title">Cuentas de prueba del sistema:</p>
              <div class="quick-buttons">
                <ion-button
                  fill="outline"
                  size="small"
                  expand="block"
                  @click="quickLogin('carlos.mendez@cultura.gob.sv', 'CulturaMC#2026')"
                  :disabled="loading"
                >
                  Carlos Méndez (Admin)
                </ion-button>
                <ion-button
                  fill="outline"
                  size="small"
                  expand="block"
                  class="ion-margin-top-xs"
                  @click="quickLogin('ana.ramirez@cultura.gob.sv', 'CulturaMC#2026')"
                  :disabled="loading"
                >
                  Ana Ramírez (Encuestadora)
                </ion-button>
              </div>
            </div>
          </ion-card-content>
        </ion-card>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  IonPage,
  IonContent,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardSubtitle,
  IonCardContent,
  IonItem,
  IonLabel,
  IonInput,
  IonButton,
  IonSpinner,
  IonText
} from '@ionic/vue'
import { login } from '../services/authApi'

const router = useRouter()
const email = ref('carlos.mendez@cultura.gob.sv')
const password = ref('CulturaMC#2026')
const loading = ref(false)
const error = ref('')

async function handleLogin () {
  loading.value = true
  error.value = ''
  try {
    await login(email.value, password.value)
    router.replace('/encuestas')
  } catch (err) {
    console.error('Error al iniciar sesión:', err)
    error.value =
      err.response?.data?.message ||
      'No se pudo iniciar sesión. Verifica las credenciales y que el backend de Laravel esté activo.'
  } finally {
    loading.value = false
  }
}

function quickLogin (userEmail, userPass) {
  email.value = userEmail
  password.value = userPass
  handleLogin()
}
</script>

<style scoped>
.auth-wrapper {
  max-width: 440px;
  margin: 40px auto;
}

.auth-card {
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.title {
  color: #173b68;
  font-size: 26px;
  font-weight: 700;
  margin-top: 4px;
}

.subtitle {
  color: #4a5568;
  font-size: 14px;
  margin-top: 4px;
}

.hint {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 20px;
  text-align: center;
}

.form-item {
  --background: #f8fafc;
  --border-radius: 8px;
  margin-bottom: 8px;
}

.login-btn {
  --background: #173b68;
  --border-radius: 8px;
  height: 44px;
  font-weight: 600;
}

.error-msg {
  display: block;
  font-size: 13px;
  margin-top: 10px;
  text-align: center;
}

.quick-access {
  border-top: 1px solid #e2e8f0;
  padding-top: 16px;
}

.quick-title {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  color: #64748b;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
  text-align: center;
}

.quick-buttons {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
</style>

