<template>
  <RouterLink :to="`/restaurant/${restaurant.id}`" class="restaurant-card">
    <div class="image-wrapper">
      <img :src="restaurant.coverImageUrl || '/placeholder.jpg'" :alt="restaurant.name" class="restaurant-image" />
      <div class="gradient-overlay"></div>
      
      <!-- Top Badges -->
      <div class="top-badges">
        <span class="promo-tag">⚡ 20% OFF Today</span>
        <span class="status-badge" :class="restaurant.isOpen ? 'open' : 'closed'">
          {{ restaurant.isOpen ? '● Open' : '○ Closed' }}
        </span>
      </div>

      <!-- Bottom Overlay info inside image -->
      <div class="image-bottom-meta">
        <span class="delivery-time-chip">⏱️ 20-30 min</span>
        <span class="delivery-fee-chip">🛵 Free Delivery</span>
      </div>
    </div>
    
    <div class="info">
      <div class="header-row">
        <h3 class="name">{{ restaurant.name }}</h3>
        <div class="rating-box">
          <span class="star-icon">★</span>
          <span class="rating-num">{{ restaurant.rating?.toFixed(1) || '4.8' }}</span>
        </div>
      </div>
      <p class="description">{{ restaurant.description || 'Authentic gourmet flavors crafted with fresh ingredients' }}</p>
      
      <div class="footer-row">
        <div class="tags-list">
          <span class="cuisine-tag">🍕 Italian</span>
          <span class="cuisine-tag">🔥 Top Rated</span>
        </div>
        <span class="action-arrow">Order Now ➔</span>
      </div>
    </div>
  </RouterLink>
</template>

<script setup>
defineProps({
  restaurant: { type: Object, required: true }
})
</script>

<style scoped>
.restaurant-card {
  display: flex;
  flex-direction: column;
  text-decoration: none;
  color: var(--color-ink);
  overflow: hidden;
  border-radius: 22px;
  border: 1px solid rgba(0, 0, 0, 0.06);
  background: white;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
}

.restaurant-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 35px rgba(225, 85, 60, 0.12);
  border-color: rgba(225, 85, 60, 0.25);
}

.image-wrapper {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f1f3f5;
}

.restaurant-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.restaurant-card:hover .restaurant-image {
  transform: scale(1.08);
}

.gradient-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.6) 0%, rgba(0,0,0,0) 50%);
  pointer-events: none;
}

.top-badges {
  position: absolute;
  top: 14px;
  left: 14px;
  right: 14px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 2;
}

.promo-tag {
  background: linear-gradient(135deg, #ff5e40, #ff8c61);
  color: white;
  font-size: 0.72rem;
  font-weight: 800;
  padding: 5px 10px;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(255, 94, 64, 0.3);
  letter-spacing: 0.02em;
}

.status-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 5px 10px;
  border-radius: 12px;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.status-badge.open {
  background: rgba(16, 185, 129, 0.85);
  color: white;
}

.status-badge.closed {
  background: rgba(239, 68, 68, 0.85);
  color: white;
}

.image-bottom-meta {
  position: absolute;
  bottom: 12px;
  left: 14px;
  right: 14px;
  display: flex;
  gap: 8px;
  z-index: 2;
}

.delivery-time-chip,
.delivery-fee-chip {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(8px);
  color: #1e1e24;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: 10px;
}

.info {
  padding: 18px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
}

.name {
  font-size: 1.15rem;
  font-weight: 800;
  color: #1e1e24;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.rating-box {
  background: #fff8f0;
  color: #d97706;
  border: 1px solid #fde68a;
  padding: 4px 8px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  gap: 4px;
  font-weight: 800;
  font-size: 0.85rem;
}

.star-icon {
  color: #f59e0b;
}

.description {
  color: #64748b;
  font-size: 0.88rem;
  line-height: 1.4;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.footer-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
  border-top: 1px dashed #f1f3f5;
  margin-top: 2px;
}

.tags-list {
  display: flex;
  gap: 6px;
}

.cuisine-tag {
  background: #f8fafc;
  color: #475569;
  font-size: 0.75rem;
  font-weight: 600;
  padding: 4px 8px;
  border-radius: 8px;
}

.action-arrow {
  color: #ff5e40;
  font-weight: 800;
  font-size: 0.85rem;
  transition: transform 0.2s ease;
}

.restaurant-card:hover .action-arrow {
  transform: translateX(4px);
}
</style>
