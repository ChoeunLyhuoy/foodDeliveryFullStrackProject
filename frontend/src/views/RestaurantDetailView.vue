<template>
  <div v-if="restaurant" class="restaurant-detail">
    <!-- Top Navigation Bar -->
    <div class="top-nav-bar">
      <RouterLink to="/" class="back-link">
        <span class="arrow-icon">←</span> Back to Discovery
      </RouterLink>
      <div class="header-badges">
        <span class="delivery-badge">⚡ Instant 20-30m Delivery</span>
      </div>
    </div>

    <!-- Immersive Cover Hero -->
    <div class="cover-wrapper">
      <img 
        :src="restaurant.coverImageUrl || 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80'" 
        :alt="restaurant.name" 
        class="cover-image" 
        @error="handleImageError($event, 'cover')"
      />
      <div class="cover-gradient"></div>
      <div class="restaurant-hero-content">
        <div class="meta-row">
          <span class="rating-pill">★ {{ restaurant.rating?.toFixed(1) || '4.8' }}</span>
          <span class="status-pill" :class="restaurant.isOpen ? 'open' : 'closed'">
            {{ restaurant.isOpen ? '● OPEN NOW' : '○ CLOSED' }}
          </span>
          <span class="category-pill">🍕 Gourmet Italian</span>
        </div>
        <h1 class="restaurant-name">{{ restaurant.name }}</h1>
        <p class="restaurant-desc">{{ restaurant.description || 'Artisanal recipes prepared fresh to order by master chefs.' }}</p>
        <div class="address-row">
          <span class="location-icon">📍</span>
          <span>{{ restaurant.address || 'Phnom Penh City Center' }}</span>
        </div>
      </div>
    </div>

    <!-- Menu Section & Category Filter Tabs -->
    <div class="menu-section">
      <div class="menu-section-header">
        <div>
          <h2>Artisanal Menu</h2>
          <p class="muted">Select dishes to add directly to your order bag</p>
        </div>
        <div class="filter-tabs">
          <button 
            v-for="cat in categories" 
            :key="cat"
            :class="['filter-tab', { active: activeMenuCategory === cat }]"
            @click="activeMenuCategory = cat"
          >
            {{ cat }}
          </button>
        </div>
      </div>

      <!-- Menu Grid -->
      <div class="menu-grid">
        <div v-for="item in filteredMenu" :key="item.id" class="menu-item-card">
          <div class="menu-image-box">
            <img 
              :src="item.imageUrl || 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=600&auto=format&fit=crop&q=80'" 
              :alt="item.name" 
              class="menu-image" 
              @error="handleImageError($event, 'dish')"
            />
            <span class="dietary-tag" v-if="item.price > 12">🔥 Chef Special</span>
            <span class="dietary-tag green" v-else>🌱 Fresh Made</span>
          </div>
          <div class="menu-info-box">
            <div class="menu-top-row">
              <h3 class="menu-name">{{ item.name }}</h3>
              <span class="menu-price">${{ item.price?.toFixed(2) }}</span>
            </div>
            <p class="menu-desc">{{ item.description || 'Rich savory flavors combined with aromatic herbs and melted mozzarella.' }}</p>
            <div class="menu-actions">
              <span class="availability-status" :class="item.isAvailable !== false ? 'in-stock' : 'sold-out'">
                {{ item.isAvailable !== false ? '✓ Available' : 'Out of stock' }}
              </span>
              <button 
                class="btn-add-dish" 
                :disabled="!restaurant.isOpen || item.isAvailable === false"
                @click="add(item)"
              >
                <span>+ Add to Bag</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Floating Order Summary Banner -->
    <transition name="slide-up">
      <div v-if="cart.items.length > 0" class="floating-bag-summary">
        <div class="bag-info">
          <span class="bag-count">{{ cart.items.length }} Items</span>
          <span class="bag-total">Total: ${{ cartTotal.toFixed(2) }}</span>
        </div>
        <RouterLink to="/cart" class="btn-checkout-link">
          Review Bag & Checkout ➔
        </RouterLink>
      </div>
    </transition>

    <!-- Toast Notification -->
    <transition name="toast-pop">
      <div v-if="showToast" class="toast-popup">
        <span class="toast-icon">✨</span>
        <span class="toast-msg">Added <strong>{{ lastAddedName }}</strong> to your bag</span>
      </div>
    </transition>
  </div>
  
  <div v-else class="loading-state">
    <div class="spinner"></div>
    <p>Preparing menu presentation...</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getRestaurant, getMenu } from '../services/api'
import { useCartStore } from '../store/cart'

const route = useRoute()
const restaurant = ref(null)
const menu = ref([])
const cart = useCartStore()
const showToast = ref(false)
const lastAddedName = ref('')
const activeMenuCategory = ref('All')

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

const categories = computed(() => {
  const cats = new Set(['All'])
  menu.value.forEach(i => {
    if (i.category) cats.add(i.category)
    else cats.add('Mains')
  })
  return Array.from(cats)
})

const filteredMenu = computed(() => {
  if (activeMenuCategory.value === 'All') return menu.value
  return menu.value.filter(item => 
    item.category === activeMenuCategory.value ||
    item.name.toLowerCase().includes(activeMenuCategory.value.toLowerCase())
  )
})

const cartTotal = computed(() => {
  return cart.items.reduce((acc, i) => acc + (i.unitPrice * i.quantity), 0)
})

function handleImageError(e, type) {
  if (type === 'cover') {
    e.target.src = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80'
  } else {
    e.target.src = 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=600&auto=format&fit=crop&q=80'
  }
}

function add(item) {
  cart.addItem(restaurant.value.id, {
    menuItemId: item.id,
    name: item.name,
    unitPrice: item.price
  })
  
  lastAddedName.value = item.name
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 2500)
}
</script>

<style scoped>
.restaurant-detail {
  display: flex;
  flex-direction: column;
  gap: 28px;
  padding-bottom: 80px;
}

.top-nav-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  color: #64748b;
  text-decoration: none;
  font-size: 0.95rem;
  transition: color 0.2s ease;
}

.back-link:hover {
  color: #ff5e40;
}

.delivery-badge {
  background: #fff3ed;
  color: #ff5e40;
  font-size: 0.82rem;
  font-weight: 800;
  padding: 6px 14px;
  border-radius: 20px;
  border: 1px solid #fed7aa;
}

/* Immersive Cover Banner */
.cover-wrapper {
  position: relative;
  height: 360px;
  border-radius: 28px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cover-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(15, 23, 42, 0.85) 100%);
}

.restaurant-hero-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 30px;
  color: white;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.meta-row {
  display: flex;
  gap: 10px;
  align-items: center;
}

.rating-pill, .status-pill, .category-pill {
  font-size: 0.78rem;
  font-weight: 800;
  padding: 5px 12px;
  border-radius: 14px;
  backdrop-filter: blur(10px);
}

.rating-pill {
  background: #fde047;
  color: #854d0e;
}

.status-pill.open {
  background: rgba(16, 185, 129, 0.9);
  color: white;
}

.status-pill.closed {
  background: rgba(239, 68, 68, 0.9);
  color: white;
}

.category-pill {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.restaurant-name {
  font-size: 2.6rem;
  font-weight: 900;
  letter-spacing: -0.03em;
  margin: 0;
}

.restaurant-desc {
  font-size: 1.05rem;
  color: #cbd5e1;
  max-width: 680px;
  margin: 0;
}

.address-row {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.9rem;
  color: #94a3b8;
}

/* Menu Section */
.menu-section {
  display: flex;
  flex-direction: column;
  gap: 22px;
}

.menu-section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  flex-wrap: wrap;
  gap: 16px;
}

.menu-section-header h2 {
  font-size: 1.8rem;
  font-weight: 800;
  margin: 0;
  color: #1e293b;
}

.filter-tabs {
  display: flex;
  gap: 8px;
  background: #f1f5f9;
  padding: 5px;
  border-radius: 16px;
}

.filter-tab {
  border: none;
  background: transparent;
  padding: 8px 16px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 0.88rem;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-tab.active {
  background: white;
  color: #ff5e40;
  box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
}

.menu-item-card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 22px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: all 0.25s ease;
}

.menu-item-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 25px rgba(0,0,0,0.06);
  border-color: rgba(255, 94, 64, 0.3);
}

.menu-image-box {
  position: relative;
  height: 170px;
  background: #f8fafc;
}

.menu-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.dietary-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  background: rgba(255, 94, 64, 0.9);
  color: white;
  font-size: 0.72rem;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 10px;
}

.dietary-tag.green {
  background: rgba(16, 185, 129, 0.9);
}

.menu-info-box {
  padding: 18px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  flex: 1;
}

.menu-top-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.menu-name {
  font-size: 1.15rem;
  font-weight: 800;
  color: #1e293b;
  margin: 0;
}

.menu-price {
  font-size: 1.25rem;
  font-weight: 900;
  color: #ff5e40;
}

.menu-desc {
  font-size: 0.88rem;
  color: #64748b;
  line-height: 1.4;
  margin: 0;
  flex: 1;
}

.menu-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px dashed #f1f5f9;
}

.availability-status {
  font-size: 0.8rem;
  font-weight: 700;
}

.availability-status.in-stock { color: #10b981; }
.availability-status.sold-out { color: #ef4444; }

.btn-add-dish {
  background: #ff5e40;
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 14px;
  font-weight: 800;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 4px 12px rgba(255, 94, 64, 0.25);
}

.btn-add-dish:hover:not(:disabled) {
  background: #e04a2e;
  transform: scale(1.03);
}

.btn-add-dish:disabled {
  background: #cbd5e1;
  cursor: not-allowed;
  box-shadow: none;
}

/* Floating Bag Summary */
.floating-bag-summary {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  width: 90%;
  max-width: 600px;
  background: #1e293b;
  color: white;
  padding: 16px 24px;
  border-radius: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
  z-index: 50;
  border: 1px solid rgba(255,255,255,0.1);
}

.bag-info {
  display: flex;
  gap: 16px;
  align-items: center;
}

.bag-count {
  background: #ff5e40;
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 800;
  font-size: 0.85rem;
}

.bag-total {
  font-weight: 800;
  font-size: 1.1rem;
}

.btn-checkout-link {
  color: #38bdf8;
  font-weight: 800;
  text-decoration: none;
  font-size: 0.95rem;
}

/* Toast Notification */
.toast-popup {
  position: fixed;
  bottom: 96px;
  right: 24px;
  background: white;
  border-left: 5px solid #10b981;
  padding: 16px 20px;
  border-radius: 16px;
  box-shadow: 0 15px 30px rgba(0,0,0,0.15);
  display: flex;
  align-items: center;
  gap: 14px;
  z-index: 60;
}

.toast-icon { font-size: 1.6rem; }
.toast-text strong { font-size: 0.95rem; color: #1e293b; display: block; }
.toast-text p { font-size: 0.82rem; color: #64748b; margin: 2px 0 0; }

.slide-up-enter-active, .slide-up-leave-active { transition: all 0.3s ease; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translate(-50%, 20px); }

.toast-pop-enter-active, .toast-pop-leave-active { transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
.toast-pop-enter-from, .toast-pop-leave-to { opacity: 0; transform: translateY(20px) scale(0.9); }
</style>
