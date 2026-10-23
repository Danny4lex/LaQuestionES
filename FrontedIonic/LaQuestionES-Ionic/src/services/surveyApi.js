import backendApi from './backendApi'

export const listarEncuestas = async (params = {}) =>
  (await backendApi.get('/public/surveys', { params })).data

export const obtenerEncuesta = async id =>
  (await backendApi.get(`/public/surveys/${encodeURIComponent(id)}`)).data

export const obtenerEncuestaPublica = async id =>
  (await backendApi.get(`/public/surveys/${encodeURIComponent(id)}`)).data

export const enviarRespuestas = async (id, payload) =>
  (
    await backendApi.post(
      `/public/surveys/${encodeURIComponent(id)}/submit`,
      payload
    )
  ).data

export function unwrapList (p) {
  if (Array.isArray(p)) return p
  for (const k of ['data', 'surveys', 'encuestas', 'items', 'results'])
    if (Array.isArray(p?.[k])) return p[k]
  return []
}

export function unwrapSurvey (p) {
  return p?.data?.survey || p?.survey || p?.data || p
}

export function getSurveyTitle (s) {
  return (
    s?.title || s?.titulo || s?.name || s?.nombre || `Encuesta ${s?.id ?? ''}`
  )
}

export function getSurveyQuestions (s) {
  if (Array.isArray(s?.questions)) return s.questions
  if (Array.isArray(s?.preguntas)) return s.preguntas
  return (s?.sections || s?.secciones || []).flatMap(
    section => section?.questions || section?.preguntas || []
  )
}

export function getQuestionOptions (q) {
  return q?.options || q?.opciones || q?.question_options || []
}
