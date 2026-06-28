<template>
  <RouterLink :to="`/restaurant/${restaurant.id}`" class="card restaurant-card">
    <div class="image-wrapper">
      <img :src="restaurant.coverImageUrl || '/placeholder.jpg'" :alt="restaurant.name" class="restaurant-image" />
      <div class="status-badge" :class="restaurant.isOpen ? 'open' : 'closed'">
        {{ restaurant.isOpen ? 'Open Now' : 'Closed' }}
      </div>
    </div>
    
    <div class="info">
      <div class="header-row">
        <h3 class="name">{{ restaurant.name }}</h3>
        <span class="rating">
          <span class="star-icon">★</span>
          {{ restaurant.rating?.toFixed(1) || '0.0' }}
        </span>
      </div>
      <p class="description">{{ restaurant.description }}</p>
      
      <div class="footer-row">
        <span class="delivery-meta">🛵 Free Delivery</span>
        <span class="time-meta">⏱ 20-30 min</span>
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
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  transition: var(--transition-smooth);
}

.restaurant-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--color-border);
}

.image-wrapper {
  position: relative;
  width: 100%;
  height: 180px;
  overflow: hidden;
  background: var(--color-bg);
}

.restaurant-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.restaurant-card:hover .restaurant-image {
  transform: scale(1.06);
}

.status-badge {
  position: absolute;
  top: var(--space-3);
  right: var(--space-3);
  font-size: 0.75rem;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: var(--radius-full);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  box-shadow: var(--shadow-sm);
}

.status-badge.open {
  background: rgba(16, 185, 129, 0.9);
  color: white;
}

.status-badge.closed {
  background: rgba(239, 68, 110, 0.9);
  color: white;
}

.info {
  padding: var(--space-4);
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: var(--space-2);
}

.header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--space-2);
}

.name {
  font-size: 1.15rem;
  font-weight: 700;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.rating {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  background: var(--color-accent-light);
  color: var(--color-accent);
  font-weight: 700;
  font-size: 0.85rem;
  padding: 3px 8px;
  border-radius: var(--radius-full);
  flex-shrink: 0;
}

.star-icon {
  font-size: 0.8rem;
}

.description {
  color: var(--color-muted);
  font-size: 0.85rem;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  height: 2.8em; /* Exact height for 2 lines */
}

.footer-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: var(--space-2);
  padding-top: var(--space-3);
  border-top: 1px dashed var(--color-border);
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--color-muted);
}

.delivery-meta {
  color: var(--color-success);
}
</style>
