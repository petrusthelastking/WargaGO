@echo off
echo ========================================
echo Deploying Firestore Rules
echo ========================================
cd /d "C:\Peyimpanan Pribadi\Data D\New folder (2)\Semester 5\PBL 2025"
echo Current directory: %CD%
echo.
firebase deploy --only firestore:rules
echo.
echo ========================================
echo Done!
echo ========================================
pause

