# Deploy Firestore Rules
Write-Host "Deploying Firestore Rules..." -ForegroundColor Cyan

Set-Location "C:\Peyimpanan Pribadi\Data D\New folder (2)\Semester 5\PBL 2025"

firebase deploy --only firestore:rules

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Firestore rules deployed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to deploy Firestore rules" -ForegroundColor Red
}

