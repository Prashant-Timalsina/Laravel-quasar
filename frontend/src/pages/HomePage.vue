<template>
  <q-page>
    <div class="flex flex-center">
      <q-table
        :rows="placeData"
        :columns="columns"
        flat
        bordered
        style="min-width: 600px; width: auto; height: auto"
      >
        <!-- Slot for Actions column -->

        <template v-slot:body-cell-actions="props">
          <q-td>
            <q-btn dense flat color="primary" label="Edit" @click="editRow(props.row)" />
          </q-td>
          <q-td>
            <q-btn dense flat color="negative" label="Delete" @click="deleteRow(props.row)" />
          </q-td>
          <q-td>
            <q-btn dense flat color="secondary" label="View" @click="viewNote(props.row)" />
          </q-td>
        </template>
      </q-table>
    </div>
  </q-page>
</template>

<script setup>
import { useNotesStore } from 'src/stores/notes'
import { ref } from 'vue'

const notesStore = useNotesStore()
notesStore.fetchNotes()

const columns = [
  { name: 'title', label: 'Title', align: 'left', field: 'title' },
  { name: 'content', label: 'Content', align: 'left', field: 'content' },
  { name: 'actions', label: 'Actions', align: 'left', field: 'actions' },
]

const placeData = ref([
  { id: 1, title: 'Meeting Notes', content: 'Discuss project milestones and deadlines.' },
  { id: 2, title: 'Shopping List', content: 'Milk, Eggs, Bread, Butter, Apples.' },
  { id: 3, title: 'Workout Plan', content: 'Monday: Chest, Tuesday: Back, Wednesday: Legs.' },
  { id: 4, title: 'Book Ideas', content: 'Write a sci-fi novel about AI in 2050.' },
  { id: 5, title: 'Recipe', content: 'Chocolate chip cookies with extra dark chocolate.' },
  { id: 6, title: 'Travel Plan', content: 'Visit Japan in Spring, see cherry blossoms.' },
  { id: 7, title: 'Budget', content: 'Track monthly expenses: rent, groceries, utilities.' },
  { id: 8, title: 'Birthday Reminder', content: 'Send gift to Alex on March 14th.' },
  { id: 9, title: 'Study Topics', content: 'Learn Vue 3, Quasar, and Composition API.' },
  { id: 10, title: 'Ideas', content: 'Start a blog about productivity and time management.' },
])

function editRow(row) {
  alert(`Edit clicked: ${JSON.stringify(row)}`)
}

function deleteRow(row) {
  placeData.value = placeData.value.filter((item) => item.id != row.id)
}

function viewNote(row) {
  alert(`View clicked: ${JSON.stringify(row)}`)
}
</script>
