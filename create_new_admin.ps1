# ============================================================================
# CREATE NEW ADMIN SCRIPT
# ============================================================================
# Script untuk membuat admin baru di Firebase Auth dan Firestore
#
# Usage: .\create_new_admin.ps1
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🔧 CREATE NEW ADMIN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create temporary Dart script
$scriptContent = @'
import 'package:firebase_core/firebase_core.dart';
import 'package:jawara/create_admin.dart';
import 'firebase_options.dart';

void main() async {
  print('🚀 Initializing Firebase...\n');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized!\n');

    // Buat admin baru: admin2@jawara.com
    final service = AdminSetupService();

    final newAdmin = AdminUserData(
      email: 'admin2@jawara.com',
      password: 'admin123',
      nama: 'Admin 2 Jawara',
      nik: '3201234567890123',
      jenisKelamin: 'Laki-laki',
      noTelepon: '081234567899',
      alamat: 'Jl. Admin 2 No. 123',
    );

    print('========================================');
    print('📝 DATA ADMIN BARU:');
    print('========================================');
    print('Email:    ${newAdmin.email}');
    print('Password: ${newAdmin.password}');
    print('Nama:     ${newAdmin.nama}');
    print('NIK:      ${newAdmin.nik}');
    print('========================================\n');

    final success = await service.createAdminWithAuth(newAdmin);

    if (success) {
      print('========================================');
      print('✅ ADMIN BERHASIL DIBUAT!');
      print('========================================');
      print('Silakan login dengan:');
      print('  Email:    admin2@jawara.com');
      print('  Password: admin123');
      print('========================================');
    } else {
      print('========================================');
      print('❌ GAGAL MEMBUAT ADMIN!');
      print('========================================');
      print('Kemungkinan admin sudah ada.');
      print('Cek Firebase Console untuk detail.');
      print('========================================');
    }

  } catch (e) {
    print('\n❌ ERROR: $e');
  }
}
'@

$tempFile = "lib\temp_create_admin2.dart"

Write-Host "📝 Creating temporary script..." -ForegroundColor Yellow
$scriptContent | Out-File -FilePath $tempFile -Encoding UTF8

Write-Host "🚀 Running script..." -ForegroundColor Yellow
Write-Host ""

flutter run -d windows --target=$tempFile

Write-Host ""
Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
Remove-Item $tempFile -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ DONE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

