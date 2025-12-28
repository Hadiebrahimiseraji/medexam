import { defineStore } from 'pinia';
import { ref } from 'vue';

export const usePathStore = defineStore('path', () => {
  const specialty = ref(null);
  const examLevel = ref(null);
  const subspecialty = ref(null);

  const setPath = (newSpecialty, newLevel, newSubspecialty = null) => {
    specialty.value = newSpecialty;
    examLevel.value = newLevel;
    subspecialty.value = newSubspecialty;
  };

  const clearPath = () => {
    specialty.value = null;
    examLevel.value = null;
    subspecialty.value = null;
  };

  return {
    specialty,
    examLevel,
    subspecialty,
    setPath,
    clearPath
  };
});
