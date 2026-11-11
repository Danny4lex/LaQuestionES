import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import terser from "@rollup/plugin-terser";
import { VitePWA } from "vite-plugin-pwa";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), terser(), VitePWA({ registerType: "autoUpdate" })],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  server: {
    port: 5173,
    host: "127.0.0.1",
    proxy: {
      // Redirige todo /api hacia Laravel de forma transparente sin CORS
      "/api": {
        target: "http://127.0.0.1:8000",
        changeOrigin: true,
        secure: false,
      },
    },
    watch: {
      usePolling: true,
    },
  },
  build: {
    outDir: "dist",
    chunkSizeWarningLimit: 500,
    rollupOptions: {
      output: {
        // Librerías pesadas en archivos aparte: el navegador las guarda en
        // caché y no las vuelve a descargar cuando cambia el código del sistema.
        manualChunks(id) {
          if (!id.includes("node_modules")) return;
          if (id.includes("chart.js")) return "vendor-charts";
          if (id.includes("vuetify")) return "vendor-vuetify";
          if (id.includes("/vue/") || id.includes("vue-router") || id.includes("pinia") || id.includes("vue-i18n")) return "vendor-vue";
        },
      },
    },
  },
});