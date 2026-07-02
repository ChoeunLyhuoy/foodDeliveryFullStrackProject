<template>
  <div class="figma-portal-container">
    <!-- Dark Left Sidebar (Figma Image 3 Exact Layout) -->
    <aside class="dark-sidebar">
      <div class="sidebar-top">
        <div class="brand-box">
          <span class="brand-emoji">🍔</span>
          <div>
            <strong class="brand-name">Burgersmith</strong>
            <span class="online-pill">● Online</span>
          </div>
        </div>

        <nav class="sidebar-nav">
          <RouterLink to="/restaurant-dashboard/orders" class="nav-item">
            <span class="nav-icon">▤</span> Order Board
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/menu" class="nav-item">
            <span class="nav-icon">🍴</span> Menu Catalog
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/reviews" class="nav-item active">
            <span class="nav-icon">👍</span> Reviews
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/settings" class="nav-item">
            <span class="nav-icon">⚙️</span> Settings
          </RouterLink>
        </nav>
      </div>

      <div class="sidebar-bottom">
        <div class="revenue-card">
          <span class="rev-label">Today's Revenue</span>
          <strong class="rev-val">$2,841</strong>
          <span class="rev-growth">↑ 12% vs yesterday</span>
        </div>
        <RouterLink to="/login" class="sign-out-link">
          <span class="signout-icon">←</span> Sign Out
        </RouterLink>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      <header class="board-header">
        <div>
          <h1 class="board-title">Reviews</h1>
        </div>
        <div class="rating-overall">
          <span class="gold-star">★</span>
          <strong>4.8 average</strong>
          <span class="total-count">(4 total)</span>
        </div>
      </header>

      <!-- 5 Rating Cards Row (Figma Screenshot 3) -->
      <div class="rating-grid">
        <div v-for="stat in ratingStats" :key="stat.stars" class="rating-card">
          <div class="stars-stars">
            <span v-for="n in stat.stars" :key="n" class="gold-star-small">★</span>
          </div>
          <strong class="percentage-val">{{ stat.pct }}%</strong>
          <span class="reviews-count">{{ stat.count }} reviews</span>
        </div>
      </div>

      <div class="reviews-list-divider"></div>

      <!-- Feed of Customer Reviews (Figma Screenshot 3) -->
      <div class="reviews-feed">
        <div v-for="rev in reviewsList" :key="rev.name" class="review-comment-card">
          <div class="comment-header">
            <div class="user-info">
              <div class="user-avatar-circle">
                <span class="avatar-face">{{ rev.avatar }}</span>
              </div>
              <div class="name-stars-col">
                <strong>{{ rev.name }}</strong>
                <div class="mini-stars">
                  <span v-for="n in 5" :key="n" :class="{ 'gold': n <= rev.rating, 'gray': n > rev.rating }">★</span>
                </div>
              </div>
            </div>
            <span class="comment-date">{{ rev.date }}</span>
          </div>
          <p class="comment-body">{{ rev.comment }}</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const ratingStats = ref([
  { stars: 5, pct: 78, count: 1827 },
  { stars: 4, pct: 14, count: 328 },
  { stars: 3, pct: 5, count: 117 },
  { stars: 2, pct: 2, count: 47 },
  { stars: 1, pct: 1, count: 23 }
])

const reviewsList = ref([
  {
    name: 'Sarah C.',
    avatar: '👩🏻',
    rating: 5,
    date: 'Jun 26',
    comment: 'Absolutely the best burgers in the city. The Wagyu Double is a revelation. Fast delivery too!'
  },
  {
    name: 'Marcus L.',
    avatar: '👨🏽',
    rating: 4,
    date: 'Jun 25',
    comment: 'Great food but delivery took longer than expected. Shakes are incredible!'
  },
  {
    name: 'Priya S.',
    avatar: '👩🏽',
    rating: 5,
    date: 'Jun 25',
    comment: 'The crispy chicken burger is a must-try. Perfectly seasoned and the slaw is fresh.'
  },
  {
    name: 'James T.',
    avatar: '👨🏻',
    rating: 4,
    date: 'Jun 24',
    comment: 'Food was great but packaging could be better. The fries were slightly cold on arrival.'
  }
])
</script>

<style scoped>
.figma-portal-container {
  display: flex;
  height: 100vh;
  background: #f8f9fa;
  margin: -32px -20px;
}

/* Dark Sidebar */
.dark-sidebar {
  width: 260px;
  background: #1e1e24;
  color: white;
  padding: 24px 18px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  flex-shrink: 0;
}

.brand-box {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  margin-bottom: 28px;
}
.brand-emoji {
  font-size: 1.8rem;
  background: #ff5e40;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.brand-name { font-size: 1.1rem; display: block; line-height: 1.2; }
.online-pill { font-size: 0.75rem; color: #10b981; font-weight: 700; }

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  border-radius: 12px;
  color: #94a3b8;
  text-decoration: none;
  font-weight: 700;
  font-size: 0.92rem;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.nav-item:hover, .nav-item.active {
  background: rgba(255, 94, 64, 0.15);
  color: #ff5e40;
  transform: translateX(4px);
}

.sidebar-bottom {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.revenue-card {
  background: rgba(255, 255, 255, 0.05);
  padding: 16px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.rev-label { font-size: 0.78rem; color: #94a3b8; display: block; }
.rev-val { font-size: 1.5rem; color: #ff5e40; font-weight: 800; display: block; margin: 4px 0; }
.rev-growth { font-size: 0.75rem; color: #10b981; font-weight: 700; }

.sign-out-link {
  color: #64748b;
  text-decoration: none;
  font-size: 0.88rem;
  font-weight: 700;
  padding-left: 6px;
}

/* Main Content */
.main-content {
  flex: 1;
  padding: 32px 36px;
  overflow-y: auto;
}

.board-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
}
.board-title { font-size: 1.8rem; font-weight: 900; color: #1e1e24; margin: 0; }

.rating-overall {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.95rem;
}
.gold-star { color: #ffb800; font-size: 1.3rem; }
.gold-star-small { color: #ffb800; font-size: 0.82rem; }
.total-count { color: #94a3b8; font-weight: 700; }

.rating-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 16px;
}

.rating-card {
  background: white;
  padding: 16px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.rating-card:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.06);
}

.percentage-val {
  font-size: 1.4rem;
  font-weight: 900;
  color: #1e1e24;
}

.reviews-count {
  font-size: 0.75rem;
  color: #94a3b8;
  font-weight: 800;
}

.reviews-list-divider {
  height: 1px;
  background: #e2e8f0;
  margin: 32px 0;
}

.reviews-feed {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.review-comment-card {
  background: white;
  padding: 18px 24px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.review-comment-card:hover {
  transform: translateY(-4px) scale(1.005);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.07);
}

.comment-header {
  display: flex;
  justify-content: main;
  align-items: center;
  justify-content: space-between;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-avatar-circle {
  width: 40px;
  height: 40px;
  background: #f1f3f5;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
}

.name-stars-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.name-stars-col strong {
  font-size: 0.95rem;
  color: #1e1e24;
}

.mini-stars {
  display: flex;
  font-size: 0.8rem;
  letter-spacing: -1px;
}
.mini-stars span.gold { color: #ffb800; }
.mini-stars span.gray { color: #cbd5e1; }

.comment-date {
  font-size: 0.78rem;
  color: #94a3b8;
  font-weight: 800;
}

.comment-body {
  font-size: 0.92rem;
  color: #475569;
  line-height: 1.5;
  margin: 12px 0 0 0;
  font-weight: 600;
}
</style>
