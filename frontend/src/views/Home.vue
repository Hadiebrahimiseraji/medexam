<template>
  <div class="py-16">
    <div class="text-center mb-12">
      <h1 class="text-5xl font-bold text-teal-600 mb-4">📄 MedExam</h1>
      <p class="text-xl text-gray-600">پلتفرم آزمون‌یار پزشکی</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-4xl mx-auto">
      <router-link
        v-for="specialty in specialties"
        :key="specialty.id"
        :to="`/${specialty.slug}`"
        class="card p-8 text-center hover:scale-105 cursor-pointer"
      >
        <div class="text-5xl mb-4">{{ specialty.icon }}</div>
        <h2 class="text-2xl font-bold text-teal-600 mb-2">{{ specialty.name_fa }}</h2>
        <p class="text-gray-600">{{ specialty.exam_levels_count }} سطح آزمون</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { specialtyService } from '../services/api';

export default {
  name: 'Home',
  setup() {
    const specialties = ref([]);

    onMounted(async () => {
      try {
        const response = await specialtyService.getAll();
        specialties.value = response.data.data;
      } catch (error) {
        console.error('Failed to load specialties:', error);
      }
    });

    return { specialties };
  }
};
</script>
