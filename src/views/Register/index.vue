<template>
  <div class="min-h-screen flex items-center justify-center p-4">
    <div class="bg-white p-8 rounded-xl shadow-2xl max-w-md w-full animate-fade-in-down
                 hover:shadow-2xl hover:scale-[1.01] transition-all duration-300 ease-in-out">
      <h1 class="text-3xl font-extrabold text-center text-gray-900 mb-6">
        Daftar Akun Baru
      </h1>
      <p class="text-center text-gray-600 mb-8">
        Selamat datang! Silakan isi data diri Anda.
      </p>

      <AlertMessage
        :message="alertMessage"
        :type="alertType"
        :isVisible="showAlert"
        :duration="alertDuration" 
        @update:isVisible="showAlert = $event; resetAlertState()" 
      />

      <form class="space-y-6" @submit.prevent="handleRegister">
        <BaseInput
          id="fullName"
          label="Nama Lengkap"
          type="text"
          placeholder="Masukkan nama lengkap Anda"
          autocomplete="name"
          required
          v-model="fullName"
        />
        <BaseInput
          id="email"
          label="Email"
          type="email"
          placeholder="Masukkan email Anda"
          autocomplete="email"
          required
          v-model="email"
        />

        <BaseInput
          id="phone"
          label="Nomor Telepon"
          type="phone"
          placeholder="Masukkan nomor telepon anda"
          autocomplete="phone"
          required
          v-model="phone"
        />        

        <BaseInput
          id="username"
          label="Nama Pengguna"
          type="text"
          placeholder="Pilih nama pengguna"
          autocomplete="username"
          required
          v-model="username"
        />
        <BaseInput
          id="password"
          label="Kata Sandi"
          type="password"
          placeholder="Buat kata sandi baru"
          autocomplete="new-password"
          required
          v-model="password"
        />
        <BaseInput
          id="confirmPassword"
          label="Konfirmasi Kata Sandi"
          type="password"
          placeholder="Masukkan ulang kata sandi"
          autocomplete="new-password"
          required
          v-model="confirmPassword"
        />
        <div>
          <button
            type="submit"
            :disabled="authStore.isLoading"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500
                   transition-all duration-300 ease-in-out"
            :class="{ 'opacity-50 cursor-not-allowed': authStore.isLoading }"
          >
            <span v-if="!authStore.isLoading">Daftar Sekarang</span>
            <span v-else class="flex items-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Mendaftar...
            </span>
          </button>
        </div>
      </form>

      <p class="mt-6 text-center text-sm text-gray-500">
        Sudah punya akun?
        <router-link to="/" class="font-medium text-indigo-600 hover:text-indigo-500 transition-colors duration-200 ease-in-out">
          Login di sini
        </router-link>
      </p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';  // Mengimpor store Pinia
import BaseInput from '@/components/BaseInput.vue';
import AlertMessage from '@/components/AlertMessage.vue';

export default {
  name: 'RegisterPage',
  components: {
    BaseInput,
    AlertMessage,
  },
  setup() {
    const router = useRouter();
    const authStore = useAuthStore();  // Mengakses store Pinia
    
    // Form fields
    const fullName = ref('');
    const email = ref('');
    const phone = ref('');
    const username = ref('');
    const password = ref('');
    const confirmPassword = ref('');

    // Alert state
    const showAlert = ref(false);
    const alertMessage = ref('');
    const alertType = ref('info');
    const alertDuration = ref(3000); 

    const displayAlert = (message, type, duration = 3000) => {
      alertMessage.value = message;
      alertType.value = type;
      alertDuration.value = duration;
      showAlert.value = true;
    };

    const resetAlertState = () => {
      showAlert.value = false;
      alertMessage.value = '';
      alertType.value = 'info';
      alertDuration.value = 3000;
    };

    const resetForm = () => {
      fullName.value = '';
      phone.value = '';
      email.value = '';
      username.value = '';
      password.value = '';
      confirmPassword.value = '';
    };

    const handleRegister = async () => {
      resetAlertState();  // Reset alert sebelum mulai proses

      // Validasi form
      if (!fullName.value.trim()) {
        displayAlert('Nama lengkap tidak boleh kosong.', 'error', 5000); 
        return;
      }

      if (!email.value.trim()) {
        displayAlert('Email tidak boleh kosong.', 'error', 5000);
        return;
      }

      if (!phone.value.trim()) {
        displayAlert('Nomor telepon tidak boleh kosong.', 'error', 5000);
        return;
      }

      if (!username.value.trim()) {
        displayAlert('Nama pengguna tidak boleh kosong.', 'error', 5000);
        return;
      }

      if (password.value !== confirmPassword.value) {
        displayAlert('Konfirmasi kata sandi tidak cocok.', 'error', 5000);
        return;
      }

      if (password.value.length < 6) {
        displayAlert('Kata sandi harus minimal 6 karakter.', 'error', 5000);
        return;
      }

      // Validasi email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email.value)) {
        displayAlert('Format email tidak valid.', 'error', 5000);
        return;
      }

      try {
        const result = await authStore.register({
          fullName: fullName.value,
          email: email.value,
          username: username.value,
          phone: phone.value,
          password: password.value,
          full_name: fullName.value
        });

        if (result.success) {
          displayAlert(result.message, 'success', 3000); 
          resetForm();
          setTimeout(() => {
            router.push('/login');  // Redirect setelah suksessesss
          }, 1500);
        } else {
          displayAlert(result.message || 'Pendaftaran gagal, silakan coba lagi.', 'error', 0); 
        }
      } catch (error) {
        console.error('Unexpected error:', error);
        displayAlert('Terjadi kesalahan yang tidak terduga saat pendaftaran.', 'error', 0);
      }
    };

    return {
      fullName,
      email,
      phone,
      username,
      password,
      confirmPassword,
      showAlert,
      alertMessage,
      alertType,
      alertDuration,
      authStore,
      handleRegister,
      resetAlertState,
    };
  },
};
</script>

<style scoped>
/* Styling */
</style>
