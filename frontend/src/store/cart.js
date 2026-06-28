import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', {
  state: () => ({
    restaurantId: null,
    items: [] // { menuItemId, name, unitPrice, quantity, notes }
  }),
  getters: {
    total: (state) => state.items.reduce((sum, i) => sum + i.unitPrice * i.quantity, 0)
  },
  actions: {
    addItem(restaurantId, item) {
      if (this.restaurantId && this.restaurantId !== restaurantId) {
        this.items = [] // switching restaurants clears the cart
      }
      this.restaurantId = restaurantId
      const existing = this.items.find((i) => i.menuItemId === item.menuItemId)
      if (existing) {
        existing.quantity += 1
      } else {
        this.items.push({ ...item, quantity: 1 })
      }
    },
    decrementItem(menuItemId) {
      const existing = this.items.find((i) => i.menuItemId === menuItemId)
      if (existing) {
        if (existing.quantity > 1) {
          existing.quantity -= 1
        } else {
          this.removeItem(menuItemId)
        }
      }
    },
    removeItem(menuItemId) {
      this.items = this.items.filter((i) => i.menuItemId !== menuItemId)
    },
    clear() {
      this.items = []
      this.restaurantId = null
    }
  }
})
