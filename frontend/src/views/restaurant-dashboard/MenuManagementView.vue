<template>
  <div class="menu-management-view">
    <div class="view-header">
      <div>
        <span class="view-subtitle">Restaurant Dashboard</span>
        <h1 class="view-title">Manage Menu</h1>
      </div>
    </div>

    <div class="management-layout">
      <!-- Add dish form -->
      <form class="card add-form-card" @submit.prevent="addItem">
        <h3 class="form-title">➕ Add New Dish</h3>
        <div class="form-body">
          <div class="input-group">
            <label>Dish Name</label>
            <input v-model="newItem.name" placeholder="e.g. Pepperoni Pizza" required />
          </div>
          <div class="input-group">
            <label>Price ($)</label>
            <input v-model="newItem.price" type="number" step="0.01" placeholder="e.g. 9.50" required />
          </div>
          <div class="input-group">
            <label>Category</label>
            <input v-model="newItem.category" placeholder="e.g. Pizza, Sides, Drinks" />
          </div>
          <button class="btn-primary add-submit-btn" type="submit">
            Add Dish to Menu
          </button>
        </div>
      </form>

      <!-- Menu Items List -->
      <div class="menu-list-section">
        <h3 class="section-title">Current Offerings</h3>
        
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
          <p>Loading your menu...</p>
        </div>
        
        <div v-else class="menu-grid">
          <div v-for="item in menu" :key="item.id" class="card menu-item-card" :class="{ unavailable: !item.isAvailable }">
            <div class="item-meta">
              <span class="category-badge" v-if="item.category">{{ item.category }}</span>
              <span class="price-badge">${{ item.price?.toFixed(2) }}</span>
            </div>
            
            <h4 class="item-name">{{ item.name }}</h4>
            
            <div class="item-actions">
              <label class="switch-container">
                <input type="checkbox" v-model="item.isAvailable" @change="toggleAvailability(item)" class="switch-input" />
                <span class="switch-slider"></span>
                <span class="switch-text">{{ item.isAvailable ? 'Available' : 'Unavailable' }}</span>
              </label>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMenu } from '../../services/api'
import api from '../../services/api'

const RESTAURANT_ID = 1 // Pizza Palace demo
const menu = ref([])
const loading = ref(true)
const newItem = ref({ name: '', price: '', category: '' })

onMounted(async () => {
  try {
    const { data } = await getMenu(RESTAURANT_ID)
    menu.value = data
  } catch (e) {
    console.error('Failed to load menu', e)
  } finally {
    loading.value = false
  }
})

async function addItem() {
  try {
    const { data } = await api.post(`/restaurants/${RESTAURANT_ID}/menu`, {
      name: newItem.value.name,
      price: parseFloat(newItem.value.price),
      category: newItem.value.category,
      isAvailable: true
    })
    menu.value.push(data)
    newItem.value = { name: '', price: '', category: '' }
  } catch (e) {
    console.error('Failed to add menu item', e)
  }
}

async function toggleAvailability(item) {
  try {
    await api.put(`/restaurants/menu/${item.id}`, item)
  } catch (e) {
    console.error('Failed to toggle availability', e)
  }
}
</script>

<style scoped>
.menu-management-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
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
}

/* Management Grid Layout */
.management-layout {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: var(--space-8);
  align-items: start;
}

.add-form-card {
  padding: var(--space-5);
  background: white;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  position: sticky;
  top: 96px;
}

.form-title {
  font-size: 1.2rem;
  font-weight: 700;
  margin-bottom: var(--space-4);
  border-bottom: 1px solid var(--color-border);
  padding-bottom: var(--space-2);
}

.form-body {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.input-group label {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--color-muted);
}

.add-submit-btn {
  width: 100%;
  height: 48px;
  margin-top: var(--space-2);
}

/* Menu list section */
.menu-list-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.section-title {
  font-size: 1.25rem;
  font-weight: 700;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: var(--space-4);
}

.menu-item-card {
  padding: var(--space-4);
  background: white;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  transition: var(--transition-smooth);
}

.menu-item-card.unavailable {
  opacity: 0.65;
  background: #fdfcfb;
}

.item-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.category-badge {
  background: var(--color-bg);
  color: var(--color-muted);
  font-size: 0.75rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: var(--radius-full);
  border: 1px solid var(--color-border);
}

.price-badge {
  font-weight: 800;
  color: var(--color-ink);
  font-size: 1.1rem;
}

.item-name {
  font-size: 1.05rem;
  font-weight: 700;
  flex: 1;
}

.item-actions {
  border-top: 1px dashed var(--color-border);
  padding-top: var(--space-2);
}

/* Toggle Switch Styling */
.switch-container {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--color-muted);
}

.switch-input {
  display: none;
}

.switch-slider {
  position: relative;
  width: 36px;
  height: 20px;
  background-color: var(--color-border);
  border-radius: var(--radius-full);
  transition: var(--transition-smooth);
  display: inline-block;
}

.switch-slider::before {
  content: "";
  position: absolute;
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  border-radius: 50%;
  transition: var(--transition-smooth);
}

.switch-input:checked + .switch-slider {
  background-color: var(--color-success);
}

.switch-input:checked + .switch-slider::before {
  transform: translateX(16px);
}

.switch-input:checked ~ .switch-text {
  color: var(--color-success);
  font-weight: 700;
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
  width: 30px;
  height: 30px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: var(--radius-full);
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 992px) {
  .management-layout {
    grid-template-columns: 1fr;
  }
  .add-form-card {
    position: static;
  }
}
</style>
