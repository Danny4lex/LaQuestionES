import { reactive } from 'vue'

const state = reactive({
  token: localStorage.getItem('access_token'),
  refreshToken: localStorage.getItem('refresh_token'),
  user: null,
  surveyProfile: null
})

try {
  const storedUser = localStorage.getItem('user')
  if (storedUser) state.user = JSON.parse(storedUser)
  const storedProfile = localStorage.getItem('survey_profile')
  if (storedProfile) state.surveyProfile = JSON.parse(storedProfile)
} catch (e) {
  console.error('Error parseando sesion de localStorage:', e)
}

export const sessionState = state

export function getAccessToken () {
  return state.token || localStorage.getItem('access_token')
}

export function saveTokens (accessToken, refreshToken) {
  state.token = accessToken
  state.refreshToken = refreshToken
  if (accessToken) localStorage.setItem('access_token', accessToken)
  if (refreshToken) localStorage.setItem('refresh_token', refreshToken)
  window.dispatchEvent(new Event('auth-change'))
}

export function saveUser (user, surveyProfile) {
  state.user = user
  state.surveyProfile = surveyProfile
  if (user) localStorage.setItem('user', JSON.stringify(user))
  if (surveyProfile) localStorage.setItem('survey_profile', JSON.stringify(surveyProfile))
  window.dispatchEvent(new Event('auth-change'))
}

export function getUser () {
  return state.user
}

export function getSurveyProfile () {
  return state.surveyProfile
}

export function limpiarSesion () {
  state.token = null
  state.refreshToken = null
  state.user = null
  state.surveyProfile = null
  localStorage.removeItem('access_token')
  localStorage.removeItem('refresh_token')
  localStorage.removeItem('user')
  localStorage.removeItem('survey_profile')
  window.dispatchEvent(new Event('auth-change'))
}
