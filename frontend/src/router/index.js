import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/:specialtySlug',
    name: 'SpecialtyLevels',
    component: () => import('../views/SpecialtyLevels.vue')
  },
  {
    path: '/:specialtySlug/:levelSlug/subspecialties',
    name: 'Subspecialties',
    component: () => import('../views/Subspecialties.vue')
  },
  {
    path: '/:specialtySlug/:levelSlug/:subspecialtySlug?',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue')
  },
  {
    path: '/:specialtySlug/:levelSlug/:subspecialtySlug?/exams',
    name: 'ExamsList',
    component: () => import('../views/exams/ExamsList.vue')
  },
  {
    path: '/:specialtySlug/:levelSlug/:subspecialtySlug?/exams/custom',
    name: 'CustomExamBuilder',
    component: () => import('../views/exams/CustomExamBuilder.vue')
  },
  {
    path: '/exam/:examId/take',
    name: 'ExamInterface',
    component: () => import('../views/exams/ExamInterface.vue')
  },
  {
    path: '/exam/:examId/results/:attemptId',
    name: 'ExamResults',
    component: () => import('../views/exams/ExamResults.vue')
  },
  {
    path: '/:specialtySlug/:levelSlug/:subspecialtySlug?/courses',
    name: 'CoursesList',
    component: () => import('../views/courses/CoursesList.vue')
  },
  {
    path: '/courses/:courseSlug/chapters',
    name: 'ChaptersList',
    component: () => import('../views/courses/ChaptersList.vue')
  },
  {
    path: '/chapters/:chapterSlug/topics',
    name: 'TopicsList',
    component: () => import('../views/courses/TopicsList.vue')
  },
  {
    path: '/topics/:topicSlug/study',
    name: 'TopicStudy',
    component: () => import('../views/courses/TopicStudy.vue')
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
