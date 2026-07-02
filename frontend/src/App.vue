<template>
  <div class="app-shell">
    <!-- Real-time WebSocket Notification Toasts -->
    <div class="toast-container">
      <transition-group name="toast">
        <div v-for="toast in activeToasts" :key="toast.id" class="live-toast" :class="toast.type?.toLowerCase() || 'info'">
          <div class="toast-icon">{{ getToastIcon(toast.type) }}</div>
          <div class="toast-content">
            <div class="toast-title">{{ toast.title }}</div>
            <div class="toast-msg">{{ toast.message }}</div>
          </div>
          <button @click="dismissToast(toast.id)" class="toast-close">&times;</button>
        </div>
      </transition-group>
    </div>

    <header class="top-nav">
      <div class="nav-container">
        <RouterLink to="/" class="logo">
          <span class="logo-emoji">🍔</span>
          <span class="logo-text">Food<span class="highlight">Go</span></span>
        </RouterLink>
        <nav class="nav-links">
          <RouterLink v-if="currentRole === 'customer' || currentRole === 'guest'" to="/" class="nav-item">Home</RouterLink>
          <RouterLink v-if="currentRole === 'customer'" to="/cart" class="nav-item cart-link">
            Cart
            <span v-if="cartCount > 0" class="cart-badge">{{ cartCount }}</span>
          </RouterLink>
          <RouterLink v-if="currentRole === 'restaurant'" to="/restaurant-dashboard/orders" class="nav-item">Restaurant Board</RouterLink>
          <RouterLink v-if="currentRole === 'callcenter'" to="/call-center-dashboard" class="nav-item font-accent">Support Queue</RouterLink>
          
          <RouterLink to="/login" class="role-switcher-btn">
            <span>{{ roleEmoji }}</span>
            <span>{{ roleLabel }}</span>
          </RouterLink>
        </nav>
      </div>
    </header>
    <main class="main-content">
      <RouterView v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </RouterView>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useCartStore } from './store/cart'
import { subscribeToTopic } from './services/socket'

const cartStore = useCartStore()
const currentRole = ref(localStorage.getItem('foodgo_role') || 'guest')
const activeToasts = ref([])

function getToastIcon(type) {
  if (type === 'SUCCESS') return '🎉'
  if (type === 'WARNING') return '🚨'
  if (type === 'ERROR') return '❌'
  return '🔔'
}

function pushToast(notif) {
  const toast = {
    id: notif.id || Date.now() + Math.random(),
    title: notif.title || 'Live Notification',
    message: notif.message || '',
    type: notif.type || 'INFO'
  }
  activeToasts.value.unshift(toast)
  if (activeToasts.value.length > 4) activeToasts.value.pop()
  setTimeout(() => dismissToast(toast.id), 6000)
}

function dismissToast(id) {
  activeToasts.value = activeToasts.value.filter(t => t.id !== id)
}

const cartCount = computed(() => {
  return cartStore.items.reduce((sum, item) => sum + item.quantity, 0)
})

const roleEmoji = computed(() => {
  if (currentRole.value === 'restaurant') return '🏪'
  if (currentRole.value === 'callcenter') return '🎧'
  if (currentRole.value === 'customer') return '🍔'
  return '🔑'
})

const roleLabel = computed(() => {
  if (currentRole.value === 'restaurant') return 'Partner'
  if (currentRole.value === 'callcenter') return 'Agent'
  if (currentRole.value === 'customer') return 'Customer'
  return 'Sign In / Roles'
})

function syncRole() {
  currentRole.value = localStorage.getItem('foodgo_role') || 'guest'
}

function handleCustomToast(e) {
  if (e && e.detail) pushToast(e.detail)
}

onMounted(() => {
  window.addEventListener('role-changed', syncRole)
  window.addEventListener('storage', syncRole)
  window.addEventListener('show-toast', handleCustomToast)
  
  // Real-time notification subscription
  subscribeToTopic('/topic/notifications', (notif) => {
    if (notif) pushToast(notif)
  })
})

onUnmounted(() => {
  window.removeEventListener('role-changed', syncRole)
  window.removeEventListener('storage', syncRole)
  window.removeEventListener('show-toast', handleCustomToast)
})
</script>

<style scoped>
.app-shell {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.top-nav {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--glass-bg);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-bottom: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--space-6);
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  text-decoration: none;
}

.logo-emoji {
  font-size: 1.8rem;
}

.logo-text {
  font-family: var(--font-display);
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--color-ink);
  letter-spacing: -0.03em;
}

.logo-text .highlight {
  color: var(--color-primary);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: var(--space-6);
}

.nav-item {
  color: var(--color-muted);
  text-decoration: none;
  font-weight: 600;
  font-size: 0.95rem;
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-sm);
  transition: var(--transition-smooth);
  position: relative;
}

.nav-item:hover {
  color: var(--color-primary);
  background: var(--color-primary-light);
}

.nav-item.router-link-active {
  color: var(--color-primary);
}

.nav-item.router-link-active::after {
  content: '';
  position: absolute;
  bottom: -16px;
  left: var(--space-3);
  right: var(--space-3);
  height: 3px;
  background-color: var(--color-primary);
  border-radius: var(--radius-full) var(--radius-full) 0 0;
}

.cart-link {
  display: flex;
  align-items: center;
  gap: var(--space-1);
}

.cart-badge {
  background: var(--color-primary);
  color: white;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 2px 7px;
  border-radius: var(--radius-full);
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.role-switcher-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--color-ink);
  color: white;
  text-decoration: none;
  font-weight: 700;
  font-size: 0.85rem;
  padding: 6px 14px;
  border-radius: var(--radius-full);
  transition: all 0.2s ease;
  box-shadow: 0 4px 10px rgba(30, 30, 36, 0.15);
}

.role-switcher-btn:hover {
  background: var(--color-primary);
  transform: translateY(-1px);
}

.main-content {
  flex: 1;
  padding: var(--space-8) var(--space-6);
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
}

/* Page transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@media (max-width: 768px) {
  .nav-container {
    padding: 0 var(--space-4);
  }
  .nav-links {
    gap: var(--space-2);
  }
  .nav-item {
    font-size: 0.85rem;
    padding: var(--space-1) var(--space-2);
  }
  .nav-item.router-link-active::after {
    bottom: -22px;
  }
}

/* Real-time Toast Notifications */
.toast-container {
  position: fixed;
  top: 85px;
  right: 24px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 380px;
  width: calc(100vw - 48px);
}

.live-toast {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(12px);
  padding: 14px 16px;
  border-radius: 14px;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.15), 0 0 1px 1px rgba(0, 0, 0, 0.05);
  border-left: 5px solid #3b82f6;
  position: relative;
  overflow: hidden;
}

.live-toast.success { border-left-color: #10b981; }
.live-toast.warning { border-left-color: #f59e0b; }
.live-toast.error { border-left-color: #ef4444; }

.toast-icon {
  font-size: 1.5rem;
  flex-shrink: 0;
}

.toast-content {
  flex: 1;
}

.toast-title {
  font-weight: 700;
  font-size: 0.9rem;
  color: #1e1e24;
  margin-bottom: 2px;
}

.toast-msg {
  font-size: 0.82rem;
  color: #64748b;
  line-height: 1.4;
}

.toast-close {
  background: none;
  border: none;
  font-size: 1.25rem;
  color: #94a3b8;
  cursor: pointer;
  padding: 0;
  line-height: 1;
}

.toast-close:hover {
  color: #1e1e24;
}

.toast-enter-active, .toast-leave-active {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.toast-enter-from {
  opacity: 0;
  transform: translateX(50px) scale(0.95);
}

.toast-leave-to {
  opacity: 0;
  transform: translateY(-20px) scale(0.9);
}
</style>
