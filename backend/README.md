# Pizza App Backend — Node.js + MySQL REST API

## Kurulum

### 1. Gereksinimler
- Node.js >= 18
- MySQL >= 8.0

### 2. Veritabanı Kurulumu

```bash
# MySQL'e bağlan
mysql -u root -p

# Şemayı ve örnek verileri yükle
mysql -u root -p < schema.sql
```

### 3. Çevre Değişkenleri

```bash
cp .env.example .env
# .env dosyasını kendi ayarlarınıza göre düzenleyin
```

**`.env` içeriği:**
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=YOUR_MYSQL_PASSWORD
DB_NAME=pizza_app
JWT_SECRET=guclu_ve_uzun_bir_gizli_anahtar
JWT_EXPIRES_IN=30d
PORT=3000
```

### 4. Bağımlılıkları Yükle

```bash
npm install
```

### 5. Sunucuyu Başlat

```bash
# Geliştirme modu (otomatik yeniden başlatma)
npm run dev

# Üretim modu
npm start
```

## API Endpoint'leri

### Auth
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| POST | `/api/auth/register` | Kullanıcı kaydı |
| POST | `/api/auth/login` | Giriş yap |
| GET | `/api/auth/me` | Mevcut kullanıcı (JWT gerekir) |

### Pizzalar
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/api/pizzas` | Tüm pizzalar |
| GET | `/api/pizzas/popular` | Popüler pizzalar |
| GET | `/api/pizzas/category/:cat` | Kategoriye göre |
| GET | `/api/pizzas/search?q=...` | Arama |
| GET | `/api/pizzas/:id` | Belirli pizza |

### Siparişler (JWT gerekir)
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| POST | `/api/orders` | Sipariş oluştur |
| GET | `/api/orders/user/:userId` | Kullanıcı siparişleri |
| GET | `/api/orders/:id` | Belirli sipariş |

### Kullanıcı (JWT gerekir)
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/api/users/profile` | Profil bilgisi |
| PUT | `/api/users/profile` | Profil güncelle |

## Flutter'da URL Ayarı

`lib/config/api_config.dart` dosyasında `_host` değişkenini değiştirin:

- **Android Emülatör:** `10.0.2.2`
- **iOS Simülatör:** `localhost`
- **Fiziksel Cihaz:** Bilgisayarınızın LAN IP'si (örn: `192.168.1.100`)
