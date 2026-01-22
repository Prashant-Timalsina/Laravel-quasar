<template>
  <q-page class="row justify-center items-center">
    <q-card class="q-pa-md" style="min-width: 400px">
      <q-card-section>
        <h3 class="text-center">Login</h3>

        <q-form @submit.prevent="submitHandler" ref="formRef">
          <q-input
            v-model="userForm.email"
            outlined
            clearable
            label="Email"
            class="q-mb-md"
            required
            placeholder="Enter email"
          />

          <q-input
            v-model="userForm.password"
            :type="showPassword ? 'text' : 'password'"
            outlined
            clearable
            label="Password"
            class="q-mb-md"
            required
            placeholder="Enter password"
          >
            <template v-slot:append>
              <q-icon
                :name="showPassword ? 'visibility_off' : 'visibility'"
                class="cursor-pointer"
                @click="showPassword = !showPassword"
              />
            </template>
          </q-input>

          <q-btn label="Login" type="submit" color="primary" class="full-width" />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { reactive, ref } from 'vue'

const userForm = reactive({
  email: '',
  password: '',
})

const showPassword = ref(false)
const formRef = ref(null)

function submitHandler() {
  alert(`${userForm.email} ${userForm.password}`)
  formRef.value.reset()
}
</script>
