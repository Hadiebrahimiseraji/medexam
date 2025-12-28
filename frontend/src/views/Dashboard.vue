<template>
  <div>
    <div class="mb-8">
      <h1 class="text-4xl font-bold">{{ breadcrumb }}</h1>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <router-link
        :to="`/${route.params.specialtySlug}/${route.params.levelSlug}/${route.params.subspecialtySlug}/exams`"
        class="card p-8 text-center hover:shadow-lg cursor-pointer"
      >
        <div class="text-5xl mb-4">📊</div>
        <h2 class="text-2xl font-bold text-teal-600 mb-2">آزمون‌های جامع</h2>
        <p class="text-gray-600">آزمایش در جو گرفته</p>
      </router-link>

      <router-link
        :to="`/${route.params.specialtySlug}/${route.params.levelSlug}/${route.params.subspecialtySlug}/courses`"
        class="card p-8 text-center hover:shadow-lg cursor-pointer"
      >
        <div class="text-5xl mb-4">📚</div>
        <h2 class="text-2xl font-bold text-teal-600 mb-2">درسنامه</h2>
        <p class="text-gray-600">مطالعه منظم</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { useRoute } from 'vue-router';

export default {
  name: 'Dashboard',
  setup() {
    const route = useRoute();
    const breadcrumb = 'داشبورد';

    return { route, breadcrumb };
  }
};
</script>
