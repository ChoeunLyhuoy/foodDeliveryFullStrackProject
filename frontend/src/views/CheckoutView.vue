<template>
  <div class="checkout-view">
    <h1 class="page-title">Checkout</h1>

    <div class="checkout-layout">
      <!-- Left: Delivery Details & Payment -->
      <div class="details-section">
        <!-- Delivery Address Card -->
        <div class="card checkout-card">
          <div class="card-header">
            <span class="header-icon">📍</span>
            <h3>Delivery Details</h3>
          </div>
          <div class="card-body">
            <div class="input-group">
              <label class="field-label">Delivery Address</label>
              <input 
                v-model="address" 
                placeholder="Enter your street address (e.g. 45 Riverside Ave)" 
                required 
              />
            </div>
            
            <div class="form-row">
              <div class="input-group">
                <label class="field-label">Recipient Name</label>
                <input :value="auth.currentUser.name" disabled class="disabled-input" />
              </div>
              <div class="input-group">
                <label class="field-label">Contact Phone</label>
                <input value="+855 11 111 111" disabled class="disabled-input" />
              </div>
            </div>
          </div>
        </div>

        <!-- Payment Method Card -->
        <div class="card checkout-card">
          <div class="card-header">
            <span class="header-icon">💳</span>
            <h3>Payment Method</h3>
          </div>
          <div class="card-body">
            <div class="payment-options">
              <label class="payment-option" :class="{ selected: paymentMethod === 'cash' }">
                <input type="radio" value="cash" v-model="paymentMethod" name="payment" />
                <span class="option-icon">💵</span>
                <span class="option-text">Cash on Delivery</span>
              </label>
              <label class="payment-option" :class="{ selected: paymentMethod === 'card' }">
                <input type="radio" value="card" v-model="paymentMethod" name="payment" />
                <span class="option-icon">💳</span>
                <span class="option-text">Credit / Debit Card</span>
              </label>
              <label class="payment-option" :class="{ selected: paymentMethod === 'pay' }">
                <input type="radio" value="pay" v-model="paymentMethod" name="payment" />
                <span class="option-icon">📱</span>
                <span class="option-text">FoodGo Pay / ABA</span>
              </label>
            </div>
          </div>
        </div>
      </div>

      <!-- Right: Summary and Payment CTA -->
      <aside class="card summary-card">
        <h3 class="summary-title">Summary Review</h3>
        <div class="summary-divider"></div>
        
        <div class="summary-row">
          <span>Items Subtotal</span>
          <span>${{ cart.total.toFixed(2) }}</span>
        </div>
        <div class="summary-row">
          <span>Delivery fee</span>
          <span class="free-text">FREE</span>
        </div>
        <div class="summary-row">
          <span>Service fee</span>
          <span>$1.50</span>
        </div>
        
        <div class="summary-divider"></div>
        <div class="summary-row total-row">
          <span>Total To Pay</span>
          <span class="total-price">${{ (cart.total + 1.50).toFixed(2) }}</span>
        </div>

        <button 
          class="btn-primary place-order-btn" 
          :disabled="!address || placing" 
          @click="placeOrder"
        >
          <span v-if="placing" class="btn-spinner"></span>
          <span>{{ placing ? 'Processing Order...' : 'Place Order Now' }}</span>
        </button>

        <p class="secure-checkout">🔒 Secure 256-bit SSL encrypted transactions</p>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '../store/cart'
import { useAuthStore } from '../store/auth'
import { createOrder } from '../services/api'

const cart = useCartStore()
const auth = useAuthStore()
const router = useRouter()
const address = ref('')
const placing = ref(false)
const paymentMethod = ref('cash')

async function placeOrder() {
  if (!address.value) return
  placing.value = true
  try {
    const { data } = await createOrder({
      customerId: auth.currentUser.id,
      restaurantId: cart.restaurantId,
      deliveryAddress: address.value,
      items: cart.items.map((i) => ({ menuItemId: i.menuItemId, quantity: i.quantity }))
    })
    cart.clear()
    router.push(`/order/${data.id}`)
  } catch (e) {
    console.error('Order failed', e)
  } finally {
    placing.value = false
  }
}
</script>

<style scoped>
.checkout-view {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.page-title {
  margin-bottom: var(--space-2);
}

.checkout-layout {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  gap: var(--space-8);
  align-items: start;
}

.details-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.checkout-card {
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

.card-header {
  padding: var(--space-4) var(--space-5);
  background: linear-gradient(to right, var(--color-primary-light), transparent);
  border-bottom: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.card-header h3 {
  font-size: 1.15rem;
  font-weight: 700;
  margin: 0;
}

.header-icon {
  font-size: 1.25rem;
}

.card-body {
  padding: var(--space-5);
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  width: 100%;
}

.field-label {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--color-muted);
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.disabled-input {
  background-color: var(--color-bg);
  color: var(--color-muted);
  cursor: not-allowed;
  border-color: var(--color-border);
}

/* Payment selection styling */
.payment-options {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.payment-option {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  padding: var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: var(--transition-smooth);
}

.payment-option:hover {
  background: var(--color-bg);
}

.payment-option.selected {
  border-color: var(--color-primary);
  background: var(--color-primary-light);
}

.payment-option input {
  width: auto;
}

.option-icon {
  font-size: 1.5rem;
}

.option-text {
  font-weight: 700;
  font-size: 0.95rem;
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

.place-order-btn {
  width: 100%;
  height: 54px;
  font-size: 1.05rem;
  box-shadow: 0 4px 14px rgba(255, 94, 64, 0.25);
}

.btn-spinner {
  width: 20px;
  height: 20px;
  border: 2px solid white;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.secure-checkout {
  font-size: 0.75rem;
  color: var(--color-success);
  text-align: center;
  font-weight: 600;
}

@media (max-width: 992px) {
  .checkout-layout {
    grid-template-columns: 1fr;
    gap: var(--space-6);
  }
  .form-row {
    grid-template-columns: 1fr;
  }
  .summary-card {
    position: static;
  }
}
</style>
