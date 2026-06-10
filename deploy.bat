@echo off
REM deploy.bat – Drum Ice · Flutter Web + Firebase Hosting
REM Patrón idéntico al de atumesatodocaserito.com.ar

echo 🍦 Drum Ice – Build y Deploy

REM Leer versión desde pubspec.yaml (requiere git bash o WSL para el grep)
FOR /F "tokens=2 delims= " %%A IN ('findstr /R "^version:" pubspec.yaml') DO SET FULL_VERSION=%%A
FOR /F "tokens=1 delims=+" %%A IN ("%FULL_VERSION%") DO SET VERSION=%%A
FOR /F "tokens=2 delims=+" %%A IN ("%FULL_VERSION%") DO SET BUILD=%%A

echo Version: %VERSION%+%BUILD%

REM Generar version.json
echo { "version": "%VERSION%", "build": "%BUILD%" } > web\version.json
echo ✅ version.json generado

REM Build Flutter Web
echo 🔨 Compilando Flutter Web...
flutter build web --release --base-href "/"
if errorlevel 1 (
  echo ❌ Error en flutter build
  exit /b 1
)

echo ✅ Build exitoso en build/web/

REM Deploy Firebase
echo 🚀 Desplegando a Firebase...
firebase deploy --only hosting
if errorlevel 1 (
  echo ❌ Error en firebase deploy
  exit /b 1
)

echo.
echo ✅ ¡Drum Ice desplegado! 🍦
