import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

import terser from "@rollup/plugin-terser";
import { VitePWA } from "vite-plugin-pwa";

// https://vitejs.dev/config/
export default defineConfig({
  input: "src/index.js",
  output: {
    dir: "output",
    format: "cjs",
  },
  plugins: [vue(), terser(), VitePWA({ registerType: "autoUpdate" })],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  server: {
    port: 5173,
    host: "127.0.0.1", // <-- Cambiado a 127.0.0.1 para evitar preflights CORS
    open: "http://127.0.0.1:5173", // <-- Abre automáticamente esta IP en el navegador
    watch: {
      usePolling: true,
    },
  },
  build: {
    outDir: "dist",
    chunkSizeWarningLimit: 500,
    rollupOptions: {
      output: {
        manualChunks: {
          lodash: ["lodash"],
        },
      },
    },
  },
});