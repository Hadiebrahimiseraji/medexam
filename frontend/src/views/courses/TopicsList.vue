<template>
  <div>
    <h1 class="text-4xl font-bold mb-8">موضوعات</h1>

    <div class="space-y-4">
      <router-link
        v-for="topic in topics"
        :key="topic.id"
        :to="`/topics/${topic.slug}/study`"
        class="card p-6 hover:shadow-lg"
      >
        <h2 class="text-xl font-bold text-teal-600 mb-2">{{ topic.name_fa }}</h2>
        <p class="text-gray-600">{{ topic.questions_count }} سوال | تخمین {{ topic.estimated_study_time }} دقیقه</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { courseService } from '../../services/api';

export default {
  name: 'TopicsList',
  setup() {
    const route = useRoute();
    const topics = ref([]);

    onMounted(async () => {
      try {
        const response = await courseService.getTopics(route.params.chapterSlug);
        topics.value = response.data.data;
      } catch (error) {
        console.error('Failed to load topics:', error);
      }
    });

    return { topics };
  }
};
</script>
