import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Add token to requests if exists
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const specialtyService = {
  getAll: () => api.get('/specialties'),
  getLevels: (specialtySlug) => api.get(`/specialties/${specialtySlug}/levels`),
  getSubspecialties: (specialtySlug, levelSlug) => 
    api.get(`/specialties/${specialtySlug}/levels/${levelSlug}/subspecialties`)
};

export const courseService = {
  getAll: (params) => api.get('/courses', { params }),
  getChapters: (courseSlug) => api.get(`/courses/${courseSlug}/chapters`),
  getTopics: (chapterSlug) => api.get(`/chapters/${chapterSlug}/topics`),
  getTopic: (topicSlug) => api.get(`/courses/${topicSlug}/view`)
};

export const examService = {
  getAll: (params) => api.get('/exams', { params }),
  start: (examId) => api.post(`/exams/${examId}/start`),
  submitAnswer: (attemptId, data) => api.post(`/attempts/${attemptId}/answers`, data),
  complete: (attemptId) => api.post(`/attempts/${attemptId}/complete`),
  getResults: (attemptId) => api.get(`/attempts/${attemptId}`),
  buildCustom: (data) => api.post('/exams/custom/build', data)
};

export const userService = {
  getProgress: () => api.get('/users/me/progress'),
  recordStudyProgress: (data) => api.post('/users/me/study-progress', data),
  answerTopicQuestion: (data) => api.post('/users/me/topic-questions/answer', data)
};

export default api;
