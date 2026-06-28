<template>
  <div :class="['bubble-wrapper', isMine ? 'mine' : 'theirs']">
    <!-- Sender initials icon for incoming messages -->
    <div class="sender-avatar" v-if="!isMine">
      {{ getInitials(message.senderRole) }}
    </div>

    <div class="bubble-container">
      <span class="sender-name" v-if="!isMine">{{ getRoleLabel(message.senderRole) }}</span>
      <div class="bubble">
        <p class="text">{{ message.message }}</p>
        <span class="time">{{ formattedTime }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  message: { type: Object, required: true },
  currentUserId: { type: [Number, String], required: true }
})

const isMine = computed(() => {
  return Number(props.message.senderId) === Number(props.currentUserId)
})

const formattedTime = computed(() => {
  if (!props.message.createdAt) return ''
  return new Date(props.message.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
})

function getInitials(role) {
  if (role === 'RIDER') return '🏍️'
  if (role === 'CALL_CENTER_AGENT') return '🎧'
  return '👤'
}

function getRoleLabel(role) {
  if (role === 'RIDER') return 'Rider'
  if (role === 'CALL_CENTER_AGENT') return 'Support Agent'
  return 'Customer'
}
</script>

<style scoped>
.bubble-wrapper {
  display: flex;
  gap: var(--space-3);
  margin-bottom: var(--space-4);
  max-width: 85%;
}

.bubble-wrapper.mine {
  margin-left: auto;
  justify-content: flex-end;
}

.bubble-wrapper.theirs {
  margin-right: auto;
  justify-content: flex-start;
}

/* Avatars */
.sender-avatar {
  width: 36px;
  height: 36px;
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.1rem;
  flex-shrink: 0;
  box-shadow: var(--shadow-sm);
  margin-top: 18px; /* Offset for the name label */
}

.bubble-container {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.sender-name {
  font-size: 0.72rem;
  font-weight: 700;
  color: var(--color-muted);
  padding-left: var(--space-1);
}

.bubble {
  padding: var(--space-3) var(--space-4);
  box-shadow: var(--shadow-sm);
  position: relative;
  line-height: 1.4;
  font-size: 0.92rem;
}

/* Message styling: theirs */
.theirs .bubble {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  color: var(--color-ink);
  border-radius: 0px var(--radius-md) var(--radius-md) var(--radius-md);
}

/* Message styling: mine */
.mine .bubble {
  background: var(--color-primary);
  color: white;
  border-radius: var(--radius-md) var(--radius-md) 0px var(--radius-md);
  box-shadow: 0 4px 12px rgba(255, 94, 64, 0.15);
}

.text {
  margin: 0;
  word-break: break-word;
}

.time {
  font-size: 0.65rem;
  opacity: 0.75;
  display: block;
  text-align: right;
  margin-top: var(--space-1);
  font-weight: 500;
}

.mine .time {
  color: rgba(255, 255, 255, 0.85);
}
</style>
