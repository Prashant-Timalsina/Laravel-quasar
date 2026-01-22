<template>
  <q-page class="row justify-center">
    <q-card class="q-pa-md" style="min-width: 500px">
      <q-card-section>
        <div class="text-h6">Add Note</div>

        <q-form @submit.prevent="submitForm" ref="formRef">
          <q-input
            v-model="form.title"
            label="Title"
            outlined
            clearable
            class="q-mb-md"
            placeholder="Enter title"
            required
          />
          <q-input
            v-model="form.content"
            label="Content"
            outlined
            clearable
            class="q-mb-md"
            placeholder="Enter content"
            required
          />
          <q-btn type="submit" label="Submit" color="primary" />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { reactive, ref } from 'vue'

const form = reactive({
  title: '',
  content: '',
})

const formRef = ref(null)
function submitForm() {
  console.log('Form Submitted:', form)
  alert(`Note is: ${form.title} ${form.content}`)

  formRef.value.reset()
}
</script>
