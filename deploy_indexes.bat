@echo off
echo ========================================
echo Deploying Firestore Indexes
echo ========================================
cd /d "C:\Peyimpanan Pribadi\Data D\New folder (2)\Semester 5\PBL 2025"
echo Current directory: %CD%
echo.
echo Deploying indexes...
firebase deploy --only firestore:indexes
echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo SUCCESS! Indexes deployed
    echo ========================================
    echo.
    echo IMPORTANT: Index creation takes 3-5 minutes
    echo Please wait before testing the app
    echo.
    echo Check status:
    echo https://console.firebase.google.com/project/pbl-2025-35a1c/firestore/indexes
    echo.
) else (
    echo ========================================
    echo FAILED! Error deploying indexes
    echo ========================================
    echo Please check your Firebase login
)
echo.
pause

