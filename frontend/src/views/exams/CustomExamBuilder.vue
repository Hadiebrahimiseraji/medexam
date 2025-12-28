<template>
  <div class="max-w-2xl mx-auto">
    <h1 class="text-4xl font-bold mb-8">ساخت آزمون سفارشی</h1>

    <form @submit.prevent="buildExam" class="card p-8 space-y-6">
      <div>
        <label class="block font-bold mb-2">تعداد سوال</label>
        <input
          v-model.number="filters.questions_count"
          type="number"
          min="1"
          max="200"
          class="w-full p-2 border-2 border-gray-200 rounded-lg"
        />
      </div>

      <div>
        <label class="block font-bold mb-2">زمان (دقیقه)</label>
        <input
          v-model.number="filters.duration_minutes"
          type="number"
          min="5"
          class="w-full p-2 border-2 border-gray-200 rounded-lg"
        />
      </div>

      <div>
        <label class="flex items-center">
          <input
            v-model="filters.include_authored"
            type="checkbox"
            class="w-4 h-4"
          />
          <span class="mr-2">نفره سوالات تألیفی</span>
        </label>
      </div>

      <button type="submit" class="btn-primary w-full">
        ساخت آزمون
      </button>
    </form>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { examService } from '../../services/api';

export default {
  name: 'CustomExamBuilder',
  setup() {
    const router = useRouter();
    const filters = ref({
      questions_count: 50,
      duration_minutes: 60,
      include_authored: true
    });

    const buildExam = async () => {
      try {
        const response = await examService.buildCustom({
          specialty_id: 1,
          exam_level_id: 3,
          subspecialty_id: 1,
          filters,
          ...filters.value
        });
        router.push(`/exam/${response.data.data.exam_id}/take`);
      } catch (error) {
        console.error('Failed to build exam:', error);
      }
    };

    return { filters, buildExam };
  }
};
</script>
