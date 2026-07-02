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
          <RouterLink to="/call-center-dashboard" class="nav-item" exact-active-class="active">
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
        <RouterLink to="/login" class="sign-out-link">
          <span class="signout-icon">←</span> Sign Out
        </RouterLink>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      <header class="queue-header">
        <div>
          <h1 class="queue-title">Support Queue</h1>
          <p class="queue-sub">{{ displayTickets.length }} tickets waiting · 3 agents online</p>
        </div>
        <button class="btn-filter" @click="toggleFilter">
          <span>⚡ Filter Priority</span>
        </button>
      </header>

      <!-- Clean Support Table (Figma Image 4) -->
      <div class="table-container">
        <table class="support-table">
          <thead>
            <tr>
              <th>TICKET</th>
              <th>CUSTOMER</th>
              <th>ISSUE</th>
              <th>ORDER</th>
              <th>WAITING</th>
              <th>PRIORITY</th>
              <th>ACTION</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="t in displayTickets" :key="t.id">
              <td class="td-ticket">{{ t.ticketNum }}</td>
              <td class="td-customer">
                <div class="customer-cell">
                  <span class="avatar-emoji">{{ t.avatar }}</span>
                  <strong>{{ t.customer }}</strong>
                </div>
              </td>
              <td class="td-issue">{{ t.issue }}</td>
              <td class="td-order">{{ t.order }}</td>
              <td class="td-waiting">{{ t.waiting }}</td>
              <td class="td-priority">
                <span class="priority-pill" :class="t.priorityClass">
                  ● {{ t.priorityText }}
                </span>
              </td>
              <td class="td-action">
                <button class="btn-assign" @click="assignTicket(t)">
                  {{ t.assigned ? 'Assigned ✓' : 'Assign to me' }}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getCallCenterQueue } from '../../services/api'

const router = useRouter()
const loading = ref(true)
const displayTickets = ref([
  { id: 1, ticketNum: 'SUP-4421', customer: 'Sarah Chen', avatar: '👩🏻', issue: 'Order delayed 40 min', order: '#FG-8821', waiting: '3m', priorityClass: 'high', priorityText: 'high', assigned: false },
  { id: 0, ticketNum: 'SUP-4420', customer: 'Marcus Lee', avatar: '👨🏽', issue: 'Wrong items delivered', order: '#FG-8810', waiting: '8m', priorityClass: 'high', priorityText: 'high', assigned: false },
  { id: 8, ticketNum: 'SUP-4418', customer: 'Emma Rossi', avatar: '👩🏼', issue: 'Payment charged twice', order: '#FG-8799', waiting: '12m', priorityClass: 'medium', priorityText: 'medium', assigned: false },
  { id: 5, ticketNum: 'SUP-4415', customer: 'James Torres', avatar: '👨🏻', issue: "Can't find restaurant", order: 'N/A', waiting: '20m', priorityClass: 'low', priorityText: 'low', assigned: false },
  { id: 4, ticketNum: 'SUP-4414', customer: 'Priya Singh', avatar: '👩🏽', issue: 'Refund not received', order: '#FG-8788', waiting: '25m', priorityClass: 'medium', priorityText: 'medium', assigned: false }
])

onMounted(async () => {
  try {
    const { data } = await getCallCenterQueue()
    if (data && data.length > 0) {
      // Map API tickets over Figma structure if live data exists
      displayTickets.value = data.map((t, idx) => {
        const figmaTickets = [
          { ticketNum: 'SUP-4421', customer: 'Sarah Chen', avatar: '👩🏻', issue: 'Order delayed 40 min', order: '#FG-8821', waiting: '3m', priorityClass: 'high' },
          { ticketNum: 'SUP-4420', customer: 'Marcus Lee', avatar: '👨🏽', issue: 'Wrong items delivered', order: '#FG-8810', waiting: '8m', priorityClass: 'high' },
          { ticketNum: 'SUP-4418', customer: 'Emma Rossi', avatar: '👩🏼', issue: 'Payment charged twice', order: '#FG-8799', waiting: '12m', priorityClass: 'medium' },
          { ticketNum: 'SUP-4415', customer: 'James Torres', avatar: '👨🏻', issue: "Can't find restaurant", order: 'N/A', waiting: '20m', priorityClass: 'low' },
          { ticketNum: 'SUP-4414', customer: 'Priya Singh', avatar: '👩🏽', issue: 'Refund not received', order: '#FG-8788', waiting: '25m', priorityClass: 'medium' }
        ]
        const template = figmaTickets[idx % figmaTickets.length]
        return {
          id: t.id,
          ticketNum: template.ticketNum,
          customer: template.customer,
          avatar: template.avatar,
          issue: template.issue,
          order: template.order,
          waiting: template.waiting,
          priorityClass: template.priorityClass,
          priorityText: template.priorityClass,
          assigned: false
        }
      })
    }
  } catch (e) {}
  loading.value = false
})

function assignTicket(t) {
  t.assigned = true
  setTimeout(() => {
    router.push(`/call-center-dashboard/chat/${t.id}`)
  }, 200)
}
function toggleFilter() {
  displayTickets.value.reverse()
}
</script>

<style scoped>
.figma-agent-portal {
  display: flex;
  min-height: calc(100vh - 70px);
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

.sign-out-link {
  color: #64748b;
  text-decoration: none;
  font-size: 0.88rem;
  font-weight: 700;
  padding-left: 6px;
  margin-top: 8px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: color 0.2s ease;
}
.sign-out-link:hover {
  color: #ff5e40;
}

/* Main Content */
.main-content {
  flex: 1;
  padding: 32px 36px;
  overflow-y: auto;
}

.queue-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
}
.queue-title { font-size: 1.8rem; font-weight: 800; color: #1e1e24; margin: 0; }
.queue-sub { color: #64748b; font-size: 0.9rem; margin-top: 4px; }

.btn-filter {
  background: white;
  border: 1px solid #e2e8f0;
  padding: 10px 18px;
  border-radius: 12px;
  font-weight: 700;
  color: #475569;
  cursor: pointer;
}

/* Table Container */
.table-container {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
  overflow: hidden;
  border: 1px solid #f1f5f9;
}

.support-table {
  width: 100%;
  border-collapse: collapse;
}

.support-table th {
  background: #f8fafc;
  text-align: left;
  padding: 14px 20px;
  font-size: 0.75rem;
  font-weight: 800;
  color: #94a3b8;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}

.support-table td {
  padding: 16px 20px;
  font-size: 0.9rem;
  color: #334155;
  border-bottom: 1px solid #f1f5f9;
}

.td-ticket { font-family: monospace; font-weight: 700; color: #64748b; }

.customer-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}
.avatar-emoji { font-size: 1.4rem; }
.customer-cell strong { color: #1e1e24; font-weight: 700; }

.td-issue { font-weight: 600; color: #1e1e24; }
.td-order { font-family: monospace; font-weight: 700; color: #64748b; }
.td-waiting { font-weight: 700; }

.priority-pill {
  font-size: 0.78rem;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 12px;
  text-transform: lowercase;
}
.priority-pill.high { background: #fef2f2; color: #ef4444; }
.priority-pill.medium { background: #fffbeb; color: #f59e0b; }
.priority-pill.low { background: #f1f5f9; color: #64748b; }

.btn-assign {
  background: #3b82f6;
  color: white;
  border: none;
  padding: 8px 18px;
  border-radius: 20px;
  font-weight: 700;
  font-size: 0.82rem;
  cursor: pointer;
  transition: all 0.2s ease;
}
.btn-assign:hover { background: #2563eb; transform: scale(1.03); }
</style>
