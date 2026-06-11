@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===============================
echo   Quarks Studio - Deploy Web
echo ===============================

if not exist pubspec.yaml (
    echo ERROR: pubspec.yaml no encontrado.
    echo Ejecuta el script desde la raiz del proyecto.
    pause & exit /b 1
)

:: ── Leer version y escribir web\version.json via Python ─────────────────────
echo [1/3] Leyendo version y generando web\version.json...
python -c ^
"import re, json; ^
content=open('pubspec.yaml','r',encoding='utf-8').read(); ^
m=re.search(r'^version:\s*(.+)$',content,re.MULTILINE); ^
raw=m.group(1).strip(); ^
parts=raw.split('+'); ver=parts[0]; build=int(parts[1]) if len(parts)>1 else 0; ^
print('VER='+raw); ^
open('web/version.json','w',encoding='utf-8').write(json.dumps({'version':ver,'build_number':build},indent=2)+'\n'); ^
" > _ver_tmp.txt 2>&1

if errorlevel 1 (
    echo ERROR: Python no disponible o fallo el parseo.
    type _ver_tmp.txt
    del _ver_tmp.txt
    pause & exit /b 1
)

for /f "tokens=1,2 delims==" %%A in (_ver_tmp.txt) do (
    if "%%A"=="VER" set VER=%%B
)
del _ver_tmp.txt

if "!VER!"=="" (
    echo ERROR: No se pudo leer la version de pubspec.yaml
    pause & exit /b 1
)

echo       OK: web\version.json generado - v!VER!
echo.

:: ── Flutter build web release ────────────────────────────────────────────────
echo [2/3] Building Flutter Web release...
call flutter build web --release
if errorlevel 1 (
    echo ERROR: flutter build fallo.
    pause & exit /b 1
)
echo.

:: ── Firebase deploy (solo hosting) ──────────────────────────────────────────
echo [3/3] Deploying a Firebase Hosting...
call firebase deploy --only hosting
if errorlevel 1 (
    echo ERROR: Firebase deploy fallo.
    pause & exit /b 1
)

echo.
echo [OK] Deploy completado - v!VER!

endlocal