<script setup>
import { onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from 'src/stores/auth'

const authStore = useAuthStore()
const router = useRouter()

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

// 1. Fetch the user when the component loads
onMounted(() => {
  if (!authStore.user) {
    authStore.fetchUser()
  }
})

// 2. Use computed properties so the UI updates automatically when the store fills up
const name = computed(() => authStore.user?.name || 'Loading...')
const email = computed(() => authStore.user?.email || 'No email found')
</script>
<template>
  <q-page class="row justify-center">
    <div class="q-pa-xl">
      <q-card class="q-pa-md row fit-content-card">
        <q-card-section class="column items-center">
          <q-avatar size="200px" color="primary" text-color="white" class="q-mb-lg">
            <!-- {{ name.charAt(0).toUpperCase() }} -->
            <q-icon name="person" />
          </q-avatar>
          <q-btn @click="handleLogout">Log out</q-btn>
        </q-card-section>

        <q-card-section>
          <h3 class="q-mb-xs text-h4">{{ name }}</h3>
          <p class="text-grey q-mb-xl">{{ email }}</p>

          <q-list class="q-pa-sm text-center" bordered>
            <q-item clickable to="/notes/create" active-class="bg-primary text-white">
              <q-item-section>
                <q-item-label>Create a new Note</q-item-label>
              </q-item-section>
            </q-item>

            <q-separator spaced />

            <q-item clickable to="/notes" active-class="bg-primary text-white">
              <q-item-section>
                <q-item-label>See your notes</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<style scoped>
.fit-content-card {
  display: inline-flex; /* or inline-block */
}
</style>
