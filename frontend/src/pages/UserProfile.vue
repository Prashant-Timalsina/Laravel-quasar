<template>
  <q-page class="row justify-center">
    <div class="q-pt-xl">
      <q-card class="q-pa-md text-center">
        <q-avatar size="100px" color="grey-3" class="q-mb-md">
          <q-icon name="account_circle" size="80px" color="grey-8" />
        </q-avatar>

        <h3 class="q-mb-xs">{{ placeholder.name }}</h3>
        <p class="text-grey">{{ placeholder.role }}</p>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
const placeholder = {
  name: 'Prashant',
  role: 'Web Developer',
}
</script>
