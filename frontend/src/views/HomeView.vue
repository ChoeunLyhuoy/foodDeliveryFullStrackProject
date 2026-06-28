<template>
  <div class="home-view">
    <!-- Hero Banner Section -->
    <div class="hero-section">
      <div class="hero-content">
        <span class="hero-badge">✨ Craving something delicious?</span>
        <h1 class="hero-title">Hungry? FoodGo is on the way.</h1>
        <p class="hero-subtitle">Discover the best culinary dishes, hot pizza, crisp salads, and Italian classics delivered straight to your door.</p>
        
        <!-- Search input inside Hero -->
        <div class="search-container">
          <span class="search-icon">🔍</span>
          <input v-model="search" class="search-input" placeholder="Search pizza, pasta, restaurants..." />
        </div>
      </div>
      <div class="hero-graphic">
        <!-- Generates a premium illustration card representing high quality food -->
        <div class="graphic-card">
          <div class="emoji-circle">🍕</div>
          <div class="graphic-text">
            <strong>Pizza Palace</strong>
            <p>Popular nearby</p>
          </div>
          <span class="rating-badge">★ 4.6</span>
        </div>
      </div>
    </div>

    <!-- Category Pills Section -->
    <div class="categories-section">
      <h2 class="section-title">Explore Categories</h2>
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
import { ref, computed, onMounted } from 'vue'
import RestaurantCard from '../components/RestaurantCard.vue'
import { getRestaurants } from '../services/api'

const restaurants = ref([])
const loading = ref(true)
const search = ref('')
const activeCategory = ref('All')

const categories = [
  { id: 1, name: 'All', emoji: '🍽️' },
  { id: 2, name: 'Pizza', emoji: '🍕' },
  { id: 3, name: 'Italian', emoji: '🍝' },
  { id: 4, name: 'Sides', emoji: '🍟' },
  { id: 5, name: 'Drinks', emoji: '🥤' }
]

const filtered = computed(() => {
  return restaurants.value.filter((r) => {
    const matchesSearch = r.name.toLowerCase().includes(search.value.toLowerCase()) || 
                          (r.description && r.description.toLowerCase().includes(search.value.toLowerCase()))
    
    if (activeCategory.value === 'All') {
      return matchesSearch
    }
    // Filter restaurants that offer items in this category or match description keywords
    const matchesCategory = r.description?.toLowerCase().includes(activeCategory.value.toLowerCase()) ||
                            r.name.toLowerCase().includes(activeCategory.value.toLowerCase())
    return matchesSearch && matchesCategory
  })
})

onMounted(async () => {
  try {
    const { data } = await getRestaurants()
    restaurants.value = data
  } catch (e) {
    console.error('Failed to load restaurants', e)
  } finally {
    loading.value = false
  }
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
</style>
