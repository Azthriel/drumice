// Cloud Function `publicar`: el panel /admin la llama al tocar "Publicar cambios".
// Dispara el workflow de GitHub Actions (build de Astro + deploy a Hosting)
// mediante un repository_dispatch.

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';

initializeApp();

// Fine-grained PAT de GitHub con acceso SOLO a Azthriel/drumice,
// permiso "Contents: Read and write". Se carga con:
//   firebase functions:secrets:set GITHUB_TOKEN
const GITHUB_TOKEN = defineSecret('GITHUB_TOKEN');

const ADMIN_EMAIL = 'drumice26@gmail.com';
const REPO = 'Azthriel/drumice';

export const publicar = onCall(
  { region: 'us-east1', secrets: [GITHUB_TOKEN], maxInstances: 1, timeoutSeconds: 30 },
  async (request) => {
    const token = request.auth?.token;
    if (!token || token.email !== ADMIN_EMAIL || token.firebase?.sign_in_provider !== 'password') {
      throw new HttpsError('permission-denied', 'No autorizado.');
    }

    const res = await fetch(`https://api.github.com/repos/${REPO}/dispatches`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${GITHUB_TOKEN.value()}`,
        Accept: 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
        'User-Agent': 'drumice-publicar',
      },
      body: JSON.stringify({ event_type: 'publicar', client_payload: { por: token.email } }),
    });

    if (res.status !== 204) {
      const detalle = await res.text();
      console.error('GitHub dispatch falló', res.status, detalle);
      throw new HttpsError('internal', `GitHub respondió ${res.status}. Revisá el token GITHUB_TOKEN.`);
    }

    await getFirestore().doc('meta/estado').set(
      { cambiosPendientes: false, ultimaPublicacion: FieldValue.serverTimestamp() },
      { merge: true },
    );

    return { ok: true };
  },
);
