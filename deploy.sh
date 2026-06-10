#!/bin/bash
# deploy.sh – Drum Ice · Flutter Web + Firebase Hosting
# Patrón idéntico al de atumesatodocaserito.com.ar
set -e

# ── Leer versión desde pubspec.yaml ─────────────────────────────────
VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
BUILD=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)
echo "🍦 Drum Ice v$VERSION+$BUILD"

# ── Escribir version.json para quarks_version_checker ───────────────
cat > web/version.json << EOF
{
  "version": "$VERSION",
  "build": "$BUILD",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
echo "✅ version.json generado: v$VERSION+$BUILD"

# ── Build Flutter Web ────────────────────────────────────────────────
echo "🔨 Compilando Flutter Web..."
flutter build web --release --base-href "/"

echo "✅ Build exitoso en build/web/"

# ── Deploy Firebase Hosting ──────────────────────────────────────────
echo "🚀 Desplegando a Firebase..."
firebase deploy --only hosting

echo ""
echo "✅ ¡Drum Ice desplegado! 🍦"
