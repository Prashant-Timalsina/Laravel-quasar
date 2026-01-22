<template>
  <q-page class="q-pa-md">
    <div class="flex flex-center">
      <q-table
        :rows="notesStore.notes"
        :columns="columns"
        flat
        bordered
        row-key="id"
        :loading="notesStore.loading"
        class="my-sticky-header-table"
        style="min-width: 800px; max-width: 100%"
        v-model:pagination="notesStore.pagination"
        @request="onRequest"
      >
        <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <div class="row no-wrap q-gutter-x-xs">
              <q-btn
                size="sm"
                flat
                round
                color="secondary"
                icon="visibility"
                @click="viewNote(props.row, 'view')"
              >
                <q-tooltip>View</q-tooltip>
              </q-btn>
              <q-btn
                size="sm"
                flat
                round
                color="primary"
                icon="edit"
                @click="editRow(props.row, 'edit')"
              >
                <q-tooltip>Edit</q-tooltip>
              </q-btn>
              <q-btn
                size="sm"
                flat
                round
                color="negative"
                icon="delete"
                @click="deleteRow(props.row)"
              >
                <q-tooltip>Delete</q-tooltip>
              </q-btn>
            </div>
          </q-td>
        </template>
      </q-table>
    </div>
    <div v-if="selectedNote" class="row justify-center">
      <q-card style="width: 800px" flat bordered>
        <q-card-section class="row items-center">
          <div class="text-h6">
            {{ isEditMode ? 'Edit Note' : 'View Note' }}
          </div>
          <q-space />

          <q-btn icon="close" flat round dense @click="selectedNote = null" />
        </q-card-section>
        <q-separator></q-separator>
        <q-card-section>
          <q-form @submit.prevent="updateNote">
            <q-input v-model="selectedNote.title" label="Title" filled :readonly="!isEditMode" />
            <q-input
              v-model="selectedNote.note"
              label="Note"
              type="textarea"
              filled
              :readonly="!isEditMode"
              class="q-mt-md"
            />

            <div v-if="isEditMode" class="row q-gutter-sm">
              <q-btn label="Update Note" type="submit" color="primary" :loading="submitting" />
              <q-btn label="Cancel" flat @click="isEditMode = false" />
            </div>

            <div v-else class="text-center text-grey-7 q-pa-xl">
              <q-icon name="info" size="lg" />
              <p>Select edit button to edit myan</p>
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { useNotesStore } from 'src/stores/notes'
import { onMounted, ref } from 'vue'

const notesStore = useNotesStore()
const selectedNote = ref(null)
const isEditMode = ref(false)
const submitting = ref(false)

const onRequest = (props) => {
  const { page, rowsPerPage } = props.pagination
  notesStore.fetchNotes(page, rowsPerPage)
}

onMounted(() => {
  notesStore.fetchNotes(notesStore.pagination.page, notesStore.pagination.rowsPerPage)
})

const columns = [
  {
    name: 'title',
    label: 'Title',
    align: 'left',
    field: 'title',
    format: (val) => {
      if (!val) return ''
      return val.length > 20 ? `${val.substring(0, 20)}...` : val
    },
    sortable: true,
  },
  {
    name: 'note',
    label: 'Note',
    align: 'left',
    field: 'note',
    format: (val) => {
      if (!val) return ''
      return val.length > 60 ? `${val.substring(0, 60)}...` : val
    },
    sortable: true,
  },
  { name: 'actions', label: 'Actions', align: 'left', field: 'actions' },
]

async function viewNote(row, mode) {
  isEditMode.value = mode === 'view' ? false : true

  try {
    const data = await notesStore.fetchNoteById(row.id)
    selectedNote.value = { ...data }
  } catch (error) {
    console.error('Error fetching note:', error)
    alert('Failed to fetch note details. Please try again.')
  }
}

async function editRow(row, mode) {
  isEditMode.value = mode === 'edit'

  try {
    const data = await notesStore.fetchNoteById(row.id)
    selectedNote.value = { ...data }
  } catch (error) {
    console.error('Error fetching note:', error)
    alert('Failed to fetch note details. Please try again.')
  }
}

async function updateNote() {
  submitting.value = true
  try {
    await notesStore.updateNote(selectedNote.value.id, selectedNote.value)
    isEditMode.value = false
    notesStore.fetchNotes()
  } finally {
    submitting.value = false
  }
}

function deleteRow(row) {
  if (confirm(`Are you sure you want to delete this note?\n\n${JSON.stringify(row)}`)) {
    notesStore.deleteNote(row.id)
  }
}
</script>
