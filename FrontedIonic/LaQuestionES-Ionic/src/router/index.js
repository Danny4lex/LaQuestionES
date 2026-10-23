import { createRouter, createWebHistory } from '@ionic/vue-router'
import SurveyListPage from '../views/SurveyListPage.vue'
import SurveyDetailPage from '../views/SurveyDetailPage.vue'
import SurveyAnswerPage from '../views/SurveyAnswerPage.vue'
import LoginPage from '../views/LoginPage.vue'

const routes = [
  { path: '/', redirect: '/encuestas' },
  { path: '/login', component: LoginPage },
  { path: '/encuestas', component: SurveyListPage },
  { path: '/encuestas/:id', component: SurveyDetailPage, props: true },
  { path: '/encuestas/:id/responder', component: SurveyAnswerPage, props: true }
]

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})
