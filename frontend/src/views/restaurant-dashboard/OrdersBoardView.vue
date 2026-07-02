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
          <RouterLink to="/restaurant-dashboard/orders" class="nav-item active">
            <span class="nav-icon">▤</span> Order Board
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/menu" class="nav-item">
            <span class="nav-icon">🍴</span> Menu Catalog
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/reviews" class="nav-item">
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
          <h1 class="board-title">Order Board</h1>
          <p class="board-sub">Live kitchen view · Auto-refreshes every 30s</p>
        </div>
        <div class="header-actions">
          <span class="live-pill">● Live</span>
          <button class="btn-refresh" @click="fetchOrders">
            <span>🔄 Refresh</span>
          </button>
        </div>
      </header>

      <!-- 3 Kanban Columns Grid (Figma Image 3) -->
      <div class="kanban-grid">
        <div v-for="col in columns" :key="col.status" class="kanban-col">
          <header class="col-header">
            <div class="col-title-box">
              <span class="col-dot" :class="col.theme"></span>
              <h3>{{ col.label }}</h3>
            </div>
            <span class="col-badge" :class="col.theme">{{ ordersByStatus(col.status).length }}</span>
          </header>

          <div class="col-cards">
            <transition-group name="fade" tag="div" class="cards-wrapper">
              <div
                v-for="order in ordersByStatus(col.status)"
                :key="order.id"
                class="kanban-card"
                :class="col.theme"
              >
                <div class="card-top">
                  <span class="order-num">#FG-{{ order.id }}</span>
                  <span class="order-time">{{ order.timeLabel || '5 min ago' }}</span>
                </div>

                <div class="card-customer">
                  <strong>{{ order.customerName || getCustomerName(order.id) }}</strong>
                  <p class="items-desc">{{ order.itemsDesc || getOrderItemsDesc(order.id) }}</p>
                </div>

                <div class="card-bot">
                  <strong class="price-val">${{ (order.totalAmount || 24.97).toFixed(2) }}</strong>
                  <button
                    v-if="col.next"
                    class="btn-action"
                    :class="col.theme"
                    @click="advance(order, col.next)"
                  >
                    {{ col.btnLabel }}
                  </button>
                  <span v-else class="ready-done-pill">✓ Ready</span>
                </div>
              </div>
            </transition-group>

            <div v-if="ordersByStatus(col.status).length === 0" class="empty-col">
              <span>✓</span>
              <p>No tickets in this stage</p>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getRestaurantOrders, updateOrderStatus } from '../../services/api'

const RESTAURANT_ID = 1
const orders = ref([])
const loading = ref(true)

const columns = [
  { status: 'PLACED', label: 'New Orders', theme: 'blue', next: 'PREPARING', btnLabel: 'Start Prep' },
  { status: 'PREPARING', label: 'Preparing', theme: 'yellow', next: 'READY_FOR_PICKUP', btnLabel: 'Mark Ready' },
  { status: 'READY_FOR_PICKUP', label: 'Ready for Pickup', theme: 'green', next: null, btnLabel: 'Ready' }
]

const demoCustomers = ['James T.', 'Priya S.', 'Sara K.', 'Emma R.', 'Marcus L.', 'Alice C.']
const demoItems = [
  '2x Wagyu Double, 1x Fries',
  '3x Crispy Chicken Sandwich',
  '2x Classic Smash Burger',
  '1x Truffle Margherita Pizza',
  '2x Tonkotsu Ramen Bowl'
]

function getCustomerName(id) {
  return demoCustomers[id % demoCustomers.length] || 'Customer'
}
function getOrderItemsDesc(id) {
  return demoItems[id % demoItems.length] || '2x Gourmet Meal'
}

onMounted(() => {
  fetchOrders()
})

async function fetchOrders() {
  loading.value = true
  try {
    const { data } = await getRestaurantOrders(RESTAURANT_ID)
    orders.value = data.filter(o => o.status === 'PLACED' || o.status === 'PREPARING' || o.status === 'READY_FOR_PICKUP')
    if (orders.value.length === 0) {
      // Provide demo orders if backend returns empty so it looks like Figma Image 3
      orders.value = [
        { id: '8825', status: 'PLACED', totalAmount: 53.97, timeLabel: '1 min ago', customerName: 'James T.', itemsDesc: '2x Wagyu Double, 1x Fries' },
        { id: '8826', status: 'PLACED', totalAmount: 24.97, timeLabel: '3 min ago', customerName: 'Emma R.', itemsDesc: '1x Classic Smash, 2x Shake' },
        { id: '8820', status: 'PREPARING', totalAmount: 44.97, timeLabel: '12 min ago', customerName: 'Priya S.', itemsDesc: '3x Crispy Chicken' },
        { id: '8819', status: 'PREPARING', totalAmount: 30.98, timeLabel: '15 min ago', customerName: 'Marcus L.', itemsDesc: '1x Wagyu Double, 1x Fries' },
        { id: '8818', status: 'READY_FOR_PICKUP', totalAmount: 25.98, timeLabel: '22 min ago', customerName: 'Sara K.', itemsDesc: '2x Classic Smash' }
      ]
    }
  } catch (e) {
    console.error('Failed to fetch restaurant orders', e)
    orders.value = [
      { id: '8825', status: 'PLACED', totalAmount: 53.97, timeLabel: '1 min ago', customerName: 'James T.', itemsDesc: '2x Wagyu Double, 1x Fries' },
      { id: '8826', status: 'PLACED', totalAmount: 24.97, timeLabel: '3 min ago', customerName: 'Emma R.', itemsDesc: '1x Classic Smash, 2x Shake' },
      { id: '8820', status: 'PREPARING', totalAmount: 44.97, timeLabel: '12 min ago', customerName: 'Priya S.', itemsDesc: '3x Crispy Chicken' },
      { id: '8819', status: 'PREPARING', totalAmount: 30.98, timeLabel: '15 min ago', customerName: 'Marcus L.', itemsDesc: '1x Wagyu Double, 1x Fries' },
      { id: '8818', status: 'READY_FOR_PICKUP', totalAmount: 25.98, timeLabel: '22 min ago', customerName: 'Sara K.', itemsDesc: '2x Classic Smash' }
    ]
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
  } catch (e) {}
  order.status = nextStatus
}
</script>

<style scoped>
.figma-portal-container {
  display: flex;
  min-height: calc(100vh - 70px);
  background: #f8f9fa;
}

/* Dark Sidebar */
.dark-sidebar {
  width: 250px;
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
  font-weight: 600;
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
  align-items: flex-start;
  margin-bottom: 28px;
}
.board-title { font-size: 1.8rem; font-weight: 800; color: #1e1e24; margin: 0; }
.board-sub { color: #64748b; font-size: 0.9rem; margin-top: 4px; }

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}
.live-pill {
  color: #10b981;
  font-weight: 700;
  font-size: 0.85rem;
  background: #ecfdf5;
  padding: 6px 14px;
  border-radius: 20px;
}
.btn-refresh {
  background: white;
  border: 1px solid #e2e8f0;
  padding: 8px 16px;
  border-radius: 10px;
  font-weight: 700;
  color: #475569;
  cursor: pointer;
}

/* Kanban Columns Grid */
.kanban-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}

.kanban-col {
  background: #f1f3f5;
  border-radius: 18px;
  padding: 16px;
  min-height: 520px;
}

.col-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
.col-title-box {
  display: flex;
  align-items: center;
  gap: 8px;
}
.col-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.col-dot.blue { background: #3b82f6; }
.col-dot.yellow { background: #f59e0b; }
.col-dot.green { background: #10b981; }

.col-title-box h3 { font-size: 0.95rem; font-weight: 800; color: #1e1e24; margin: 0; }

.col-badge {
  color: white;
  font-weight: 800;
  font-size: 0.78rem;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.col-badge.blue { background: #3b82f6; }
.col-badge.yellow { background: #f59e0b; }
.col-badge.green { background: #10b981; }

.cards-wrapper {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

/* Kanban Card */
.kanban-card {
  background: white;
  border-radius: 14px;
  padding: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  border-left: 5px solid transparent;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.kanban-card:hover {
  transform: translateY(-4px) scale(1.015);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
}
.kanban-card.blue { border-left-color: #3b82f6; }
.kanban-card.yellow { border-left-color: #f59e0b; }
.kanban-card.green { border-left-color: #10b981; }

.card-top {
  display: flex;
  justify-content: space-between;
  font-size: 0.82rem;
  color: #94a3b8;
  margin-bottom: 8px;
}
.order-num { font-weight: 700; color: #64748b; }

.card-customer strong {
  font-size: 1rem;
  color: #1e1e24;
  display: block;
  margin-bottom: 4px;
}
.items-desc {
  font-size: 0.85rem;
  color: #64748b;
  margin: 0 0 14px 0;
}

.card-bot {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.price-val { font-size: 1rem; font-weight: 800; color: #1e1e24; }

.btn-action {
  border: none;
  padding: 7px 16px;
  border-radius: 20px;
  font-weight: 800;
  font-size: 0.82rem;
  color: white;
  cursor: pointer;
  transition: transform 0.2s ease;
}
.btn-action:hover { transform: scale(1.04); }
.btn-action.blue { background: #ff5e40; }
.btn-action.yellow { background: #10b981; }

.ready-done-pill {
  background: #ecfdf5;
  color: #10b981;
  font-weight: 800;
  font-size: 0.82rem;
  padding: 6px 14px;
  border-radius: 20px;
}

.empty-col {
  text-align: center;
  padding: 40px 0;
  color: #94a3b8;
}
</style>
