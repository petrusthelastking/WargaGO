# 🚀 CARA TEST GOOGLE SIGN IN (CEPAT)

## ✅ Perbaikan Sudah Selesai!

Saya sudah memperbaiki konfigurasi Google Sign In di `auth_provider.dart`.

## 📱 PILIH SALAH SATU:

### Opsi 1: Test di HP Fisik (TERCEPAT & RECOMMENDED) ⭐

```bash
# 1. Sambungkan HP ke laptop via USB
# 2. Aktifkan USB Debugging di HP
# 3. Jalankan perintah ini:

flutter run
```

**Selesai!** Google Sign In akan langsung berfungsi di HP fisik.

---

### Opsi 2: Test di Emulator dengan Google Play

**Pastikan emulator punya Google Play Services:**

1. Buka **Android Studio**
2. **Tools** → **Device Manager**
3. **Create Device**
4. Pilih device (contoh: Pixel 6)
5. **PENTING:** Pilih System Image yang ada **logo Play Store** ▶️
   - Contoh: **API 33** dengan **Play Store**
   - Jangan pilih yang cuma tulisan "Google APIs"
6. Finish
7. Start emulator
8. Run: `flutter run`

---

### Opsi 3: Build APK & Install di HP

```bash
# Build APK
flutter build apk --release

# APK ada di:
# build/app/outputs/flutter-apk/app-release.apk

# Transfer ke HP via:
# - USB
# - WhatsApp
# - Google Drive
# - Bluetooth

# Install di HP
```

---

## 🔧 Apa yang Sudah Diperbaiki?

### 1. File: `lib/core/providers/auth_provider.dart`

**SEBELUM:**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
  serverClientId: '693556950050-vp8tf6ib0a5vfsqik0m3lm46o1f0786o.apps.googleusercontent.com',
);
```

**SESUDAH:**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);
```

### 2. Error Handling Lebih Baik

Sekarang error message lebih jelas dan memberikan solusi.

---

## ⚠️ PENTING!

**Google Sign In TIDAK BISA di emulator tanpa Google Play Services!**

Jadi:
- ✅ **HP Fisik** → BISA
- ✅ **Emulator dengan Play Store** → BISA
- ❌ **Emulator tanpa Play Store** → TIDAK BISA

---

## 🎯 Quick Test

Setelah run aplikasi:

1. Klik **"Daftar sebagai Warga"**
2. Klik tombol **"Login dengan Google"**
3. Pilih akun Google
4. ✅ **Berhasil!**

ATAU

1. Di halaman login
2. Klik tombol **"Login dengan Google"**
3. Pilih akun Google
4. ✅ **Berhasil!**

---

## 🐛 Troubleshooting

### Jika masih error:

```bash
# Clean & rebuild
flutter clean
flutter pub get
flutter run --uninstall-first
```

### Check Google Play Services di HP:

1. Buka **Settings** di HP
2. **Apps** → **See all apps**
3. Cari **"Google Play Services"**
4. Pastikan sudah **terinstall** dan **update**

---

## 📞 Error Masih Muncul?

Kemungkinan besar:
- Menggunakan emulator tanpa Google Play
- Google Play Services belum update di HP

**Solusi:** Gunakan HP fisik atau emulator dengan Play Store ✅

---

**Status:** ✅ SIAP TEST
**Waktu:** < 5 menit
**Rekomendasi:** Gunakan HP fisik untuk hasil terbaik

