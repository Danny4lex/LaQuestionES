# LaQuestionES - Aplicación Móvil (Ionic + Vue)

Repositorio de proyecto final de UFDS, Metodologías, Apps móviles.

Portal Ciudadano de Encuestas Públicas desarrollado con **Ionic 8 + Vue 3**, optimizado para dispositivos móviles con diseño institucional y arquitectura desacoplada conectada a la API de Laravel.

---

## 🚀 Requisitos Previos

- **Node.js**: v18+ o v20+
- **Backend Laravel**: En ejecución en `http://127.0.0.1:8000`

---

## 📦 Instalación y Ejecución

1. **Instalar dependencias:**
   ```bash
   npm install
   ```

2. **Configurar variables de entorno:**
   Copia el archivo `.env.example` a `.env`:
   ```bash
   cp .env.example .env
   ```
   Verifica que apunte a tu servidor Laravel:
   ```env
   VITE_BACKEND_URL=http://127.0.0.1:8000
   ```

3. **Ejecutar en modo desarrollo:**
   ```bash
   npm run dev
   ```
   - **En PC:** Accede a `http://localhost:5173`
   - **En Móvil (misma red Wi-Fi):** Accede a `http://<TU_IP_LOCAL>:5173`

4. **Compilar para producción:**
   ```bash
   npm run build
   ```

---

## 📱 Características Principales

- **Portal Público Ciudadano:** Sin barreras de autenticación para los encuestados.
- **Iconografía Minimalista:** Integración con **Ionicons** en modo outline.
- **Métricas Interactivas:** Filtro instantáneo al tocar tarjetas de estadísticas (Total, Activas, Finalizadas).
- **Formulario Táctil:**
  - Preguntas Sí/No con botones segmentados de un toque.
  - Opciones de selección única y múltiple en tarjetas táctiles.
  - Escala numérica del 1 al 5.
  - Barra de progreso en tiempo real (% y contador de preguntas respondidas).
- **Diseño Institucional:** Paleta de colores unificada con el panel administrativo de Vue (`#1C8686`, `#1DAFAF`, `#235454`, `#F4F6FD`).
