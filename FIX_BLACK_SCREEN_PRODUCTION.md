# Fix Black Screen di Production APK

## 🔴 Masalah

Setelah install APK dari Firebase App Distribution, aplikasi menampilkan **layar hitam** dan crash.

## 🔍 Penyebab

### 1. **File `.env` Tidak Ada di Production APK**
- File `.env` sudah dihapus dari assets untuk keamanan
- Tapi kode masih mencoba **load file `.env`** secara WAJIB
- `await dotenv.load(fileName: ".env")` → **CRASH** jika file tidak ada

### 2. **Static Initialization `dotenv.env[]`**
- `url_pcvk_api.dart` menggunakan `dotenv.env['PCVK_API_URL']` di static field
- Static field diinisialisasi saat class di-load
- Jika `.env` tidak ada → **CRASH** sebelum app berjalan

## ✅ Solusi yang Diterapkan

### 1. **Make `.env` Loading Optional** (`lib/main.dart`)

**SEBELUM (CRASH):**
```dart
await dotenv.load(fileName: ".env"); // CRASH jika file tidak ada
```

**SESUDAH (AMAN):**
```dart
// Load .env only if file exists (for local development/testing)
// In production APK, .env doesn't exist (for security reasons)
try {
  await dotenv.load(fileName: ".env");
  print('✅ .env file loaded (development mode)');
} catch (e) {
  print('ℹ️  .env file not found (production mode) - This is normal');
}
```

### 2. **Safe Dotenv Access** (`lib/core/configs/url_pcvk_api.dart`)

**SEBELUM (CRASH):**
```dart
class UrlPCVKAPI {
  static String azureUrl = dotenv.env['PCVK_API_URL'] ?? '';
  // ❌ Static initialization CRASH jika dotenv belum load
```

**SESUDAH (AMAN):**
```dart
class UrlPCVKAPI {
  // Use getter to safely access dotenv
  static String get azureUrl => dotenv.maybeGet('PCVK_API_URL') ?? '';
  
  static bool get isSSL => (dotenv.maybeGet('PCVK_API_HTTPS') ?? 'true') == 'true';
  // ✅ Lazy evaluation - tidak crash jika .env tidak ada
```

## 🧪 Testing

### Test Lokal (Development):
```bash
# 1. Pastikan .env ada
cp .env.example .env

# 2. Run app
flutter run

# Expected: ✅ .env file loaded (development mode)
```

### Test Production (Simulasi APK):
```bash
# 1. Hapus .env dari pubspec.yaml assets (sudah dilakukan)
# 2. Build release APK
flutter build apk --release

# 3. Install dan test
# Expected: ℹ️ .env file not found (production mode) - This is normal
# App berjalan normal tanpa crash
```

## 🔒 Keamanan Tetap Terjaga

### ✅ Production APK:
- Tidak ada file `.env`
- Tidak ada secrets
- Safe dari reverse engineering
- App berjalan normal dengan fallback values

### ✅ Development:
- File `.env` hanya di lokal
- Tidak di-commit (`.gitignore`)
- Developer bisa testing dengan credentials lokal

## 📋 Files yang Diubah

1. ✅ `lib/main.dart` - Optional `.env` loading
2. ✅ `lib/core/configs/url_pcvk_api.dart` - Safe dotenv access with getters

## 🚀 Deployment

Setelah perubahan ini:
1. ✅ Push ke GitHub
2. ✅ GitHub Actions build APK
3. ✅ APK di-upload ke Firebase App Distribution
4. ✅ Install APK → **App berjalan normal** (tidak black screen lagi!)

## 🎯 Checklist

- [x] Fix `.env` loading di `main.dart`
- [x] Fix static initialization di `url_pcvk_api.dart`
- [x] Test build lokal
- [ ] Commit & push changes
- [ ] Test APK dari Firebase App Distribution
- [ ] Verify app tidak crash/black screen lagi

## ⚠️ Important Notes

### Untuk Developer:
- File `.env` **HANYA untuk development lokal**
- **JANGAN** hard-code credentials di code
- Use Firebase Remote Config untuk config production

### Untuk Production:
- APK **TIDAK membutuhkan** file `.env`
- Semua config menggunakan fallback values yang aman
- Azure/PCVK features bisa disabled jika tidak ada config

## 🔧 Troubleshooting

### App masih black screen?
1. Uninstall APK lama sepenuhnya
2. Clear app data/cache
3. Install APK baru
4. Restart device jika perlu

### Azure features tidak jalan?
- Normal! Production APK tidak punya PCVK_API_URL
- Jika butuh Azure di production, use Firebase Remote Config atau build flavors

### Testing lokal tidak bisa load .env?
- Pastikan file `.env` ada di root project
- Copy dari `.env.example`
- Check `.gitignore` - pastikan `.env` tidak ter-commit

## 📚 References

- [flutter_dotenv Documentation](https://pub.dev/packages/flutter_dotenv)
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config)
- [Flutter Build Flavors](https://flutter.dev/docs/deployment/flavors)

