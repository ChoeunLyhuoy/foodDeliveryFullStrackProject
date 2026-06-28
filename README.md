# FoodGo — Food Delivery Platform (Full Stack)

A working scaffold for a food delivery platform, covering:

- **Backend**: Spring Boot (Java 17) — REST API + WebSocket/STOMP chat
- **Frontend (web)**: Vue 3 + Vite — customer site, restaurant dashboard, call center dashboard
- **Mobile**: Flutter — customer app + rider app (single codebase, role chooser on launch)
- **Database**: MySQL

This is a functional MVP/starter scaffold, not a production-ready system — see
"What's not included" at the bottom before deploying it anywhere real.

## Project structure
```
foodgo/
├── database/         schema.sql, seed.sql (MySQL)
├── backend/           Spring Boot REST + WebSocket API
├── frontend/           Vue 3 web app (customer site + both dashboards)
└── mobile/              Flutter app (customer + rider)
```

## The two chat systems
Both chats share the same `chat_messages` table and the same STOMP broker,
but are kept logically separate by `channel`:

- **Customer ↔ Rider chat** — tied to one order. The rider side is built as
  an *inbox* of every active order assigned to that rider (one rider, many
  simultaneous customer conversations). The customer side is a single thread
  with their assigned rider, opened from the order tracking screen.
- **Customer ↔ Call Center chat** — a separate support-only channel, opened
  via a "Need help?" button. Not linked to the rider chat. Agents see it from
  the call-center web dashboard with canned replies and an order-details panel.

## Running it locally

### 1. Database
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql
```

### 2. Backend (Spring Boot)
```bash
cd backend
# set DB credentials if different from root/root
export DB_USERNAME=root
export DB_PASSWORD=root
./mvnw spring-boot:run
```
Runs on `http://localhost:8080`. REST endpoints under `/api/...`, WebSocket at
`/ws` (SockJS, used by the web app) and `/ws-native` (plain STOMP, used by Flutter).

### 3. Frontend (Vue)
```bash
cd frontend
npm install
npm run dev
```
Runs on `http://localhost:5173`, proxies `/api` and `/ws` to the backend (see `vite.config.js`).
This was built and verified with `npm run build` during generation.

### 4. Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```
Update `ApiConfig.baseUrl` / `wsUrl` in `lib/core/api_service.dart` if running
on a physical device or Android emulator (`10.0.2.2` instead of `localhost`
for the Android emulator).

## Demo data
`seed.sql` creates one customer (Alice), one restaurant (Pizza Palace) with a
menu, one rider (Bob), one call center agent (Cara), and one order already
in progress with sample chat messages in both channels — so you can open the
chat screens immediately without placing a fresh order first.

## What's not included (intentionally, to keep the scaffold readable)
- Real authentication (JWT/OAuth) — `password_hash` exists in the schema but
  there's no login endpoint yet; the frontend/mobile apps use a hardcoded demo user.
- Payments integration.
- Live map/GPS tracking (the rider `lat`/`lng` fields and an update endpoint
  exist, but there's no map UI wired up).
- Push notifications.
- A `GET /api/call-center/tickets/{id}` endpoint — the agent chat screen
  currently assumes `ticketId == orderId` as a placeholder; add this endpoint
  to resolve it properly.
- Automated tests.

These are the natural "next steps" to harden this into production.
# foodDeliveryFullStrackProject
