<template>
  <div>
    <h1 class="text-4xl font-bold mb-8">درس‌ها</h1>

    <div class="space-y-4">
      <router-link
        v-for="course in courses"
        :key="course.id"
        :to="`/courses/${course.slug}/chapters`"
        class="card p-6 hover:shadow-lg"
      >
        <h2 class="text-xl font-bold text-teal-600 mb-2">{{ course.name_fa }}</h2>
        <p class="text-gray-600 mb-4">{{ course.main_reference }}</p>
        <p class="text-sm text-gray-500">{{ course.chapters_count }} فصل | {{ course.total_topics || 0 }} موضوع</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { courseService } from '../../services/api';

export default {
  name: 'CoursesList',
  setup() {
    const route = useRoute();
    const courses = ref([]);

    onMounted(async () => {
      try {
        const response = await courseService.getAll({
          specialty_id: 1,
          exam_level_id: 3,
          subspecialty_id: route.params.subspecialtySlug
        });
        courses.value = response.data.data;
      } catch (error) {
        console.error('Failed to load courses:', error);
      }
    });

    return { courses };
  }
};
</script>
