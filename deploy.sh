#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "==============================="
echo "  Quarks Studio - Deploy Web"
echo "==============================="

if [ ! -f pubspec.yaml ]; then
    echo "ERROR: pubspec.yaml no encontrado."
    echo "Ejecuta el script desde la raiz del proyecto."
    exit 1
fi

# ── Leer version y escribir web/version.json via Python ─────────────────────
echo "[1/3] Leyendo version y generando web/version.json..."

VER=$(python3 - <<'EOF'
import re, json
content = open('pubspec.yaml', 'r', encoding='utf-8').read()
m = re.search(r'^version:\s*(.+)$', content, re.MULTILINE)
raw = m.group(1).strip()
parts = raw.split('+')
ver = parts[0]
build = int(parts[1]) if len(parts) > 1 else 0
print(raw)
open('web/version.json', 'w', encoding='utf-8').write(
    json.dumps({'version': ver, 'build_number': build}, indent=2) + '\n'
)
EOF
)

if [ -z "$VER" ]; then
    echo "ERROR: No se pudo leer la version de pubspec.yaml"
    exit 1
fi

echo "      OK: web/version.json generado - v$VER"
echo ""

# ── Flutter build web release ────────────────────────────────────────────────
echo "[2/3] Building Flutter Web release..."
flutter build web --release
echo ""

# ── Firebase deploy (solo hosting) ──────────────────────────────────────────
echo "[3/3] Deploying a Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo "[OK] Deploy completado - v$VER"