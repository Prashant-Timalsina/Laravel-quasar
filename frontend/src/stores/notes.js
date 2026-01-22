import { defineStore } from 'pinia'
import { api } from 'src/boot/axios'
import { baseURL } from 'src/constants'

// src/stores/notes.js
export const useNotesStore = defineStore('notes', {
  state: () => ({
    notes: [], // Change this to an array
    loading: false,
  }),
  actions: {
    async fetchNotes() {
      this.loading = true
      try {
        const response = await api.get(`${baseURL}/notes`)

        // Laravel Pagination wraps the array in response.data.data
        this.notes = response.data.data

        console.log('Notes loaded:', this.notes)
      } catch (error) {
        console.error('Error fetching notes:', error)
      } finally {
        this.loading = false
      }
    },
  },
})
