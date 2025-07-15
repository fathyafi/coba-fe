import { createRouter, createWebHistory } from 'vue-router';
import LoginPage from '@/views/Login/LoginPage.vue';  
import RegisterPage from '@/views/Register/index.vue';
import OtpVerification from '@/views/verifikasi/OtpVerification.vue';
import Dashboard from '@/views/Dashboard/index.vue';
import ForgotPassword from '@/views/ForgotPassword/index.vue';  // Import ForgotPassword

const routes = [
  { path: '/', name: 'login', component: LoginPage },
  { path: '/login', name: 'login-page', component: LoginPage },
  { path: '/register', name: 'register', component: RegisterPage },
  { path: '/otp', name: 'otp', component: OtpVerification },
  { path: '/dashboard', name: 'dashboard', component: Dashboard },
  { path: '/forgot-password', name: 'forgot-password', component: ForgotPassword },  // Rute Forgot Password
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
