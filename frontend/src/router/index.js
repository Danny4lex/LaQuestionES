import { createRouter, createWebHistory } from "vue-router";
import NotFoundView from "../views/NotFoundView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/login",
      name: "login",
      component: () => import("../views/LoginView.vue"),
      // El menú lateral no aplica antes de iniciar sesión.
      meta: { hideChrome: true },
    },
    {
      path: "/callback",
      name: "callback",
      component: () => import("../views/CallbackView.vue"),
      meta: { hideChrome: true },
    },
    {
      // FIX: antes cargaba HomeView.vue (datos hardcodeados, ej. "101"
      // encuestas fijas). El dashboard real ya existía como
      // DashboardPage.vue conectado a /dashboard/summary, pero el sidebar
      // y el CallbackView (router.push("/")) apuntaban aquí, así que
      // nunca se veía. Ahora "/" carga el dashboard real directamente.
      path: "/",
      name: "home",
      component: () => import("../views/DashboardPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/test",
      name: "test",
      component: () => import("../views/TestView.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/department",
      name: "department",
      component: () => import("../views/DepartmentView.vue"),
      meta: { requiresAuth: true },
    },
    // Nuevas rutas para las vistas de Carlos (adaptadas a Vuetify)
    {
      path: "/dashboard",
      name: "dashboard",
      component: () => import("../views/DashboardPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/surveys",
      name: "surveys",
      component: () => import("../views/SurveyListPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/surveys/new/edit",
      name: "survey-new-edit",
      component: () => import("../views/SurveyEditPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/surveys/:id/edit",
      name: "survey-edit",
      component: () => import("../views/SurveyEditPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/surveys/:id/results",
      name: "survey-results",
      component: () => import("../views/SurveyResultsPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/templates",
      name: "templates",
      component: () => import("../views/TemplateListPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      // Gestión de grupos de participantes (módulo 2.4 del documento de
      // requerimientos). El backend ya tenía /groups completo desde
      // antes, esta es la vista que faltaba para usarlo.
      path: "/groups",
      name: "groups",
      component: () => import("../views/GroupListPage.vue"),
      meta: { requiresAuth: true },
    },
    {
      path: "/catalogs",
      name: "catalogs",
      component: () => import("../views/CatalogsPage.vue"),
      // Solo el rol con "catalogs.manage" (Administrador) puede entrar,
      // ver hasPermission() en el guard de abajo.
      meta: { requiresAuth: true, permission: "catalogs.manage" },
    },
    {
      path: "/survey/:id/answer",
      name: "survey-answer",
      component: () => import("../views/SurveyAnswerPage.vue"),
      // Quien responde una encuesta pública no es un usuario del sistema
      // (no inicia sesión): el menú lateral administrativo no tiene
      // sentido aquí.
      meta: { hideChrome: true },
    },
    {
      // Enlace individual de invitación (correo con token único) — sin
      // login, ver ParticipantController::invite + SurveyPublicController.
      path: "/responder/:token",
      name: "survey-answer-by-token",
      component: () => import("../views/SurveyAnswerByTokenPage.vue"),
      meta: { hideChrome: true },
    },
    {
      path: "/:pathMatch(.*)*",
      name: "NotFound",
      component: NotFoundView,
    },
  ],
});

// add a global beforeEnter guard to check if the route requires authentication and if the user has an access token
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !hasAccessToken()) {
    return next("/login");
  }

  // Sesión válida, pero el rol no tiene acceso al panel administrativo
  // en absoluto (rol "Respondedor" — solo puede responder encuestas,
  // que es público y no pasa por aquí). Se le devuelve al login en vez
  // de dejarlo entrar a una pantalla que el backend igual le va a
  // rechazar con 403.
  if (to.meta.requiresAuth && !hasPermission("admin.access")) {
    return next("/login");
  }

  // Rutas que además exigen un permiso puntual del rol (ej. Catálogos
  // solo para "catalogs.manage").
  if (to.meta.permission && !hasPermission(to.meta.permission)) {
    return next("/dashboard");
  }

  next();
});

// helper function to check if the user has an access token
function hasAccessToken() {
  const token = localStorage.getItem("access_token");
  return token !== null && token !== undefined;
}

// helper function to check a permission from the survey_profile persisted
// at login (ver useAuth.js -> hasPermission, misma fuente de verdad).
function hasPermission(ability) {
  try {
    const profile = JSON.parse(localStorage.getItem("survey_profile"));
    return !!profile?.permissions?.includes(ability);
  } catch (e) {
    return false;
  }
}

export default router;