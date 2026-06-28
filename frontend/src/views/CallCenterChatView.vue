<template>
  <div class="chat-container-page">
    <div class="card chat-screen-card">
      <header class="chat-header support-theme">
        <div class="header-user-info">
          <div class="avatar-circle">🎧</div>
          <div class="header-text">
            <h2>Support Live Chat</h2>
            <p class="subtitle">Order #{{ orderId }} · Contacting call center</p>
          </div>
        </div>
        <div class="status-indicator">
          <span class="pulse-dot"></span>
          <span>Agents Online</span>
        </div>
      </header>

      <!-- Message History -->
      <div class="messages-body" ref="messagesContainer">
        <div v-if="messages.length === 0" class="empty-chat-info">
          <span class="chat-bubble-emoji">🆘</span>
          <p>Connecting you to the support agent queue. Please describe your issue in detail below.</p>
        </div>
        <ChatBubble 
          v-for="m in messages" 
          :key="m.id" 
          :message="m" 
          :currentUserId="auth.currentUser.id" 
        />
      </div>

      <!-- Composer Input -->
      <form class="composer-form" @submit.prevent="send">
        <input 
          v-model="draft" 
          placeholder="Describe your issue to our agents..." 
          class="composer-input"
          required 
        />
        <button class="btn-primary send-btn support-color" type="submit">
          <span>Send</span>
          <span class="send-icon">🚀</span>
        </button>
      </form>

      <!-- Fallback Direct Line -->
      <div class="fallback-call-banner">
        <span>Urgent? Call customer support hotline directly at</span>
        <a href="tel:+85512345678" class="hotline-link">📞 +855 12 345 678</a>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { useRoute } from 'vue-router'
import ChatBubble from '../components/ChatBubble.vue'
import { getCallCenterChatHistory } from '../services/api'
import { subscribeToChat, sendChatMessage } from '../services/socket'
import { useAuthStore } from '../store/auth'

const route = useRoute()
const orderId = route.params.id
const auth = useAuthStore()
const messages = ref([])
const draft = ref('')
const messagesContainer = ref(null)

onMounted(async () => {
  try {
    const { data } = await getCallCenterChatHistory(orderId)
    messages.value = data
    scrollToBottom()
    
    // Subscribe to support channel topic
    subscribeToChat(orderId, 'callcenter', (msg) => {
      messages.value.push(msg)
      scrollToBottom()
    })
  } catch (e) {
    console.error('Failed to load support chat history', e)
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

function send() {
  if (!draft.value || !draft.value.trim()) return
  sendChatMessage(orderId, 'callcenter', {
    senderId: auth.currentUser.id,
    senderRole: 'CUSTOMER',
    message: draft.value.trim()
  })
  draft.value = ''
}
</script>

<style scoped>
.chat-container-page {
  max-width: 680px;
  margin: 0 auto;
  height: calc(100vh - 140px);
  min-height: 520px;
  display: flex;
  flex-direction: column;
}

.chat-screen-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  border-radius: var(--radius-xl);
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
  width: 44px;
  height: 44px;
  background: white;
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-border);
}

.header-text h2 {
  font-size: 1.2rem;
  font-weight: 800;
  margin: 0;
}

.subtitle {
  font-size: 0.78rem;
  color: var(--color-muted);
  font-weight: 500;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  background: white;
  padding: 4px 10px;
  border-radius: var(--radius-full);
  border: 1px solid var(--color-border);
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--color-accent);
}

.pulse-dot {
  width: 8px;
  height: 8px;
  background: var(--color-accent);
  border-radius: 50%;
  animation: pulse 1.6s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.3); opacity: 0.5; }
  100% { transform: scale(1); opacity: 1; }
}

/* Chat History Area */
.messages-body {
  flex: 1;
  overflow-y: auto;
  padding: var(--space-5);
  background: #faf9f6;
  display: flex;
  flex-direction: column;
}

.empty-chat-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  gap: var(--space-3);
  color: var(--color-muted);
  max-width: 380px;
  margin: auto;
}

.chat-bubble-emoji {
  font-size: 3rem;
  opacity: 0.6;
}

.empty-chat-info p {
  font-size: 0.88rem;
  line-height: 1.5;
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

.send-btn.support-color {
  background: var(--color-accent);
  box-shadow: 0 4px 14px rgba(245, 166, 35, 0.2);
}

.send-btn.support-color:hover {
  background: #d9911c;
  box-shadow: 0 6px 20px rgba(245, 166, 35, 0.3);
}

/* Hotline banner */
.fallback-call-banner {
  background: var(--color-bg);
  border-top: 1px solid var(--color-border);
  padding: var(--space-3) var(--space-5);
  display: flex;
  justify-content: center;
  align-items: center;
  gap: var(--space-2);
  font-size: 0.82rem;
  color: var(--color-muted);
  font-weight: 600;
  flex-wrap: wrap;
}

.hotline-link {
  color: var(--color-primary);
  font-weight: 700;
}
</style>
