import { defineStore } from 'pinia'
import { api } from 'src/boot/axios'
import { baseURL } from 'src/constants'

// src/stores/notes.js
export const useNotesStore = defineStore('notes', {
  state: () => ({
    notes: [], // Change this to an array
    loading: false,
    pagination: {
      page: 1,
      rowsPerPage: 6,
      rowsNumber: 0,
    },
  }),
  actions: {
    async fetchNotes(page = 1, perPage = 6) {
      this.loading = true
      try {
        const response = await api.get(`${baseURL}/notes`, {
          params: {
            page,
            per_page: perPage,
          },
        })

        // Laravel Pagination wraps the array in response.data.data
        this.notes = response.data.data
        this.pagination.page = response.data.current_page
        this.pagination.rowsPerPage = response.data.per_page
        this.pagination.rowsNumber = response.data.total

        console.log('Notes loaded:', this.notes)
      } catch (error) {
        console.error('Error fetching notes:', error)
      } finally {
        this.loading = false
      }
    },
    // 2. Fetch single note by ID (used for the "View" button)
    async fetchNoteById(id) {
      try {
        const response = await api.get(`/notes/${id}`)
        return response.data
      } catch (error) {
        console.error('Error fetching note details:', error)
        throw error
      }
    },

    // 3. Update existing note
    async updateNote(id, updatedData) {
      try {
        const response = await api.put(`/notes/${id}`, updatedData)
        return response.data
      } catch (error) {
        console.error('Error updating note:', error)
        throw error
      }
    },
    async deleteNote(id) {
      try {
        const response = await api.delete(`${baseURL}/notes/${id}`)
        console.log(response)
      } catch (err) {
        console.log(err)
      }
    },
  },
})
