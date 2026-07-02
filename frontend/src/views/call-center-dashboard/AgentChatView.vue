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
          <RouterLink to="/call-center-dashboard" class="nav-item active">
            <span class="nav-icon">📥</span> Support Queue
            <span class="badge red">12</span>
          </RouterLink>
          <a href="#" class="nav-item">
            <span class="nav-icon">💬</span> Live Chat
            <span class="badge orange">3</span>
          </a>
          <RouterLink to="/call-center-dashboard/lookup" class="nav-item" exact-active-class="active">
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

      <div class="agent-chat-grid" v-if="ticket">
        <!-- Left side: Live Chat Box -->
        <div class="card chat-panel-card">
          <header class="chat-header support-theme">
            <div class="header-user-info">
              <div class="avatar-circle">👤</div>
              <div class="header-text">
                <h2>Ticket #{{ ticketId }}</h2>
                <p class="subtitle">Support Chat · Customer ID #{{ ticket.customerId }}</p>
              </div>
            </div>
            <span :class="['priority-badge', ticket.priority?.toLowerCase()]">{{ ticket.priority }}</span>
          </header>

          <!-- Message logs -->
          <div class="messages-body" ref="messagesContainer">
            <div v-if="messages.length === 0" class="empty-messages">
              <p>No messages in this chat yet. Type a response below to start the conversation.</p>
            </div>
            <ChatBubble 
              v-for="m in messages" 
              :key="m.id" 
              :message="m" 
              :currentUserId="agentId" 
            />
          </div>

          <!-- Canned replies quick selectors -->
          <div class="canned-replies-bar">
            <span class="canned-label">Canned replies:</span>
            <div class="canned-replies-list">
              <button 
                v-for="c in canned" 
                :key="c" 
                class="canned-pill"
                @click="send(c)"
              >
                {{ c }}
              </button>
            </div>
          </div>

          <!-- Composer form -->
          <form class="composer-form" @submit.prevent="send(draft)">
            <input 
              v-model="draft" 
              placeholder="Type your response to the customer..." 
              class="composer-input"
              required 
            />
            <button class="btn-primary send-btn" type="submit">
              <span>Send</span>
              <span class="send-icon">🚀</span>
            </button>
          </form>
        </div>

        <!-- Right side: Linked Order Panel -->
        <aside class="card order-details-panel">
          <div class="panel-header">
            <h3>Linked Order Details</h3>
          </div>
          
          <div class="panel-body" v-if="order">
            <div class="order-id-row">
              <strong>Order #{{ order.id }}</strong>
              <span :class="['status-badge', order.status.toLowerCase()]">
                {{ formatStatus(order.status) }}
              </span>
            </div>

            <div class="detail-item">
              <label>Amount charged</label>
              <span class="value-price">${{ order.totalAmount?.toFixed(2) }}</span>
            </div>

            <div class="detail-item">
              <label>Delivery location</label>
              <span class="value-text">{{ order.deliveryAddress }}</span>
            </div>

            <div class="detail-item" v-if="order.riderId">
              <label>Assigned Rider</label>
              <span class="value-text">Rider ID #{{ order.riderId }}</span>
            </div>
            <div class="detail-item" v-else>
              <label>Assigned Rider</label>
              <span class="value-text unassigned">No Rider Assigned</span>
            </div>

            <div class="panel-actions">
              <button class="btn-secondary resolve-btn" @click="resolve">
                Mark Ticket Resolved
              </button>
            </div>
          </div>
          
          <div class="panel-body empty-order-details" v-else-if="loadingOrder">
            <div class="spinner"></div>
            <p>Fetching linked order details...</p>
          </div>

          <div class="panel-body empty-order-details" v-else>
            <span class="alert-icon">⚠️</span>
            <p>No active order linked directly to this support ticket.</p>
          </div>
        </aside>
      </div>

      <div class="loading-state" v-else>
        <div class="spinner"></div>
        <p>Loading support ticket #{{ ticketId }}...</p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ChatBubble from '../../components/ChatBubble.vue'
import { getCallCenterChatHistory, getCallCenterTicket, getOrder, resolveTicket } from '../../services/api'
import { subscribeToChat, sendChatMessage } from '../../services/socket'

const route = useRoute()
const router = useRouter()
const ticketId = route.params.ticketId
const agentId = 4

const ticket = ref(null)
const order = ref(null)
const messages = ref([])
const draft = ref('')
const loadingOrder = ref(false)
const messagesContainer = ref(null)

const canned = [
  'Checking on that for you right now.',
  'Your order has been successfully refunded.',
  'Apologies for the delay, our rider is on the way.',
  'Is there anything else I can help you with?'
]

onMounted(async () => {
  try {
    // 1. Fetch Ticket
    try {
      const ticketRes = await getCallCenterTicket(ticketId)
      ticket.value = ticketRes.data
    } catch (e) {
      console.warn('Backend ticket fetch failed, using fallback mock ticket.')
      ticket.value = {
        id: ticketId,
        ticketNum: 'SUP-' + ticketId,
        customerId: 1,
        orderId: 1,
        priority: 'HIGH',
        status: 'OPEN'
      }
    }
    
    const linkedOrderId = ticket.value ? ticket.value.orderId : null
    
    // 2. Fetch Chat History
    if (linkedOrderId) {
      try {
        const chatRes = await getCallCenterChatHistory(linkedOrderId)
        messages.value = chatRes.data
        scrollToBottom()
      } catch (err) {
        console.warn('Could not load chat history', err)
      }

      // 3. Subscribe to Socket Chat
      try {
        subscribeToChat(linkedOrderId, 'callcenter', (msg) => {
          messages.value.push(msg)
          scrollToBottom()
        })
      } catch (err) {
        console.warn('Could not subscribe to chat socket', err)
      }
    }

    // 4. Fetch Linked Order if exists
    if (linkedOrderId) {
      loadingOrder.value = true
      try {
        const orderRes = await getOrder(linkedOrderId)
        order.value = orderRes.data
      } catch (err) {
        console.warn('Could not load order details', err)
        // Fallback demo order details
        order.value = {
          id: linkedOrderId,
          status: 'PREPARING',
          totalAmount: 44.97,
          deliveryAddress: '123 Norodom Blvd, Phnom Penh',
          riderId: null
        }
      } finally {
        loadingOrder.value = false
      }
    }
  } catch (e) {
    console.error('Failed to load support ticket details', e)
  }
})

watch(messages, () => {
  scrollToBottom()
}, { deep: true })

function scrollToBottom() {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}

function send(text) {
  if (!text || !text.trim() || !ticket.value) return
  sendChatMessage(ticket.value.orderId, 'callcenter', {
    senderId: agentId,
    senderRole: 'CALL_CENTER_AGENT',
    message: text.trim()
  })
  // Optimistic local add
  messages.value.push({
    id: Date.now(),
    senderId: agentId,
    senderRole: 'CALL_CENTER_AGENT',
    message: text.trim(),
    createdAt: new Date().toISOString()
  })
  draft.value = ''
  scrollToBottom()
}

async function resolve() {
  try {
    await resolveTicket(ticketId)
    router.push('/call-center-dashboard')
  } catch (e) {
    console.error('Failed to resolve ticket', e)
    router.push('/call-center-dashboard')
  }
}

function formatStatus(status) {
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

/* Chat Layout Grid */
.agent-chat-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
  flex: 1;
}

.chat-panel-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  border-radius: 18px;
  overflow: hidden;
  background: white;
  border: 1px solid #e2e8f0;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
}

.chat-header {
  padding: 18px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e2e8f0;
}

.chat-header.support-theme {
  background: linear-gradient(135deg, #fff0ed 0%, transparent 100%);
  border-bottom: 2px solid #ff5e40;
}

.header-user-info {
  display: flex;
  align-items: center;
  gap: 14px;
}

.avatar-circle {
  width: 44px;
  height: 44px;
  background: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.3rem;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
  border: 1px solid #e2e8f0;
}

.header-text h2 {
  font-size: 1.15rem;
  font-weight: 900;
  color: #1e1e24;
  margin: 0;
}

.subtitle {
  font-size: 0.78rem;
  color: #64748b;
  margin: 2px 0 0 0;
  font-weight: 600;
}

.priority-badge {
  font-size: 0.72rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 20px;
  background: white;
  border: 1px solid #e2e8f0;
  text-transform: uppercase;
}

.priority-badge.high { border-color: #ef4444; color: #ef4444; background: #fef2f2; }
.priority-badge.normal { border-color: #f59e0b; color: #f59e0b; background: #fffbeb; }
.priority-badge.low { border-color: #10b981; color: #10b981; background: #ecfdf5; }

/* Messages Log */
.messages-body {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
  background: #fafaf9;
  display: flex;
  flex-direction: column;
  gap: 14px;
  min-height: 320px;
}

.empty-messages {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
  font-size: 0.85rem;
  text-align: center;
}

/* Canned replies selection bar */
.canned-replies-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 24px;
  background: white;
  border-top: 1px solid #e2e8f0;
}

.canned-label {
  font-size: 0.8rem;
  font-weight: 800;
  color: #94a3b8;
  white-space: nowrap;
}

.canned-replies-list {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  white-space: nowrap;
}

.canned-pill {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  color: #475569;
  border-radius: 20px;
  padding: 6px 14px;
  font-size: 0.78rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
}

.canned-pill:hover {
  background: #fff0ed;
  border-color: #ff5e40;
  color: #ff5e40;
}

/* Composer Form */
.composer-form {
  display: flex;
  gap: 14px;
  padding: 16px 24px;
  background: white;
  border-top: 1px solid #e2e8f0;
}

.composer-input {
  flex: 1;
  height: 48px;
  border-radius: 12px;
  border: 1px solid #cbd5e1;
  padding: 0 16px;
  font-size: 0.95rem;
}
.composer-input:focus {
  outline: none;
  border-color: #ff5e40;
}

.send-btn {
  height: 48px;
  padding: 0 24px;
  background: #ff5e40;
  color: white;
  border: none;
  border-radius: 12px;
  font-weight: 900;
  font-size: 0.92rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* Right Panel: Order info */
.order-details-panel {
  padding: 24px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 18px;
  display: flex;
  flex-direction: column;
  gap: 18px;
  height: fit-content;
}

.panel-header {
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 12px;
}

.panel-header h3 {
  font-size: 1.1rem;
  font-weight: 900;
  color: #1e1e24;
  margin: 0;
}

.panel-body {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.order-id-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-id-row strong {
  font-size: 1.15rem;
  font-weight: 900;
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

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.detail-item label {
  font-size: 0.75rem;
  font-weight: 800;
  color: #94a3b8;
  text-transform: uppercase;
}

.value-price {
  font-size: 1.4rem;
  font-weight: 900;
  color: #ff5e40;
}

.value-text {
  font-size: 0.9rem;
  font-weight: 700;
  color: #1e1e24;
  line-height: 1.4;
}

.unassigned {
  color: #ef4444;
}

.panel-actions {
  margin-top: 12px;
}

.resolve-btn {
  width: 100%;
  height: 46px;
  background: #f8fafc;
  border: 1px solid #cbd5e1;
  color: #475569;
  border-radius: 12px;
  font-weight: 900;
  cursor: pointer;
  transition: all 0.2s ease;
}

.resolve-btn:hover {
  background: #ecfdf5;
  border-color: #10b981;
  color: #10b981;
}

.empty-order-details {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 32px 0;
  color: #94a3b8;
  gap: 8px;
}

.alert-icon {
  font-size: 2rem;
}

.empty-order-details p {
  font-size: 0.85rem;
}

/* Loading States */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 0;
  color: #94a3b8;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e2e8f0;
  border-top-color: #ff5e40;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
