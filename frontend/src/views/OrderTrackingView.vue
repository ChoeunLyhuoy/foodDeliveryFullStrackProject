<template>
  <div v-if="order" class="order-tracking-view">
    <div class="tracking-header">
      <span class="tracking-subtitle">Live Tracking</span>
      <h1 class="tracking-title">Order #{{ order.id }}</h1>
    </div>

    <!-- Active Status Card -->
    <div class="card status-card">
      <div class="status-top">
        <div class="status-summary">
          <span class="status-label">Current Status</span>
          <h2 class="status-text">{{ formatStatus(order.status) }}</h2>
        </div>
        <div class="status-visual" :class="order.status.toLowerCase()">
          <span class="status-emoji">{{ getStatusEmoji(order.status) }}</span>
        </div>
      </div>
      
      <div class="timeline-wrapper">
        <OrderStatusTimeline :status="order.status" />
      </div>
    </div>

    <!-- Order Items & Summary panel -->
    <div class="card details-card">
      <h3 class="details-title">Order Details</h3>
      <div class="details-divider"></div>
      
      <div class="meta-details">
        <p><strong>Deliver to:</strong> {{ order.deliveryAddress }}</p>
        <p><strong>Payment:</strong> Cash on Delivery</p>
        <p><strong>Placed on:</strong> {{ new Date(order.createdAt).toLocaleString() }}</p>
      </div>
      
      <div class="details-divider"></div>
      
      <div class="details-summary-row">
        <span>Total Amount Charged</span>
        <span class="final-price">${{ order.totalAmount?.toFixed(2) }}</span>
      </div>
    </div>

    <!-- Actions Panel -->
    <div class="card actions-card">
      <h3 class="actions-title">Communication & Support</h3>
      <p class="muted">Have questions about your order? Get in touch with our live agents or your rider immediately.</p>
      
      <div class="actions-btn-group">
        <RouterLink :to="`/order/${order.id}/chat/rider`" class="action-btn-link">
          <button class="btn-primary action-btn">
            <span>💬 Chat with Rider</span>
          </button>
        </RouterLink>
        <RouterLink :to="`/order/${order.id}/chat/call-center`" class="action-btn-link">
          <button class="btn-secondary action-btn support-btn">
            <span>🆘 Contact Support</span>
          </button>
        </RouterLink>
      </div>
    </div>
  </div>
  
  <div v-else class="loading-container">
    <div class="spinner"></div>
    <p>Loading order details...</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getOrder } from '../services/api'
import OrderStatusTimeline from '../components/OrderStatusTimeline.vue'

const route = useRoute()
const order = ref(null)

onMounted(async () => {
  try {
    const { data } = await getOrder(route.params.id)
    order.value = data
  } catch (e) {
    console.error('Failed to load order', e)
  }
})

function formatStatus(status) {
  return status.replaceAll('_', ' ').toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase())
}

function getStatusEmoji(status) {
  switch (status) {
    case 'PLACED': return '📝'
    case 'CONFIRMED': return '👍'
    case 'PREPARING': return '🍳'
    case 'READY_FOR_PICKUP': return '📦'
    case 'PICKED_UP': return '🏍️'
    case 'ON_THE_WAY': return '🚴'
    case 'DELIVERED': return '🎁'
    case 'CANCELLED': return '❌'
    default: return '🍔'
  }
}
</script>

<style scoped>
.order-tracking-view {
  max-width: 720px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.tracking-header {
  margin-bottom: var(--space-2);
}

.tracking-subtitle {
  color: var(--color-primary);
  font-weight: 700;
  text-transform: uppercase;
  font-size: 0.8rem;
  letter-spacing: 0.05em;
}

.tracking-title {
  margin-top: var(--space-1);
}

/* Status Card */
.status-card {
  padding: var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
}

.status-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
}

.status-label {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--color-muted);
  text-transform: uppercase;
}

.status-text {
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--color-ink);
  margin-top: 4px;
}

.status-visual {
  width: 60px;
  height: 60px;
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-md);
}

.status-visual.placed { background: #eff6ff; }
.status-visual.confirmed { background: #ecfdf5; }
.status-visual.preparing { background: #fff7ed; }
.status-visual.ready_for_pickup { background: #fef2f2; }
.status-visual.picked_up, .status-visual.on_the_way { background: #fffbeb; }
.status-visual.delivered { background: #ecfdf5; }

.status-emoji {
  font-size: 1.8rem;
}

.timeline-wrapper {
  margin-top: var(--space-4);
  padding: var(--space-4) 0;
  border-top: 1px solid var(--color-border);
}

/* Details Card */
.details-card {
  padding: var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
}

.details-title {
  font-size: 1.2rem;
  font-weight: 700;
  margin-bottom: var(--space-4);
}

.details-divider {
  height: 1px;
  background-color: var(--color-border);
  margin: var(--space-4) 0;
}

.meta-details {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  font-size: 0.95rem;
  color: var(--color-muted);
}

.meta-details strong {
  color: var(--color-ink);
}

.details-summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 1.05rem;
  font-weight: 700;
}

.final-price {
  font-size: 1.4rem;
  font-weight: 800;
  color: var(--color-primary);
}

/* Actions Card */
.actions-card {
  padding: var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.actions-title {
  font-size: 1.2rem;
  font-weight: 700;
}

.actions-btn-group {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
  margin-top: var(--space-2);
}

.action-btn-link {
  width: 100%;
}

.action-btn {
  width: 100%;
  height: 52px;
  font-size: 0.95rem;
}

.support-btn {
  border-color: var(--color-border);
}

.support-btn:hover {
  background-color: var(--color-error-light) !important;
  color: var(--color-error) !important;
  border-color: var(--color-error) !important;
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

@media (max-width: 576px) {
  .actions-btn-group {
    grid-template-columns: 1fr;
  }
}
</style>
