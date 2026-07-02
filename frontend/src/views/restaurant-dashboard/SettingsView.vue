<template>
  <div class="figma-portal-container">
    <!-- Dark Left Sidebar (Figma Image 3 Exact Layout) -->
    <aside class="dark-sidebar">
      <div class="sidebar-top">
        <div class="brand-box">
          <span class="brand-emoji">🍔</span>
          <div>
            <strong class="brand-name">Burgersmith</strong>
            <span class="online-pill">● Online</span>
          </div>
        </div>

        <nav class="sidebar-nav">
          <RouterLink to="/restaurant-dashboard/orders" class="nav-item">
            <span class="nav-icon">▤</span> Order Board
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/menu" class="nav-item">
            <span class="nav-icon">🍴</span> Menu Catalog
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/reviews" class="nav-item">
            <span class="nav-icon">👍</span> Reviews
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/settings" class="nav-item active">
            <span class="nav-icon">⚙️</span> Settings
          </RouterLink>
        </nav>
      </div>

      <div class="sidebar-bottom">
        <div class="revenue-card">
          <span class="rev-label">Today's Revenue</span>
          <strong class="rev-val">$2,841</strong>
          <span class="rev-growth">↑ 12% vs yesterday</span>
        </div>
        <RouterLink to="/login" class="sign-out-link">
          <span class="signout-icon">←</span> Sign Out
        </RouterLink>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      <header class="board-header">
        <div>
          <h1 class="board-title">Store Settings</h1>
        </div>
      </header>

      <div class="settings-form">
        <!-- Store Profile Card (Figma Screenshot 4) -->
        <div class="settings-card">
          <div class="settings-row">
            <span class="row-label">Cuisine Type</span>
            <div class="row-value-group">
              <span class="row-val">{{ cuisine }}</span>
              <button class="btn-edit" @click="editField('Cuisine Type', cuisine)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Address</span>
            <div class="row-value-group">
              <span class="row-val">{{ address }}</span>
              <button class="btn-edit" @click="editField('Address', address)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Phone</span>
            <div class="row-value-group">
              <span class="row-val">{{ phone }}</span>
              <button class="btn-edit" @click="editField('Phone', phone)">Edit</button>
            </div>
          </div>
        </div>

        <!-- Operating Hours Card (Figma Screenshot 4) -->
        <div class="settings-card card-titled">
          <h3 class="card-section-title">Operating Hours</h3>
          <div class="settings-row">
            <span class="row-label">Monday - Friday</span>
            <div class="row-value-group">
              <span class="row-val">{{ hours.monFri }}</span>
              <button class="btn-edit" @click="editField('Monday - Friday Hours', hours.monFri)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Saturday</span>
            <div class="row-value-group">
              <span class="row-val">{{ hours.sat }}</span>
              <button class="btn-edit" @click="editField('Saturday Hours', hours.sat)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Sunday</span>
            <div class="row-value-group">
              <span class="row-val">{{ hours.sun }}</span>
              <button class="btn-edit" @click="editField('Sunday Hours', hours.sun)">Edit</button>
            </div>
          </div>
        </div>

        <!-- Delivery Settings Card (Figma Screenshot 4) -->
        <div class="settings-card card-titled">
          <h3 class="card-section-title">Delivery Settings</h3>
          <div class="settings-row">
            <span class="row-label">Delivery Radius</span>
            <div class="row-value-group">
              <span class="row-val">{{ radius }}</span>
              <button class="btn-edit" @click="editField('Delivery Radius', radius)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Minimum Order</span>
            <div class="row-value-group">
              <span class="row-val">${{ minOrder.toFixed(2) }}</span>
              <button class="btn-edit" @click="editField('Minimum Order', minOrder)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Delivery Fee</span>
            <div class="row-value-group">
              <span class="row-val">${{ deliveryFee.toFixed(2) }}</span>
              <button class="btn-edit" @click="editField('Delivery Fee', deliveryFee)">Edit</button>
            </div>
          </div>
          <div class="settings-row">
            <span class="row-label">Estimated Prep Time</span>
            <div class="row-value-group">
              <span class="row-val">{{ prepTime }}</span>
              <button class="btn-edit" @click="editField('Estimated Prep Time', prepTime)">Edit</button>
            </div>
          </div>
        </div>

        <!-- Save Button (Figma Screenshot 4) -->
        <div class="action-footer">
          <button class="btn-save-changes" @click="saveChanges">
            Save Changes
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const cuisine = ref('American · Burgers')
const address = ref('456 Food Street, District 1')
const phone = ref('+1(555) 234-5678')

const hours = ref({
  monFri: '10:00 AM - 10:00 PM',
  sat: '10:00 AM - 11:00 PM',
  sun: '11:00 AM - 9:00 PM'
})

const radius = ref('5 km')
const minOrder = ref(10.00)
const deliveryFee = ref(2.99)
const prepTime = ref('15-25 min')

function editField(fieldName, currentValue) {
  const newVal = prompt(`Edit ${fieldName}:`, currentValue)
  if (newVal !== null && newVal !== '') {
    if (fieldName === 'Cuisine Type') cuisine.value = newVal
    else if (fieldName === 'Address') address.value = newVal
    else if (fieldName === 'Phone') phone.value = newVal
    else if (fieldName === 'Monday - Friday Hours') hours.value.monFri = newVal
    else if (fieldName === 'Saturday Hours') hours.value.sat = newVal
    else if (fieldName === 'Sunday Hours') hours.value.sun = newVal
    else if (fieldName === 'Delivery Radius') radius.value = newVal
    else if (fieldName === 'Estimated Prep Time') prepTime.value = newVal
    else if (fieldName === 'Minimum Order') minOrder.value = parseFloat(newVal) || minOrder.value
    else if (fieldName === 'Delivery Fee') deliveryFee.value = parseFloat(newVal) || deliveryFee.value
  }
}

function saveChanges() {
  alert('All store settings saved successfully!')
}
</script>

<style scoped>
.figma-portal-container {
  display: flex;
  height: 100vh;
  background: #f8f9fa;
}

/* Dark Sidebar */
.dark-sidebar {
  width: 260px;
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
.brand-emoji {
  font-size: 1.8rem;
  background: #ff5e40;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.brand-name { font-size: 1.1rem; display: block; line-height: 1.2; }
.online-pill { font-size: 0.75rem; color: #10b981; font-weight: 700; }

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
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.nav-item:hover, .nav-item.active {
  background: rgba(255, 94, 64, 0.15);
  color: #ff5e40;
  transform: translateX(4px);
}

.sidebar-bottom {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.revenue-card {
  background: rgba(255, 255, 255, 0.05);
  padding: 16px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.rev-label { font-size: 0.78rem; color: #94a3b8; display: block; }
.rev-val { font-size: 1.5rem; color: #ff5e40; font-weight: 800; display: block; margin: 4px 0; }
.rev-growth { font-size: 0.75rem; color: #10b981; font-weight: 700; }

.sign-out-link {
  color: #64748b;
  text-decoration: none;
  font-size: 0.88rem;
  font-weight: 700;
  padding-left: 6px;
}

/* Main Content */
.main-content {
  flex: 1;
  padding: 32px 36px;
  overflow-y: auto;
}

.board-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
}
.board-title { font-size: 1.8rem; font-weight: 900; color: #1e1e24; margin: 0; }

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 800px;
}

.settings-card {
  background: white;
  padding: 18px 24px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  display: flex;
  flex-direction: column;
  gap: 16px;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.settings-card:hover {
  transform: translateY(-3px) scale(1.005);
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.05);
}

.card-titled {
  padding-top: 20px;
}

.card-section-title {
  font-size: 1rem;
  font-weight: 900;
  color: #1e1e24;
  margin: 0 0 4px 0;
}

.settings-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.row-label {
  font-size: 0.9rem;
  color: #64748b;
  font-weight: 600;
}

.row-value-group {
  display: flex;
  align-items: center;
  gap: 14px;
}

.row-val {
  font-size: 0.92rem;
  font-weight: 900;
  color: #1e1e24;
}

.btn-edit {
  background: none;
  border: none;
  color: #ff5e40;
  font-weight: 800;
  font-size: 0.85rem;
  cursor: pointer;
  padding: 4px 8px;
}

.action-footer {
  margin-top: 10px;
  display: flex;
  justify-content: flex-start;
}

.btn-save-changes {
  background: #ff5e40;
  color: white;
  border: none;
  padding: 12px 28px;
  border-radius: 12px;
  font-weight: 900;
  font-size: 0.95rem;
  cursor: pointer;
}
</style>
