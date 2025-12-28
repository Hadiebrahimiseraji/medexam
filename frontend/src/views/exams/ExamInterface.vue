<template>
  <div class="max-w-4xl mx-auto">
    <div v-if="exam" class="space-y-6">
      <div class="card p-6">
        <h1 class="text-2xl font-bold">{{ exam.title }}</h1>
        <p class="text-gray-600">{{ currentQuestion }} از {{ exam.total_questions }}</p>
      </div>

      <div v-if="questions[currentQuestion - 1]" class="card p-8">
        <h2 class="text-xl font-bold mb-6">{{ questions[currentQuestion - 1].question_text }}</h2>

        <div class="space-y-3">
          <label
            v-for="option in questions[currentQuestion - 1].options"
            :key="option.id"
            class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50"
          >
            <input
              type="radio"
              :value="option.id"
              v-model="selectedOption"
              class="w-4 h-4"
            />
            <span class="mr-4">{{ option.option_text }}</span>
          </label>
        </div>

        <div class="flex gap-4 mt-8">
          <button
            v-if="currentQuestion > 1"
            @click="previousQuestion"
            class="btn-secondary"
          >
            ← قبلی
          </button>
          <button
            @click="submitAnswer"
            class="btn-primary"
          >
            ثبت پاسخ
          </button>
          <button
            v-if="currentQuestion < exam.total_questions"
            @click="nextQuestion"
            class="btn-secondary"
          >
            بعدی →
          </button>
          <button
            v-if="currentQuestion === exam.total_questions"
            @click="completeExam"
            class="btn-primary ml-auto"
          >
            اتمام آزمون
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { examService } from '../../services/api';

export default {
  name: 'ExamInterface',
  setup() {
    const route = useRoute();
    const router = useRouter();
    const exam = ref(null);
    const questions = ref([]);
    const currentQuestion = ref(1);
    const selectedOption = ref(null);
    const attemptId = ref(null);

    onMounted(async () => {
      try {
        const response = await examService.start(route.params.examId);
        exam.value = response.data.data.exam;
        questions.value = response.data.data.questions;
        attemptId.value = response.data.data.attempt_id;
      } catch (error) {
        console.error('Failed to start exam:', error);
      }
    });

    const nextQuestion = () => {
      if (currentQuestion.value < exam.value.total_questions) {
        currentQuestion.value++;
        selectedOption.value = null;
      }
    };

    const previousQuestion = () => {
      if (currentQuestion.value > 1) {
        currentQuestion.value--;
        selectedOption.value = null;
      }
    };

    const submitAnswer = async () => {
      try {
        const question = questions.value[currentQuestion.value - 1];
        await examService.submitAnswer(attemptId.value, {
          question_id: question.id,
          selected_option_id: selectedOption.value
        });
        nextQuestion();
      } catch (error) {
        console.error('Failed to submit answer:', error);
      }
    };

    const completeExam = async () => {
      try {
        const response = await examService.complete(attemptId.value);
        router.push(`/exam/${route.params.examId}/results/${attemptId.value}`);
      } catch (error) {
        console.error('Failed to complete exam:', error);
      }
    };

    return {
      exam,
      questions,
      currentQuestion,
      selectedOption,
      nextQuestion,
      previousQuestion,
      submitAnswer,
      completeExam
    };
  }
};
</script>
