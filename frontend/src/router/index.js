import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/login', name: 'login', component: () => import('../views/LoginView.vue'), meta: { roles: ['guest', 'customer', 'restaurant', 'callcenter', 'delivery'] } },
  { path: '/', name: 'home', component: () => import('../views/HomeView.vue'), meta: { roles: ['guest', 'customer'] } },
  { path: '/restaurant/:id', name: 'restaurant-detail', component: () => import('../views/RestaurantDetailView.vue'), meta: { roles: ['guest', 'customer'] } },
  { path: '/cart', name: 'cart', component: () => import('../views/CartView.vue'), meta: { roles: ['customer'] } },
  { path: '/checkout', name: 'checkout', component: () => import('../views/CheckoutView.vue'), meta: { roles: ['customer'] } },
  { path: '/order/:id', name: 'order-tracking', component: () => import('../views/OrderTrackingView.vue'), meta: { roles: ['customer', 'delivery', 'callcenter'] } },
  { path: '/order/:id/chat/rider', name: 'rider-chat', component: () => import('../views/RiderChatView.vue'), meta: { roles: ['customer', 'delivery'] } },
  { path: '/order/:id/chat/call-center', name: 'call-center-chat', component: () => import('../views/CallCenterChatView.vue'), meta: { roles: ['customer', 'callcenter'] } },

  // Restaurant dashboard (web)
  { path: '/restaurant-dashboard', name: 'restaurant-dashboard', component: () => import('../views/restaurant-dashboard/DashboardView.vue'), meta: { roles: ['restaurant'] } },
  { path: '/restaurant-dashboard/orders', name: 'restaurant-orders-board', component: () => import('../views/restaurant-dashboard/OrdersBoardView.vue'), meta: { roles: ['restaurant'] } },
  { path: '/restaurant-dashboard/menu', name: 'restaurant-menu', component: () => import('../views/restaurant-dashboard/MenuManagementView.vue'), meta: { roles: ['restaurant'] } },

  // Call center dashboard (web)
  { path: '/call-center-dashboard', name: 'call-center-dashboard', component: () => import('../views/call-center-dashboard/AgentDashboardView.vue'), meta: { roles: ['callcenter'] } },
  { path: '/call-center-dashboard/chat/:ticketId', name: 'call-center-agent-chat', component: () => import('../views/call-center-dashboard/AgentChatView.vue'), meta: { roles: ['callcenter'] } },
  { path: '/call-center-dashboard/lookup', name: 'order-lookup', component: () => import('../views/call-center-dashboard/OrderLookupView.vue'), meta: { roles: ['callcenter'] } }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const currentRole = localStorage.getItem('foodgo_role') || 'guest'
  
  if (to.meta && to.meta.roles) {
    if (to.meta.roles.includes(currentRole)) {
      next()
    } else {
      // Redirect unauthorized users to their correct workspace
      if (currentRole === 'restaurant') {
        next('/restaurant-dashboard/orders')
      } else if (currentRole === 'callcenter') {
        next('/call-center-dashboard')
      } else if (currentRole === 'delivery') {
        next('/order/1')
      } else {
        next('/')
      }
    }
  } else {
    next()
  }
})

export default router
