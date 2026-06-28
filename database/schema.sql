-- =========================================================
-- FoodGo Food Delivery Platform - MySQL Schema
-- =========================================================
CREATE DATABASE IF NOT EXISTS foodgo CHARACTER SET utf8mb4;
USE foodgo;

-- ---------------------------------------------------------
-- Users (customers, restaurant owners, riders, call-center
-- agents and admins all live in one table, differentiated
-- by role)
-- ---------------------------------------------------------
CREATE TABLE users (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(120)  NOT NULL,
    email           VARCHAR(160)  NOT NULL UNIQUE,
    phone           VARCHAR(30),
    password_hash   VARCHAR(255)  NOT NULL,
    role            ENUM('CUSTOMER','RESTAURANT_OWNER','RIDER','CALL_CENTER_AGENT','ADMIN') NOT NULL,
    avatar_url      VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------
-- Restaurants
-- ---------------------------------------------------------
CREATE TABLE restaurants (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    owner_id        BIGINT NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    address         VARCHAR(255),
    cover_image_url VARCHAR(255),
    rating          DECIMAL(2,1) DEFAULT 0.0,
    is_open         BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_restaurant_owner FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- ---------------------------------------------------------
-- Menu items
-- ---------------------------------------------------------
CREATE TABLE menu_items (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id   BIGINT NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    price           DECIMAL(10,2) NOT NULL,
    image_url       VARCHAR(255),
    category        VARCHAR(80),
    is_available    BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ---------------------------------------------------------
-- Riders (extends a user with role = RIDER)
-- ---------------------------------------------------------
CREATE TABLE riders (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT NOT NULL UNIQUE,
    vehicle_type    VARCHAR(60),
    is_online       BOOLEAN DEFAULT FALSE,
    current_lat     DECIMAL(10,7),
    current_lng     DECIMAL(10,7),
    rating          DECIMAL(2,1) DEFAULT 0.0,
    CONSTRAINT fk_rider_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ---------------------------------------------------------
-- Orders
-- ---------------------------------------------------------
CREATE TABLE orders (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id         BIGINT NOT NULL,
    restaurant_id       BIGINT NOT NULL,
    rider_id            BIGINT NULL,
    status              ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
                              'PICKED_UP','ON_THE_WAY','DELIVERED','CANCELLED')
                         NOT NULL DEFAULT 'PLACED',
    delivery_address    VARCHAR(255) NOT NULL,
    total_amount        DECIMAL(10,2) NOT NULL,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_customer   FOREIGN KEY (customer_id)   REFERENCES users(id),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    CONSTRAINT fk_order_rider      FOREIGN KEY (rider_id)      REFERENCES riders(id)
);

-- ---------------------------------------------------------
-- Order items
-- ---------------------------------------------------------
CREATE TABLE order_items (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT NOT NULL,
    menu_item_id    BIGINT NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    unit_price      DECIMAL(10,2) NOT NULL,
    notes           VARCHAR(255),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_orderitem_menu  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- ---------------------------------------------------------
-- Chat messages
-- One table, two channels:
--   RIDER        -> customer <-> assigned rider (per order)
--   CALL_CENTER  -> customer <-> support agent (per ticket)
-- ---------------------------------------------------------
CREATE TABLE chat_messages (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT NOT NULL,
    channel         ENUM('RIDER','CALL_CENTER') NOT NULL,
    sender_id       BIGINT NOT NULL,
    sender_role     ENUM('CUSTOMER','RIDER','CALL_CENTER_AGENT') NOT NULL,
    message         TEXT NOT NULL,
    is_read         BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_order  FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_chat_sender FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- ---------------------------------------------------------
-- Call center tickets (the support-only channel, can exist
-- with or without a linked order)
-- ---------------------------------------------------------
CREATE TABLE call_center_tickets (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT NULL,
    customer_id     BIGINT NOT NULL,
    agent_id        BIGINT NULL,
    status          ENUM('OPEN','IN_PROGRESS','RESOLVED') DEFAULT 'OPEN',
    priority        ENUM('LOW','NORMAL','HIGH') DEFAULT 'NORMAL',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket_order    FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_ticket_customer FOREIGN KEY (customer_id) REFERENCES users(id),
    CONSTRAINT fk_ticket_agent    FOREIGN KEY (agent_id) REFERENCES users(id)
);

CREATE INDEX idx_chat_order_channel ON chat_messages(order_id, channel);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_menu_restaurant ON menu_items(restaurant_id);
