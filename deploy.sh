#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "==============================="
echo "  Quarks Studio - Deploy Web"
echo "==============================="

if [ ! -f package.json ]; then
    echo "ERROR: package.json no encontrado. Ejecutá el script desde la raíz del proyecto."
    exit 1
fi

echo "[1/3] Instalando dependencias..."
npm ci

echo "[2/3] Build de Astro (lee sabores y promos de Firestore)..."
rm -rf dist
npm run build

echo "[3/3] Deploy a Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo "[OK] Deploy completado - v$(node -p "require('./package.json').version")"
