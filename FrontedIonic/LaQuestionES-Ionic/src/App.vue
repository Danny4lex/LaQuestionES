<template>
  <ion-app>
    <ion-header class="ion-no-border">
      <ion-toolbar class="main-toolbar">
        <div class="toolbar-brand" @click="goHome">
          <img :src="logoUrl" alt="LaQuestionES" class="brand-logo" />
        </div>
        <div slot="end" class="toolbar-end">
          <span class="portal-badge">
            <span class="pulse-dot"></span>
            Portal Ciudadano
          </span>
        </div>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-router-outlet />
    </ion-content>
  </ion-app>
</template>

<script setup>
import { useRouter } from 'vue-router'
import {
  IonApp,
  IonHeader,
  IonToolbar,
  IonContent,
  IonRouterOutlet
} from '@ionic/vue'
import logoUrl from './assets/Logo2.png'

const router = useRouter()

function goHome () {
  router.push('/encuestas')
}
</script>

<style scoped>
.main-toolbar {
  --background: #1C8686;
  --color: #ffffff;
  --min-height: 52px;
  padding: 4px 12px;
  border-bottom: 2px solid #1DAFAF;
  box-shadow: 0 2px 8px rgba(28, 134, 134, 0.15);
}

.toolbar-brand {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.brand-logo {
  height: 30px;
  max-width: 150px;
  object-fit: contain;
  filter: brightness(0) invert(1);
}

.toolbar-end {
  display: flex;
  align-items: center;
  margin-right: 6px;
}

.portal-badge {
  background: rgba(255, 255, 255, 0.18);
  color: #ffffff;
  font-size: 11px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.28);
  letter-spacing: 0.3px;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.pulse-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #34d399;
  box-shadow: 0 0 6px #34d399;
  animation: pulse-glow 2s infinite ease-in-out;
}

@keyframes pulse-glow {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(0.85); }
}
</style>
