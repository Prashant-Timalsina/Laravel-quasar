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
              required
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
                  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(
                    val,
                  ) || 'Must include uppercase, lowercase, number and special character',
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
              <a @click="ref((loginState = 'register'))">Register Here</a>
            </p>

            <p v-if="loginState === 'register'">
              Already have an account?
              <a @click="ref((loginState = 'login'))">Login Here</a>
            </p>

            <q-btn
              v-if="loginState === 'login'"
              label="Login"
              type="submit"
              color="primary"
              class="full-width"
              @click="loginUser"
            />
            <q-btn
              v-if="loginState === 'register'"
              label="Register"
              type="submit"
              color="primary"
              class="full-width"
              @click="registerUser"
            />
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
})

const showPassword = ref(false)
const formRef = ref(null)

async function submitHandler() {
  const success = await formRef.value.validate()
  if (success) {
    alert(`${userForm.email} ${userForm.password}`)
    formRef.value.resetValidation()

    // 2. Clear the actual data
    userForm.email = ''
    userForm.password = ''
    userForm.userName = ''
  } else {
    alert('Validation failed')
  }
}
function loginUser() {
  // Implement login logic here
  console.log('Logging in with', userForm.email, userForm.password)
}

function registerUser() {
  // Implement registration logic here
  console.log('Registering with', userForm.userName, userForm.email, userForm.password)
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
