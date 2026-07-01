<template>
  <div class="agent-dashboard-view">
    <!-- Top Hero Header -->
    <div class="view-header">
      <div>
        <div class="subtitle-row">
          <span class="view-subtitle">Call Center Dispatch</span>
          <span class="live-pulse-badge">
            <span class="pulse-dot"></span> REAL-TIME STOMP SYNC
          </span>
        </div>
        <h1 class="view-title">Customer Support Center</h1>
        <p class="muted">Live monitoring of customer inquiries, order assistance, and priority escalations.</p>
      </div>
      <div class="header-actions">
        <button @click="refreshQueue" class="btn-refresh" title="Refresh Queue">
          🔄 Refresh
        </button>
        <RouterLink to="/call-center-dashboard/lookup">
          <button class="btn-lookup">
            <span>🔍</span> Look Up Order
          </button>
        </RouterLink>
      </div>
    </div>

    <!-- Quick Stats Grid -->
    <div class="stats-grid">
      <div class="stat-box">
        <span class="stat-label">Queue Length</span>
        <span class="stat-value">{{ queue.length }} <small>Open</small></span>
      </div>
      <div class="stat-box">
        <span class="stat-label">High Priority</span>
        <span class="stat-value error">{{ highPriorityCount }} <small>Tickets</small></span>
      </div>
      <div class="stat-box">
        <span class="stat-label">System Status</span>
        <span class="stat-value success">99.9% <small>Online</small></span>
      </div>
    </div>

    <!-- Priority Filter Tabs -->
    <div class="filter-bar">
      <div class="tabs">
        <button 
          v-for="f in ['ALL', 'HIGH', 'NORMAL', 'LOW']" 
          :key="f"
          :class="['tab-btn', { active: activeFilter === f }]"
          @click="activeFilter = f"
        >
          {{ f === 'ALL' ? 'All Tickets' : `${f} Priority` }}
        </button>
      </div>
    </div>

    <!-- Active Tickets Queue -->
    <div class="queue-section">
      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <p>Syncing active ticket queue...</p>
      </div>
      <div v-else>
        <div class="tickets-list">
          <transition-group name="ticket-list">
            <div v-for="ticket in filteredQueue" :key="ticket.id" class="ticket-card">
              <div class="ticket-left">
                <div class="ticket-avatar">
                  <span>🎧</span>
                </div>
                <div class="ticket-info">
                  <div class="ticket-header-row">
                    <span class="ticket-id-tag">Ticket #{{ ticket.id }}</span>
                    <span :class="['priority-badge', ticket.priority?.toLowerCase() || 'normal']">
                      {{ ticket.priority || 'NORMAL' }} PRIORITY
                    </span>
                    <span class="status-pill">{{ ticket.status || 'OPEN' }}</span>
                  </div>
                  <p class="ticket-details-text">
                    Inquiry regarding <strong>Order #{{ ticket.orderId }}</strong> · Customer ID #{{ ticket.customerId }}
                  </p>
                  <div class="ticket-meta-row">
                    <span class="ticket-time">⏰ Received: {{ formatTime(ticket.createdAt) }}</span>
                    <span class="issue-type">💡 Support Request</span>
                  </div>
                </div>
              </div>
              
              <div class="ticket-action">
                <RouterLink :to="`/call-center-dashboard/chat/${ticket.id}`">
                  <button class="btn-open-chat">
                    <span>Connect & Chat</span>
                    <span class="arrow">➔</span>
                  </button>
                </RouterLink>
              </div>
            </div>
          </transition-group>
        </div>
        
        <div v-if="filteredQueue.length === 0" class="empty-queue-card">
          <span class="empty-emoji">🌟</span>
          <h3>All Support Tickets Clear!</h3>
          <p class="muted">No {{ activeFilter !== 'ALL' ? activeFilter.toLowerCase() + ' priority' : 'open' }} customer tickets requiring attention right now.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { getCallCenterQueue } from '../../services/api'
import { subscribeToTopic } from '../../services/socket'

const queue = ref([])
const loading = ref(true)
const activeFilter = ref('ALL')
let socketSubscription = null

async function refreshQueue() {
  try {
    const { data } = await getCallCenterQueue()
    queue.value = data
  } catch (e) {
    console.error('Failed to load call center queue', e)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await refreshQueue()
  
  // Real-time STOMP WebSocket updates
  socketSubscription = subscribeToTopic('/topic/callcenter/tickets', (newOrUpdatedTicket) => {
    refreshQueue()
  })
})

onUnmounted(() => {
  if (socketSubscription && socketSubscription.unsubscribe) {
    socketSubscription.unsubscribe()
  }
})

const highPriorityCount = computed(() => {
  return queue.value.filter(t => t.priority === 'HIGH').length
})

const filteredQueue = computed(() => {
  if (activeFilter.value === 'ALL') return queue.value
  return queue.value.filter(t => (t.priority || 'NORMAL').toUpperCase() === activeFilter.value)
})

function formatTime(t) {
  if (!t) return 'Just now'
  return new Date(t).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}
</script>

<style scoped>
.agent-dashboard-view {
  display: flex;
  flex-direction: column;
  gap: 28px;
  max-width: 960px;
  margin: 0 auto;
  padding-bottom: 60px;
}

.view-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 20px;
}

.subtitle-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.view-subtitle {
  color: #ff5e40;
  font-weight: 800;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.live-pulse-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: #ecfdf5;
  color: #10b981;
  font-size: 0.75rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 20px;
  border: 1px solid #a7f3d0;
}

.pulse-dot {
  width: 8px;
  height: 8px;
  background: #10b981;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% { transform: scale(0.95); opacity: 1; }
  50% { transform: scale(1.3); opacity: 0.6; }
  100% { transform: scale(0.95); opacity: 1; }
}

.view-title {
  font-size: 2.3rem;
  font-weight: 900;
  color: #1e293b;
  margin: 4px 0;
  letter-spacing: -0.03em;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.btn-refresh {
  background: white;
  border: 1px solid #cbd5e1;
  color: #475569;
  padding: 10px 16px;
  border-radius: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-refresh:hover {
  background: #f8fafc;
  border-color: #94a3b8;
}

.btn-lookup {
  background: #1e293b;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 14px;
  font-weight: 800;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 4px 12px rgba(30, 41, 59, 0.2);
}

.btn-lookup:hover {
  background: #0f172a;
  transform: translateY(-2px);
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.stat-box {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 20px;
  padding: 18px 24px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.03);
}

.stat-label {
  font-size: 0.85rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
}

.stat-value {
  font-size: 1.8rem;
  font-weight: 900;
  color: #1e293b;
}

.stat-value small { font-size: 0.95rem; font-weight: 700; color: #94a3b8; }
.stat-value.error { color: #ef4444; }
.stat-value.success { color: #10b981; }

/* Filter Tabs */
.filter-bar {
  display: flex;
}

.tabs {
  display: flex;
  gap: 8px;
  background: #f1f5f9;
  padding: 6px;
  border-radius: 16px;
}

.tab-btn {
  border: none;
  background: transparent;
  padding: 8px 18px;
  border-radius: 12px;
  font-weight: 800;
  font-size: 0.85rem;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
}

.tab-btn.active {
  background: white;
  color: #ff5e40;
  box-shadow: 0 4px 10px rgba(0,0,0,0.06);
}

/* Tickets Queue List */
.tickets-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.ticket-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 22px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 24px;
  box-shadow: 0 6px 18px rgba(0,0,0,0.04);
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.ticket-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 32px rgba(0,0,0,0.08);
  border-color: rgba(255, 94, 64, 0.3);
}

.ticket-left {
  display: flex;
  gap: 18px;
  align-items: flex-start;
}

.ticket-avatar {
  width: 54px;
  height: 54px;
  background: #fff3ed;
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.6rem;
  flex-shrink: 0;
}

.ticket-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.ticket-header-row {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.ticket-id-tag {
  font-weight: 900;
  color: #1e293b;
  font-size: 1.15rem;
}

.priority-badge {
  font-size: 0.72rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 20px;
}

.priority-badge.high { background: #fee2e2; color: #ef4444; }
.priority-badge.normal { background: #fef3c7; color: #d97706; }
.priority-badge.low { background: #d1fae5; color: #10b981; }

.status-pill {
  font-size: 0.72rem;
  font-weight: 800;
  background: #f1f5f9;
  color: #64748b;
  padding: 4px 10px;
  border-radius: 12px;
}

.ticket-details-text {
  font-size: 0.95rem;
  color: #64748b;
  margin: 0;
}

.ticket-details-text strong {
  color: #1e293b;
  font-weight: 800;
}

.ticket-meta-row {
  display: flex;
  gap: 16px;
  align-items: center;
  font-size: 0.82rem;
  color: #94a3b8;
  font-weight: 600;
}

.btn-open-chat {
  background: #ff5e40;
  color: white;
  border: none;
  padding: 12px 22px;
  border-radius: 16px;
  font-weight: 800;
  font-size: 0.92rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
  box-shadow: 0 6px 16px rgba(255, 94, 64, 0.25);
}

.btn-open-chat:hover {
  background: #e04a2e;
  transform: scale(1.04);
}

/* Empty State */
.empty-queue-card {
  background: white;
  border: 1px dashed #cbd5e1;
  border-radius: 24px;
  padding: 60px 30px;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.empty-emoji { font-size: 4rem; }
.empty-queue-card h3 { font-size: 1.5rem; font-weight: 800; color: #1e293b; margin: 0; }

.ticket-list-enter-active, .ticket-list-leave-active { transition: all 0.3s ease; }
.ticket-list-enter-from, .ticket-list-leave-to { opacity: 0; transform: translateY(15px); }

@media (max-width: 768px) {
  .ticket-card {
    flex-direction: column;
    align-items: stretch;
    gap: 18px;
  }
}
</style>
