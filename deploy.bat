@echo off
setlocal
cd /d "%~dp0"

echo ===============================
echo   Quarks Studio - Deploy Web
echo ===============================

if not exist package.json (
    echo ERROR: package.json no encontrado. Ejecuta el script desde la raiz del proyecto.
    pause & exit /b 1
)

echo [1/3] Instalando dependencias...
call npm ci
if errorlevel 1 ( echo ERROR: npm ci fallo. & pause & exit /b 1 )

echo [2/3] Build de Astro (lee sabores y promos de Firestore)...
if exist dist rmdir /s /q dist
call npm run build
if errorlevel 1 ( echo ERROR: el build fallo. & pause & exit /b 1 )

echo [3/3] Deploy a Firebase Hosting...
call firebase deploy --only hosting
if errorlevel 1 ( echo ERROR: Firebase deploy fallo. & pause & exit /b 1 )

echo.
echo [OK] Deploy completado
endlocal
