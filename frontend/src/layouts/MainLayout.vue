<template>
  <q-layout view="hHh Lpr fff">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />

        <!-- Centered title using flex auto margins -->
        <q-toolbar-title class="text-center"> Notes App </q-toolbar-title>

        <q-btn>Login</q-btn>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered>
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
import { ref } from 'vue'
import NavBar from 'components/Nav/NavBar.vue'

const navLinks = [
  {
    title: 'Home',
    icon: 'home',
    link: '/',
  },
  {
    title: 'Create',
    icon: 'edit',
    link: '/create',
  },
  {
    title: 'Profile',
    icon: 'account_circle',
    link: '/profile',
  },
]

const leftDrawerOpen = ref(false)

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value
}
</script>
