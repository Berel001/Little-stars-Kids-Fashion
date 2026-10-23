DROP DATABASE IF EXISTS little_stars_kids_fashion;
CREATE DATABASE little_stars_kids_fashion
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE little_stars_kids_fashion;

-- -----------------------------------------------------------------------------
-- Users and addresses
-- -----------------------------------------------------------------------------
CREATE TABLE users (
    user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(191) NOT NULL,
    phone VARCHAR(25) DEFAULT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin', 'staff') NOT NULL DEFAULT 'customer',
    account_status ENUM('active', 'inactive', 'suspended', 'pending_verification') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE addresses (
    address_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    recipient_name VARCHAR(120) NOT NULL,
    phone VARCHAR(25) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) DEFAULT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Nigeria',
    is_default TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id),
    KEY idx_addresses_user_id (user_id),
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (is_default IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Categories and products
-- -----------------------------------------------------------------------------
CREATE TABLE categories (
    category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_category_id BIGINT UNSIGNED DEFAULT NULL,
    category_name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_categories_slug (slug),
    KEY idx_categories_parent (parent_category_id),
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_category_id)
        REFERENCES categories(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id BIGINT UNSIGNED NOT NULL,
    product_name VARCHAR(180) NOT NULL,
    brand VARCHAR(100) DEFAULT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    status ENUM('active', 'draft', 'out_of_stock', 'archived') NOT NULL DEFAULT 'active',
    is_featured TINYINT(1) NOT NULL DEFAULT 0,
    is_new_arrival TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    KEY idx_products_category (category_id),
    KEY idx_products_name (product_name),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (base_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_variants (
    variant_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id BIGINT UNSIGNED NOT NULL,
    sku VARCHAR(100) NOT NULL,
    size_label VARCHAR(30) NOT NULL,
    colour VARCHAR(50) NOT NULL,
    variant_price DECIMAL(10,2) DEFAULT NULL,
    stock_quantity INT UNSIGNED NOT NULL DEFAULT 0,
    status ENUM('active', 'inactive', 'discontinued') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (variant_id),
    UNIQUE KEY uq_variants_sku (sku),
    KEY idx_variants_product (product_id),
    KEY idx_variants_sku_lookup (sku),
    CONSTRAINT fk_variants_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (stock_quantity >= 0),
    CHECK (variant_price IS NULL OR variant_price >= 0),
    CHECK (size_label <> ''),
    CHECK (colour <> '')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_images (
    image_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id BIGINT UNSIGNED NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255) DEFAULT NULL,
    display_order INT UNSIGNED NOT NULL DEFAULT 0,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (image_id),
    KEY idx_product_images_product_order (product_id, display_order),
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (is_primary IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Carts and cart items
-- -----------------------------------------------------------------------------
CREATE TABLE carts (
    cart_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED DEFAULT NULL,
    session_id VARCHAR(128) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (cart_id),
    UNIQUE KEY uq_carts_user (user_id),
    UNIQUE KEY uq_carts_session (session_id),
    KEY idx_carts_session (session_id),
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK ((user_id IS NOT NULL OR session_id IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart_items (
    cart_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cart_id BIGINT UNSIGNED NOT NULL,
    product_variant_id BIGINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (cart_item_id),
    UNIQUE KEY uq_cart_variant_line (cart_id, product_variant_id),
    KEY idx_cart_items_cart_variant (cart_id, product_variant_id),
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id)
        REFERENCES carts(cart_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_variant FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(variant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Orders, order items, payments, shipment records, discounts
-- -----------------------------------------------------------------------------
CREATE TABLE discounts (
    discount_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    coupon_code VARCHAR(50) NOT NULL,
    discount_type ENUM('percentage', 'fixed_amount') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_value DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    start_date DATETIME NOT NULL,
    expiry_date DATETIME NOT NULL,
    usage_limit INT UNSIGNED DEFAULT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (discount_id),
    UNIQUE KEY uq_discounts_coupon_code (coupon_code),
    CHECK (discount_value > 0),
    CHECK (minimum_order_value >= 0),
    CHECK (usage_limit IS NULL OR usage_limit > 0),
    CHECK (active IN (0, 1)),
    CHECK (expiry_date > start_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number VARCHAR(40) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    discount_id BIGINT UNSIGNED DEFAULT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') NOT NULL DEFAULT 'pending',
    payment_status ENUM('unpaid', 'pending', 'paid', 'failed', 'refunded', 'partially_paid') NOT NULL DEFAULT 'unpaid',
    subtotal DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'NGN',
    delivery_address_id BIGINT UNSIGNED DEFAULT NULL,
    recipient_name VARCHAR(120) NOT NULL,
    recipient_phone VARCHAR(25) NOT NULL,
    delivery_street VARCHAR(255) NOT NULL,
    delivery_city VARCHAR(100) NOT NULL,
    delivery_state VARCHAR(100) NOT NULL,
    delivery_postal_code VARCHAR(20) DEFAULT NULL,
    delivery_country VARCHAR(100) NOT NULL DEFAULT 'Nigeria',
    customer_notes TEXT,
    discount_code_snapshot VARCHAR(50) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id),
    UNIQUE KEY uq_orders_number (order_number),
    KEY idx_orders_user_date (user_id, order_date),
    KEY idx_orders_status (order_status),
    KEY idx_orders_discount (discount_id),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_discount FOREIGN KEY (discount_id)
        REFERENCES discounts(discount_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_delivery_address FOREIGN KEY (delivery_address_id)
        REFERENCES addresses(address_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CHECK (subtotal >= 0),
    CHECK (discount_amount >= 0),
    CHECK (delivery_fee >= 0),
    CHECK (total_amount >= 0),
    CHECK (CHAR_LENGTH(order_number) >= 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_items (
    item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    variant_id BIGINT UNSIGNED DEFAULT NULL,
    product_name_snapshot VARCHAR(180) NOT NULL,
    variant_name_snapshot VARCHAR(80) DEFAULT NULL,
    sku_snapshot VARCHAR(100) DEFAULT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    line_total DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (item_id),
    KEY idx_order_items_order (order_id),
    KEY idx_order_items_product (product_id),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_items_variant FOREIGN KEY (variant_id)
        REFERENCES product_variants(variant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (unit_price >= 0),
    CHECK (quantity > 0),
    CHECK (line_total >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payments (
    payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    payment_provider ENUM('paystack', 'flutterwave', 'wallet', 'bank_transfer', 'cash_on_delivery') NOT NULL,
    payment_reference VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'NGN',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded', 'cancelled') NOT NULL DEFAULT 'pending',
    provider_transaction_id VARCHAR(100) DEFAULT NULL,
    paid_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (payment_id),
    UNIQUE KEY uq_payments_reference (payment_reference),
    KEY idx_payments_order (order_id),
    KEY idx_payments_ref (payment_reference),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE shipments (
    shipment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    delivery_provider VARCHAR(80) NOT NULL,
    tracking_reference VARCHAR(100) NOT NULL,
    shipment_status ENUM('pending', 'packed', 'in_transit', 'out_for_delivery', 'delivered', 'failed') NOT NULL DEFAULT 'pending',
    dispatch_date TIMESTAMP NULL DEFAULT NULL,
    delivery_date TIMESTAMP NULL DEFAULT NULL,
    delivery_notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shipment_id),
    UNIQUE KEY uq_shipments_tracking_ref (tracking_reference),
    KEY idx_shipments_order (order_id),
    KEY idx_shipments_tracking (tracking_reference),
    CONSTRAINT fk_shipments_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE discount_usage (
    usage_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    discount_id BIGINT UNSIGNED NOT NULL,
    order_id BIGINT UNSIGNED NOT NULL,
    used_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usage_id),
    UNIQUE KEY uq_discount_usage_order (discount_id, order_id),
    KEY idx_discount_usage_discount (discount_id),
    CONSTRAINT fk_discount_usage_discount FOREIGN KEY (discount_id)
        REFERENCES discounts(discount_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_discount_usage_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Wishlist and reviews
-- -----------------------------------------------------------------------------
CREATE TABLE wishlists (
    wishlist_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    wishlist_name VARCHAR(120) NOT NULL DEFAULT 'My Wishlist',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wishlist_id),
    UNIQUE KEY uq_wishlists_user (user_id),
    CONSTRAINT fk_wishlists_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlist_items (
    wishlist_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    wishlist_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    variant_id BIGINT UNSIGNED DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wishlist_item_id),
    UNIQUE KEY uq_wishlist_product_variant (wishlist_id, product_id, variant_id),
    KEY idx_wishlist_items_product (product_id),
    CONSTRAINT fk_wishlist_items_wishlist FOREIGN KEY (wishlist_id)
        REFERENCES wishlists(wishlist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_items_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_items_variant FOREIGN KEY (variant_id)
        REFERENCES product_variants(variant_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reviews (
    review_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review_text TEXT,
    review_status ENUM('pending', 'approved', 'rejected', 'flagged') NOT NULL DEFAULT 'pending',
    is_verified_purchase TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id),
    UNIQUE KEY uq_reviews_user_product (user_id, product_id),
    KEY idx_reviews_product_created (product_id, created_at),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (rating BETWEEN 1 AND 5),
    CHECK (is_verified_purchase IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Audit log
-- -----------------------------------------------------------------------------
CREATE TABLE audit_logs (
    log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    actor_id BIGINT UNSIGNED DEFAULT NULL,
    action_type VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    entity_id BIGINT UNSIGNED DEFAULT NULL,
    metadata JSON DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id),
    KEY idx_audit_logs_actor_date (actor_id, created_at),
    CONSTRAINT fk_audit_logs_actor FOREIGN KEY (actor_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Final indexing and validation notes
-- -----------------------------------------------------------------------------
-- Core lookup indexes already included for transactions and catalogs.
-- The database intentionally does not use cascading delete for orders, payments,
-- shipments, or audit history because those records must remain stable for
-- accounting traceability and customer support.
