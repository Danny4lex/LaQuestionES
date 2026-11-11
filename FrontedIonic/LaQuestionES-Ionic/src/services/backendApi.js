import axios from 'axios'
import { getAccessToken, limpiarSesion, saveTokens } from '../utils/session'
const backendUrl = import.meta.env.VITE_BACKEND_URL
const isBrowser = typeof window !== 'undefined'
const base = isBrowser && (import.meta.env.DEV || !backendUrl || backendUrl.includes('127.0.0.1') || backendUrl.includes('localhost'))
  ? ''
  : (backendUrl || 'http://127.0.0.1:8000').replace(/\/$/, '')

const backendApi = axios.create({
  baseURL: base ? `${base}/api` : '/api',
  headers: { Accept: 'application/json' }
})
backendApi.interceptors.request.use(config => {
  const token = getAccessToken()
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})
let refreshInProgress = null
backendApi.interceptors.response.use(
  response => response,
  async error => {
    const original = error.config
    if (error.response?.status === 401 && original && !original._retry) {
      const refreshToken = localStorage.getItem('refresh_token')
      const refreshPath =
        import.meta.env.VITE_BACKEND_REFRESH_TOKEN_ENDPOINT ||
        '/api/auth/refresh'
      if (refreshToken && !original.url?.includes('/auth/refresh')) {
        original._retry = true
        try {
          if (!refreshInProgress) {
            const url = /^https?:\/\//i.test(refreshPath)
              ? refreshPath
              : `${base}${refreshPath.startsWith('/') ? '' : '/'}${refreshPath}`
            refreshInProgress = axios
              .post(
                url,
                {},
                {
                  headers: {
                    Authorization: `Bearer ${refreshToken}`,
                    Accept: 'application/json'
                  }
                }
              )
              .finally(() => {
                refreshInProgress = null
              })
          }
          const response = await refreshInProgress
          const data = response.data?.backend || response.data
          saveTokens(data?.access_token, data?.refresh_token)
          if (!data?.access_token)
            throw new Error(
              'El endpoint de renovación no devolvió access_token.'
            )
          original.headers = original.headers || {}
          original.headers.Authorization = `Bearer ${data.access_token}`
          return backendApi(original)
        } catch (refreshError) {
          limpiarSesion()
          return Promise.reject(refreshError)
        }
      }
    }
    return Promise.reject(error)
  }
)
export default backendApi
