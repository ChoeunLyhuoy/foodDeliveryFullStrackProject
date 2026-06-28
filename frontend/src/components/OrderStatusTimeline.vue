<template>
  <div class="timeline-container">
    <!-- Connecting Line -->
    <div class="timeline-line">
      <div 
        class="timeline-line-progress" 
        :style="{ width: progressPercentage + '%' }"
      ></div>
    </div>

    <!-- Timeline Steps -->
    <div class="timeline">
      <div
        v-for="(step, i) in steps"
        :key="step"
        :class="['step', { done: i <= currentIndex, active: i === currentIndex }]"
      >
        <span class="dot-wrapper">
          <span class="dot"></span>
          <span class="pulse-dot" v-if="i === currentIndex"></span>
        </span>
        <span class="label">{{ formatLabel(step) }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  status: { type: String, required: true }
})

const steps = ['PLACED', 'CONFIRMED', 'PREPARING', 'PICKED_UP', 'ON_THE_WAY', 'DELIVERED']
const currentIndex = computed(() => {
  const idx = steps.indexOf(props.status)
  // If cancelled or anything else, just show Placed
  return idx === -1 ? 0 : idx
})

const progressPercentage = computed(() => {
  if (currentIndex.value <= 0) return 0
  return (currentIndex.value / (steps.length - 1)) * 100
})

function formatLabel(step) {
  return step.replaceAll('_', ' ').toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase())
}
</script>

<style scoped>
.timeline-container {
  position: relative;
  width: 100%;
  padding: var(--space-4) 0;
}

/* Horizontal line behind dots */
.timeline-line {
  position: absolute;
  top: calc(var(--space-4) + 12px); /* Centered with the 16px dots */
  left: calc(100% / 12);
  right: calc(100% / 12);
  height: 4px;
  background-color: var(--color-border);
  border-radius: var(--radius-full);
  z-index: 1;
}

.timeline-line-progress {
  height: 100%;
  background-color: var(--color-primary);
  border-radius: var(--radius-full);
  transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.timeline {
  display: flex;
  justify-content: space-between;
  position: relative;
  z-index: 2;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.dot-wrapper {
  position: relative;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: var(--space-3);
}

.dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: var(--color-surface);
  border: 3px solid var(--color-border);
  transition: var(--transition-smooth);
}

.step.done .dot {
  background: var(--color-primary);
  border-color: var(--color-primary);
  transform: scale(1.15);
}

.step.active .dot {
  background: var(--color-surface);
  border-color: var(--color-primary);
  border-width: 4px;
  transform: scale(1.25);
  box-shadow: 0 0 0 4px var(--color-primary-light);
}

/* Pulse animation for active step */
.pulse-dot {
  position: absolute;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--color-primary);
  opacity: 0.2;
  animation: pulse 1.6s cubic-bezier(0.4, 0, 0.2, 1) infinite;
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 0.25; }
  100% { transform: scale(1.8); opacity: 0; }
}

.label {
  font-size: 0.72rem;
  font-weight: 600;
  color: var(--color-muted);
  text-align: center;
  transition: var(--transition-smooth);
  max-width: 80px;
}

.step.done .label {
  color: var(--color-ink);
  font-weight: 700;
}

.step.active .label {
  color: var(--color-primary);
  font-weight: 800;
}

@media (max-width: 576px) {
  .label {
    font-size: 0.6rem;
    max-width: 60px;
  }
}
</style>
