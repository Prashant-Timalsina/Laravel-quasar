import { defineStore } from 'pinia'
import { api } from 'src/boot/axios'
import { baseURL } from 'src/constants'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    isLoggedIn: false,
    token: localStorage.getItem('token') || null,
  }),
  actions: {
    setToken(token) {
      this.token = token
      if (token) {
        localStorage.setItem('token', token)
        api.defaults.headers.common['Authorization'] = `Bearer ${token}`
      } else {
        localStorage.removeItem('token')
        delete api.defaults.headers.common['Authorization']
      }
    },
    async fetchUser() {
      if (this.token) {
        try {
          const response = await api.get(`${baseURL}/me`)
          this.user = response.data
          this.isLoggedIn = true
          console.log(response.data)
          return response.data
        } catch (err) {
          console.log('Error fetching user:', err)
          this.user = null
          this.isLoggedIn = false
          this.setToken(null)
        }
      }
    },
    logout() {
      this.user = null
      this.isLoggedIn = false
      this.setToken(null)
    },
  },
  getters: {
    isAuthenticated: (state) => state.isLoggedIn && !!state.token,
  },
})
