<template>
  <div>
    <label v-if="label" :for="id" class="block text-sm font-medium text-gray-700">
      {{ label }}
    </label>
    <div class="mt-1">
      <input
        :id="id"
        :type="type"
        :placeholder="placeholder"
        :autocomplete="autocomplete"
        :required="required"
        :maxlength="maxlength"
        :pattern="pattern"
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm
               transition-all duration-200 ease-in-out"
        :class="inputClass"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseInput',
  props: {
    id: {
      type: String,
      required: true,
    },
    label: {
      type: String,
      default: '',
    },
    type: {
      type: String,
      default: 'text',
    },
    placeholder: {
      type: String,
      default: '',
    },
    autocomplete: {
      type: String,
      default: '',
    },
    required: {
      type: Boolean,
      default: false,
    },
    maxlength: {
      type: [String, Number],
      default: null,
    },
    pattern: {
      type: String,
      default: null,
    },
    modelValue: { // Untuk mendukung v-model
      type: [String, Number],
      default: '',
    },
    inputClass: { // Properti baru untuk kustomisasi kelas input
      type: String,
      default: '',
    },
  },
  emits: ['update:modelValue'], // Mendefinisikan event yang di-emit
};
</script>

<style scoped>
/* Style tambahan jika diperlukan, tapi Tailwind sudah cukup */
</style>