USE db_foodgo;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE chat_messages;
TRUNCATE TABLE call_center_tickets;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE riders;
TRUNCATE TABLE menu_items;
TRUNCATE TABLE restaurants;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. SEED USERS & ROLES
INSERT INTO users (name, email, phone, password_hash, role) VALUES
('Alice Customer', 'alice@example.com', '+855111111', '$2a$10$placeholderHash', 'CUSTOMER'),
('David Gourmet Owner', 'owner@pizzapalace.com', '+855222222', '$2a$10$placeholderHash', 'RESTAURANT_OWNER'),
('Bob Express Rider', 'bob.rider@example.com', '+855333333', '$2a$10$placeholderHash', 'RIDER'),
('Cara Lead Agent', 'cara.agent@foodgo.com', '+855444444', '$2a$10$placeholderHash', 'CALL_CENTER_AGENT'),
('Sophea Customer', 'sophea@example.com', '+855555555', '$2a$10$placeholderHash', 'CUSTOMER'),
('Kenji Swift Rider', 'kenji.rider@example.com', '+855666666', '$2a$10$placeholderHash', 'RIDER');

-- 2. SEED 10 GOURMET RESTAURANTS WITH HIGH-RES COVER PICTURE LINKS
INSERT INTO restaurants (owner_id, name, description, address, cover_image_url, rating, is_open) VALUES
(2, 'Pizza Palace & Trattoria', 'Authentic wood-fired Neapolitan pizza, handmade pasta, and Italian classics.', '123 Norodom Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80', 4.8, TRUE),
(2, 'Tokyo Sushi & Ramen Bar', 'Premium Grade A sashimi, 12-hour Tonkotsu broth ramen, and artisanal rolls.', '45 BKK1 St 278, Phnom Penh', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&auto=format&fit=crop&q=80', 4.9, TRUE),
(2, 'Burger Artisan & Craft Shake', 'Double smashed Wagyu patties, truffle mayo, crispy bacon melts, and thick shakes.', '88 Monivong Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80', 4.7, TRUE),
(2, 'Royal Khmer Heritage Kitchen', 'Authentic Cambodian Royal recipes featuring Fish Amok and Kampot Pepper Lok Lak.', '12 Sisowath Quay, Phnom Penh', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&auto=format&fit=crop&q=80', 4.9, TRUE),
(2, 'Sweet Boba & Dessert Lounge', 'Fresh brewed Taiwanese milk teas, brown sugar boba, and French pastries.', '99 Russian Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1558857563-b3773e7c8475?w=800&auto=format&fit=crop&q=80', 4.6, TRUE),
(2, 'Seoul Korean BBQ & Chicken', 'Crispy double-fried Korean wings, sizzling beef bulgogi, and spicy tteokbokki.', '34 Toul Kork Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1580651315530-69c8e0026377?w=800&auto=format&fit=crop&q=80', 4.8, TRUE),
(2, 'El Taco Loco Authentic Mexican', 'Fresh Birria beef tacos with rich consomé dip, loaded burritos, and guacamole.', '77 Mao Tse Toung Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&auto=format&fit=crop&q=80', 4.7, TRUE),
(2, 'Bangkok Street Thai Curry', 'Fiery Tom Yum Goong soup, authentic Pad Thai wok noodles, and green curry.', '52 Sothearos Blvd, Phnom Penh', 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=800&auto=format&fit=crop&q=80', 4.8, TRUE),
(2, 'Le Petit Bakery & Café', 'Handmade butter croissants, sourdough toast, eclairs, and specialty iced lattes.', '15 Pasteur St 51, Phnom Penh', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&auto=format&fit=crop&q=80', 4.9, TRUE),
(2, 'Spice of India Tandoori', 'Creamy Butter Chicken masala, fresh baked garlic naan, and royal biryani rice.', '63 Street 63, Phnom Penh', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&auto=format&fit=crop&q=80', 4.7, TRUE);

-- 3. SEED 40 VIBRANT MENU PRODUCTS ACROSS ALL 10 RESTAURANTS
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_available) VALUES
-- Restaurant 1: Pizza Palace & Trattoria
(1, 'Truffle Burrata Margherita', 'San Marzano tomatoes, creamy fresh burrata, basil, and black truffle oil drizzle.', 12.50, 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=600&auto=format&fit=crop&q=80', 'Pizza', TRUE),
(1, 'Spicy Calabrese Pepperoni', 'Crispy double pepperoni, spicy honey glaze, mozzarella, and oregano.', 11.50, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&fit=crop&q=80', 'Pizza', TRUE),
(1, 'Creamy Carbonara Tagliatelle', 'Handmade ribbon pasta, crispy pancetta, egg yolk cream, and pecorino romano.', 10.00, 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=600&auto=format&fit=crop&q=80', 'Pasta', TRUE),
(1, 'Garlic & Herb Cheesy Focaccia', 'Freshly baked focaccia brushed with roasted garlic butter and melted mozzarella.', 4.50, 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=600&auto=format&fit=crop&q=80', 'Sides', TRUE),

-- Restaurant 2: Tokyo Sushi & Ramen Bar
(2, 'Signature Tonkotsu Ramen', 'Rich pork bone broth, chashu pork belly, soft boiled egg, wood ear mushrooms.', 11.00, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80', 'Ramen', TRUE),
(2, 'Ultimate Dragon Roll', 'Tempura shrimp prawn, topped with sliced avocado, unagi eel glaze, and tobiko.', 14.00, 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600&auto=format&fit=crop&q=80', 'Sushi Rolls', TRUE),
(2, 'Salmon & Tuna Sashimi Platter', '12 thick cuts of Atlantic salmon and yellowfin tuna served with freshly grated wasabi.', 18.50, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80', 'Sashimi', TRUE),
(2, 'Matcha Green Tea Mochi', 'Delicate Japanese rice cake stuffed with premium Uji matcha ice cream.', 4.00, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80', 'Desserts', TRUE),

-- Restaurant 3: Burger Artisan & Craft Shake
(3, 'Wagyu Truffle Smash Burger', 'Double smashed Wagyu beef, aged cheddar, caramelized onions, truffle aioli on brioche.', 10.50, 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80', 'Burgers', TRUE),
(3, 'Crispy Hot Chicken Sandwich', 'Nashville spiced buttermilk fried chicken breast, pickles, slaw, and spicy chipotle sauce.', 9.50, 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80', 'Burgers', TRUE),
(3, 'Loaded Bacon Sweet Potato Fries', 'Crispy sweet potato fries smothered in cheese sauce, bacon bits, and scallions.', 5.50, 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=600&auto=format&fit=crop&q=80', 'Sides', TRUE),
(3, 'Oreo Cookie Monster Milkshake', 'Thick vanilla bean gelato blended with double stuffed Oreo cookies and whipped cream.', 5.00, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80', 'Drinks', TRUE),

-- Restaurant 4: Royal Khmer Heritage Kitchen
(4, 'Royal Fish Amok in Coconut Shell', 'Traditional steamed river fish curry steamed with kroeung paste and coconut milk.', 11.50, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80', 'Khmer Mains', TRUE),
(4, 'Kampot Pepper Beef Lok Lak', 'Tender stir-fried beef cubes served with lime pepper dipping sauce and garlic rice.', 12.00, 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80', 'Khmer Mains', TRUE),
(4, 'Crispy Spring Rolls (6 pcs)', 'Hand-rolled spring rolls filled with minced pork, taro, and served with sweet chili dip.', 5.00, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80', 'Appetizers', TRUE),
(4, 'Fresh Mango Sticky Rice', 'Sweet ripe yellow mango served with warm coconut sticky rice and toasted mung beans.', 6.00, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&auto=format&fit=crop&q=80', 'Desserts', TRUE),

-- Restaurant 5: Sweet Boba & Dessert Lounge
(5, 'Brown Sugar Pearl Milk Tea', 'Tiger stripe caramelized brown sugar syrup, slow-cooked tapioca pearls, and organic milk.', 4.50, 'https://images.unsplash.com/photo-1558857563-b3773e7c8475?w=600&auto=format&fit=crop&q=80', 'Boba Tea', TRUE),
(5, 'Matcha Taro Cloud Latte', 'Layered ceremonial Japanese matcha over creamy taro purée and fresh milk.', 5.00, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&auto=format&fit=crop&q=80', 'Boba Tea', TRUE),
(5, 'French Strawberry Mille Crepe', 'Twenty layers of paper-thin French crepes filled with vanilla chantilly and fresh strawberries.', 6.50, 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=600&auto=format&fit=crop&q=80', 'Cakes', TRUE),
(5, 'Belgian Waffle with Berries', 'Golden crispy waffle topped with maple syrup, fresh blueberries, and chantilly cream.', 7.00, 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80', 'Desserts', TRUE),

-- Restaurant 6: Seoul Korean BBQ & Chicken
(6, 'Yangnyeom Fried Chicken Wings', 'Crispy double-fried Korean chicken tossed in sweet and spicy gochujang glaze.', 10.50, 'https://images.unsplash.com/photo-1527477247444-b79518346802?w=600&auto=format&fit=crop&q=80', 'Korean BBQ', TRUE),
(6, 'Sizzling Beef Bulgogi Platter', 'Marinated tender ribeye slices grilled with sesame oil, garlic, and scallions.', 13.50, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&auto=format&fit=crop&q=80', 'Korean BBQ', TRUE),
(6, 'Spicy Tteokbokki Rice Cakes', 'Chewy Korean rice cakes and fish cakes simmered in spicy gochujang broth with melted cheese.', 8.50, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80', 'Korean BBQ', TRUE),
(6, 'Kimchi Fried Rice with Egg', 'Fragrant stir-fried aged kimchi rice topped with a crispy fried egg and roasted seaweed.', 7.50, 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80', 'Korean BBQ', TRUE),

-- Restaurant 7: El Taco Loco Authentic Mexican
(7, 'Birria Beef Tacos & Consomé', 'Three slow-braised beef brisket tacos griddled with cheese and served with dipping consomé.', 11.50, 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80', 'Tacos', TRUE),
(7, 'Loaded Carne Asada Burrito', 'Grilled skirt steak, cilantro lime rice, black beans, guacamole, and sour cream wrapped inside flour tortilla.', 10.00, 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=600&auto=format&fit=crop&q=80', 'Burritos', TRUE),
(7, 'Guacamole & Crispy Tortilla Chips', 'Fresh hand-mashed avocado with lime, tomato, cilantro, and warm tortilla chips.', 6.00, 'https://images.unsplash.com/photo-1541544741938-0af808871cc0?w=600&auto=format&fit=crop&q=80', 'Appetizers', TRUE),
(7, 'Cinnamon Sugar Churros', 'Warm golden churros rolled in cinnamon sugar served with rich dark chocolate dip.', 5.50, 'https://images.unsplash.com/photo-1624300629298-e9de39c13be5?w=600&auto=format&fit=crop&q=80', 'Desserts', TRUE),

-- Restaurant 8: Bangkok Street Thai Curry
(8, 'Authentic Pad Thai Prawns', 'Wok-fried rice noodles with king prawns, peanuts, bean sprouts, tamarind sauce, and lime.', 9.50, 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=600&auto=format&fit=crop&q=80', 'Noodles', TRUE),
(8, 'Green Curry Chicken', 'Fragrant Thai green curry cooked in rich coconut milk with Thai eggplants and sweet basil.', 10.50, 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=600&auto=format&fit=crop&q=80', 'Curry', TRUE),
(8, 'Tom Yum Goong Spicy Soup', 'Hot and sour lemongrass seafood broth with jumbo river prawns, mushrooms, and chili.', 11.00, 'https://images.unsplash.com/photo-1548946526-f69e2424cf45?w=600&auto=format&fit=crop&q=80', 'Soups', TRUE),
(8, 'Crispy Papaya Salad (Som Tum)', 'Fresh shredded green papaya pounded with chili, lime juice, palm sugar, and roasted peanuts.', 6.50, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&fit=crop&q=80', 'Salads', TRUE),

-- Restaurant 9: Le Petit Bakery & Café
(9, 'Butter Almond Croissant', 'Flaky French golden croissant baked with sweet almond frangipane and toasted flaked almonds.', 4.50, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80', 'Bakery', TRUE),
(9, 'Avocado Sourdough Poached Egg', 'Thick artisan sourdough toast topped with smashed avocado, poached eggs, and chili flakes.', 8.50, 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&auto=format&fit=crop&q=80', 'Breakfast', TRUE),
(9, 'Belgian Chocolate Eclair', 'Choux pastry filled with vanilla custard and glazed with Belgian 70% dark chocolate.', 5.00, 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=600&auto=format&fit=crop&q=80', 'Bakery', TRUE),
(9, 'Iced Sea Salt Caramel Latte', 'Double shot espresso poured over cold milk and house-made salted caramel syrup.', 4.50, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600&auto=format&fit=crop&q=80', 'Drinks', TRUE),

-- Restaurant 10: Spice of India Tandoori
(10, 'Delhi Butter Chicken Masala', 'Tender tandoori chicken simmered in a creamy, spiced tomato and fenugreek gravy.', 12.00, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80', 'Curry', TRUE),
(10, 'Garlic Butter Naan Bread', 'Freshly baked tandoor oven flatbread brushed with garlic butter and fresh cilantro.', 3.50, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80', 'Sides', TRUE),
(10, 'Royal Chicken Biryani Rice', 'Aromatic basmati rice layered with spiced marinated chicken, saffron, and caramelized onions.', 13.00, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80', 'Biryani', TRUE),
(10, 'Crispy Vegetable Samosas (3 pcs)', 'Golden pastry pockets stuffed with spiced potatoes and green peas served with mint chutney.', 5.50, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80', 'Appetizers', TRUE);

-- 4. SEED FLEET RIDERS
INSERT INTO riders (user_id, vehicle_type, is_online, current_lat, current_lng, rating) VALUES
(3, 'Honda PCX Motorbike 160cc', TRUE, 11.5564, 104.9282, 4.9),
(6, 'Yamaha NMAX 155cc Express', TRUE, 11.5680, 104.9120, 4.8);

-- 5. SEED ORDERS & ITEMS
INSERT INTO orders (customer_id, restaurant_id, rider_id, status, delivery_address, total_amount) VALUES
(1, 1, 1, 'ON_THE_WAY', '45 Riverside Ave, Phnom Penh', 24.00),
(1, 2, 2, 'PREPARING', '12 Independence Monument St, Phnom Penh', 25.00),
(5, 6, 1, 'DELIVERED', '88 Toul Kork Blvd, Phnom Penh', 24.00);

INSERT INTO order_items (order_id, menu_item_id, quantity, unit_price, notes) VALUES
(1, 1, 1, 12.50, 'Extra basil and crispy crust please'),
(1, 2, 1, 11.50, 'Spicy honey on the side'),
(2, 5, 1, 11.00, 'Extra chashu pork'),
(2, 6, 1, 14.00, 'No spicy mayo'),
(3, 21, 1, 10.50, 'Extra crispy'),
(3, 22, 1, 13.50, 'Medium spice');

-- 6. SEED LIVE CHAT MESSAGES & SUPPORT TICKETS
INSERT INTO chat_messages (order_id, channel, sender_id, sender_role, message, is_read) VALUES
(1, 'RIDER', 1, 'CUSTOMER', 'Hi Bob! I am waiting at the main lobby of Riverside Apartments.', TRUE),
(1, 'RIDER', 3, 'RIDER', 'Got it Alice! I just picked up the hot pizza and am about 4 minutes away.', FALSE);

INSERT INTO call_center_tickets (order_id, customer_id, agent_id, status, priority) VALUES
(1, 1, 4, 'IN_PROGRESS', 'HIGH'),
(2, 1, NULL, 'OPEN', 'NORMAL');

INSERT INTO chat_messages (order_id, channel, sender_id, sender_role, message, is_read) VALUES
(1, 'CALL_CENTER', 1, 'CUSTOMER', 'Could you please make sure the rider calls when arriving?', TRUE),
(1, 'CALL_CENTER', 4, 'CALL_CENTER_AGENT', 'Certainly Alice! I have notified Bob on his dispatch app.', TRUE);
