<template>
  <q-page class="row justify-center">
    <div class="q-mt-xl">
      <q-card class="q-pa-md" style="min-width: 400px">
        <q-card-section>
          <h3 class="text-center">{{ loginState === 'login' ? 'Login' : 'Register' }}</h3>

          <q-form @submit.prevent="submitHandler" ref="formRef">
            <q-input
              v-if="loginState === 'register'"
              v-model="userForm.userName"
              outlined
              clearable
              label="User Name"
              class="q-mb-md"
              required
            />
            <q-input
              v-if="loginState === 'register'"
              v-model="userForm.DOB"
              outlined
              clearable
              label="DOB"
              class="q-mb-md"
              required
            />

            <q-input
              type="email"
              v-model="userForm.email"
              outlined
              clearable
              label="Email"
              class="q-mb-md"
              required
            />

            <q-input
              v-model="userForm.password"
              :type="showPassword ? 'text' : 'password'"
              outlined
              clearable
              label="Password"
              class="q-mb-md"
              required
            >
              <template v-slot:append>
                <q-icon
                  :name="showPassword ? 'visibility_off' : 'visibility'"
                  class="cursor-pointer"
                  @click="showPassword = !showPassword"
                />
              </template>
            </q-input>

            <p v-if="loginState === 'login'">
              Dont you have an account?
              <a @click="ref((loginState = 'register'))">Register Here</a>
            </p>

            <p v-if="loginState === 'register'">
              Already have an account?
              <a @click="ref((loginState = 'login'))">Login Here</a>
            </p>

            <q-btn label="Login" type="submit" color="primary" class="full-width" />
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { reactive, ref } from 'vue'

const loginState = ref('login')

const userForm = reactive({
  email: '',
  password: '',
  userName: '',
  DOB: '',
})

const showPassword = ref(false)
const formRef = ref(null)

function submitHandler() {
  alert(`${userForm.email} ${userForm.password}`)
  formRef.value.reset()
}
</script>

<style scoped>
p {
  a {
    cursor: pointer;
    font-style: italic;
    color: var(--q-accent);
    text-decoration: underline;
  }
}
</style>
