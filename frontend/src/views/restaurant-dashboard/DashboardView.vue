<template>
  <div class="dashboard-view">
    <div class="dashboard-header">
      <span class="view-subtitle">Owner Console</span>
      <h1 class="view-title">Restaurant Dashboard</h1>
      <p class="muted">Manage your store operations, menus, and track live customer metrics.</p>
    </div>

    <!-- Stat Dashboard Grid -->
    <div class="stat-grid">
      <div class="card stat-card today-orders">
        <div class="stat-icon">📦</div>
        <div class="stat-details">
          <span class="value">12</span>
          <span class="label">Orders Today</span>
        </div>
      </div>
      <div class="card stat-card today-revenue">
        <div class="stat-icon">💵</div>
        <div class="stat-details">
          <span class="value">$248.50</span>
          <span class="label">Revenue Today</span>
        </div>
      </div>
      <div class="card stat-card avg-rating">
        <div class="stat-icon">★</div>
        <div class="stat-details">
          <span class="value">4.6</span>
          <span class="label">Average Rating</span>
        </div>
      </div>
    </div>

    <!-- Live Controls / Links -->
    <div class="actions-panel card">
      <h3>Quick Actions</h3>
      <p class="muted">Monitor preparation progress or modify available menu items instantly.</p>
      
      <div class="links-group">
        <RouterLink to="/restaurant-dashboard/orders">
          <button class="btn-primary action-btn">
            <span>View Live Orders Board</span>
            <span>→</span>
          </button>
        </RouterLink>
        <RouterLink to="/restaurant-dashboard/menu">
          <button class="btn-secondary action-btn">
            <span>Manage Menu Catalog</span>
          </button>
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped>
.dashboard-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
  max-width: 840px;
  margin: 0 auto;
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

/* Stat Cards Layout */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-5);
}

.stat-card {
  padding: var(--space-5) var(--space-6);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  gap: var(--space-4);
  box-shadow: var(--shadow-sm);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: var(--radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

/* Custom stats backgrounds */
.today-orders .stat-icon { background: var(--color-primary-light); color: var(--color-primary); }
.today-revenue .stat-icon { background: var(--color-success-light); color: var(--color-success); }
.avg-rating .stat-icon { background: var(--color-accent-light); color: var(--color-accent); }

.stat-details {
  display: flex;
  flex-direction: column;
}

.value {
  font-family: var(--font-display);
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--color-ink);
  line-height: 1.1;
}

.label {
  font-size: 0.8rem;
  color: var(--color-muted);
  font-weight: 600;
  margin-top: 2px;
}

/* Quick Actions Panel */
.actions-panel {
  padding: var(--space-6);
  background: white;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.actions-panel h3 {
  font-size: 1.25rem;
}

.links-group {
  display: flex;
  gap: var(--space-4);
  margin-top: var(--space-3);
}

.action-btn {
  height: 48px;
  font-size: 0.95rem;
}

@media (max-width: 768px) {
  .stat-grid {
    grid-template-columns: 1fr;
  }
  .links-group {
    flex-direction: column;
  }
  .action-btn {
    width: 100%;
  }
}
</style>
