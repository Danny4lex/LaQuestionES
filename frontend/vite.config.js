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
  },
});