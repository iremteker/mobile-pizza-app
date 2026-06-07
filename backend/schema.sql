-- ============================================
-- Pizza Teslimat Uygulaması - MySQL Şeması
-- ============================================
-- Kullanım: mysql -u root -p < schema.sql
-- ============================================

CREATE DATABASE IF NOT EXISTS pizza_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pizza_app;

-- Kullanıcılar tablosu
CREATE TABLE IF NOT EXISTS users (
  id          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  uid         VARCHAR(36)  NOT NULL UNIQUE,
  email       VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  name        VARCHAR(255) NOT NULL,
  phone       VARCHAR(50),
  address     TEXT,
  photo_url   VARCHAR(500) DEFAULT NULL,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_email (email),
  INDEX idx_users_uid (uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pizzalar tablosu
CREATE TABLE IF NOT EXISTS pizzas (
  id           INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(255)  NOT NULL,
  description  TEXT          NOT NULL,
  image_url    VARCHAR(500)  DEFAULT '',
  base_price   DECIMAL(10,2) NOT NULL,
  category     VARCHAR(100)  NOT NULL,
  ingredients  JSON          NOT NULL,
  is_popular   BOOLEAN       NOT NULL DEFAULT FALSE,
  is_vegetarian BOOLEAN      NOT NULL DEFAULT FALSE,
  rating       DECIMAL(3,2)  NOT NULL DEFAULT 4.00,
  review_count INT           NOT NULL DEFAULT 0,
  created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_pizzas_category (category),
  INDEX idx_pizzas_popular (is_popular)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Siparişler tablosu
CREATE TABLE IF NOT EXISTS orders (
  id               INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id          VARCHAR(36)   NOT NULL,
  subtotal         DECIMAL(10,2) NOT NULL,
  delivery_fee     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total            DECIMAL(10,2) NOT NULL,
  status           ENUM('preparing','onTheWay','delivered','cancelled') NOT NULL DEFAULT 'preparing',
  delivery_address TEXT          NOT NULL,
  note             TEXT          DEFAULT NULL,
  created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_orders_user (user_id),
  INDEX idx_orders_status (status),
  FOREIGN KEY (user_id) REFERENCES users(uid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sipariş öğeleri tablosu
CREATE TABLE IF NOT EXISTS order_items (
  id                 INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  order_id           INT           NOT NULL,
  pizza_data         JSON          NOT NULL,
  selected_size      VARCHAR(50)   NOT NULL,
  quantity           INT           NOT NULL DEFAULT 1,
  extra_ingredients  JSON          DEFAULT NULL,
  unit_price         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total_price        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order_items_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- ÖRNEK PIZZA VERİLERİ (Seed Data)
-- ============================================

INSERT INTO pizzas (name, description, image_url, base_price, category, ingredients, is_popular, is_vegetarian, rating, review_count) VALUES
(
  'Margherita',
  'İtalyan mutfağının vazgeçilmezi. Taze mozzarella, domates sosu ve fesleğen ile hazırlanan klasik pizza.',
  'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
  89.90, 'Klasik',
  '["Mozzarella", "Domates Sosu", "Fesleğen", "Zeytinyağı"]',
  TRUE, TRUE, 4.50, 234
),
(
  'Pepperoni',
  'Bol pepperoni dilimi, mozzarella peyniri ve özel domates sosumuz ile hazırlanır.',
  'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
  99.90, 'Klasik',
  '["Pepperoni", "Mozzarella", "Domates Sosu"]',
  TRUE, FALSE, 4.70, 456
),
(
  'Karışık Pizza',
  'Sucuk, sosis, mantar, biber, mısır, zeytin ve mozzarella peyniri ile dolu dolu bir lezzet.',
  'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
  119.90, 'Özel',
  '["Sucuk", "Sosis", "Mantar", "Biber", "Mısır", "Zeytin", "Mozzarella"]',
  TRUE, FALSE, 4.80, 567
),
(
  'Quattro Formaggi',
  'Dört çeşit peynirin mükemmel uyumu: Mozzarella, cheddar, parmesan ve rokfor.',
  'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
  109.90, 'Özel',
  '["Mozzarella", "Cheddar", "Parmesan", "Rokfor"]',
  FALSE, TRUE, 4.30, 189
),
(
  'Vejeteryan',
  'Taze sebzelerle dolu: Mantar, biber, soğan, domates, mısır ve zeytin.',
  'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?w=400',
  94.90, 'Vejetaryen',
  '["Mantar", "Biber", "Soğan", "Domates", "Mısır", "Zeytin", "Mozzarella"]',
  FALSE, TRUE, 4.20, 145
),
(
  'Tavuk Ranch',
  'Izgara tavuk parçaları, ranch sos, mozzarella peyniri ve taze sebzeler.',
  'https://images.unsplash.com/photo-1594007654729-407eedc4be65?w=400',
  114.90, 'Tavuklu',
  '["Izgara Tavuk", "Ranch Sos", "Mozzarella", "Mısır", "Domates"]',
  TRUE, FALSE, 4.60, 321
),
(
  'BBQ Tavuk',
  'Barbekü soslu tavuk parçaları, soğan halkaları, mozzarella ve cheddar peyniri.',
  'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400',
  119.90, 'Tavuklu',
  '["Tavuk", "BBQ Sos", "Soğan", "Mozzarella", "Cheddar"]',
  FALSE, FALSE, 4.40, 278
),
(
  'Sucuklu Pizza',
  'Bol sucuk, kaşar peyniri ve domates sosu ile hazırlanan Türk usulü pizza.',
  'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=400',
  104.90, 'Etli',
  '["Sucuk", "Kaşar", "Domates Sosu", "Biber"]',
  TRUE, FALSE, 4.60, 432
),
(
  'Ton Balıklı',
  'Ton balığı, soğan, mısır, mozzarella ve özel deniz ürünleri sosu.',
  'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400',
  124.90, 'Deniz Ürünleri',
  '["Ton Balığı", "Soğan", "Mısır", "Mozzarella", "Kapari"]',
  FALSE, FALSE, 4.10, 98
),
(
  'Kuşbaşılı Pizza',
  'Özel marine edilmiş kuşbaşı et, biber, soğan ve özel baharat karışımı.',
  'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
  134.90, 'Etli',
  '["Kuşbaşı Et", "Biber", "Soğan", "Domates", "Baharatlar", "Mozzarella"]',
  TRUE, FALSE, 4.90, 387
),
(
  'Hawaiian',
  'Ananas, jambon, mozzarella peyniri ve domates sosu ile tropikal bir lezzet.',
  'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400',
  104.90, 'Özel',
  '["Ananas", "Jambon", "Mozzarella", "Domates Sosu"]',
  FALSE, FALSE, 3.90, 167
),
(
  'Akdeniz',
  'Zeytinyağı, feta peyniri, domates, zeytin, kapari ve kekik ile Akdeniz esintisi.',
  'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=400',
  109.90, 'Vejetaryen',
  '["Feta", "Domates", "Zeytin", "Kapari", "Kekik", "Zeytinyağı"]',
  FALSE, TRUE, 4.30, 156
);
