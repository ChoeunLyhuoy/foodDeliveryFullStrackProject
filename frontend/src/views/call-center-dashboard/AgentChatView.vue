<template>
  <div class="agent-chat-view-container">
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
const agentId = 4 // Demo Cara Agent from seed.sql

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
    const ticketRes = await getCallCenterTicket(ticketId)
    ticket.value = ticketRes.data
    
    const linkedOrderId = ticket.value.orderId
    
    // 2. Fetch Chat History
    const chatRes = await getCallCenterChatHistory(linkedOrderId)
    messages.value = chatRes.data
    scrollToBottom()

    // 3. Subscribe to Socket Chat
    subscribeToChat(linkedOrderId, 'callcenter', (msg) => {
      messages.value.push(msg)
      scrollToBottom()
    })

    // 4. Fetch Linked Order if exists
    if (linkedOrderId) {
      loadingOrder.value = true
      try {
        const orderRes = await getOrder(linkedOrderId)
        order.value = orderRes.data
      } catch (err) {
        console.warn('Could not load order details', err)
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
  draft.value = ''
}

async function resolve() {
  try {
    await resolveTicket(ticketId)
    router.push('/call-center-dashboard')
  } catch (e) {
    console.error('Failed to resolve ticket', e)
  }
}

function formatStatus(status) {
  return status.replaceAll('_', ' ').toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase())
}
</script>

<style scoped>
.agent-chat-view-container {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  height: calc(100vh - 120px);
  min-height: 550px;
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

/* Chat Layout Grid */
.agent-chat-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: var(--space-6);
  flex: 1;
  height: calc(100% - var(--space-8));
}

.chat-panel-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  border-radius: var(--radius-lg);
  overflow: hidden;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
}

.chat-header {
  padding: var(--space-4) var(--space-5);
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--color-border);
}

.chat-header.support-theme {
  background: linear-gradient(135deg, var(--color-accent-light) 0%, transparent 100%);
  border-bottom: 2px solid var(--color-accent);
}

.header-user-info {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.avatar-circle {
  width: 40px;
  height: 40px;
  background: white;
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-border);
}

.header-text h2 {
  font-size: 1.15rem;
  font-weight: 800;
  margin: 0;
}

.subtitle {
  font-size: 0.76rem;
  color: var(--color-muted);
  font-weight: 500;
}

.priority-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: var(--radius-full);
  background: white;
  border: 1px solid var(--color-border);
  text-transform: uppercase;
}

.priority-badge.high { border-color: var(--color-error); color: var(--color-error); background: var(--color-error-light); }
.priority-badge.normal { border-color: var(--color-warning); color: var(--color-warning); background: var(--color-warning-light); }
.priority-badge.low { border-color: var(--color-success); color: var(--color-success); background: var(--color-success-light); }

/* Messages Log */
.messages-body {
  flex: 1;
  overflow-y: auto;
  padding: var(--space-5);
  background: #faf9f6;
  display: flex;
  flex-direction: column;
}

/* Canned replies selection bar */
.canned-replies-bar {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-5);
  background: var(--color-surface);
  border-top: 1px solid var(--color-border);
  overflow-x: auto;
}

.canned-label {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-muted);
  white-space: nowrap;
}

.canned-replies-list {
  display: flex;
  gap: var(--space-2);
  overflow-x: auto;
  white-space: nowrap;
}

.canned-pill {
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  color: var(--color-ink);
  border-radius: var(--radius-full);
  padding: var(--space-2) var(--space-4);
  font-size: 0.78rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-smooth);
}

.canned-pill:hover {
  background: var(--color-accent-light);
  border-color: var(--color-accent);
  color: var(--color-accent);
}

/* Composer Form */
.composer-form {
  display: flex;
  gap: var(--space-3);
  padding: var(--space-4) var(--space-5);
  background: var(--color-surface);
  border-top: 1px solid var(--color-border);
}

.composer-input {
  flex: 1;
  height: 48px;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
}

.send-btn {
  height: 48px;
  padding: 0 var(--space-5);
  box-shadow: none;
}

/* Right Panel: Order info */
.order-details-panel {
  padding: var(--space-5);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  height: fit-content;
}

.panel-header {
  border-bottom: 1px solid var(--color-border);
  padding-bottom: var(--space-3);
}

.panel-header h3 {
  font-size: 1.15rem;
  font-weight: 700;
}

.panel-body {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.order-id-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-id-row strong {
  font-size: 1.1rem;
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

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.detail-item label {
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--color-muted);
  text-transform: uppercase;
}

.value-price {
  font-size: 1.3rem;
  font-weight: 800;
  color: var(--color-primary);
}

.value-text {
  font-size: 0.92rem;
  font-weight: 600;
  color: var(--color-ink);
  line-height: 1.4;
}

.unassigned {
  color: var(--color-error);
}

.panel-actions {
  margin-top: var(--space-4);
}

.resolve-btn {
  width: 100%;
  height: 46px;
  background: var(--color-bg);
  border-color: var(--color-border);
  color: var(--color-ink);
}

.resolve-btn:hover {
  background: var(--color-success-light);
  border-color: var(--color-success);
  color: var(--color-success);
}

.empty-order-details {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: var(--space-8) 0;
  color: var(--color-muted);
  gap: var(--space-2);
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
  flex: 1;
  gap: var(--space-3);
}

.spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: var(--radius-full);
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 992px) {
  .agent-chat-grid {
    grid-template-columns: 1fr;
  }
  .order-details-panel {
    position: static;
  }
}
</style>
