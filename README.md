# 🍕 Pizza Teslimatı - Mobil Sipariş Uygulaması

Domino's tarzı, tam işleyen bir Flutter pizza sipariş uygulaması. Firebase ile entegre, Türkçe arayüz.

## ✨ Özellikler

- 🔐 **Kullanıcı Girişi/Kaydı** - Firebase Auth ile email/şifre
- 🍕 **Pizza Menüsü** - 12 farklı pizza, 6 kategori
- 🔍 **Arama & Filtreleme** - İsim ve kategoriye göre
- 📏 **Boyut Seçimi** - Küçük, Orta, Büyük, Ekstra Büyük
- 🧀 **Ekstra Malzemeler** - Özelleştirilebilir siparişler
- 🛒 **Sepet Yönetimi** - Ekleme, çıkarma, adet kontrolü
- 💰 **Fiyat Hesaplama** - Ara toplam, teslimat ücreti, ücretsiz teslimat
- 📦 **Sipariş Oluşturma** - Firestore'a kaydetme
- 👤 **Profil Yönetimi** - Bilgi güncelleme
- 📜 **Sipariş Geçmişi** - Geçmiş siparişleri görüntüleme

## 🛠 Teknolojiler

| Teknoloji | Kullanım |
|-----------|----------|
| Flutter | UI Framework |
| Provider | State Management |
| Firebase Auth | Kimlik Doğrulama |
| Cloud Firestore | Veritabanı |
| Firebase Storage | Dosya Depolama |
| Google Fonts | Tipografi (Poppins) |
| Cached Network Image | Görsel önbellekleme |

## 📱 Ekranlar

1. **Splash Screen** - Logo animasyonu
2. **Welcome Screen** - Hoşgeldiniz sayfası
3. **Login Screen** - Giriş ekranı
4. **Register Screen** - Kayıt ekranı
5. **Home Screen** - Ana sayfa (popüler pizzalar, kategoriler)
6. **Pizza Options** - Menü listesi
7. **Pizza Detail** - Pizza detayı ve boyut seçimi
8. **Cart Screen** - Sepet ve sipariş
9. **Profile Screen** - Kullanıcı profili

## 🔥 Firebase Kurulumu

### 1. Firebase Projesi Oluşturma
1. [Firebase Console](https://console.firebase.google.com/) adresine gidin
2. Yeni proje oluşturun
3. Authentication > Email/Password yöntemini etkinleştirin
4. Firestore Database oluşturun (Production/Test mode)

### 2. Android Yapılandırması
1. Firebase Console'da Android uygulaması ekleyin
2. Package adı: `com.pizzadelivery.pizza_app`
3. İndirilen `google-services.json` dosyasını `android/app/` klasörüne koyun
   (mevcut placeholder dosyanın üzerine yazın)

### 3. iOS Yapılandırması (Opsiyonel)
1. Firebase Console'da iOS uygulaması ekleyin
2. Bundle ID: `com.pizzadelivery.pizzaApp`
3. `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne koyun

### 4. FlutterFire CLI (Alternatif - Kolay Yol)
```bash
# FlutterFire CLI kurulumu
dart pub global activate flutterfire_cli

# Firebase yapılandırması
flutterfire configure --project=YOUR_PROJECT_ID
```

## 🚀 Çalıştırma

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run

# Testleri çalıştır
flutter test

# APK oluştur
flutter build apk --release
```

## 🧪 Testler

34 unit test mevcuttur:
- **Sepet testleri** - Ekleme, çıkarma, adet güncelleme, fiyat hesaplama
- **Pizza model testleri** - Boyut fiyatlandırma, serileştirme
- **Sipariş testleri** - Durum metinleri, serileştirme
- **Kullanıcı testleri** - Model oluşturma, kopyalama

## 📂 Proje Yapısı

```
lib/
├── main.dart                       # Giriş noktası
├── app.dart                        # MaterialApp yapılandırması
├── constants/
│   ├── app_colors.dart             # Renk sabitleri
│   └── app_strings.dart            # Türkçe metinler
├── models/
│   ├── pizza_model.dart            # Pizza modeli
│   ├── cart_item_model.dart        # Sepet öğesi modeli
│   ├── order_model.dart            # Sipariş modeli
│   └── user_model.dart             # Kullanıcı modeli
├── providers/
│   ├── auth_provider.dart          # Auth state
│   ├── pizza_provider.dart         # Pizza state
│   ├── cart_provider.dart          # Sepet state
│   └── order_provider.dart         # Sipariş state
├── services/
│   ├── auth_service.dart           # Firebase Auth servisi
│   └── firestore_service.dart      # Firestore servisi
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── pizza_options_screen.dart
│   ├── pizza_detail_screen.dart
│   ├── cart_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── pizza_card.dart
│   ├── cart_item_widget.dart
│   ├── custom_text_field.dart
│   └── custom_button.dart
└── utils/
    ├── validators.dart
    └── helpers.dart
test/
├── cart_provider_test.dart
├── pizza_model_test.dart
└── order_test.dart
```

## 📝 Notlar

- Tüm metinler Türkçe
- Kod yorumları Türkçe
- 12 farklı pizza otomatik olarak Firestore'a eklenir
- 150₺ üzeri siparişlerde ücretsiz teslimat
- Modern UI: gradient, animasyon, glassmorphism
- Play Store'a yayımlamaya hazır
