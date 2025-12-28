<template>
  <div>
    <div class="mb-8">
      <router-link :to="`/${route.params.specialtySlug}`" class="text-teal-600 hover:underline">← بازگشت</router-link>
      <h1 class="text-4xl font-bold mt-4">انتخاب تخصص فرعی</h1>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <router-link
        v-for="subspecialty in subspecialties"
        :key="subspecialty.id"
        :to="`/${route.params.specialtySlug}/${route.params.levelSlug}/${subspecialty.slug}`"
        class="card p-6 hover:shadow-lg cursor-pointer"
      >
        <h2 class="text-xl font-bold text-teal-600">{{ subspecialty.name_fa }}</h2>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { specialtyService } from '../services/api';

export default {
  name: 'Subspecialties',
  setup() {
    const route = useRoute();
    const subspecialties = ref([]);

    onMounted(async () => {
      try {
        const response = await specialtyService.getSubspecialties(
          route.params.specialtySlug,
          route.params.levelSlug
        );
        subspecialties.value = response.data.data;
      } catch (error) {
        console.error('Failed to load subspecialties:', error);
      }
    });

    return { route, subspecialties };
  }
};
</script>
