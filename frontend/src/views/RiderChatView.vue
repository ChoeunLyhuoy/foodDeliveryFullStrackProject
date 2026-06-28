<template>
  <div class="chat-container-page">
    <div class="card chat-screen-card">
      <header class="chat-header rider-theme">
        <div class="header-user-info">
          <div class="avatar-circle">🏍️</div>
          <div class="header-text">
            <h2>Chat with Rider</h2>
            <p class="subtitle">Order #{{ orderId }} · Live conversation</p>
          </div>
        </div>
        <div class="status-indicator">
          <span class="pulse-dot"></span>
          <span>Online</span>
        </div>
      </header>

      <!-- Message History -->
      <div class="messages-body" ref="messagesContainer">
        <div v-if="messages.length === 0" class="empty-chat-info">
          <span class="chat-bubble-emoji">💬</span>
          <p>No messages yet. Send a message or a quick reply below to coordinate your delivery!</p>
        </div>
        <ChatBubble 
          v-for="m in messages" 
          :key="m.id" 
          :message="m" 
          :currentUserId="auth.currentUser.id" 
        />
      </div>

      <!-- Quick Replies -->
      <div class="quick-replies-container">
        <button 
          v-for="q in quickReplies" 
          :key="q" 
          class="quick-reply-pill"
          @click="send(q)"
        >
          {{ q }}
        </button>
      </div>

      <!-- Message Input Composer -->
      <form class="composer-form" @submit.prevent="send(draft)">
        <input 
          v-model="draft" 
          placeholder="Type your message to rider..." 
          class="composer-input"
          required 
        />
        <button class="btn-primary send-btn" type="submit">
          <span>Send</span>
          <span class="send-icon">🚀</span>
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { useRoute } from 'vue-router'
import ChatBubble from '../components/ChatBubble.vue'
import { getRiderChatHistory } from '../services/api'
import { subscribeToChat, sendChatMessage } from '../services/socket'
import { useAuthStore } from '../store/auth'

const route = useRoute()
const orderId = route.params.id
const auth = useAuthStore()
const messages = ref([])
const draft = ref('')
const messagesContainer = ref(null)
const quickReplies = ["I'm at the door", 'On my way down', 'Thank you so much!', 'Please leave it at reception']

onMounted(async () => {
  try {
    const { data } = await getRiderChatHistory(orderId)
    messages.value = data
    scrollToBottom()
    
    subscribeToChat(orderId, 'rider', (msg) => {
      messages.value.push(msg)
      scrollToBottom()
    })
  } catch (e) {
    console.error('Failed to load chat history', e)
  }
})

// Auto-scroll when messages change
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
  if (!text || !text.trim()) return
  sendChatMessage(orderId, 'rider', {
    senderId: auth.currentUser.id,
    senderRole: 'CUSTOMER',
    message: text.trim()
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

.chat-header.rider-theme {
  background: linear-gradient(135deg, var(--color-primary-light) 0%, transparent 100%);
  border-bottom: 2px solid var(--color-primary);
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
  color: var(--color-success);
}

.pulse-dot {
  width: 8px;
  height: 8px;
  background: var(--color-success);
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

/* Quick Replies */
.quick-replies-container {
  display: flex;
  gap: var(--space-2);
  padding: var(--space-3) var(--space-5);
  background: var(--color-surface);
  border-top: 1px solid var(--color-border);
  overflow-x: auto;
  white-space: nowrap;
}

.quick-reply-pill {
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  color: var(--color-ink);
  border-radius: var(--radius-full);
  padding: var(--space-2) var(--space-4);
  font-size: 0.82rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-smooth);
}

.quick-reply-pill:hover {
  background: var(--color-primary-light);
  border-color: var(--color-primary);
  color: var(--color-primary);
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
</style>
