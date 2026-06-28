<template>
  <div v-if="restaurant" class="restaurant-detail">
    <!-- Back to restaurants link -->
    <RouterLink to="/" class="back-link">
      <span>←</span> Back to restaurants
    </RouterLink>

    <!-- Cover banner -->
    <div class="cover-wrapper">
      <img :src="restaurant.coverImageUrl || '/placeholder.jpg'" :alt="restaurant.name" class="cover-image" />
      <div class="cover-overlay"></div>
      <div class="restaurant-header-info">
        <div class="meta-row">
          <span class="rating-badge">★ {{ restaurant.rating?.toFixed(1) || '0.0' }}</span>
          <span class="status-badge" :class="restaurant.isOpen ? 'open' : 'closed'">
            {{ restaurant.isOpen ? 'Open Now' : 'Closed' }}
          </span>
        </div>
        <h1 class="restaurant-name">{{ restaurant.name }}</h1>
        <p class="restaurant-desc">{{ restaurant.description }}</p>
        <div class="address-row">
          <span class="location-icon">📍</span>
          <span>{{ restaurant.address }}</span>
        </div>
      </div>
    </div>

    <!-- Menu grid -->
    <div class="menu-container">
      <div class="menu-header">
        <h2>Our Menu</h2>
        <p class="muted">Fresh ingredients, prepared daily</p>
      </div>

      <div class="menu-grid">
        <div v-for="item in menu" :key="item.id" class="card menu-item-card">
          <div class="menu-image-wrapper">
            <img :src="item.imageUrl || '/images/margherita.jpg'" :alt="item.name" class="menu-item-image" />
            <span class="category-tag" v-if="item.category">{{ item.category }}</span>
          </div>
          <div class="menu-item-info">
            <h3 class="menu-item-name">{{ item.name }}</h3>
            <p class="menu-item-desc">{{ item.description || 'Delicately cooked with premium quality ingredients.' }}</p>
            <div class="purchase-row">
              <span class="menu-item-price">${{ item.price?.toFixed(2) }}</span>
              <button 
                class="btn-primary add-button" 
                :disabled="!restaurant.isOpen"
                @click="add(item)"
              >
                <span>Add</span>
                <span class="plus-icon">+</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast Notification for cart -->
    <transition name="toast-fade">
      <div v-if="showToast" class="cart-toast card">
        <span class="toast-emoji">🛒</span>
        <span>Dish added to your cart!</span>
      </div>
    </transition>
  </div>
  
  <div v-else class="loading-container">
    <div class="spinner"></div>
    <p>Loading restaurant menu...</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getRestaurant, getMenu } from '../services/api'
import { useCartStore } from '../store/cart'

const route = useRoute()
const restaurant = ref(null)
const menu = ref([])
const cart = useCartStore()
const showToast = ref(false)

onMounted(async () => {
  const id = route.params.id
  try {
    const [r, m] = await Promise.all([getRestaurant(id), getMenu(id)])
    restaurant.value = r.data
    menu.value = m.data
  } catch (e) {
    console.error('Error loading restaurant detail', e)
  }
})

function add(item) {
  cart.addItem(restaurant.value.id, {
    menuItemId: item.id,
    name: item.name,
    unitPrice: item.price
  })
  
  // Show toast feedback
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 2000)
}
</script>

<style scoped>
.restaurant-detail {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-weight: 600;
  color: var(--color-muted);
  font-size: 0.95rem;
}

.back-link:hover {
  color: var(--color-primary);
}

/* Immersive banner */
.cover-wrapper {
  position: relative;
  height: 320px;
  border-radius: var(--radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cover-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.7) 100%);
}

.restaurant-header-info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: var(--space-8);
  color: white;
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.restaurant-name {
  color: white;
  font-size: 2.2rem;
  font-weight: 800;
  letter-spacing: -0.02em;
}

.restaurant-desc {
  font-size: 1.05rem;
  color: rgba(255, 255, 255, 0.9);
  max-width: 600px;
}

.meta-row {
  display: flex;
  gap: var(--space-3);
}

.rating-badge {
  background: var(--color-accent);
  color: var(--color-ink);
  font-weight: 800;
  padding: 4px 10px;
  border-radius: var(--radius-full);
  font-size: 0.85rem;
}

.status-badge {
  font-weight: 700;
  padding: 4px 10px;
  border-radius: var(--radius-full);
  font-size: 0.85rem;
}

.status-badge.open {
  background: var(--color-success);
  color: white;
}

.status-badge.closed {
  background: var(--color-error);
  color: white;
}

.address-row {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.85);
  font-weight: 500;
}

/* Menu area */
.menu-container {
  margin-top: var(--space-6);
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.menu-header h2 {
  font-size: 1.8rem;
  letter-spacing: -0.02em;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: var(--space-6);
}

.menu-item-card {
  overflow: hidden;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  display: flex;
  flex-direction: column;
}

.menu-item-card:hover {
  transform: translateY(-3px);
  box-shadow: var(--shadow-lg);
}

.menu-image-wrapper {
  position: relative;
  height: 150px;
  overflow: hidden;
  background: var(--color-bg);
}

.menu-item-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.category-tag {
  position: absolute;
  bottom: var(--space-2);
  left: var(--space-2);
  background: rgba(255, 255, 255, 0.9);
  color: var(--color-ink);
  font-size: 0.7rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: var(--radius-full);
  text-transform: uppercase;
}

.menu-item-info {
  padding: var(--space-4);
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: var(--space-2);
}

.menu-item-name {
  font-size: 1.1rem;
  font-weight: 700;
}

.menu-item-desc {
  color: var(--color-muted);
  font-size: 0.85rem;
  line-height: 1.4;
  flex: 1;
}

.purchase-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: var(--space-2);
  padding-top: var(--space-2);
}

.menu-item-price {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--color-ink);
}

.add-button {
  padding: var(--space-2) var(--space-4);
  font-size: 0.85rem;
}

.plus-icon {
  font-size: 1rem;
}

/* Toast */
.cart-toast {
  position: fixed;
  bottom: var(--space-8);
  right: var(--space-8);
  background: var(--color-ink);
  color: white;
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: var(--space-3);
  z-index: 200;
  font-weight: 600;
  font-size: 0.95rem;
}

.toast-emoji {
  font-size: 1.2rem;
}

/* Transitions */
.toast-fade-enter-active,
.toast-fade-leave-active {
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.toast-fade-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.toast-fade-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* Loading */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-12) 0;
  gap: var(--space-4);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3.5px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: var(--radius-full);
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 768px) {
  .cover-wrapper {
    height: 240px;
  }
  .restaurant-name {
    font-size: 1.7rem;
  }
}
</style>
