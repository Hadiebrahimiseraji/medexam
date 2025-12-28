<template>
  <div class="max-w-4xl mx-auto">
    <div v-if="topic" class="space-y-8">
      <div class="card p-8">
        <h1 class="text-4xl font-bold mb-6">{{ topic.name_fa }}</h1>
        <div class="prose max-w-none" v-html="topic.summary_content"></div>
      </div>

      <div class="card p-8">
        <h2 class="text-2xl font-bold mb-6">تست موضوع</h2>
        <div class="space-y-6">
          <div
            v-for="(question, index) in topic.questions"
            :key="question.id"
            class="p-6 bg-gray-50 rounded-lg"
          >
            <h3 class="font-bold mb-4">{{ index + 1 }}. {{ question.question_text }}</h3>
            <div class="space-y-2 ml-4">
              <label
                v-for="option in question.options"
                :key="option.id"
                class="flex items-center"
              >
                <input
                  type="radio"
                  :value="option.id"
                  :name="`question-${question.id}`"
                  class="w-4 h-4"
                  @change="answerQuestion(question.id, option.id)"
                />
                <span class="mr-2">{{ option.option_text }}</span>
              </label>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { courseService, userService } from '../../services/api';

export default {
  name: 'TopicStudy',
  setup() {
    const route = useRoute();
    const topic = ref(null);

    onMounted(async () => {
      try {
        const response = await courseService.getTopic(route.params.topicSlug);
        topic.value = response.data.data;
      } catch (error) {
        console.error('Failed to load topic:', error);
      }
    });

    const answerQuestion = async (questionId, optionId) => {
      try {
        await userService.answerTopicQuestion({
          topic_id: topic.value.id,
          question_id: questionId,
          selected_option_id: optionId
        });
      } catch (error) {
        console.error('Failed to answer question:', error);
      }
    };

    return { topic, answerQuestion };
  }
};
</script>
