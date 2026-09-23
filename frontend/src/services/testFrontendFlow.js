import axios from 'axios';

const API_URL = 'http://127.0.0.1:8000/api';

// Reemplaza con un token válido obtenido de tu navegador (DevTools -> Application -> LocalStorage -> token)
// O con las credenciales que utilizas para el inicio de sesión
let authToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3OTAyMDA2NzAsImV4cCI6MTc5MDIwNDI3MCwibmJmIjoxNzkwMjAwNjcwLCJqdGkiOiJNc3RZTUp3RFVReThtNU43Iiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.IM4hJtLLMtgkLn9bs81E1uKt-Td7M1xNwQreunLo8iE';

async function testEndpoint(name, url) {
  const start = Date.now();
  try {
    const res = await axios.get(`${API_URL}${url}`, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        Accept: 'application/json',
      },
      timeout: 3000,
    });
    const time = Date.now() - start;
    console.log(`\x1b[32m✔ [OK]\x1b[0m ${name} -> (${res.status} OK) en ${time}ms`);
    return res.data;
  } catch (error) {
    const time = Date.now() - start;
    const status = error.response ? error.response.status : 'SIN CONEXIÓN';
    console.log(`\x1b[31m✘ [ERROR]\x1b[0m ${name} -> (${status}) en ${time}ms`);
    if (error.response?.data?.message) {
      console.log(`   └─ Detalle: ${error.response.data.message}`);
    }
  }
}

async function login() {
  try {
    console.log('Autenticando usuario con el backend...');
    // Intenta autenticar a través del endpoint de refresco o login local
    const res = await axios.post(`${API_URL}/auth/refresh`, {}, {
      withCredentials: true
    });
    authToken = res.data.access_token || res.data.token;
    console.log('\x1b[32m✔ Autenticación exitosa vía token.\x1b[0m\n');
  } catch (e) {
    console.log('\x1b[33m⚠ No se obtuvo token automático. Asegúrate de pegar un Bearer Token válido en authToken.\x1b[0m\n');
  }
}

async function runFrontendDiagnostics() {
  console.log('\n==================================================');
  console.log('   DIAGNÓSTICO INTEGRAL DE API DESDE FRONTEND');
  console.log('==================================================\n');

  await login();

  console.log('--- Checking Catálogos ---');
  await testEndpoint('Catálogo: Tipos', '/types');
  await testEndpoint('Catálogo: Categorías', '/survey-categories');
  await testEndpoint('Catálogo: Estados', '/statuses');
  await testEndpoint('Catálogo: Unidades Organizativas', '/organizational-units');

  console.log('\n--- Checking Módulo de Encuestas ---');
  const surveys = await testEndpoint('Listado de Encuestas', '/surveys');

  if (surveys && Array.isArray(surveys) && surveys.length > 0) {
    const firstId = surveys[0].id;
    console.log(`\n--- Testing Vista Edición (Encuesta ID: ${firstId}) ---`);
    await testEndpoint(`Detalle de Encuesta (${firstId})`, `/surveys/${firstId}`);
  } else {
    console.log('\n⚠ No se encontraron encuestas para probar el detalle.');
  }

  console.log('\n==================================================');
  console.log('            DIAGNÓSTICO FINALIZADO');
  console.log('==================================================\n');
}

runFrontendDiagnostics();