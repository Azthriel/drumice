# Drum Ice 🍦

Landing de **Drum Ice**, heladería artesanal en Hurlingham inspirada en Drum Island de One Piece.
Astro (SSG) + Firebase (Hosting, Firestore, Storage, Auth). Desarrollado por [Quarks Studio](https://quarks-studio.com).

## Cómo funciona

- El sitio es **100% estático**. En el build, `src/lib/data.ts` lee las colecciones `sabores` y `promos`
  de Firestore por REST (lectura pública) y las deja en el HTML → SEO completo sin JS.
- Si Firestore no responde o `sabores` está vacía, usa `src/data/sabores-seed.json` (los 30 sabores originales).
  Si `promos` está vacía, la sección Promociones y su link del menú no se renderizan.
- Las fotos de promos viven en Firebase Storage; Astro las descarga en el build y genera WebP en varios anchos (`srcset`).

## Desarrollo

```bash
npm install
npm run dev            # http://localhost:4321
npm run build          # genera dist/
npm run preview
```

Requiere Node `>=22.23.4` (lo pide Astro 7).

## Deploy manual

```bash
./deploy.sh     # Linux/Mac
deploy.bat      # Windows
```

## Estructura

```
src/
  components/   Navbar, Hero, Historia, Promos, Sabores, Pedidos, Footer, QuarksFooter, Icon
  layouts/      Base.astro (metas, OG, JSON-LD, analytics)
  lib/          site.ts (teléfono, links), data.ts (Firestore REST)
  scripts/      analytics.ts (mismos eventos que la versión Flutter)
  pages/        index.astro, 404.astro
  data/         sabores-seed.json
public/         fuente, íconos PWA, og-image, robots.txt, kill-switch del SW de Flutter
```

## Panel /admin

Login con contraseña de `drumice26@gmail.com` (Firebase Auth). Permite:
- Sabores: agregar, renombrar, ordenar, marcar **Nuevo** / **Agotado**, borrar, importar los 30 iniciales.
- Promos: subir foto (se comprime en el navegador a WebP ≤1080×1920), título, ordenar, ocultar, borrar.
- **Publicar cambios** → Cloud Function `publicar` → `repository_dispatch` → GitHub Actions hace build + deploy (~1-2 min).

Config pública de Firebase en `src/lib/firebase-config.ts`. Reglas en `firestore.rules` y `storage.rules`.

## Modelo de datos (Firestore)

`sabores/{id}`: `nombre` (string), `orden` (number), `agotado` (bool), `nuevo` (bool)

`promos/{id}`: `titulo` (string, alt/SEO), `url` (string, download URL), `path` (string, ruta en Storage),
`ancho`, `alto` (number, px), `orden` (number), `activa` (bool)

## Puesta en marcha (una sola vez)

1. Authentication → habilitar Email/Password y crear el usuario `drumice26@gmail.com`.
2. Crear Firestore (modo producción) si no existe.
3. `firebase deploy --only firestore:rules,storage`
4. Token de GitHub (fine-grained, solo este repo, Contents: Read and write):
   `firebase functions:secrets:set GITHUB_TOKEN` y `firebase deploy --only functions`
5. `firebase init hosting:github` → crea el secret `FIREBASE_SERVICE_ACCOUNT_DRUMICE_EF734` en el repo.
