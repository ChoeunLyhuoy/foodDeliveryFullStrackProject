<template>
  <div class="orders-board-view">
    <div class="board-header">
      <div>
        <span class="board-subtitle">Restaurant Dashboard</span>
        <h1 class="board-title">Live Kitchen Orders</h1>
      </div>
      <button class="btn-secondary refresh-btn" @click="fetchOrders">
        <span>🔄</span> Refresh Board
      </button>
    </div>

    <!-- Kanban Board Grid -->
    <div class="board">
      <div v-for="col in columns" :key="col.status" class="board-column">
        <header class="column-header" :class="col.status.toLowerCase()">
          <div class="header-left">
            <span class="status-indicator-dot"></span>
            <h3>{{ col.label }}</h3>
          </div>
          <span class="order-count-badge">{{ ordersByStatus(col.status).length }}</span>
        </header>

        <div class="column-body">
          <transition-group name="list" tag="div" class="cards-list">
            <div
              v-for="order in ordersByStatus(col.status)"
              :key="order.id"
              class="card order-card"
            >
              <div class="card-top-row">
                <span class="order-id">Order #{{ order.id }}</span>
                <span class="order-price">${{ order.totalAmount?.toFixed(2) }}</span>
              </div>
              
              <div class="card-address">
                <span class="pin-icon">📍</span>
                <span class="address-text">{{ order.deliveryAddress }}</span>
              </div>

              <div class="card-footer" v-if="col.next">
                <button class="btn-primary advance-btn" @click="advance(order, col.next)">
                  <span>Move to {{ col.nextLabel }}</span>
                  <span>→</span>
                </button>
              </div>
            </div>
          </transition-group>
          
          <div v-if="ordersByStatus(col.status).length === 0" class="empty-column-state">
            <span class="empty-icon">✓</span>
            <p>No orders in this stage</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getRestaurantOrders, updateOrderStatus } from '../../services/api'

const RESTAURANT_ID = 1 // Hardcoded demo restaurant Pizza Palace
const orders = ref([])
const loading = ref(true)

const columns = [
  { status: 'PLACED', label: 'New Orders', next: 'PREPARING', nextLabel: 'Preparing' },
  { status: 'PREPARING', label: 'Preparing', next: 'READY_FOR_PICKUP', nextLabel: 'Ready' },
  { status: 'READY_FOR_PICKUP', label: 'Ready for Pickup', next: null }
]

onMounted(() => {
  fetchOrders()
})

async function fetchOrders() {
  loading.value = true
  try {
    const { data } = await getRestaurantOrders(RESTAURANT_ID)
    // Filter out final delivery statuses for this screen
    orders.value = data.filter(o => o.status === 'PLACED' || o.status === 'PREPARING' || o.status === 'READY_FOR_PICKUP')
  } catch (e) {
    console.error('Failed to fetch restaurant orders', e)
  } finally {
    loading.value = false
  }
}

function ordersByStatus(status) {
  return orders.value.filter((o) => o.status === status)
}

async function advance(order, nextStatus) {
  try {
    await updateOrderStatus(order.id, nextStatus)
    order.status = nextStatus
  } catch (e) {
    console.error('Failed to update status', e)
  }
}
</script>

<style scoped>
.orders-board-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.board-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.board-subtitle {
  color: var(--color-primary);
  font-weight: 700;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.board-title {
  margin-top: var(--space-1);
}

.refresh-btn {
  padding: var(--space-2) var(--space-4);
  font-size: 0.85rem;
}

/* Kanban Layout */
.board {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-6);
  align-items: start;
}

.board-column {
  background: #f8f6f2;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 480px;
}

.column-header {
  padding: var(--space-4);
  background: white;
  border-bottom: 1px solid var(--color-border);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.header-left h3 {
  font-size: 1rem;
  font-weight: 700;
}

.status-indicator-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

/* Header-specific colors */
.column-header.placed .status-indicator-dot { background-color: var(--color-warning); }
.column-header.preparing .status-indicator-dot { background-color: var(--color-primary); }
.column-header.ready_for_pickup .status-indicator-dot { background-color: var(--color-success); }

.order-count-badge {
  font-size: 0.75rem;
  font-weight: 700;
  background: var(--color-bg);
  color: var(--color-ink);
  padding: 2px 8px;
  border-radius: var(--radius-full);
  border: 1px solid var(--color-border);
}

.column-body {
  padding: var(--space-4);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  flex: 1;
}

.cards-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.order-card {
  padding: var(--space-4);
  background: white;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.order-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.card-top-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.order-id {
  font-weight: 800;
  font-size: 0.95rem;
}

.order-price {
  font-weight: 700;
  color: var(--color-primary);
  font-size: 0.95rem;
}

.card-address {
  display: flex;
  gap: var(--space-2);
  font-size: 0.8rem;
  color: var(--color-muted);
}

.pin-icon {
  flex-shrink: 0;
}

.address-text {
  line-height: 1.3;
}

.card-footer {
  margin-top: var(--space-1);
}

.advance-btn {
  width: 100%;
  padding: var(--space-2);
  font-size: 0.82rem;
  height: 38px;
  border-radius: var(--radius-sm);
  box-shadow: none;
}

.empty-column-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: var(--color-muted);
  text-align: center;
  padding: var(--space-12) 0;
  gap: var(--space-2);
  margin: auto;
}

.empty-icon {
  font-size: 1.5rem;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 2px dashed var(--color-border);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--color-border);
}

.empty-column-state p {
  font-size: 0.8rem;
  font-weight: 500;
}

/* Transitions */
.list-enter-active,
.list-leave-active {
  transition: all 0.4s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: scale(0.9) translateY(10px);
}
.list-move {
  transition: transform 0.4s ease;
}

@media (max-width: 992px) {
  .board {
    grid-template-columns: 1fr;
  }
  .board-column {
    min-height: auto;
  }
}
</style>
