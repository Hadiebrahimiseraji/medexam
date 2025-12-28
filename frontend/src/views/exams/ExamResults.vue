<template>
  <div class="max-w-2xl mx-auto">
    <div class="card p-8 text-center">
      <h1 class="text-4xl font-bold mb-4">🌟 براوور🌟</h1>
      <p class="text-6xl font-bold text-teal-600 mb-4">{{ results?.score }}/{{ results?.total_questions }}</p>
      <p class="text-2xl font-bold mb-8">{{ results?.percentage }}%</p>

      <div class="grid grid-cols-3 gap-4 mb-8">
        <div class="p-4 bg-green-50 rounded-lg">
          <p class="text-green-600 font-bold">{{ results?.correct_answers }}</p>
          <p class="text-sm text-gray-600">صحیح</p>
        </div>
        <div class="p-4 bg-red-50 rounded-lg">
          <p class="text-red-600 font-bold">{{ results?.wrong_answers }}</p>
          <p class="text-sm text-gray-600">غلط</p>
        </div>
        <div class="p-4 bg-gray-50 rounded-lg">
          <p class="text-gray-600 font-bold">{{ results?.unanswered || 0 }}</p>
          <p class="text-sm text-gray-600">بی‌پاسخ</p>
        </div>
      </div>

      <router-link to="/" class="btn-primary">
        بازگشت به خانه
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { examService } from '../../services/api';

export default {
  name: 'ExamResults',
  setup() {
    const route = useRoute();
    const results = ref(null);

    onMounted(async () => {
      try {
        const response = await examService.getResults(route.params.attemptId);
        results.value = response.data.data.attempt;
      } catch (error) {
        console.error('Failed to load results:', error);
      }
    });

    return { results };
  }
};
</script>
