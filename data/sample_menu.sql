-- =============================================================================
-- City Pizza — Sample menu SQL for DriftPOS
-- =============================================================================
-- Run in: Settings → Data → SQL Console (password: devtanics)
--
-- PRICES: stored as price_in_paisa (integer).  1 PKR = 100 paisa
--         Rs 850   → 85000
--         Rs 1200  → 120000
--         Rs 1999  → 199900
--
-- BOOLEANS: use 1 = true, 0 = false
--
-- ORDER: categories → products → product_variants → deals → deal_items
-- =============================================================================

BEGIN TRANSACTION;

-- Optional: wipe existing menu data (keeps orders intact)
-- Uncomment the next 5 lines if you want a clean slate:
-- DELETE FROM deal_items;
-- DELETE FROM deals;
-- DELETE FROM product_variants;
-- DELETE FROM products;
-- DELETE FROM categories;

-- -----------------------------------------------------------------------------
-- 1. CATEGORIES
-- -----------------------------------------------------------------------------
-- Omit `id` to auto-assign. If you use fixed ids, adjust product category_id below.

INSERT INTO categories (name, color, icon, sort_order, is_active) VALUES
  ('Pizzas',       '#E63946', 'pizza',        1, 1),
  ('Burgers',      '#FF6B35', 'burger',       2, 1),
  ('Pasta',        '#F4A261', 'utensils',     3, 1),
  ('Fries & Sides','#F59E0B', 'french_fries', 4, 1),
  ('Drinks',       '#3B82F6', 'cup',          5, 1),
  ('Desserts',     '#EC4899', 'ice_cream',    6, 1);

-- -----------------------------------------------------------------------------
-- 2. PRODUCTS
-- -----------------------------------------------------------------------------
-- category_id: use subquery so you don't need to know numeric ids
-- price_in_paisa: base price (smallest variant when variants exist)

INSERT INTO products (name, description, price_in_paisa, category_id, is_available, is_deal, sort_order)
VALUES
  (
    'Chicken Fajita Pizza',
    'Chicken, capsicum, onion, fajita sauce',
    85000,
    (SELECT id FROM categories WHERE name = 'Pizzas' LIMIT 1),
    1, 0, 1
  ),
  (
    'Chicken Supreme Pizza',
    'Chicken, mushrooms, olives, capsicum',
    90000,
    (SELECT id FROM categories WHERE name = 'Pizzas' LIMIT 1),
    1, 0, 2
  ),
  (
    'Cheese Lover Pizza',
    'Extra mozzarella and cheddar',
    80000,
    (SELECT id FROM categories WHERE name = 'Pizzas' LIMIT 1),
    1, 0, 3
  ),
  (
    'Beef Burger',
    'Beef patty, lettuce, cheese, special sauce',
    45000,
    (SELECT id FROM categories WHERE name = 'Burgers' LIMIT 1),
    1, 0, 1
  ),
  (
    'Chicken Burger',
    'Crispy chicken fillet with mayo',
    40000,
    (SELECT id FROM categories WHERE name = 'Burgers' LIMIT 1),
    1, 0, 2
  ),
  (
    'Zinger Burger',
    'Spicy zinger fillet',
    48000,
    (SELECT id FROM categories WHERE name = 'Burgers' LIMIT 1),
    1, 0, 3
  ),
  (
    'Chicken Alfredo Pasta',
    'Creamy white sauce with grilled chicken',
    55000,
    (SELECT id FROM categories WHERE name = 'Pasta' LIMIT 1),
    1, 0, 1
  ),
  (
    'French Fries',
    NULL,
    20000,
    (SELECT id FROM categories WHERE name = 'Fries & Sides' LIMIT 1),
    1, 0, 1
  ),
  (
    'Garlic Bread',
    NULL,
    25000,
    (SELECT id FROM categories WHERE name = 'Fries & Sides' LIMIT 1),
    1, 0, 2
  ),
  (
    'Coca Cola',
    NULL,
    12000,
    (SELECT id FROM categories WHERE name = 'Drinks' LIMIT 1),
    1, 0, 1
  ),
  (
    'Sprite',
    NULL,
    12000,
    (SELECT id FROM categories WHERE name = 'Drinks' LIMIT 1),
    1, 0, 2
  ),
  (
    'Mineral Water',
    NULL,
    8000,
    (SELECT id FROM categories WHERE name = 'Drinks' LIMIT 1),
    1, 0, 3
  ),
  (
    'Chocolate Brownie',
    NULL,
    30000,
    (SELECT id FROM categories WHERE name = 'Desserts' LIMIT 1),
    1, 0, 1
  );

-- -----------------------------------------------------------------------------
-- 3. PRODUCT VARIANTS (sizes / flavors)
-- -----------------------------------------------------------------------------
-- product_id: linked by product name

INSERT INTO product_variants (product_id, name, price_in_paisa, is_available, sort_order)
VALUES
  ((SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1), 'Small',  85000,  1, 1),
  ((SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1), 'Medium', 120000, 1, 2),
  ((SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1), 'Large',  155000, 1, 3),
  ((SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1), 'Family', 210000, 1, 4),

  ((SELECT id FROM products WHERE name = 'Chicken Supreme Pizza' LIMIT 1), 'Small',  90000,  1, 1),
  ((SELECT id FROM products WHERE name = 'Chicken Supreme Pizza' LIMIT 1), 'Medium', 125000, 1, 2),
  ((SELECT id FROM products WHERE name = 'Chicken Supreme Pizza' LIMIT 1), 'Large',  160000, 1, 3),
  ((SELECT id FROM products WHERE name = 'Chicken Supreme Pizza' LIMIT 1), 'Family', 220000, 1, 4),

  ((SELECT id FROM products WHERE name = 'Cheese Lover Pizza' LIMIT 1), 'Small',  80000,  1, 1),
  ((SELECT id FROM products WHERE name = 'Cheese Lover Pizza' LIMIT 1), 'Medium', 115000, 1, 2),
  ((SELECT id FROM products WHERE name = 'Cheese Lover Pizza' LIMIT 1), 'Large',  150000, 1, 3),

  ((SELECT id FROM products WHERE name = 'Zinger Burger' LIMIT 1), 'Regular', 48000, 1, 1),
  ((SELECT id FROM products WHERE name = 'Zinger Burger' LIMIT 1), 'Double',  65000, 1, 2),

  ((SELECT id FROM products WHERE name = 'French Fries' LIMIT 1), 'Regular', 20000, 1, 1),
  ((SELECT id FROM products WHERE name = 'French Fries' LIMIT 1), 'Large',   32000, 1, 2),

  ((SELECT id FROM products WHERE name = 'Coca Cola' LIMIT 1), 'Regular',  12000, 1, 1),
  ((SELECT id FROM products WHERE name = 'Coca Cola' LIMIT 1), '1.5 Litre', 22000, 1, 2);

-- -----------------------------------------------------------------------------
-- 4. DEALS (combo offers — separate from products table)
-- -----------------------------------------------------------------------------

INSERT INTO deals (name, description, price_in_paisa, is_available)
VALUES
  (
    'Family Deal 1',
    '1 Large Chicken Fajita + 1 Large Fries + 1.5L Drink',
    199900,
    1
  ),
  (
    'Burger Meal',
    '1 Zinger Burger + Regular Fries + Regular Drink',
    75000,
    1
  ),
  (
    'Pizza Duo',
    '2 Medium pizzas',
    220000,
    1
  );

-- -----------------------------------------------------------------------------
-- 5. DEAL ITEMS (products included in each deal)
-- -----------------------------------------------------------------------------
-- Note: deals reference base products, not a specific variant.
-- Cashier picks variant at order time when applicable.

INSERT INTO deal_items (deal_id, product_id, quantity)
VALUES
  (
    (SELECT id FROM deals WHERE name = 'Family Deal 1' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1),
    1
  ),
  (
    (SELECT id FROM deals WHERE name = 'Family Deal 1' LIMIT 1),
    (SELECT id FROM products WHERE name = 'French Fries' LIMIT 1),
    1
  ),
  (
    (SELECT id FROM deals WHERE name = 'Family Deal 1' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Coca Cola' LIMIT 1),
    1
  ),

  (
    (SELECT id FROM deals WHERE name = 'Burger Meal' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Zinger Burger' LIMIT 1),
    1
  ),
  (
    (SELECT id FROM deals WHERE name = 'Burger Meal' LIMIT 1),
    (SELECT id FROM products WHERE name = 'French Fries' LIMIT 1),
    1
  ),
  (
    (SELECT id FROM deals WHERE name = 'Burger Meal' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Sprite' LIMIT 1),
    1
  ),

  (
    (SELECT id FROM deals WHERE name = 'Pizza Duo' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Chicken Fajita Pizza' LIMIT 1),
    1
  ),
  (
    (SELECT id FROM deals WHERE name = 'Pizza Duo' LIMIT 1),
    (SELECT id FROM products WHERE name = 'Cheese Lover Pizza' LIMIT 1),
    1
  );

COMMIT;

-- =============================================================================
-- QUICK REFERENCE — copy/paste one product
-- =============================================================================
--
-- INSERT INTO products (name, description, price_in_paisa, category_id, is_available, is_deal, sort_order)
-- VALUES (
--   'Your Product Name',
--   'Optional description',
--   50000,                                              -- Rs 500
--   (SELECT id FROM categories WHERE name = 'Pizzas' LIMIT 1),
--   1, 0, 10
-- );
--
-- INSERT INTO product_variants (product_id, name, price_in_paisa, is_available, sort_order)
-- VALUES
--   ((SELECT id FROM products WHERE name = 'Your Product Name' LIMIT 1), 'Small',  50000, 1, 1),
--   ((SELECT id FROM products WHERE name = 'Your Product Name' LIMIT 1), 'Large',  75000, 1, 2);
--
-- =============================================================================
-- VERIFY (run after import)
-- =============================================================================
-- SELECT c.name AS category, p.name, p.price_in_paisa / 100.0 AS price_pkr
-- FROM products p
-- JOIN categories c ON c.id = p.category_id
-- ORDER BY c.sort_order, p.sort_order;
--
-- SELECT p.name AS product, v.name AS variant, v.price_in_paisa / 100.0 AS price_pkr
-- FROM product_variants v
-- JOIN products p ON p.id = v.product_id
-- ORDER BY p.name, v.sort_order;
