USE little_stars_kids_fashion;

INSERT INTO users (user_id, full_name, email, phone, password_hash, role, account_status)
VALUES
    (1, 'Amaka Okafor', 'amaka.okafor@example.com', '+2348001112233', '$2y$10$Xb5B8sJRYe2s3kQwYQf.9uOevr0nQZVaJmws7Y6MZrBv2Tg7mK4zS', 'customer', 'active'),
    (2, 'Chinedu Adebayo', 'chinedu.adebayo@example.com', '+2348002223344', '$2y$10$T8r2Vd9bN4kaL2Q1C0v8ZeqP3NfKZIdQ4J/Ac8vZQw4C7NhCj6rky', 'customer', 'active'),
    (3, 'Ngozi Eze', 'ngozi.eze@example.com', '+2348003334455', '$2y$10$z1S4cQWnYdI9GKTlXQ/EcOpeWc6Y9OeR6j9l0uy4Q31u2vGWt5UjO', 'admin', 'active');

INSERT INTO addresses (address_id, user_id, recipient_name, phone, street_address, city, state_province, postal_code, country, is_default)
VALUES
    (1, 1, 'Amaka Okafor', '+2348001112233', '12 Harmony Close', 'Lagos', 'Lagos State', '100001', 'Nigeria', 1),
    (2, 1, 'Amaka Okafor', '+2348001112233', '25 Bwari Road', 'Abuja', 'FCT', '900001', 'Nigeria', 0),
    (3, 2, 'Chinedu Adebayo', '+2348002223344', '8 Adaobi Crescent', 'Port Harcourt', 'Rivers', '500001', 'Nigeria', 1);

INSERT INTO categories (category_id, parent_category_id, category_name, slug, description, status)
VALUES
    (1, NULL, 'Boys Clothing', 'boys-clothing', 'Trendy outfits for boys aged 1 to 6 years.', 'active'),
    (2, NULL, 'Girls Clothing', 'girls-clothing', 'Bright and comfortable outfits for girls aged 1 to 6 years.', 'active'),
    (3, 1, 'Tops & Shirts', 'tops-shirts', 'T-shirts, polos, and casual tops for young boys.', 'active'),
    (4, 2, 'Dresses', 'dresses', 'Cute dresses designed for everyday play and little celebrations.', 'active'),
    (5, NULL, 'Shoes & Accessories', 'shoes-accessories', 'Matching shoes, hats, and accessories for the complete look.', 'active');

INSERT INTO products (product_id, category_id, product_name, brand, description, base_price, status, is_featured, is_new_arrival)
VALUES
    (1, 3, 'Captain Print Tee', 'Little Stars', 'Soft cotton boys tee with playful captain print and comfort fit.', 4800.00, 'active', 1, 1),
    (2, 4, 'Bloom Party Dress', 'Little Stars', 'A twirly dress with lace sleeves and a satin finish.', 7200.00, 'active', 1, 0),
    (3, 5, 'Light Up Sneakers', 'Little Stars', 'Lightweight sneakers with flexible soles for active play.', 9500.00, 'active', 1, 1),
    (4, 1, 'Adventure Shorts Set', 'Little Stars', 'Comfortable shorts paired with a cool stripe top for summer play.', 6800.00, 'active', 0, 1),
    (5, 2, 'Sunbeam Skirt Set', 'Little Stars', 'A soft cotton set with a matching waist ribbon and easy movement.', 6100.00, 'active', 0, 0);

INSERT INTO product_variants (variant_id, product_id, sku, size_label, colour, variant_price, stock_quantity, status)
VALUES
    (1, 1, 'LS-BT-TEE-20-BLUE', '2 years', 'Blue', NULL, 25, 'active'),
    (2, 1, 'LS-BT-TEE-24-GREEN', '4 years', 'Green', 5100.00, 18, 'active'),
    (3, 2, 'LS-BPD-24-PINK', '4 years', 'Pink', NULL, 12, 'active'),
    (4, 2, 'LS-BPD-30-PURPLE', '5 years', 'Purple', 7600.00, 10, 'active'),
    (5, 3, 'LS-SNE-18-WHITE', '18 months', 'White', NULL, 20, 'active'),
    (6, 3, 'LS-SNE-24-BLACK', '2 years', 'Black', 9800.00, 8, 'active'),
    (7, 4, 'LS-ADV-30-NAVY', '5 years', 'Navy', NULL, 16, 'active'),
    (8, 5, 'LS-SUN-24-ROSE', '2 years', 'Rose', NULL, 14, 'active');

INSERT INTO product_images (image_id, product_id, image_url, alt_text, display_order, is_primary)
VALUES
    (1, 1, 'https://example.com/images/captain-print-tee-front.jpg', 'Captain print tee front view', 1, 1),
    (2, 1, 'https://example.com/images/captain-print-tee-back.jpg', 'Captain print tee back view', 2, 0),
    (3, 2, 'https://example.com/images/bloom-party-dress-front.jpg', 'Bloom party dress front view', 1, 1),
    (4, 3, 'https://example.com/images/light-up-sneakers-front.jpg', 'Light up sneakers front view', 1, 1),
    (5, 4, 'https://example.com/images/adventure-shorts-set.jpg', 'Adventure shorts set image', 1, 1),
    (6, 5, 'https://example.com/images/sunbeam-skirt-set.jpg', 'Sunbeam skirt set image', 1, 1);

INSERT INTO carts (cart_id, user_id, session_id)
VALUES
    (1, 1, NULL),
    (2, NULL, 'guest-session-abc123');

INSERT INTO cart_items (cart_item_id, cart_id, product_variant_id, quantity)
VALUES
    (1, 1, 1, 2),
    (2, 1, 5, 1),
    (3, 2, 3, 1);

INSERT INTO discounts (discount_id, coupon_code, discount_type, discount_value, minimum_order_value, start_date, expiry_date, usage_limit, active)
VALUES
    (1, 'STAR10', 'percentage', 10.00, 8000.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 200, 1),
    (2, 'WELCOME50', 'fixed_amount', 1500.00, 5000.00, '2026-01-01 00:00:00', '2026-06-30 23:59:59', 50, 1);

INSERT INTO orders (order_id, order_number, user_id, discount_id, order_status, payment_status, subtotal, discount_amount, delivery_fee, total_amount, currency, delivery_address_id, recipient_name, recipient_phone, delivery_street, delivery_city, delivery_state, delivery_postal_code, delivery_country, customer_notes, discount_code_snapshot)
VALUES
    (1, 'LS-ORD-1001', 1, 1, 'processing', 'paid', 12800.00, 1280.00, 1200.00, 12720.00, 'NGN', 1, 'Amaka Okafor', '+2348001112233', '12 Harmony Close', 'Lagos', 'Lagos State', '100001', 'Nigeria', 'Please deliver before 5pm.', 'STAR10'),
    (2, 'LS-ORD-1002', 2, NULL, 'shipped', 'paid', 9500.00, 0.00, 1500.00, 11000.00, 'NGN', 3, 'Chinedu Adebayo', '+2348002223344', '8 Adaobi Crescent', 'Port Harcourt', 'Rivers', '500001', 'Nigeria', '', NULL);

INSERT INTO order_items (item_id, order_id, product_id, variant_id, product_name_snapshot, variant_name_snapshot, sku_snapshot, unit_price, quantity, line_total)
VALUES
    (1, 1, 1, 1, 'Captain Print Tee', 'Blue / 2 years', 'LS-BT-TEE-20-BLUE', 4800.00, 2, 9600.00),
    (2, 1, 3, 5, 'Light Up Sneakers', 'White / 18 months', 'LS-SNE-18-WHITE', 9500.00, 1, 9500.00),
    (3, 2, 3, 6, 'Light Up Sneakers', 'Black / 2 years', 'LS-SNE-24-BLACK', 9800.00, 1, 9800.00);

INSERT INTO payments (payment_id, order_id, payment_provider, payment_reference, amount, currency, payment_status, provider_transaction_id, paid_at)
VALUES
    (1, 1, 'paystack', 'PAY-001-LS1001', 12720.00, 'NGN', 'paid', 'paystack_txn_101', '2026-02-02 09:10:00'),
    (2, 2, 'flutterwave', 'FLW-002-LS1002', 11000.00, 'NGN', 'paid', 'flw_txn_201', '2026-02-03 14:30:00');

INSERT INTO shipments (shipment_id, order_id, delivery_provider, tracking_reference, shipment_status, dispatch_date, delivery_date, delivery_notes)
VALUES
    (1, 1, 'GIG Logistics', 'GIG-LS-1001', 'in_transit', '2026-02-03 08:00:00', NULL, 'Expected on next business day.'),
    (2, 2, 'FedEx', 'FEX-LS-1002', 'out_for_delivery', '2026-02-04 07:30:00', NULL, 'Courier is near local delivery hub.');

INSERT INTO discount_usage (usage_id, discount_id, order_id, used_at)
VALUES
    (1, 1, 1, '2026-02-02 09:11:00');

INSERT INTO wishlists (wishlist_id, user_id, wishlist_name)
VALUES
    (1, 1, 'Amaka Birthday Picks'),
    (2, 2, 'Chinedu Favorites');

INSERT INTO wishlist_items (wishlist_item_id, wishlist_id, product_id, variant_id)
VALUES
    (1, 1, 2, 3),
    (2, 1, 5, 8),
    (3, 2, 1, 2);

INSERT INTO reviews (review_id, user_id, product_id, rating, review_text, review_status, is_verified_purchase)
VALUES
    (1, 1, 1, 5, 'Excellent fit and super soft fabric. My son loves the print.', 'approved', 1),
    (2, 2, 3, 4, 'Very comfortable and stylish. Perfect for school events.', 'approved', 1);

INSERT INTO audit_logs (log_id, actor_id, action_type, entity_type, entity_id, metadata)
VALUES
    (1, 3, 'product_created', 'products', 1, '{"source": "admin_dashboard", "summary": "New product created"}'),
    (2, 3, 'discount_updated', 'discounts', 1, '{"source": "promotions_manager", "summary": "Discount policy updated"}');
