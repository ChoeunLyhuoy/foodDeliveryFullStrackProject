import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/login', name: 'login', component: () => import('../views/LoginView.vue') },
  { path: '/', name: 'home', component: () => import('../views/HomeView.vue') },
  { path: '/restaurant/:id', name: 'restaurant-detail', component: () => import('../views/RestaurantDetailView.vue') },
  { path: '/cart', name: 'cart', component: () => import('../views/CartView.vue') },
  { path: '/checkout', name: 'checkout', component: () => import('../views/CheckoutView.vue') },
  { path: '/order/:id', name: 'order-tracking', component: () => import('../views/OrderTrackingView.vue') },
  { path: '/order/:id/chat/rider', name: 'rider-chat', component: () => import('../views/RiderChatView.vue') },
  { path: '/order/:id/chat/call-center', name: 'call-center-chat', component: () => import('../views/CallCenterChatView.vue') },

  // Restaurant dashboard (web)
  { path: '/restaurant-dashboard', name: 'restaurant-dashboard', component: () => import('../views/restaurant-dashboard/DashboardView.vue') },
  { path: '/restaurant-dashboard/orders', name: 'restaurant-orders-board', component: () => import('../views/restaurant-dashboard/OrdersBoardView.vue') },
  { path: '/restaurant-dashboard/menu', name: 'restaurant-menu', component: () => import('../views/restaurant-dashboard/MenuManagementView.vue') },

  // Call center dashboard (web)
  { path: '/call-center-dashboard', name: 'call-center-dashboard', component: () => import('../views/call-center-dashboard/AgentDashboardView.vue') },
  { path: '/call-center-dashboard/chat/:ticketId', name: 'call-center-agent-chat', component: () => import('../views/call-center-dashboard/AgentChatView.vue') },
  { path: '/call-center-dashboard/lookup', name: 'order-lookup', component: () => import('../views/call-center-dashboard/OrderLookupView.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
