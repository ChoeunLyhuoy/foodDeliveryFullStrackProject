<template>
  <div class="figma-agent-portal">
    <!-- Dark Left Sidebar (Figma Image 4 Exact Layout) -->
    <aside class="dark-sidebar">
      <div class="sidebar-top">
        <div class="brand-box">
          <span class="brand-icon">🎧</span>
          <div>
            <strong class="brand-name">Call Center</strong>
            <span class="brand-sub">FoodGo Support</span>
          </div>
        </div>

        <nav class="sidebar-nav">
          <RouterLink to="/call-center-dashboard" class="nav-item">
            <span class="nav-icon">📥</span> Support Queue
            <span class="badge red">12</span>
          </RouterLink>
          <RouterLink to="/call-center-dashboard" class="nav-item">
            <span class="nav-icon">💬</span> Live Chat
            <span class="badge orange">3</span>
          </RouterLink>
          <RouterLink to="/call-center-dashboard/lookup" class="nav-item active">
            <span class="nav-icon">🔍</span> Order Lookup
          </RouterLink>
          <a href="#" class="nav-item">
            <span class="nav-icon">📊</span> Platform Stats
          </a>
          <a href="#" class="nav-item">
            <span class="nav-icon">👥</span> Users
          </a>
        </nav>
      </div>

      <div class="sidebar-bottom">
        <div class="agent-status-box">
          <span class="status-label">Agent Status</span>
          <strong class="status-val"><span class="online-dot">●</span> Alex M. · Online</strong>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      <div class="view-navigation">
        <RouterLink to="/call-center-dashboard" class="back-link">
          <span>←</span> Back to Support Queue
        </RouterLink>
      </div>

      <div class="order-lookup-container">
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
                <p v-if="order.riderId" class="rider-val">Rider ID #{{ order.riderId }}</p>
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
    </main>
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
.figma-agent-portal {
  display: flex;
  height: 100vh;
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
.brand-icon {
  font-size: 1.6rem;
  background: #ff5e40;
  width: 42px;
  height: 42px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.brand-name { font-size: 1.1rem; display: block; line-height: 1.2; }
.brand-sub { font-size: 0.78rem; color: #94a3b8; }

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
  position: relative;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.nav-item:hover, .nav-item.active {
  background: rgba(255, 94, 64, 0.15);
  color: #ff5e40;
  transform: translateX(4px);
}

.badge {
  position: absolute;
  right: 14px;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 0.75rem;
  font-weight: 800;
  color: white;
}
.badge.red { background: #ef4444; }
.badge.orange { background: #ff5e40; }

.agent-status-box {
  background: rgba(255, 255, 255, 0.05);
  padding: 14px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.status-label { font-size: 0.78rem; color: #94a3b8; display: block; }
.status-val { font-size: 0.92rem; color: white; display: block; margin-top: 4px; font-weight: 700; }
.online-dot { color: #10b981; }

/* Main Content */
.main-content {
  flex: 1;
  padding: 32px 36px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.view-navigation {
  margin-bottom: 4px;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 800;
  color: #64748b;
  text-decoration: none;
  font-size: 0.92rem;
  transition: color 0.2s ease;
}

.back-link:hover {
  color: #ff5e40;
}

.order-lookup-container {
  max-width: 680px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.view-subtitle {
  color: #ff5e40;
  font-weight: 800;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.view-title {
  font-size: 1.8rem;
  font-weight: 900;
  color: #1e1e24;
  margin: 4px 0;
}

.muted {
  color: #64748b;
  font-size: 0.9rem;
  line-height: 1.5;
  margin: 0;
}

/* Lookup input card */
.lookup-form-card {
  padding: 16px;
  background: white;
  border: 1px solid #cbd5e1;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.01);
}

.search-row {
  display: flex;
  gap: 12px;
}

.lookup-input {
  flex: 1;
  height: 48px;
  border-radius: 10px;
  border: 1px solid #cbd5e1;
  padding: 0 16px;
  font-size: 0.95rem;
}
.lookup-input:focus {
  outline: none;
  border-color: #ff5e40;
}

.search-btn {
  height: 48px;
  padding: 0 24px;
  background: #ff5e40;
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 900;
  cursor: pointer;
}

/* Result Card */
.result-card {
  padding: 24px;
  background: white;
  border: 1px solid #cbd5e1;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.02);
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #cbd5e1;
  padding-bottom: 12px;
}

.result-header h3 {
  font-size: 1.15rem;
  font-weight: 900;
  margin: 0;
}

.status-badge {
  font-size: 0.75rem;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 20px;
  text-transform: uppercase;
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
  gap: 16px;
}

.info-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-group label {
  font-size: 0.78rem;
  font-weight: 800;
  color: #94a3b8;
  text-transform: uppercase;
}

.info-group p {
  font-size: 0.95rem;
  font-weight: 700;
  color: #1e1e24;
  margin: 0;
}

.info-group-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.price-value {
  font-size: 1.25rem;
  font-weight: 900;
  color: #ff5e40;
}

.rider-val {
  font-weight: 700;
  color: #1e1e24;
}

.unassigned {
  color: #ef4444;
  font-weight: 700;
}

/* Error Card */
.error-card {
  padding: 20px;
  background: white;
  border-left: 4px solid #ef4444;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.01);
}

.error-icon {
  font-size: 2rem;
}

.error-card h4 {
  font-size: 1.05rem;
  font-weight: 900;
  color: #ef4444;
  margin: 0;
}

.error-card p {
  font-size: 0.85rem;
  margin-top: 4px;
  margin-bottom: 0;
}
</style>
