<template>
  <div>
    <div class="mb-8">
      <router-link to="/" class="text-teal-600 hover:underline">← بازگشت</router-link>
      <h1 class="text-4xl font-bold mt-4">{{ specialty?.name_fa }}</h1>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <router-link
        v-for="level in levels"
        :key="level.id"
        :to="getRoute(level)"
        class="card p-6 hover:shadow-lg cursor-pointer"
      >
        <div class="text-3xl mb-3">{{ level.icon }}</div>
        <h2 class="text-xl font-bold text-teal-600 mb-2">{{ level.name_fa }}</h2>
        <p class="text-gray-600">{{ level.description }}</p>
      </router-link>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { usePathStore } from '../stores/pathStore';
import { specialtyService } from '../services/api';

export default {
  name: 'SpecialtyLevels',
  setup() {
    const route = useRoute();
    const router = useRouter();
    const pathStore = usePathStore();
    const specialty = ref(null);
    const levels = ref([]);

    onMounted(async () => {
      try {
        const response = await specialtyService.getLevels(route.params.specialtySlug);
        levels.value = response.data.data;
        specialty.value = { name_fa: levels.value[0]?.specialty_id };
      } catch (error) {
        console.error('Failed to load levels:', error);
      }
    });

    const getRoute = (level) => {
      if (level.requires_subspecialty) {
        return `/${route.params.specialtySlug}/${level.slug}/subspecialties`;
      }
      return `/${route.params.specialtySlug}/${level.slug}`;
    };

    return { specialty, levels, getRoute };
  }
};
</script>
