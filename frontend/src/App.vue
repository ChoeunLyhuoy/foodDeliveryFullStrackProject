<template>
  <div class="app-shell">
    <header class="top-nav">
      <div class="nav-container">
        <RouterLink to="/" class="logo">
          <span class="logo-emoji">🍔</span>
          <span class="logo-text">Food<span class="highlight">Go</span></span>
        </RouterLink>
        <nav class="nav-links">
          <RouterLink to="/" class="nav-item">Home</RouterLink>
          <RouterLink to="/cart" class="nav-item cart-link">
            Cart
            <span v-if="cartCount > 0" class="cart-badge">{{ cartCount }}</span>
          </RouterLink>
          <RouterLink to="/restaurant-dashboard" class="nav-item">Restaurant</RouterLink>
          <RouterLink to="/call-center-dashboard" class="nav-item font-accent">Support Queue</RouterLink>
          
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

const cartStore = useCartStore()
const currentRole = ref(localStorage.getItem('foodgo_role') || 'guest')

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

onMounted(() => {
  window.addEventListener('role-changed', syncRole)
  window.addEventListener('storage', syncRole)
})

onUnmounted(() => {
  window.removeEventListener('role-changed', syncRole)
  window.removeEventListener('storage', syncRole)
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
</style>
