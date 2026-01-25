<template>
  <q-page class="q-pa-md q-pb-xl">
    <div class="row justify-center">
      <div class="full-width" style="max-width: 1200px">
        <q-list>
          <div class="row">
            <div
              v-for="note in notesStore.notes"
              :key="note.id"
              class="q-pa-sm col-xs-12 col-sm-6 col-md-4"
            >
              <q-card bordered flat class="column full-height shadow-1">
                <q-card-section class="col">
                  <div class="text-h6 note-clamp-title">
                    {{ note.title }}
                  </div>

                  <div class="text-body2 text-grey-7 q-mt-sm note-clamp">
                    {{ note.note }}
                  </div>
                </q-card-section>

                <q-separator />

                <q-card-actions align="right" class="q-py-xs">
                  <q-btn
                    flat
                    round
                    size="sm"
                    color="secondary"
                    icon="visibility"
                    @click="openViewModal(note)"
                  >
                    <q-tooltip>View Note</q-tooltip>
                  </q-btn>

                  <q-btn
                    flat
                    round
                    size="sm"
                    color="primary"
                    icon="edit"
                    @click="openEditModal(note)"
                  >
                    <q-tooltip>Edit Note</q-tooltip>
                  </q-btn>

                  <q-btn
                    flat
                    round
                    size="sm"
                    color="negative"
                    icon="delete"
                    @click="deleteRow(note)"
                  >
                    <q-tooltip>Delete</q-tooltip>
                  </q-btn>
                </q-card-actions>
              </q-card>
            </div>
          </div>
        </q-list>

        <!-- ✅ SINGLE pagination (correct place) -->
        <div class="pagination-wrapper" v-if="totalPages != 1">
          <q-pagination
            v-model="notesStore.pagination.page"
            :max="totalPages"
            @update:model-value="onPageChange"
          />
        </div>
      </div>
    </div>

    <note-modal
      v-model="isModalOpen"
      :data="selectedNote"
      :mode="modalMode"
      @refresh="refreshCurrentPage"
    />
  </q-page>
</template>

<script setup>
import { useNotesStore } from 'src/stores/notes'
import NoteModal from 'src/components/Notes/NoteModal.vue'
import { computed, onMounted, ref } from 'vue'
import { Notify } from 'quasar'

const notesStore = useNotesStore()
const selectedNote = ref({})
const isModalOpen = ref(false)
const modalMode = ref('view')

const onPageChange = (page) => {
  notesStore.fetchNotes(page, notesStore.pagination.rowsPerPage)
}

const refreshCurrentPage = () => {
  notesStore.fetchNotes(notesStore.pagination.page, notesStore.pagination.rowsPerPage)
}

const openViewModal = (note) => {
  selectedNote.value = { ...note }
  modalMode.value = 'view'
  isModalOpen.value = true
}

const totalPages = computed(() =>
  Math.ceil(notesStore.pagination.rowsNumber / notesStore.pagination.rowsPerPage),
)

async function openEditModal(note) {
  if (confirm(`Edit Note: ${note.title}?`)) {
    const data = await notesStore.fetchNoteById(note.id)
    console.log('Fetched note for editing:', data)
    selectedNote.value = { ...data }
    modalMode.value = 'edit'
    isModalOpen.value = true
  }
}

async function deleteRow(note) {
  if (confirm(`Delete note: ${note.title}?`)) {
    try {
      const response = await notesStore.deleteNote(note.id) // ✅ await here
      console.log('Delete response:', response)

      // QNotify shows message safely
      Notify.create({
        type: 'positive',
        message: response?.data?.message || 'gone now',
      })

      refreshCurrentPage()
    } catch (err) {
      console.error('Delete failed:', err)
      Notify.create({
        type: 'negative',
        message: 'Failed to delete note.',
      })
    }
  }
}

onMounted(() => {
  refreshCurrentPage()
})
</script>

<style scoped>
.note-clamp {
  display: -webkit-box;
  -webkit-line-clamp: 5;
  line-clamp: 5;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.note-clamp-title {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  font-weight: 500;
}

.full-height {
  height: 100%;
}

.pagination-wrapper {
  position: fixed; /* 🔹 makes it always at viewport bottom */
  bottom: 0;
  left: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  background: white;
  padding: 10px 0;
  z-index: 50; /* above all content */
  box-shadow: 0 -2px 6px rgba(0, 0, 0, 0.1);
}
</style>
