<template>
  <q-page>
    <div class="row justify-center q-pt-xl">
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
              type="textarea"
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
    </div>
  </q-page>
</template>

<script setup>
import { Notify } from 'quasar'
import { api } from 'src/boot/axios'
import { baseURL } from 'src/constants'
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const form = reactive({
  title: '',
  content: '',
})

const formRef = ref(null)
async function submitForm() {
  console.log('Form submitted:', form)
  // Reset the form after submission
  const response = await api.post(`${baseURL}/notes`, {
    title: form.title,
    note: form.content,
  })
  console.log('Response from server:', response.data)
  Notify.create({
    type: 'positive',
    message: 'Note created successfully!',
  })
  router.push('/lists')
  resetForm()

  formRef.value.reset()
}

function resetForm() {
  form.title = ''
  form.content = ''
}
</script>
