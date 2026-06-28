<template>
  <div class="order-lookup-view">
    <div class="view-navigation">
      <RouterLink to="/call-center-dashboard" class="back-link">
        <span>←</span> Back to Support Queue
      </RouterLink>
    </div>

    <div class="view-header">
      <span class="view-subtitle">Customer Care</span>
      <h1 class="view-title">Order Lookup</h1>
      <p class="muted">Search order records by their primary database ID to verify tracking states and delivery information.</p>
    </div>

    <!-- Search Form -->
    <form class="card lookup-form-card" @submit.prevent="lookup">
      <div class="search-row">
        <input 
          v-model="orderId" 
          placeholder="Enter Order ID (e.g. 1)" 
          class="lookup-input"
          required 
        />
        <button class="btn-primary search-btn" type="submit">
          Search Order
        </button>
      </div>
    </form>

    <!-- Search Results -->
    <div v-if="order" class="card result-card">
      <div class="result-header">
        <h3>Order #{{ order.id }}</h3>
        <span :class="['status-badge', order.status?.toLowerCase()]">
          {{ formatStatus(order.status) }}
        </span>
      </div>
      
      <div class="result-body">
        <div class="info-group">
          <label>Delivery Address</label>
          <p>{{ order.deliveryAddress }}</p>
        </div>
        
        <div class="info-group-row">
          <div class="info-group">
            <label>Total Amount</label>
            <p class="price-value">${{ order.totalAmount?.toFixed(2) }}</p>
          </div>
          <div class="info-group">
            <label>Assigned Rider</label>
            <p v-if="order.riderId">Rider ID #{{ order.riderId }}</p>
            <p v-else class="unassigned">No Rider Assigned</p>
          </div>
        </div>
      </div>
    </div>

    <div v-if="notFound" class="card error-card">
      <span class="error-icon">⚠️</span>
      <div>
        <h4>No Order Found</h4>
        <p class="muted">We couldn't locate any order database record matching ID "{{ searchAttempt }}".</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { getOrder } from '../../services/api'

const orderId = ref('')
const order = ref(null)
const notFound = ref(false)
const searchAttempt = ref('')

async function lookup() {
  notFound.value = false
  order.value = null
  searchAttempt.value = orderId.value
  try {
    const { data } = await getOrder(orderId.value)
    order.value = data
  } catch (e) {
    notFound.value = true
  }
}

function formatStatus(status) {
  if (!status) return ''
  return status.replaceAll('_', ' ').toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase())
}
</script>

<style scoped>
.order-lookup-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
  max-width: 620px;
  margin: 0 auto;
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

.view-subtitle {
  color: var(--color-primary);
  font-weight: 700;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.view-title {
  margin-top: var(--space-1);
  margin-bottom: var(--space-1);
}

/* Lookup input card */
.lookup-form-card {
  padding: var(--space-4);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}

.search-row {
  display: flex;
  gap: var(--space-3);
}

.lookup-input {
  flex: 1;
  height: 48px;
  border-radius: var(--radius-md);
}

.search-btn {
  height: 48px;
  padding: 0 var(--space-5);
  box-shadow: none;
}

/* Result Card */
.result-card {
  padding: var(--space-5) var(--space-6);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  box-shadow: var(--shadow-md);
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: var(--space-3);
}

.result-header h3 {
  font-size: 1.25rem;
  font-family: var(--font-display);
}

.status-badge {
  font-size: 0.75rem;
  font-weight: 700;
  padding: 3px 10px;
  border-radius: var(--radius-full);
}

.status-badge.placed { background: #eff6ff; color: #2563eb; }
.status-badge.confirmed { background: #ecfdf5; color: #059669; }
.status-badge.preparing { background: #fff7ed; color: #ea580c; }
.status-badge.ready_for_pickup { background: #fef2f2; color: #dc2626; }
.status-badge.picked_up, .status-badge.on_the_way { background: #fffbeb; color: #d97706; }
.status-badge.delivered { background: #ecfdf5; color: #10b981; }

.result-body {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.info-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-group label {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-muted);
  text-transform: uppercase;
}

.info-group p {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--color-ink);
}

.info-group-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.price-value {
  font-size: 1.2rem;
  font-weight: 800;
  color: var(--color-primary);
}

.unassigned {
  color: var(--color-error);
}

/* Error Card */
.error-card {
  padding: var(--space-5);
  background: white;
  border-color: var(--color-error);
  display: flex;
  align-items: center;
  gap: var(--space-4);
}

.error-icon {
  font-size: 2.2rem;
}

.error-card h4 {
  font-size: 1.05rem;
  font-weight: 700;
  color: var(--color-error);
}

.error-card p {
  font-size: 0.85rem;
  margin-top: 2px;
}
</style>
