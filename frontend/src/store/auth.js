import { defineStore } from 'pinia'

// Simplified session store for the demo: in a real build this would be
// populated by a real login call against /api/auth.
export const useAuthStore = defineStore('auth', {
  state: () => ({
    currentUser: {
      id: 1,
      name: 'Alice Customer',
      role: 'CUSTOMER'
    }
  })
})
