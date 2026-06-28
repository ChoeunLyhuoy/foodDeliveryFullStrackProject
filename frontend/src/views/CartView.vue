<template>
  <div class="cart-view">
    <h1 class="page-title">Your Shopping Cart</h1>

    <div v-if="cart.items.length === 0" class="empty-cart card">
      <span class="empty-emoji">🛒</span>
      <h2>Your cart is empty</h2>
      <p class="muted">Looks like you haven't added anything to your cart yet.</p>
      <RouterLink to="/"><button class="btn-primary">Browse Restaurants</button></RouterLink>
    </div>

    <div v-else class="cart-layout">
      <!-- Cart Items List -->
      <div class="cart-items-list">
        <div v-for="item in cart.items" :key="item.menuItemId" class="card cart-item-card">
          <div class="item-details">
            <span class="item-emoji">🍲</span>
            <div class="item-meta">
              <span class="item-name">{{ item.name }}</span>
              <span class="item-price-each">${{ item.unitPrice?.toFixed(2) }} each</span>
            </div>
          </div>
          
          <div class="item-actions">
            <div class="quantity-controller">
              <button class="qty-btn" @click="cart.decrementItem(item.menuItemId)">-</button>
              <span class="qty-text">{{ item.quantity }}</span>
              <button class="qty-btn" @click="cart.addItem(cart.restaurantId, item)">+</button>
            </div>
            <span class="item-total-price">${{ (item.unitPrice * item.quantity).toFixed(2) }}</span>
            <button class="delete-btn" @click="cart.removeItem(item.menuItemId)" title="Remove item">
              🗑️
            </button>
          </div>
        </div>
      </div>

      <!-- Pricing Summary Card -->
      <aside class="card summary-card">
        <h3 class="summary-title">Order Summary</h3>
        <div class="summary-divider"></div>
        
        <div class="summary-row">
          <span>Subtotal</span>
          <span>${{ cart.total.toFixed(2) }}</span>
        </div>
        <div class="summary-row">
          <span>Delivery Fee</span>
          <span class="free-text">FREE</span>
        </div>
        <div class="summary-row">
          <span>Service Fee</span>
          <span>$1.50</span>
        </div>
        
        <div class="summary-divider"></div>
        <div class="summary-row total-row">
          <span>Total</span>
          <span class="total-price">${{ (cart.total + 1.50).toFixed(2) }}</span>
        </div>

        <RouterLink to="/checkout" class="checkout-link">
          <button class="btn-primary checkout-btn">
            Proceed to Checkout
            <span>→</span>
          </button>
        </RouterLink>
        
        <p class="terms-text">By proceeding, you agree to our Terms of Service & Delivery Guidelines.</p>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { useCartStore } from '../store/cart'
const cart = useCartStore()
</script>

<style scoped>
.cart-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.page-title {
  margin-bottom: var(--space-2);
}

/* Empty State */
.empty-cart {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-12) var(--space-6);
  text-align: center;
  gap: var(--space-4);
  max-width: 480px;
  margin: var(--space-8) auto;
}

.empty-emoji {
  font-size: 3.5rem;
}

/* Cart Layout */
.cart-layout {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  gap: var(--space-8);
  align-items: start;
}

.cart-items-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.cart-item-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-4) var(--space-5);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
}

.item-details {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}

.item-emoji {
  font-size: 1.8rem;
  background: var(--color-bg);
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-border);
}

.item-meta {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.item-name {
  font-weight: 700;
  font-size: 1.05rem;
}

.item-price-each {
  font-size: 0.8rem;
  color: var(--color-muted);
  font-weight: 500;
}

.item-actions {
  display: flex;
  align-items: center;
  gap: var(--space-6);
}

.quantity-controller {
  display: flex;
  align-items: center;
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-full);
  overflow: hidden;
  height: 36px;
}

.qty-btn {
  background: none;
  border: none;
  width: 32px;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1rem;
  color: var(--color-ink);
  padding: 0;
  border-radius: 0;
}

.qty-btn:hover {
  background: var(--color-border);
}

.qty-text {
  width: 28px;
  text-align: center;
  font-size: 0.9rem;
  font-weight: 700;
}

.item-total-price {
  font-weight: 800;
  font-size: 1.1rem;
  min-width: 65px;
  text-align: right;
}

.delete-btn {
  background: none;
  border: none;
  padding: var(--space-1);
  cursor: pointer;
  opacity: 0.6;
  font-size: 1.1rem;
  border-radius: var(--radius-xs);
}

.delete-btn:hover {
  opacity: 1;
  background: var(--color-error-light);
}

/* Summary Card */
.summary-card {
  padding: var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  position: sticky;
  top: 96px;
}

.summary-title {
  font-size: 1.3rem;
  font-weight: 700;
}

.summary-divider {
  height: 1px;
  background-color: var(--color-border);
}

.summary-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--color-muted);
}

.summary-row span:last-child {
  color: var(--color-ink);
  font-weight: 600;
}

.free-text {
  color: var(--color-success) !important;
  font-weight: 700 !important;
}

.total-row {
  font-size: 1.15rem;
  color: var(--color-ink);
  font-weight: 700;
}

.total-row span:last-child {
  font-size: 1.4rem;
  font-weight: 800;
  color: var(--color-primary);
}

.checkout-link {
  width: 100%;
}

.checkout-btn {
  width: 100%;
  height: 52px;
  font-size: 1.05rem;
}

.terms-text {
  font-size: 0.75rem;
  color: var(--color-muted);
  text-align: center;
  line-height: 1.4;
}

@media (max-width: 992px) {
  .cart-layout {
    grid-template-columns: 1fr;
    gap: var(--space-6);
  }
  .summary-card {
    position: static;
  }
}
</style>
