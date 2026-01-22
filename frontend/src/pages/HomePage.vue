<script setup>
import { useAuthStore } from 'src/stores/auth'
import { onMounted, computed } from 'vue'

const authStore = useAuthStore()

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
    <div class="q-pt-xl">
      <q-card class="q-pa-md text-center" style="min-width: 300px">
        <q-avatar size="100px" color="primary" text-color="white" class="q-mb-md">
          <!-- {{ name.charAt(0).toUpperCase() }} -->
          <q-icon name="person"></q-icon>
        </q-avatar>

        <h3 class="q-mb-xs text-h5">{{ name }}</h3>
        <p class="text-grey">{{ email }}</p>
      </q-card>
    </div>
  </q-page>
</template>
