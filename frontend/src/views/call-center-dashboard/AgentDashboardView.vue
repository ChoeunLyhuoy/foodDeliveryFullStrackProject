<template>
  <div class="agent-dashboard-view">
    <div class="view-header">
      <div>
        <span class="view-subtitle">Agent Panel</span>
        <h1 class="view-title">Support Ticket Queue</h1>
        <p class="muted">Monitor incoming customer inquiries, dispatch agents, and track ticket urgencies.</p>
      </div>
      <RouterLink to="/call-center-dashboard/lookup">
        <button class="btn-secondary lookup-btn">
          <span>🔍</span> Look Up Order
        </button>
      </RouterLink>
    </div>

    <!-- Active Tickets Queue -->
    <div class="queue-section">
      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <p>Loading active ticket queue...</p>
      </div>
      <div v-else>
        <div class="tickets-list">
          <div v-for="ticket in queue" :key="ticket.id" class="card ticket-card">
            <div class="ticket-info">
              <div class="ticket-header-row">
                <span class="ticket-id-tag">Ticket #{{ ticket.id }}</span>
                <span :class="['priority-badge', ticket.priority?.toLowerCase()]">
                  {{ ticket.priority }} Priority
                </span>
              </div>
              <p class="ticket-details-text">
                Linked to <strong>Order #{{ ticket.orderId }}</strong> · Customer ID #{{ ticket.customerId }}
              </p>
              <span class="ticket-time">⏰ Received: {{ new Date(ticket.createdAt).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) }}</span>
            </div>
            
            <div class="ticket-action">
              <RouterLink :to="`/call-center-dashboard/chat/${ticket.id}`">
                <button class="btn-primary open-chat-btn">
                  <span>Open Chat</span>
                  <span>🎧</span>
                </button>
              </RouterLink>
            </div>
          </div>
        </div>
        
        <div v-if="queue.length === 0" class="empty-queue-card card">
          <span class="empty-emoji">🎉</span>
          <h3>All caught up!</h3>
          <p class="muted">No open support tickets in the queue right now.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getCallCenterQueue } from '../../services/api'

const queue = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    const { data } = await getCallCenterQueue()
    queue.value = data
  } catch (e) {
    console.error('Failed to load call center queue', e)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.agent-dashboard-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
  max-width: 840px;
  margin: 0 auto;
}

.view-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

.lookup-btn {
  padding: var(--space-2) var(--space-4);
  font-size: 0.88rem;
}

/* Queue List */
.tickets-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.ticket-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-4) var(--space-5);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  transition: var(--transition-smooth);
}

.ticket-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.ticket-info {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.ticket-header-row {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.ticket-id-tag {
  font-family: var(--font-display);
  font-weight: 800;
  color: var(--color-ink);
  font-size: 1.05rem;
}

.priority-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: var(--radius-full);
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

.priority-badge.high { background-color: var(--color-error-light); color: var(--color-error); }
.priority-badge.normal { background-color: var(--color-warning-light); color: var(--color-warning); }
.priority-badge.low { background-color: var(--color-success-light); color: var(--color-success); }

.ticket-details-text {
  font-size: 0.9rem;
  color: var(--color-muted);
}

.ticket-details-text strong {
  color: var(--color-ink);
}

.ticket-time {
  font-size: 0.78rem;
  color: var(--color-muted);
  font-weight: 500;
}

.open-chat-btn {
  padding: var(--space-2) var(--space-4);
  font-size: 0.88rem;
}

/* Empty Queue */
.empty-queue-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-12) var(--space-6);
  text-align: center;
  gap: var(--space-3);
  max-width: 440px;
  margin: var(--space-6) auto;
}

.empty-emoji {
  font-size: 3.5rem;
}

/* Loading */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-10) 0;
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

@media (max-width: 768px) {
  .ticket-card {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }
  .ticket-action {
    width: 100%;
  }
  .open-chat-btn {
    width: 100%;
  }
}
</style>
