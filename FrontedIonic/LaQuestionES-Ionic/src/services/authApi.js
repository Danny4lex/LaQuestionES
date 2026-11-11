import backendApi from './backendApi'
import {
  saveTokens,
  saveUser,
  limpiarSesion,
  getAccessToken,
  getUser,
  getSurveyProfile
} from '../utils/session'

export const login = async (email, password) => {
  const { data } = await backendApi.post('/auth/login', { email, password })
  const token = data?.data?.backend?.access_token || data?.access_token
  const refreshToken = data?.data?.backend?.refresh_token || data?.refresh_token
  const user = data?.data?.user || data?.user
  const surveyProfile = data?.data?.survey_profile || data?.survey_profile

  if (token) {
    saveTokens(token, refreshToken)
  }
  if (user || surveyProfile) {
    saveUser(user, surveyProfile)
  }
  return data
}

export const logout = async () => {
  try {
    await backendApi.post('/auth/logout')
  } catch (err) {
    // Si expiro o fallo, igual limpiamos sesión local
  } finally {
    limpiarSesion()
  }
}

export const getUserInfo = async () => {
  const { data } = await backendApi.post('/auth/userInfo')
  if (data?.user || data?.survey_profile) {
    saveUser(data.user, data.survey_profile)
  }
  return data
}

export const isAuthenticated = () => {
  return !!getAccessToken()
}

export { getUser, getSurveyProfile }

