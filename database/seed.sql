USE db_foodgo;

INSERT INTO users (name, email, phone, password_hash, role) VALUES
('Alice Customer', 'alice@example.com', '+855111111', '$2a$10$placeholderHash', 'CUSTOMER'),
('Pizza Palace Owner', 'owner@pizzapalace.com', '+855222222', '$2a$10$placeholderHash', 'RESTAURANT_OWNER'),
('Bob Rider', 'bob.rider@example.com', '+855333333', '$2a$10$placeholderHash', 'RIDER'),
('Cara Agent', 'cara.agent@foodgo.com', '+855444444', '$2a$10$placeholderHash', 'CALL_CENTER_AGENT');

INSERT INTO restaurants (owner_id, name, description, address, cover_image_url, rating, is_open) VALUES
(2, 'Pizza Palace', 'Wood-fired pizza and Italian classics', '123 Main St', '/images/pizza-palace.jpg', 4.6, TRUE);

INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_available) VALUES
(1, 'Margherita Pizza', 'Tomato, mozzarella, basil', 8.50, '/images/margherita.jpg', 'Pizza', TRUE),
(1, 'Pepperoni Pizza', 'Tomato, mozzarella, pepperoni', 9.50, '/images/pepperoni.jpg', 'Pizza', TRUE),
(1, 'Garlic Bread', 'Toasted bread with garlic butter', 3.50, '/images/garlic-bread.jpg', 'Sides', TRUE);

INSERT INTO riders (user_id, vehicle_type, is_online, current_lat, current_lng, rating) VALUES
(3, 'Motorbike', TRUE, 11.5564, 104.9282, 4.8);

INSERT INTO orders (customer_id, restaurant_id, rider_id, status, delivery_address, total_amount) VALUES
(1, 1, 1, 'ON_THE_WAY', '45 Riverside Ave', 18.00);

INSERT INTO order_items (order_id, menu_item_id, quantity, unit_price, notes) VALUES
(1, 1, 1, 8.50, 'Extra basil please'),
(1, 3, 1, 3.50, NULL);

INSERT INTO chat_messages (order_id, channel, sender_id, sender_role, message, is_read) VALUES
(1, 'RIDER', 1, 'CUSTOMER', 'Hi, how far away are you?', TRUE),
(1, 'RIDER', 3, 'RIDER', 'About 5 minutes away!', FALSE);

INSERT INTO call_center_tickets (order_id, customer_id, agent_id, status, priority) VALUES
(1, 1, 4, 'IN_PROGRESS', 'NORMAL');

INSERT INTO chat_messages (order_id, channel, sender_id, sender_role, message, is_read) VALUES
(1, 'CALL_CENTER', 1, 'CUSTOMER', 'My order is taking longer than expected', TRUE),
(1, 'CALL_CENTER', 4, 'CALL_CENTER_AGENT', 'Sorry about that, let me check on it for you', FALSE);
