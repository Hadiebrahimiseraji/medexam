<template>
  <div>
    <h1 class="text-4xl font-bold mb-8">فصل‌ها</h1>

    <div class="space-y-4">
      <router-link
        v-for="chapter in chapters"
        :key="chapter.id"
        :to="`/chapters/${chapter.slug}/topics`"
        class="card p-6 hover:shadow-lg"
      >
        <h2 class="text-xl font-bold text-teal-600 mb-2">{{ chapter.name_fa }}</h2>
        <p class="text-gray-600">{{ chapter.topics_count }} موضوع | تخمین {{ chapter.estimated_study_time }} دقیقه</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { courseService } from '../../services/api';

export default {
  name: 'ChaptersList',
  setup() {
    const route = useRoute();
    const chapters = ref([]);

    onMounted(async () => {
      try {
        const response = await courseService.getChapters(route.params.courseSlug);
        chapters.value = response.data.data;
      } catch (error) {
        console.error('Failed to load chapters:', error);
      }
    });

    return { chapters };
  }
};
</script>
