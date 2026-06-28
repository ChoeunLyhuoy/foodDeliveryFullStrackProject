import axios from 'axios'

const api = axios.create({
  baseURL: '/api'
})

export default api

// --- Restaurants & menu ---
export const getRestaurants = () => api.get('/restaurants')
export const getRestaurant = (id) => api.get(`/restaurants/${id}`)
export const getMenu = (restaurantId) => api.get(`/restaurants/${restaurantId}/menu`)

// --- Orders ---
export const createOrder = (payload) => api.post('/orders', payload)
export const getOrder = (id) => api.get(`/orders/${id}`)
export const getOrdersForCustomer = (customerId) => api.get(`/orders/customer/${customerId}`)
export const getActiveOrdersForRider = (riderId) => api.get(`/orders/rider/${riderId}/active`)
export const updateOrderStatus = (id, status) => api.patch(`/orders/${id}/status`, { status })

// --- Chat ---
export const getRiderChatHistory = (orderId) => api.get(`/orders/${orderId}/chat/rider`)
export const sendRiderChatMessage = (orderId, payload) => api.post(`/orders/${orderId}/chat/rider`, payload)
export const getCallCenterChatHistory = (orderId) => api.get(`/orders/${orderId}/chat/call-center`)
export const sendCallCenterChatMessage = (orderId, payload) => api.post(`/orders/${orderId}/chat/call-center`, payload)

// --- Call center ---
export const getCallCenterQueue = () => api.get('/call-center/tickets/queue')
export const getCallCenterTicket = (id) => api.get(`/call-center/tickets/${id}`)
export const resolveTicket = (id) => api.patch(`/call-center/tickets/${id}/resolve`)

// --- Extra Restaurant endpoints ---
export const getRestaurantOrders = (id) => api.get(`/restaurants/${id}/orders`)
