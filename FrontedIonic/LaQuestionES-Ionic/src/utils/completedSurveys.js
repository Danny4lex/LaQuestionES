import { reactive } from 'vue'
import { getSurveyTitle, getSurveyQuestions } from '../services/surveyApi'

const STORAGE_KEY = 'laquestiones_completed_surveys'

function loadFromStorage () {
  if (typeof window === 'undefined' || !window.localStorage) return []
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    if (!Array.isArray(parsed)) return []
    return parsed.filter(item => item && item.id != null)
  } catch (e) {
    console.error('Error leyendo encuestas realizadas de localStorage:', e)
    return []
  }
}

function persistToStorage (items) {
  if (typeof window === 'undefined' || !window.localStorage) return
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items))
  } catch (e) {
    console.error('Error guardando encuestas realizadas en localStorage:', e)
  }
}

export const completedSurveysState = reactive({
  items: loadFromStorage()
})

if (typeof window !== 'undefined') {
  window.addEventListener('storage', event => {
    if (event.key === STORAGE_KEY) {
      completedSurveysState.items = loadFromStorage()
    }
  })
}

export function reloadCompletedSurveys () {
  completedSurveysState.items = loadFromStorage()
}

export function getCompletedSurveys () {
  return completedSurveysState.items
}

export function getCompletedSurveyRecord (surveyId) {
  if (surveyId == null) return null
  return (
    completedSurveysState.items.find(
      item => String(item.id) === String(surveyId)
    ) || null
  )
}

export function isSurveyCompleted (surveyId) {
  return Boolean(getCompletedSurveyRecord(surveyId))
}

export function markSurveyCompleted (survey) {
  if (!survey || survey.id == null) return null

  const existing = getCompletedSurveyRecord(survey.id)
  const questionsCount =
    getSurveyQuestions(survey).length ||
    survey.questions_count ||
    existing?.questions_count ||
    0

  const record = {
    id: survey.id,
    title: getSurveyTitle(survey),
    description: survey.description || existing?.description || '',
    department: survey.department
      ? { id: survey.department.id, name: survey.department.name }
      : existing?.department || null,
    category: survey.category
      ? { id: survey.category.id, name: survey.category.name }
      : existing?.category || null,
    status: survey.status
      ? {
          id: survey.status.id,
          name: survey.status.name,
          slug: survey.status.slug
        }
      : existing?.status || null,
    questions_count: questionsCount,
    is_single_response: Boolean(survey.is_single_response),
    completedAt: new Date().toISOString(),
    timesCompleted: (existing?.timesCompleted || 0) + 1
  }

  const remaining = completedSurveysState.items.filter(
    item => String(item.id) !== String(survey.id)
  )
  const next = [record, ...remaining]
  completedSurveysState.items = next
  persistToStorage(next)

  return record
}

export function formatCompletedDate (isoDate) {
  if (!isoDate) return ''
  try {
    return new Intl.DateTimeFormat('es-SV', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    }).format(new Date(isoDate))
  } catch {
    return ''
  }
}
