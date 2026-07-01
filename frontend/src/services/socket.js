import { Client } from '@stomp/stompjs'
import SockJS from 'sockjs-client'

/**
 * One STOMP connection, reused by both chat features. Each call to
 * subscribeToChat() is scoped to a single order + channel, so a
 * subscription to the rider topic never receives call-center messages.
 *
 * channel: 'rider' | 'callcenter'
 */
let client = null

function getClient() {
  if (!client) {
    const wsUrl = import.meta.env.VITE_WS_URL || '/ws'
    client = new Client({
      webSocketFactory: () => new SockJS(wsUrl),
      reconnectDelay: 4000
    })
    client.activate()
  }
  return client
}

export function subscribeToChat(orderId, channel, onMessage) {
  const c = getClient()
  const topic = `/topic/order.${orderId}.${channel}`

  const trySubscribe = () => {
    if (c.connected) {
      c.subscribe(topic, (msg) => onMessage(JSON.parse(msg.body)))
    } else {
      c.onConnect = () => c.subscribe(topic, (msg) => onMessage(JSON.parse(msg.body)))
    }
  }
  trySubscribe()
}

export function sendChatMessage(orderId, channel, payload) {
  const c = getClient()
  const destination = `/app/chat.${channel}.${orderId}`
  c.publish({ destination, body: JSON.stringify(payload) })
}
