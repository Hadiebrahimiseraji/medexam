<template>
  <div>
    <h1 class="text-4xl font-bold mb-8">آزمون‌ها</h1>

    <div class="mb-6">
      <router-link
        :to="`/${route.params.specialtySlug}/${route.params.levelSlug}/${route.params.subspecialtySlug}/exams/custom`"
        class="btn-primary"
      >
        + ساخت آزمون سفارشی
      </router-link>
    </div>

    <div class="space-y-4">
      <div
        v-for="exam in exams"
        :key="exam.id"
        class="card p-6 hover:shadow-lg"
      >
        <h3 class="text-2xl font-bold text-teal-600 mb-2">{{ exam.title }}</h3>
        <p class="text-gray-600 mb-4">{{ exam.total_questions }} سوال | {{ exam.duration_minutes }} دقیقه</p>
        <router-link
          :to="`/exam/${exam.id}/take`"
          class="btn-primary"
        >
          شروع آزمون
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { examService } from '../../services/api';

export default {
  name: 'ExamsList',
  setup() {
    const route = useRoute();
    const exams = ref([]);

    onMounted(async () => {
      try {
        const response = await examService.getAll({
          specialty_id: 1,
          exam_level_id: 3,
          subspecialty_id: route.params.subspecialtySlug
        });
        exams.value = response.data.data;
      } catch (error) {
        console.error('Failed to load exams:', error);
      }
    });

    return { route, exams };
  }
};
</script>
