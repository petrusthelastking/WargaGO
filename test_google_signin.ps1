#!/usr/bin/env pwsh
# Quick Test Google Sign In
# File: test_google_signin.ps1

Write-Host "🚀 Testing Google Sign In..." -ForegroundColor Cyan
Write-Host ""

# Check if device is connected
Write-Host "📱 Checking connected devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "⚠️  PENTING!" -ForegroundColor Yellow
Write-Host "Google Sign In hanya berfungsi di:" -ForegroundColor White
Write-Host "  ✅ HP fisik" -ForegroundColor Green
Write-Host "  ✅ Emulator dengan Google Play Store" -ForegroundColor Green
Write-Host "  ❌ Emulator tanpa Google Play" -ForegroundColor Red
Write-Host ""

$continue = Read-Host "Lanjut test? (Y/n)"
if ($continue -eq "n" -or $continue -eq "N") {
    Write-Host "❌ Test dibatalkan" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "🧹 Cleaning project..." -ForegroundColor Yellow
flutter clean

Write-Host ""
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "🚀 Running app..." -ForegroundColor Yellow
flutter run --uninstall-first

Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green

