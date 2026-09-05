import axios from "axios";

const backendApi = axios.create({
    baseURL: import.meta.env.VITE_BACKEND_URL + "/api",
});

// Interceptor de Petición: Inyecta dinámicamente el token actualizado
backendApi.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem("access_token");
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Interceptor de Respuesta: Manejo seguro de errores y renovación JWT
backendApi.interceptors.response.use(
    (response) => response,
    async function (error) {
        const originalRequest = error.config;

        // Validación segura del estado 401 sin causar crash de JS cuando no existe error.response
        if (error.response?.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;

            try {
                const refreshEndpoint = import.meta.env.VITE_BACKEND_REFRESH_TOKEN_ENDPOINT;
                const refreshUrl = refreshEndpoint.startsWith("http")
                    ? refreshEndpoint
                    : `${import.meta.env.VITE_BACKEND_URL}${refreshEndpoint}`;

                const response = await axios.post(refreshUrl, null, {
                    headers: {
                        Authorization: "Bearer " + localStorage.getItem("access_token"),
                    },
                });

                const newToken = response.data.backend?.access_token || response.data.access_token;
                const newRefreshToken = response.data.backend?.refresh_token || response.data.refresh_token;

                localStorage.setItem("access_token", newToken);
                if (newRefreshToken) {
                    localStorage.setItem("refresh_token", newRefreshToken);
                }

                originalRequest.headers["Authorization"] = "Bearer " + newToken;
                return backendApi(originalRequest);
            } catch (refreshError) {
                localStorage.clear();
                window.location.href = "/login";
                return Promise.reject(refreshError);
            }
        }

        return Promise.reject(error);
    }
);

export default backendApi;