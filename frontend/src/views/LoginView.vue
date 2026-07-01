<template>
  <div class="login-portal">
    <!-- Animated Glow Orbs -->
    <div class="portal-background">
      <div class="glow-orb orb-1"></div>
      <div class="glow-orb orb-2"></div>
      <div class="glow-orb orb-3"></div>
    </div>

    <div class="portal-container">
      <div class="portal-header">
        <div class="logo-wrapper">
          <span class="logo-emoji">🍔</span>
          <span class="pulse-ring"></span>
        </div>
        <h1 class="portal-title">Food<span class="highlight">Go</span> Enterprise Portal</h1>
        <p class="portal-subtitle">Select your role workspace to sign into the unified cloud platform</p>
      </div>

      <!-- 4 Role Selector Grid -->
      <div class="role-grid">
        <div 
          v-for="role in roles" 
          :key="role.id"
          :class="['role-card', { active: activeRole === role.id }]"
          @click="selectRole(role.id)"
        >
          <div class="role-card-header">
            <span class="role-emoji">{{ role.emoji }}</span>
            <span v-if="activeRole === role.id" class="active-badge">● Active</span>
          </div>
          <div class="role-card-body">
            <h4 class="role-name">{{ role.name }}</h4>
            <span class="role-category">{{ role.category }}</span>
          </div>
        </div>
      </div>

      <!-- Login Form Workspace -->
      <div class="workspace-card">
        <div class="workspace-header">
          <div class="workspace-title-box">
            <span class="workspace-icon">{{ currentRoleObj.emoji }}</span>
            <div>
              <h3>{{ currentRoleObj.title }}</h3>
              <p class="workspace-desc">{{ currentRoleObj.description }}</p>
            </div>
          </div>
          <div class="demo-badge">
            <span class="sparkle">✨</span> 1-Click Demo Ready
          </div>
        </div>

        <!-- Quick Access Feature Pills -->
        <div class="features-bar">
          <span class="feature-label">Capabilities:</span>
          <span v-for="(feat, idx) in currentRoleObj.features" :key="idx" class="feature-pill">
            ✓ {{ feat }}
          </span>
        </div>

        <form @submit.prevent="handleLogin" class="login-form">
          <div class="form-grid">
            <div class="form-group">
              <label>Work Email / Username</label>
              <div class="input-wrapper">
                <span class="input-icon">👤</span>
                <input v-model="email" type="text" required placeholder="Enter credentials..." />
              </div>
            </div>

            <div class="form-group">
              <label>Security Password</label>
              <div class="input-wrapper">
                <span class="input-icon">🔒</span>
                <input v-model="password" :type="showPass ? 'text' : 'password'" required placeholder="Enter password..." />
                <button type="button" class="btn-toggle-pass" @click="showPass = !showPass">
                  {{ showPass ? '👁️' : '👁️‍🗨️' }}
                </button>
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn-reset-demo" @click="selectRole(activeRole)">
              🔄 Reset Demo Account
            </button>
            <button type="submit" class="btn-launch" :disabled="loading">
              <span v-if="loading" class="spinner"></span>
              <span v-else>Launch {{ currentRoleObj.name }} Workspace ➔</span>
            </button>
          </div>
        </form>
      </div>

      <div class="security-footer">
        <span>🛡️ 256-bit Encrypted Session · Connected to Spring Boot API & MySQL · Docker Cloud</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeRole = ref('restaurant')
const email = ref('partner@pizzapalace.com')
const password = ref('restaurant123')
const showPass = ref(false)
const loading = ref(false)

const roles = [
  {
    id: 'restaurant',
    name: 'Restaurant Partner',
    category: 'Kitchen & Orders',
    emoji: '🏪',
    title: 'Restaurant Operations Desk',
    description: 'Manage live kitchen tickets, adjust menu item prices, and monitor prep times.',
    features: ['Live Order Kanban Board', 'Menu Availability Toggle', 'Kitchen Sound Alerts'],
    defaultEmail: 'partner@pizzapalace.com',
    targetRoute: '/restaurant-dashboard'
  },
  {
    id: 'callcenter',
    name: 'Call Center Support',
    category: 'Customer Success',
    emoji: '🎧',
    title: 'Dispatch & Support Hub',
    description: 'Investigate customer inquiries, resolve delayed orders, and message riders.',
    features: ['Real-time Ticket Queue', '3-Way Chat Intervention', 'Priority Escalation'],
    defaultEmail: 'agent@foodgo.support',
    targetRoute: '/call-center-dashboard'
  },
  {
    id: 'delivery',
    name: 'Fleet Ops Control',
    category: 'Logistics Center',
    emoji: '🛵',
    title: 'Rider & Fleet Operations',
    description: 'Track active deliveries, inspect rider telemetry, and view live order maps.',
    features: ['Live Rider Map Lookup', 'Order Dispatch Status', 'Customer Chat Log'],
    defaultEmail: 'fleet@foodgo.ops',
    targetRoute: '/order/1'
  },
  {
    id: 'customer',
    name: 'Customer Web',
    category: 'Online Food Portal',
    emoji: '🍔',
    title: 'Customer Ordering Portal',
    description: 'Explore gourmet restaurants, order pizza & pasta, and track deliveries.',
    features: ['Rich Menu Navigation', 'Instant Cart Checkout', 'Live Status Updates'],
    defaultEmail: 'customer@foodgo.web',
    targetRoute: '/'
  }
]

const currentRoleObj = computed(() => roles.find(r => r.id === activeRole.value))

function selectRole(roleId) {
  activeRole.value = roleId
  const found = roles.find(r => r.id === roleId)
  if (found) {
    email.value = found.defaultEmail
    password.value = roleId + '123'
  }
}

async function handleLogin() {
  loading.value = true
  await new Promise(resolve => setTimeout(resolve, 600))
  
  localStorage.setItem('foodgo_role', activeRole.value)
  localStorage.setItem('foodgo_user', email.value)
  window.dispatchEvent(new Event('role-changed'))

  loading.value = false
  router.push(currentRoleObj.value.targetRoute)
}
</script>

<style scoped>
.login-portal {
  min-height: calc(100vh - 80px);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  padding: var(--space-8) var(--space-4);
  background: #0f1117;
  color: white;
}

.portal-background {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.glow-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  opacity: 0.18;
}

.orb-1 {
  width: 500px;
  height: 500px;
  background: #ff5e40;
  top: -150px;
  left: -100px;
}

.orb-2 {
  width: 450px;
  height: 450px;
  background: #3b82f6;
  bottom: -100px;
  right: -100px;
}

.orb-3 {
  width: 350px;
  height: 350px;
  background: #10b981;
  bottom: 20%;
  left: 30%;
}

.portal-container {
  position: relative;
  z-index: 1;
  max-width: 820px;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.portal-header {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.logo-wrapper {
  position: relative;
  width: 72px;
  height: 72px;
  background: rgba(255, 94, 64, 0.15);
  border: 1px solid rgba(255, 94, 64, 0.4);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: var(--space-3);
  box-shadow: 0 0 25px rgba(255, 94, 64, 0.3);
}

.logo-emoji {
  font-size: 2.2rem;
}

.portal-title {
  font-family: var(--font-display);
  font-size: 2.4rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  margin-bottom: var(--space-1);
}

.highlight {
  color: #ff5e40;
}

.portal-subtitle {
  color: #94a3b8;
  font-size: 1.05rem;
}

/* Role Grid */
.role-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: var(--space-4);
}

.role-card {
  background: rgba(30, 41, 59, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 18px;
  padding: var(--space-4);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.role-card:hover {
  background: rgba(51, 65, 85, 0.8);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-4px);
}

.role-card.active {
  background: linear-gradient(135deg, rgba(255, 94, 64, 0.2), rgba(30, 41, 59, 0.9));
  border-color: #ff5e40;
  box-shadow: 0 10px 25px rgba(255, 94, 64, 0.25);
}

.role-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.role-card .role-emoji {
  font-size: 1.8rem;
}

.active-badge {
  background: #ff5e40;
  color: white;
  font-size: 0.7rem;
  font-weight: 800;
  padding: 3px 8px;
  border-radius: 20px;
  letter-spacing: 0.05em;
  text-transform: uppercase;
}

.role-name {
  font-size: 1.05rem;
  font-weight: 800;
  color: white;
}

.role-category {
  font-size: 0.8rem;
  color: #94a3b8;
}

/* Workspace Card */
.workspace-card {
  background: rgba(30, 41, 59, 0.85);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 24px;
  padding: var(--space-6);
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.workspace-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: var(--space-4);
  padding-bottom: var(--space-4);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.workspace-title-box {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}

.workspace-icon {
  font-size: 2.5rem;
  background: rgba(255, 255, 255, 0.05);
  width: 60px;
  height: 60px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.workspace-title-box h3 {
  font-size: 1.3rem;
  font-weight: 800;
}

.workspace-desc {
  font-size: 0.9rem;
  color: #94a3b8;
  margin-top: 2px;
}

.demo-badge {
  background: rgba(16, 185, 129, 0.15);
  color: #34d399;
  border: 1px solid rgba(16, 185, 129, 0.3);
  font-size: 0.8rem;
  font-weight: 700;
  padding: 6px 12px;
  border-radius: 20px;
  white-space: nowrap;
}

.features-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--space-2);
  background: rgba(15, 23, 42, 0.6);
  padding: 10px 14px;
  border-radius: 14px;
}

.feature-label {
  font-size: 0.8rem;
  font-weight: 700;
  color: #cbd5e1;
}

.feature-pill {
  background: rgba(255, 255, 255, 0.08);
  color: #e2e8f0;
  font-size: 0.78rem;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 12px;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

@media (max-width: 640px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 0.85rem;
  font-weight: 700;
  color: #e2e8f0;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 14px;
  font-size: 1.1rem;
}

.input-wrapper input {
  width: 100%;
  padding: 13px 14px 13px 44px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(15, 23, 42, 0.8);
  color: white;
  font-size: 0.95rem;
  transition: all 0.2s ease;
}

.input-wrapper input:focus {
  outline: none;
  border-color: #ff5e40;
  box-shadow: 0 0 0 3px rgba(255, 94, 64, 0.2);
}

.btn-toggle-pass {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  font-size: 1.1rem;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--space-4);
  padding-top: var(--space-2);
}

.btn-reset-demo {
  background: rgba(255, 255, 255, 0.08);
  color: #cbd5e1;
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 12px 18px;
  border-radius: 14px;
  font-weight: 700;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-reset-demo:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
}

.btn-launch {
  flex: 1;
  background: linear-gradient(135deg, #ff5e40, #ff8c61);
  color: white;
  border: none;
  padding: 14px 24px;
  border-radius: 14px;
  font-weight: 800;
  font-size: 1.05rem;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 6px 20px rgba(255, 94, 64, 0.35);
  display: flex;
  justify-content: center;
  align-items: center;
}

.btn-launch:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(255, 94, 64, 0.5);
}

.btn-launch:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.spinner {
  width: 20px;
  height: 20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.security-footer {
  text-align: center;
  font-size: 0.8rem;
  color: #64748b;
}
</style>
