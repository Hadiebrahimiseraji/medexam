<template>
  <div id="app" class="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
        <router-link to="/" class="text-2xl font-bold text-teal-600">
          📄 MedExam
        </router-link>
        <div class="flex gap-4">
          <button class="text-gray-600 hover:text-gray-900">Profile</button>
          <button class="text-gray-600 hover:text-gray-900">Logout</button>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 py-8">
      <router-view />
    </main>
  </div>
</template>

<script>
export default {
  name: 'App'
};
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>
