<template>
  <div class="home-view">
    <!-- ROLE-SPECIFIC GREETING BANNER -->
    <!-- 1. Guest Account Style -->
    <div v-if="currentRole === 'guest'" class="hero-section guest-hero">
      <div class="hero-content">
        <span class="hero-badge guest-badge">👋 Welcome Guest Visitor!</span>
        <h1 class="hero-title">Discover Gourmet Meals & Fast Delivery.</h1>
        <p class="hero-subtitle">Sign in or register an account to unlock loyalty rewards, save favorite dishes, and track live GPS courier updates.</p>
        
        <div class="hero-action-row">
          <RouterLink to="/login" class="btn-primary guest-signin-btn">🔑 Sign In to Your Account ➔</RouterLink>
        </div>

        <div class="search-container mt-4">
          <span class="search-icon">🔍</span>
          <input v-model="search" class="search-input" placeholder="Explore 10 restaurants, pizza, ramen..." />
        </div>
      </div>
      <div class="hero-graphic">
        <div class="graphic-card guest-card">
          <div class="emoji-circle">🎁</div>
          <div class="graphic-text">
            <strong>New Customer Offer</strong>
            <p>Free Delivery on 1st order</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 2. Logged-in Customer Style -->
    <div v-else-if="currentRole === 'customer'" class="hero-section customer-hero">
      <div class="hero-content">
        <span class="hero-badge customer-badge">⭐ VIP Member · {{ currentUser }}</span>
        <h1 class="hero-title">Hungry again, Alice? We've got you.</h1>
        <p class="hero-subtitle">Your favorite Neapolitan pizza and Tokyo ramen are open right now with 20-30 minute express dispatch.</p>
        
        <div class="hero-action-row">
          <RouterLink to="/order/1" class="btn-live-track">🛵 Track Order #1 Live ➔</RouterLink>
          <RouterLink to="/cart" class="btn-secondary">🛍️ View Bag</RouterLink>
        </div>

        <div class="search-container mt-4">
          <span class="search-icon">🔍</span>
          <input v-model="search" class="search-input" placeholder="Search your favorite dishes..." />
        </div>
      </div>
      <div class="hero-graphic">
        <div class="graphic-card customer-card">
          <div class="emoji-circle">🍕</div>
          <div class="graphic-text">
            <strong>Pizza Palace</strong>
            <p>Ready in 15 mins</p>
          </div>
          <span class="rating-badge">★ 4.8</span>
        </div>
      </div>
    </div>

    <!-- 3. Restaurant Partner Style -->
    <div v-else-if="currentRole === 'restaurant'" class="hero-section partner-hero">
      <div class="hero-content">
        <span class="hero-badge partner-badge">🏪 Kitchen Partner Portal · {{ currentUser }}</span>
        <h1 class="hero-title">Restaurant Management Desk</h1>
        <p class="hero-subtitle">You are signed in as a Restaurant Partner. Switch to the Kanban live kitchen board to manage incoming orders.</p>
        
        <div class="hero-action-row">
          <RouterLink to="/restaurant-dashboard" class="btn-partner">👨‍🍳 Launch Live Kitchen Board ➔</RouterLink>
        </div>
      </div>
    </div>

    <!-- 4. Call Center Agent Style -->
    <div v-else-if="currentRole === 'callcenter'" class="hero-section agent-hero">
      <div class="hero-content">
        <span class="hero-badge agent-badge">🎧 Support Dispatch Desk · {{ currentUser }}</span>
        <h1 class="hero-title">Call Center Operations</h1>
        <p class="hero-subtitle">You are signed in as a Support Agent. Monitor live customer escalations and assist riders in transit.</p>
        
        <div class="hero-action-row">
          <RouterLink to="/call-center-dashboard" class="btn-agent">🚨 Open Live Ticket Queue ➔</RouterLink>
        </div>
      </div>
    </div>

    <!-- Category Pills Section -->
    <div class="categories-section">
      <h2 class="section-title">Explore Cuisines</h2>
      <div class="category-pills">
        <button 
          v-for="cat in categories" 
          :key="cat.id"
          :class="['category-pill', { active: activeCategory === cat.name }]"
          @click="activeCategory = cat.name"
        >
          <span class="pill-emoji">{{ cat.emoji }}</span>
          <span class="pill-text">{{ cat.name }}</span>
        </button>
      </div>
    </div>

    <!-- Restaurants List -->
    <div class="restaurants-section">
      <div class="section-header">
        <h2 class="section-title">Restaurants Near You</h2>
        <span class="results-count">{{ filtered.length }} open now</span>
      </div>

      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <p>Finding restaurants near you...</p>
      </div>
      <div v-else>
        <div class="restaurants-grid">
          <RestaurantCard v-for="r in filtered" :key="r.id" :restaurant="r" />
        </div>
        <div v-if="filtered.length === 0" class="empty-state card">
          <span class="empty-emoji">🥣</span>
          <h3>No restaurants found</h3>
          <p class="muted">Try adjusting your search query or choosing another category.</p>
          <button class="btn-primary" @click="resetFilters">Reset search</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import RestaurantCard from '../components/RestaurantCard.vue'
import { getRestaurants } from '../services/api'

const restaurants = ref([])
const loading = ref(true)
const search = ref('')
const activeCategory = ref('All')

const currentRole = ref(localStorage.getItem('foodgo_role') || 'guest')
const currentUser = ref(localStorage.getItem('foodgo_user') || 'Visitor')

function syncRole() {
  currentRole.value = localStorage.getItem('foodgo_role') || 'guest'
  currentUser.value = localStorage.getItem('foodgo_user') || 'Visitor'
}

const categories = [
  { id: 1, name: 'All', emoji: '🍽️' },
  { id: 2, name: 'Pizza', emoji: '🍕' },
  { id: 3, name: 'Sushi', emoji: '🍣' },
  { id: 4, name: 'Ramen', emoji: '🍜' },
  { id: 5, name: 'Burgers', emoji: '🍔' },
  { id: 6, name: 'Khmer', emoji: '🍲' },
  { id: 7, name: 'Boba Tea', emoji: '🧋' },
  { id: 8, name: 'Desserts', emoji: '🍰' }
]

const filtered = computed(() => {
  return restaurants.value.filter((r) => {
    const matchesSearch = r.name.toLowerCase().includes(search.value.toLowerCase()) || 
                          (r.description && r.description.toLowerCase().includes(search.value.toLowerCase()))
    
    if (activeCategory.value === 'All') {
      return matchesSearch
    }
    const matchesCategory = r.description?.toLowerCase().includes(activeCategory.value.toLowerCase()) ||
                            r.name.toLowerCase().includes(activeCategory.value.toLowerCase())
    return matchesSearch && matchesCategory
  })
})

onMounted(async () => {
  window.addEventListener('role-changed', syncRole)
  window.addEventListener('storage', syncRole)
  try {
    const { data } = await getRestaurants()
    restaurants.value = data
  } catch (e) {
    console.error('Failed to load restaurants', e)
  } finally {
    loading.value = false
  }
})

onUnmounted(() => {
  window.removeEventListener('role-changed', syncRole)
  window.removeEventListener('storage', syncRole)
})

function resetFilters() {
  search.value = ''
  activeCategory.value = 'All'
}
</script>

<style scoped>
.home-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-10);
}

/* Hero Section */
.hero-section {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr;
  align-items: center;
  background: linear-gradient(135deg, #fffcf9 0%, #fff0ed 100%);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-10) var(--space-8);
  gap: var(--space-8);
  box-shadow: var(--shadow-sm);
  position: relative;
  overflow: hidden;
}

.hero-section::before {
  content: '';
  position: absolute;
  top: -50px;
  right: -50px;
  width: 250px;
  height: 250px;
  background: radial-gradient(circle, rgba(255,94,64,0.06) 0%, rgba(255,255,255,0) 70%);
  border-radius: var(--radius-full);
  pointer-events: none;
}

.hero-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--space-4);
}

.hero-badge {
  background: var(--color-primary-light);
  color: var(--color-primary);
  font-size: 0.85rem;
  font-weight: 700;
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-full);
  letter-spacing: 0.02em;
}

.hero-title {
  font-size: 2.8rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.1;
}

.hero-subtitle {
  font-size: 1.1rem;
  color: var(--color-muted);
  max-width: 540px;
}

.search-container {
  position: relative;
  width: 100%;
  max-width: 480px;
  margin-top: var(--space-2);
}

.search-icon {
  position: absolute;
  left: var(--space-4);
  top: 50%;
  transform: translateY(-50%);
  font-size: 1.1rem;
  color: var(--color-muted);
}

.search-input {
  padding-left: calc(var(--space-4) + 24px);
  height: 54px;
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--color-border);
}

.search-input:focus {
  border-color: var(--color-primary);
}

.hero-graphic {
  display: flex;
  justify-content: center;
  align-items: center;
}

.graphic-card {
  background: white;
  padding: var(--space-4);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: var(--space-4);
  border: 1px solid var(--color-border);
  transform: rotate(4deg);
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0% { transform: rotate(4deg) translateY(0px); }
  50% { transform: rotate(2deg) translateY(-10px); }
  100% { transform: rotate(4deg) translateY(0px); }
}

.emoji-circle {
  width: 50px;
  height: 50px;
  background: var(--color-primary-light);
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.6rem;
}

.graphic-text strong {
  font-family: var(--font-display);
  font-size: 1.05rem;
  color: var(--color-ink);
}

.graphic-text p {
  font-size: 0.8rem;
  color: var(--color-muted);
}

.rating-badge {
  background: var(--color-accent-light);
  color: var(--color-accent);
  font-weight: 700;
  font-size: 0.8rem;
  padding: 4px 8px;
  border-radius: var(--radius-full);
}

/* Category Pills */
.categories-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.section-title {
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.01em;
}

.category-pills {
  display: flex;
  gap: var(--space-3);
  overflow-x: auto;
  padding-bottom: var(--space-2);
}

.category-pill {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  color: var(--color-ink);
  border-radius: var(--radius-full);
  padding: var(--space-2) var(--space-4);
  font-weight: 600;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: var(--space-2);
  white-space: nowrap;
  transition: var(--transition-smooth);
}

.category-pill:hover {
  background: var(--color-bg);
  border-color: var(--color-muted);
}

.category-pill.active {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
  box-shadow: 0 4px 12px rgba(255, 94, 64, 0.2);
}

/* Restaurants Section */
.restaurants-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.results-count {
  font-size: 0.9rem;
  color: var(--color-muted);
  font-weight: 500;
}

.restaurants-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: var(--space-6);
}

.loading-state {
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

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-10) var(--space-6);
  text-align: center;
  gap: var(--space-3);
  max-width: 460px;
  margin: 0 auto;
}

.empty-emoji {
  font-size: 3rem;
}

@media (max-width: 992px) {
  .hero-section {
    grid-template-columns: 1fr;
    padding: var(--space-8) var(--space-6);
  }
  .hero-graphic {
    display: none;
  }
  .hero-title {
    font-size: 2.2rem;
  }
}

/* Role-Specific Hero Styling */
.guest-hero {
  background: linear-gradient(135deg, #1e1e24 0%, #31323d 100%);
  color: white;
}
.guest-badge { background: rgba(255, 255, 255, 0.15); color: #facc15; }
.guest-signin-btn { background: #ff5e40; color: white; padding: 12px 24px; border-radius: 50px; text-decoration: none; font-weight: 700; display: inline-block; }

.customer-hero {
  background: linear-gradient(135deg, #fff3f0 0%, #ffe8e2 100%);
  border: 2px solid #ffccb8;
}
.customer-badge { background: #ff5e40; color: white; }
.btn-live-track { background: #10b981; color: white; padding: 12px 24px; border-radius: 50px; text-decoration: none; font-weight: 800; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); }

.partner-hero {
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  color: white;
  border-left: 6px solid #3b82f6;
}
.partner-badge { background: #3b82f6; color: white; }
.btn-partner { background: #3b82f6; color: white; padding: 14px 28px; border-radius: 50px; text-decoration: none; font-weight: 800; display: inline-block; }

.agent-hero {
  background: linear-gradient(135deg, #311042 0%, #4a1d64 100%);
  color: white;
  border-left: 6px solid #a855f7;
}
.agent-badge { background: #a855f7; color: white; }
.btn-agent { background: #a855f7; color: white; padding: 14px 28px; border-radius: 50px; text-decoration: none; font-weight: 800; display: inline-block; }

.hero-action-row {
  display: flex;
  gap: 14px;
  align-items: center;
  margin-top: 10px;
}
</style>
