<template>
  <q-dialog v-model="computedModel">
    <q-card style="width: 500px; max-width: 90vw">
      <q-card-section class="row items-center q-pb-none">
        <div class="text-h6">{{ mode === 'edit' ? 'Edit Note' : 'View Note' }}</div>
        <q-space />
        <q-btn icon="close" flat round dense v-close-popup />
      </q-card-section>

      <q-card-section>
        <div v-if="mode === 'view'">
          <div class="text-subtitle1 text-weight-bold">{{ data?.title }}</div>
          <div class="q-mt-sm">{{ data?.note }}</div>
        </div>

        <div v-else>
          <q-input v-model="formData.title" label="Title" filled class="q-mb-md" />
          <q-input v-model="formData.note" label="Note" filled type="textarea" />
        </div>
      </q-card-section>

      <q-card-actions align="right" class="q-pa-md" v-if="mode === 'edit'">
        <q-btn flat label="Cancel" color="grey" v-close-popup />
        <q-btn unelevated label="Update Note" color="primary" @click="saveChanges" />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import { useNotesStore } from 'src/stores/notes'
import { notifyError, notifySuccess } from 'src/utils/notify'
import { Dialog } from 'quasar'

const props = defineProps({
  modelValue: Boolean,
  data: Object,
  mode: String,
})

const emit = defineEmits(['update:modelValue', 'refresh'])
const notesStore = useNotesStore()

// Local copy of data for the form
const formData = ref({ title: '', note: '' })

// Sync modelValue with parent
const computedModel = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

// Update local form whenever the passed data changes
watch(
  () => props.data,
  (newVal) => {
    if (newVal) formData.value = { ...newVal }
  },
  { immediate: true },
)

async function saveChanges() {
  Dialog.create({
    title: 'Confirm Update',
    message: 'Are you sure you want to update this note?',
    cancel: true,
    persistent: true,
  })
    .onOk(async () => {
      try {
        const response = await notesStore.updateNote(formData.value.id, formData.value)
        console.log('Update response:', response)

        notifySuccess(response?.message || 'Update successful')

        emit('refresh') // tell parent to reload
        computedModel.value = false // close modal
      } catch (error) {
        console.error('Update failed', error)
        notifyError(error?.message || 'Failed to update note.')
      }
    })
    .onCancel(() => {
      console.log('Update canceled')
    })
}
</script>
