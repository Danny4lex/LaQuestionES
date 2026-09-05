import { createApp } from "vue";
import { createPinia } from "pinia";
import { createVuetify } from "vuetify";

// ✅ Importar estilos de Vuetify
import "vuetify/styles";

import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import { es } from "vuetify/locale";
import * as labs from "vuetify/labs/VDataTable";


import App from "./App.vue";
import router from "./router";

// Importing styles
import "./assets/styles/main.scss";

const vuetify = createVuetify({
  components: {
    ...components,
    ...labs,
  },
  directives,
  locale: {
    locale: "es",
    messages: { es },
  },
  icons: {
    defaultSet: "mdi",
  },
  theme: {
    defaultTheme: "light",
    themes: {
      light: {
        colors: {
          primary: "#4880FF",
          secondary: "#E42716B0",
          accent: "#2D52A7",
          error: "#E42716B0",
          info: "#2196F3",
          success: "#9EF18D",
          warning: "#FFC107",
        },
      },
    },
  },
  defaults: {
    global: {
      fontFamily: 'Poppins, sans-serif',
    },
  },
});

const app = createApp(App);

app.use(createPinia());
app.use(vuetify);
app.use(router);

app.mount("#app");