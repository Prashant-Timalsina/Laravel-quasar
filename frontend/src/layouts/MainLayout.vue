<template>
  <q-layout view="hHh Lpr fff">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />

        <!-- Centered title using flex auto margins -->
        <q-toolbar-title class="text-center"> Notes App </q-toolbar-title>

        <div v-if="authStore.isLoggedIn" class="row items-center">
          <q-btn
            flat
            no-caps
            :label="`Hi, ${authStore.user?.name}`"
            @click="homeRoute"
            icon="person"
          />
          <q-btn flat round icon="logout" @click="handleLogout" />
        </div>

        <q-btn v-else flat label="Login" @click="moveToLogin" />
      </q-toolbar>
    </q-header>

    <q-drawer
      v-if="authStore.isLoggedIn"
      v-model="leftDrawerOpen"
      :style="{ backgroundColor: '#f2f2f2' }"
      :width="200"
      :breakpoint="900"
      show-if-above
      bordered
    >
      <q-list>
        <q-item-label header> Navigation Links </q-item-label>

        <NavBar v-for="link in navLinks" :key="link.title" v-bind="link" />
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import NavBar from 'components/Nav/NavBar.vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from 'src/stores/auth'

const authStore = useAuthStore()
const router = useRouter()

const navLinks = [
  {
    title: 'Home',
    icon: 'account_circle',
    link: '/home',
  },
  {
    title: 'Create',
    icon: 'edit',
    link: '/notes/create',
  },
  {
    title: 'Notes List',
    icon: 'list',
    link: '/notes',
  },
]

const leftDrawerOpen = ref(false)

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

function moveToLogin() {
  router.push('/')
}

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

const homeRoute = () => {
  router.push('/home')
}

onMounted(() => {
  // Fetch user if token exists
  if (localStorage.getItem('token')) {
    authStore.fetchUser()
  }
})
</script>
