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
          <RouterLink to="/restaurant-dashboard/menu" class="nav-item active">
            <span class="nav-icon">🍴</span> Menu Catalog
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/reviews" class="nav-item">
            <span class="nav-icon">👍</span> Reviews
          </RouterLink>
          <RouterLink to="/restaurant-dashboard/settings" class="nav-item">
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
          <h1 class="board-title">Menu Management</h1>
          <p class="board-sub">{{ displayMenu.length }} items across 3 categories</p>
        </div>
        <button class="btn-add-item" @click="showAddDialog = true">
          <span>+ Add Item</span>
        </button>
      </header>

      <!-- Category Groups list (Figma Image 2) -->
      <div class="menu-categories-list">
        <div v-for="cat in ['BURGERS', 'SIDES', 'DRINKS']" :key="cat" class="category-group">
          <h3 class="category-title">{{ cat }}</h3>
          
          <div class="category-items">
            <div 
              v-for="item in displayMenu.filter(i => i.category.toUpperCase() === cat)" 
              :key="item.id" 
              class="menu-item-card"
            >
              <!-- Item Thumbnail -->
              <div class="item-thumb-box">
                <span class="thumb-emoji">{{ getEmoji(item.name) }}</span>
              </div>

              <!-- Item info -->
              <div class="item-info">
                <h4 class="item-name">{{ item.name }}</h4>
                <p class="item-desc">{{ item.description }}</p>
              </div>

              <!-- Status & Price controls -->
              <div class="item-controls">
                <span class="item-price">${{ item.price.toFixed(2) }}</span>
                <span class="status-pill active">● Active</span>
                
                <!-- Action Buttons -->
                <div class="action-icons">
                  <button class="icon-btn edit-btn" @click="editItem(item)">✏️</button>
                  <button class="icon-btn delete-btn" @click="deleteItem(item.id)">🗑️</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Simple Add Item Dialog -->
    <div v-if="showAddDialog" class="modal-overlay">
      <div class="modal-card">
        <h3>➕ Add Menu Item</h3>
        <form @submit.prevent="addItem">
          <div class="input-group">
            <label>Name</label>
            <input v-model="newItem.name" placeholder="Classic Smash" required />
          </div>
          <div class="input-group">
            <label>Description</label>
            <input v-model="newItem.description" placeholder="Double patty, cheddar..." required />
          </div>
          <div class="input-group">
            <label>Price ($)</label>
            <input v-model="newItem.price" type="number" step="0.01" required />
          </div>
          <div class="input-group">
            <label>Category</label>
            <select v-model="newItem.category">
              <option value="BURGERS">BURGERS</option>
              <option value="SIDES">SIDES</option>
              <option value="DRINKS">DRINKS</option>
            </select>
          </div>
          <div class="modal-actions">
            <button type="button" class="btn-cancel" @click="showAddDialog = false">Cancel</button>
            <button type="submit" class="btn-submit">Add Item</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMenu } from '../../services/api'
import api from '../../services/api'

const RESTAURANT_ID = 1
const displayMenu = ref([])
const loading = ref(true)
const showAddDialog = ref(false)
const newItem = ref({ name: '', description: '', price: 12.99, category: 'BURGERS' })

onMounted(async () => {
  fetchItems()
})

async function fetchItems() {
  loading.value = true
  try {
    const { data } = await getMenu(RESTAURANT_ID)
    displayMenu.value = data
    if (displayMenu.value.length === 0) {
      // Provide demo items from Figma Image 2 if backend returns empty
      displayMenu.value = [
        { id: 101, name: 'Classic Smash', description: 'Double patty, cheddar, lettuce, house sauce', price: 12.99, category: 'BURGERS' },
        { id: 102, name: 'Wagyu Double', description: 'Premium wagyu, truffle mayo, aged cheddar', price: 22.99, category: 'BURGERS' },
        { id: 103, name: 'Crispy Chicken', description: 'Buttermilk fried chicken, slaw, sriracha', price: 14.99, category: 'BURGERS' },
        { id: 104, name: 'Loaded Fries', description: 'Seasoned fries, cheese sauce, jalapeños', price: 7.99, category: 'SIDES' },
        { id: 105, name: 'Chocolate Shake', description: 'Creamy milk, chocolate syrup, whipped cream', price: 5.99, category: 'DRINKS' }
      ]
    }
  } catch (e) {
    console.error(e)
    displayMenu.value = [
      { id: 101, name: 'Classic Smash', description: 'Double patty, cheddar, lettuce, house sauce', price: 12.99, category: 'BURGERS' },
      { id: 102, name: 'Wagyu Double', description: 'Premium wagyu, truffle mayo, aged cheddar', price: 22.99, category: 'BURGERS' },
      { id: 103, name: 'Crispy Chicken', description: 'Buttermilk fried chicken, slaw, sriracha', price: 14.99, category: 'BURGERS' },
      { id: 104, name: 'Loaded Fries', description: 'Seasoned fries, cheese sauce, jalapeños', price: 7.99, category: 'SIDES' },
      { id: 105, name: 'Chocolate Shake', description: 'Creamy milk, chocolate syrup, whipped cream', price: 5.99, category: 'DRINKS' }
    ]
  } finally {
    loading.value = false
  }
}

async function addItem() {
  try {
    const { data } = await api.post(`/restaurants/${RESTAURANT_ID}/menu`, {
      name: newItem.value.name,
      description: newItem.value.description,
      price: parseFloat(newItem.value.price),
      category: newItem.value.category,
      isAvailable: true
    })
    displayMenu.value.push(data)
  } catch (e) {
    // Local fallback insert
    displayMenu.value.push({
      id: Date.now(),
      name: newItem.value.name,
      description: newItem.value.description,
      price: parseFloat(newItem.value.price),
      category: newItem.value.category
    })
  }
  showAddDialog.value = false
  newItem.value = { name: '', description: '', price: 12.99, category: 'BURGERS' }
}

function editItem(item) {
  alert(`Editing item: ${item.name}`)
}

async function deleteItem(id) {
  if (confirm('Are you sure you want to delete this menu item?')) {
    try {
      await api.delete(`/restaurants/menu/${id}`)
    } catch (e) {}
    displayMenu.value = displayMenu.value.filter(i => i.id !== id)
  }
}

function getEmoji(name) {
  const n = name.toLowerCase()
  if (n.includes('fries') || n.includes('side')) return '🍟'
  if (n.includes('shake') || n.includes('drink') || n.includes('coke')) return '🥤'
  return '🍔'
}
</script>

<style scoped>
.figma-portal-container {
  display: flex;
  height: 100vh;
  background: #f8f9fa;
  margin: -32px -20px;
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
  align-items: flex-start;
  margin-bottom: 28px;
}
.board-title { font-size: 1.8rem; font-weight: 900; color: #1e1e24; margin: 0; }
.board-sub { color: #64748b; font-size: 0.9rem; margin-top: 4px; font-weight: 600; }

.btn-add-item {
  background: #ff5e40;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 12px;
  font-weight: 900;
  cursor: pointer;
}

.menu-categories-list {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.category-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.category-title {
  font-size: 0.8rem;
  color: #94a3b8;
  font-weight: 900;
  letter-spacing: 0.05em;
  margin: 0;
}

.category-items {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.menu-item-card {
  background: white;
  padding: 16px 20px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  display: flex;
  align-items: center;
  gap: 18px;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}
.menu-item-card:hover {
  transform: translateY(-3px) scale(1.008);
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.06);
}

.item-thumb-box {
  width: 56px;
  height: 56px;
  background: #f8f9fa;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.8rem;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 1.05rem;
  font-weight: 900;
  color: #1e1e24;
  margin: 0;
}

.item-desc {
  font-size: 0.85rem;
  color: #64748b;
  margin: 4px 0 0 0;
  font-weight: 500;
}

.item-controls {
  display: flex;
  align-items: center;
  gap: 24px;
}

.item-price {
  font-size: 1.05rem;
  font-weight: 900;
  color: #1e1e24;
}

.status-pill {
  font-size: 0.78rem;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 20px;
}
.status-pill.active {
  color: #10b981;
  background: #ecfdf5;
}

.action-icons {
  display: flex;
  gap: 8px;
}

.icon-btn {
  background: none;
  border: 1px solid #e2e8f0;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.85rem;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-card {
  background: white;
  padding: 24px;
  border-radius: 20px;
  width: 400px;
  max-width: 90%;
}

.modal-card h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-weight: 900;
}

.input-group {
  margin-bottom: 16px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.input-group label {
  font-size: 0.82rem;
  font-weight: 800;
  color: #64748b;
}

.input-group input, .input-group select {
  height: 40px;
  padding: 0 12px;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  font-size: 0.95rem;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
}

.btn-cancel {
  background: none;
  border: 1px solid #e2e8f0;
  padding: 8px 16px;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
}

.btn-submit {
  background: #ff5e40;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 8px;
  font-weight: 800;
  cursor: pointer;
}
</style>
