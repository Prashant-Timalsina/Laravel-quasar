<template>
  <q-page class="row justify-center">
    <div class="q-mt-xl">
      <q-card class="q-pa-md" style="min-width: 400px">
        <q-card-section>
          <h3 class="text-center">{{ loginState === 'login' ? 'Login' : 'Register' }}</h3>

          <q-form @submit.prevent="submitHandler" ref="formRef">
            <q-input
              type="email"
              v-model="userForm.email"
              outlined
              clearable
              label="Email"
              class="q-mb-md"
              lazy-rules
              :rules="[
                (val) => !!val || 'email is required',
                (val) => /.+@.+\..+/.test(val) || 'Email must be valid',
              ]"
            />

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
              v-model="userForm.password"
              :type="showPassword ? 'text' : 'password'"
              outlined
              clearable
              label="Password"
              class="q-mb-md"
              lazy-rules
              :rules="[
                (val) => !!val || 'Password is required',
                (val) => !/\s/.test(val) || 'Spaces are not allowed',
                (val) => val.length >= 8 || 'Minimum 8 characters',
                (val) =>
                  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.]).{8,}$/.test(val) ||
                  'Must include uppercase, lowercase, number and special character (e.g. . ! @ #)',
              ]"
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
              <a @click="switchState('register')">Register Here</a>
            </p>

            <p v-if="loginState === 'register'">
              Already have an account?
              <a @click="switchState('login')">Login Here</a>
            </p>

            <q-btn
              type="submit"
              :label="loginState === 'login' ? 'Login' : 'Register'"
              color="primary"
              class="full-width"
            />
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { api } from 'boot/axios'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar' // 1. Import the hook

const router = useRouter()
const $q = useQuasar() // 2. Initialize it

function switchState(stateValue) {
  loginState.value = stateValue
  if (formRef.value) formRef.value.resetValidation()
  Object.assign(userForm, {
    email: '',
    password: '',
    userName: '',
  })
}

const loginState = ref('login')

const userForm = reactive({
  email: '',
  password: '',
  userName: '',
})

const showPassword = ref(false)
const formRef = ref(null)

async function submitHandler() {
  const valid = await formRef.value.validate()

  if (!valid) {
    return
  }

  try {
    const baseUrl = 'http://localhost:8000/api'
    const endpoint = loginState.value === 'login' ? `${baseUrl}/login` : `${baseUrl}/register`
    const payload = {
      email: userForm.email,
      password: userForm.password,
      ...(loginState.value === 'register' && { name: userForm.userName }),
    }

    console.log('--- Submitting ---', payload)

    const response = await api.post(endpoint, payload)

    console.log('--- API Success ---', response.data)

    if (response.data.token) {
      localStorage.setItem('token', response.data.token)
      api.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`
    }

    // 3. Success Notification
    $q.notify({
      type: 'positive',
      message: loginState.value === 'login' ? 'Welcome back!' : 'Account created successfully!',
      position: 'top',
      timeout: 2000,
    })

    formRef.value.resetValidation()
    Object.assign(userForm, {
      email: '',
      password: '',
      userName: '',
    })

    router.push('/')
  } catch (err) {
    console.error('--- API Error ---', err)

    let message = 'An unexpected error occurred'
    if (err.response?.status === 401) {
      message = 'Invalid email or password.'
    } else if (err.response?.data?.message) {
      message = err.response.data.message
    }

    // 4. Error Notification
    $q.notify({
      type: 'negative',
      message: message,
      icon: 'report_problem',
      position: 'top',
    })
  }
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
