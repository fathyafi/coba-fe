<template>
  <div class="min-h-screen  flex items-center justify-center p-4">
    <div class="bg-white p-8 rounded-xl shadow-2xl max-w-md w-full animate-fade-in-down
                 hover:shadow-2xl hover:scale-[1.01] transition-all duration-300 ease-in-out">
      
      <!-- Logo BNI -->
      <div class="flex justify-center mb-6">
        <img class="h-28 w-auto" src="@/assets/BNI.webp" alt="Logo BNI" />
      </div>

      <h1 class="text-3xl font-extrabold text-center text-gray-900 mb-6">
        Sign in to your account
      </h1>

      <!-- Error Message -->
      <div v-if="errorMessage" class="bg-red-100 border border-red-500 text-red-700 p-3 rounded mb-6">
        <span class="font-semibold">ERROR: </span>{{ errorMessage }}
      </div>

      <!-- Login Form -->
      <form class="space-y-6" @submit.prevent="handleLogin">
        <BaseInput
          id="username"
          label="Username"
          type="text"
          placeholder="Enter your username"
          autocomplete="username"
          v-model="username"
          required
        />

        <BaseInput
          id="password"
          label="Password"
          type="password"
          placeholder="Enter your password"
          autocomplete="password"
          v-model="password"
          required
        />

        <!-- Remember Me Checkbox -->
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <input
              id="remember-me"
              name="remember-me"
              type="checkbox"
              class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
            />
            <label for="remember-me" class="ml-2 block text-sm text-gray-900">
              Remember me
            </label>
          </div>
          <div class="text-sm">
            <router-link to="/forgot-password" class="font-medium text-indigo-600 hover:text-indigo-500 transition-colors duration-200 ease-in-out">
              Forgot password?
            </router-link>
          </div>
        </div>

        <!-- Login Button -->
        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500
                   transition-all duration-300 ease-in-out"
            :class="{ 'opacity-50 cursor-not-allowed': isLoading }"
          >
            <span v-if="!isLoading">Login</span>
            <span v-else class="flex items-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Loading...
            </span>
          </button>
        </div>
      </form>

      <!-- Redirect to Signup -->
      <p class="mt-6 text-center text-sm text-gray-500">
        Don't have an account?
        <router-link to="/register" class="font-medium text-indigo-600 hover:text-indigo-500 transition-colors duration-200 ease-in-out">
          Sign Up
        </router-link>
      </p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';  // Pinia store untuk autentikasi
import BaseInput from '@/components/BaseInput.vue';

export default {
  name: 'LoginPage',
  components: {
    BaseInput
  },
  setup() {
    const router = useRouter();
    const authStore = useAuthStore();  // Mendapatkan Pinia store

    const username = ref('');
    const password = ref('');
    const isLoading = ref(false);
    const errorMessage = ref('');

    const handleLogin = async () => {
      isLoading.value = true;
      errorMessage.value = ''; // Reset error message sebelum memulai

      try {
        const result = await authStore.login({
          username: username.value,
          password: password.value
        });

        if (result.success) {
          // Login berhasil, arahkan ke halaman OTP jika diperlukan
          if (result.data.mfaRequired) {
            router.push('/otp');
          } else {
            router.push('/dashboard');
          }
        } else {
          // Tampilkan error jika login gagal
          errorMessage.value = result.message;
        }
      } catch (error) {
        errorMessage.value = 'Username atau Password Salah';  // Pesan error default
      } finally {
        isLoading.value = false;
      }
    };

    return {
      username,
      password,
      isLoading,
      errorMessage,
      handleLogin
    };
  }
};
</script>

<style>
#app {
  background-image: url('@/assets/background.png');
  background-size: cover;
  background-position: center;
  min-height: 100vh;
}
</style>
