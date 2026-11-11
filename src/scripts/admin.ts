// Panel /admin de Drum Ice: login, ABM de sabores y promos, y botón de publicar.

import { initializeApp } from 'firebase/app';
import {
  getAuth,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  sendPasswordResetEmail,
  signOut,
} from 'firebase/auth';
import {
  getFirestore,
  collection,
  doc,
  query,
  orderBy,
  onSnapshot,
  writeBatch,
  serverTimestamp,
  type DocumentReference,
  type WriteBatch,
} from 'firebase/firestore';
import { getStorage, ref, uploadBytesResumable, getDownloadURL, deleteObject } from 'firebase/storage';
import { getFunctions, httpsCallable } from 'firebase/functions';
import { firebaseConfig, ADMIN_EMAIL, FUNCTIONS_REGION } from '../lib/firebase-config';
import seed from '../data/sabores-seed.json';

interface Sabor {
  id: string;
  nombre: string;
  orden: number;
  agotado: boolean;
  nuevo: boolean;
}
interface Promo {
  id: string;
  titulo: string;
  url: string;
  path: string;
  ancho: number;
  alto: number;
  orden: number;
  activa: boolean;
}

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);
const storage = getStorage(app);
const functions = getFunctions(app, FUNCTIONS_REGION);

const $ = <T extends HTMLElement = HTMLElement>(sel: string) => document.querySelector<T>(sel)!;

let sabores: Sabor[] = [];
let promos: Promo[] = [];
let unsubs: (() => void)[] = [];

// ── Utilidades ──────────────────────────────────────────────────────
let toastTimer: number | undefined;
function toast(msg: string, error = false) {
  const el = $('#toast');
  el.textContent = msg;
  el.classList.toggle('err', error);
  el.hidden = false;
  window.clearTimeout(toastTimer);
  toastTimer = window.setTimeout(() => (el.hidden = true), error ? 6000 : 3000);
}

function fail(err: unknown, contexto: string) {
  console.error(contexto, err);
  const code = (err as { code?: string })?.code ?? '';
  const msg =
    code === 'permission-denied' || code === 'storage/unauthorized'
      ? 'Sin permiso. Volvé a iniciar sesión.'
      : code === 'unavailable'
        ? 'Sin conexión. Probá de nuevo.'
        : 'Algo salió mal. Probá de nuevo.';
  toast(`${contexto}: ${msg}`, true);
}

/** Toda escritura marca que hay cambios sin publicar, en el mismo batch. */
async function commit(fill: (b: WriteBatch) => void) {
  const b = writeBatch(db);
  fill(b);
  b.set(doc(db, 'meta', 'estado'), { cambiosPendientes: true, actualizado: serverTimestamp() }, { merge: true });
  await b.commit();
}

/** Reescribe `orden` = posición, solo en los docs que cambiaron. */
function reorder<T extends { id: string; orden: number }>(list: T[], from: number, to: number, col: string) {
  if (to < 0 || to >= list.length) return;
  const next = [...list];
  const [moved] = next.splice(from, 1);
  next.splice(to, 0, moved);
  commit((b) => {
    next.forEach((item, i) => {
      if (item.orden !== i + 1) b.update(doc(db, col, item.id), { orden: i + 1 });
    });
  }).catch((e) => fail(e, 'Reordenar'));
}

// ── Login ───────────────────────────────────────────────────────────
function showView(view: 'loading' | 'login' | 'app') {
  $('#loading').hidden = view !== 'loading';
  $('#login').hidden = view !== 'login';
  $('#app').hidden = view !== 'app';
}

function initLogin() {
  const form = $<HTMLFormElement>('#login-form');
  const err = $('#login-error');
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    err.hidden = true;
    const btn = form.querySelector<HTMLButtonElement>('button[type=submit]')!;
    btn.disabled = true;
    try {
      await signInWithEmailAndPassword(auth, ADMIN_EMAIL, $<HTMLInputElement>('#password').value);
      form.reset();
    } catch (e) {
      const code = (e as { code?: string }).code;
      err.textContent =
        code === 'auth/too-many-requests'
          ? 'Demasiados intentos. Esperá unos minutos.'
          : code === 'auth/network-request-failed'
            ? 'Sin conexión.'
            : 'Contraseña incorrecta.';
      err.hidden = false;
    } finally {
      btn.disabled = false;
    }
  });

  $('#forgot').addEventListener('click', async () => {
    try {
      await sendPasswordResetEmail(auth, ADMIN_EMAIL);
      toast(`Te mandamos un email a ${ADMIN_EMAIL} para cambiar la contraseña.`);
    } catch (e) {
      fail(e, 'Recuperar contraseña');
    }
  });

  $('#salir').addEventListener('click', () => signOut(auth));
}

// ── Tabs ────────────────────────────────────────────────────────────
function initTabs() {
  document.querySelectorAll<HTMLButtonElement>('.tab').forEach((tab) => {
    tab.addEventListener('click', () => {
      document.querySelectorAll<HTMLButtonElement>('.tab').forEach((t) => {
        const on = t === tab;
        t.setAttribute('aria-selected', String(on));
        $(`#tab-${t.dataset.tab}`).hidden = !on;
      });
    });
  });
}

// ── Estado de publicación ───────────────────────────────────────────
let publicando = false;
function initPublicar() {
  const btn = $<HTMLButtonElement>('#publicar');
  btn.addEventListener('click', async () => {
    btn.disabled = true;
    publicando = true;
    setEstado('publicando', 'Mandando a publicar…');
    try {
      await httpsCallable(functions, 'publicar')();
      setEstado('publicando', 'Publicando… la web se actualiza en 1 o 2 minutos.');
      toast('¡Listo! En 1 o 2 minutos se ven los cambios en la web.');
      window.setTimeout(() => {
        publicando = false;
        renderEstado(lastEstado);
      }, 120_000);
    } catch (e) {
      publicando = false;
      fail(e, 'Publicar');
      renderEstado(lastEstado);
    } finally {
      btn.disabled = false;
    }
  });
}

function setEstado(state: 'ok' | 'pendiente' | 'publicando', texto: string, detalle = '') {
  const el = $('#estado');
  el.dataset.state = state;
  el.textContent = texto;
  $('#estado-detalle').textContent = detalle;
}

type Estado = { cambiosPendientes?: boolean; ultimaPublicacion?: { toDate(): Date } };
let lastEstado: Estado = {};
function renderEstado(e: Estado) {
  lastEstado = e;
  if (publicando) return;
  const ultima = e.ultimaPublicacion?.toDate();
  const detalle = ultima
    ? `Última publicación: ${ultima.toLocaleString('es-AR', { dateStyle: 'short', timeStyle: 'short' })}`
    : '';
  if (e.cambiosPendientes) {
    setEstado('pendiente', 'Hay cambios sin publicar', detalle || 'Tocá "Publicar cambios" para que se vean en la web.');
  } else {
    setEstado('ok', 'Todo publicado', detalle);
  }
}

// ── Sabores ─────────────────────────────────────────────────────────
function initSabores() {
  const form = $<HTMLFormElement>('#sabor-form');
  const input = $<HTMLInputElement>('#sabor-nombre');
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const nombre = input.value.trim();
    if (!nombre) return;
    if (sabores.some((s) => s.nombre.toLowerCase() === nombre.toLowerCase())) {
      toast(`"${nombre}" ya está en la lista.`, true);
      return;
    }
    const orden = Math.max(0, ...sabores.map((s) => s.orden)) + 1;
    commit((b) => b.set(doc(collection(db, 'sabores')), { nombre, orden, agotado: false, nuevo: true }))
      .then(() => {
        input.value = '';
        toast(`Agregado "${nombre}" (marcado como Nuevo).`);
      })
      .catch((e) => fail(e, 'Agregar sabor'));
  });

  $('#importar').addEventListener('click', (e) => {
    (e.currentTarget as HTMLButtonElement).disabled = true;
    commit((b) => {
      seed.forEach((s) => b.set(doc(collection(db, 'sabores')), s));
    })
      .then(() => toast('Sabores importados.'))
      .catch((err) => fail(err, 'Importar sabores'));
  });

  const list = $('#sabores-list');
  list.addEventListener('click', (e) => {
    const btn = (e.target as HTMLElement).closest<HTMLButtonElement>('button[data-act]');
    const row = btn?.closest<HTMLElement>('.row');
    if (!btn || !row) return;
    const i = sabores.findIndex((s) => s.id === row.dataset.id);
    const s = sabores[i];
    const r = doc(db, 'sabores', s.id);
    switch (btn.dataset.act) {
      case 'up':
        return reorder(sabores, i, i - 1, 'sabores');
      case 'down':
        return reorder(sabores, i, i + 1, 'sabores');
      case 'nuevo':
        return commit((b) => b.update(r, { nuevo: !s.nuevo })).catch((er) => fail(er, 'Actualizar'));
      case 'agotado':
        return commit((b) => b.update(r, { agotado: !s.agotado })).catch((er) => fail(er, 'Actualizar'));
      case 'borrar':
        if (confirm(`¿Borrar "${s.nombre}"?`)) {
          commit((b) => b.delete(r))
            .then(() => toast(`Borrado "${s.nombre}".`))
            .catch((er) => fail(er, 'Borrar'));
        }
    }
  });

  // Renombrar al salir del campo o con Enter.
  list.addEventListener('change', (e) => {
    const el = e.target as HTMLInputElement;
    if (!el.classList.contains('nombre')) return;
    const id = el.closest<HTMLElement>('.row')!.dataset.id!;
    const nombre = el.value.trim();
    const actual = sabores.find((s) => s.id === id);
    if (!nombre || !actual) {
      el.value = actual?.nombre ?? '';
      return;
    }
    if (nombre === actual.nombre) return;
    commit((b) => b.update(doc(db, 'sabores', id), { nombre }))
      .then(() => toast('Nombre actualizado.'))
      .catch((er) => fail(er, 'Renombrar'));
  });
  list.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && (e.target as HTMLElement).classList.contains('nombre')) {
      (e.target as HTMLInputElement).blur();
    }
  });
}

function renderSabores() {
  const list = $('#sabores-list');
  const tpl = $<HTMLTemplateElement>('#tpl-sabor');
  const focused = document.activeElement as HTMLInputElement | null;
  const focusedId = focused?.classList.contains('nombre') ? focused.closest<HTMLElement>('.row')?.dataset.id : undefined;

  list.replaceChildren(
    ...sabores.map((s, i) => {
      const li = (tpl.content.cloneNode(true) as DocumentFragment).firstElementChild as HTMLElement;
      li.dataset.id = s.id;
      const input = li.querySelector<HTMLInputElement>('.nombre')!;
      input.value = s.nombre;
      li.querySelector<HTMLButtonElement>('[data-act=up]')!.disabled = i === 0;
      li.querySelector<HTMLButtonElement>('[data-act=down]')!.disabled = i === sabores.length - 1;
      li.querySelector('.t-nuevo')!.setAttribute('aria-pressed', String(s.nuevo));
      li.querySelector('.t-agotado')!.setAttribute('aria-pressed', String(s.agotado));
      return li;
    }),
  );
  // No perder el foco si alguien está editando mientras llega un snapshot.
  if (focusedId) list.querySelector<HTMLInputElement>(`[data-id="${focusedId}"] .nombre`)?.focus();

  $('#sabores-empty').hidden = sabores.length > 0;
  $('#count-sabores').textContent = `(${sabores.length})`;
}

// ── Promos ──────────────────────────────────────────────────────────
const MAX_W = 1080;
const MAX_H = 1920;

/** Redimensiona en el navegador y devuelve WebP (o JPEG si el navegador no codifica WebP). */
async function comprimir(file: File): Promise<{ blob: Blob; ancho: number; alto: number; ext: string }> {
  const bmp = await createImageBitmap(file);
  const escala = Math.min(1, MAX_W / bmp.width, MAX_H / bmp.height);
  const ancho = Math.round(bmp.width * escala);
  const alto = Math.round(bmp.height * escala);
  const canvas = document.createElement('canvas');
  canvas.width = ancho;
  canvas.height = alto;
  canvas.getContext('2d')!.drawImage(bmp, 0, 0, ancho, alto);
  bmp.close();
  const toBlob = (type: string, q: number) =>
    new Promise<Blob | null>((res) => canvas.toBlob(res, type, q));
  let blob = await toBlob('image/webp', 0.86);
  let ext = 'webp';
  if (!blob || blob.type !== 'image/webp') {
    blob = await toBlob('image/jpeg', 0.88);
    ext = 'jpg';
  }
  if (!blob) throw new Error('No se pudo procesar la imagen');
  return { blob, ancho, alto, ext };
}

function initPromos() {
  const form = $<HTMLFormElement>('#promo-form');
  const fileInput = $<HTMLInputElement>('#promo-file');
  const preview = $<HTMLImageElement>('#promo-preview');
  const aviso = $('#promo-aviso');
  const progress = $<HTMLProgressElement>('#promo-progress');
  const btn = $<HTMLButtonElement>('#promo-subir');

  fileInput.addEventListener('change', () => {
    const file = fileInput.files?.[0];
    aviso.hidden = true;
    if (!file) return;
    if (preview.src) URL.revokeObjectURL(preview.src);
    preview.src = URL.createObjectURL(file);
    preview.hidden = false;
    $('#drop-text').hidden = true;
    preview.onload = () => {
      const ratio = preview.naturalWidth / preview.naturalHeight;
      if (Math.abs(ratio - 9 / 16) > 0.04) {
        aviso.textContent =
          'Ojo: la foto no es vertical 9:16. Se va a mostrar completa, pero puede quedar distinta a las demás.';
        aviso.hidden = false;
      }
    };
  });

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const file = fileInput.files?.[0];
    const titulo = $<HTMLInputElement>('#promo-titulo').value.trim();
    if (!file || !titulo) return;

    btn.disabled = true;
    progress.hidden = false;
    progress.value = 0;
    try {
      const { blob, ancho, alto, ext } = await comprimir(file);
      const path = `promos/${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`;
      const task = uploadBytesResumable(ref(storage, path), blob, {
        contentType: blob.type,
        cacheControl: 'public, max-age=31536000, immutable',
      });
      task.on('state_changed', (snap) => {
        progress.value = (snap.bytesTransferred / snap.totalBytes) * 100;
      });
      await task;
      const url = await getDownloadURL(ref(storage, path));
      const orden = Math.max(0, ...promos.map((p) => p.orden)) + 1;
      await commit((b) =>
        b.set(doc(collection(db, 'promos')), {
          titulo,
          url,
          path,
          ancho,
          alto,
          orden,
          activa: true,
          creada: serverTimestamp(),
        }),
      );
      toast('Promo subida. Acordate de publicar.');
      form.reset();
      preview.hidden = true;
      preview.removeAttribute('src');
      $('#drop-text').hidden = false;
      aviso.hidden = true;
    } catch (err) {
      fail(err, 'Subir promo');
    } finally {
      btn.disabled = false;
      progress.hidden = true;
    }
  });

  const list = $('#promos-list');
  list.addEventListener('click', (e) => {
    const b = (e.target as HTMLElement).closest<HTMLButtonElement>('button[data-act]');
    const item = b?.closest<HTMLElement>('.promo-item');
    if (!b || !item) return;
    const i = promos.findIndex((p) => p.id === item.dataset.id);
    const p = promos[i];
    const r: DocumentReference = doc(db, 'promos', p.id);
    switch (b.dataset.act) {
      case 'up':
        return reorder(promos, i, i - 1, 'promos');
      case 'down':
        return reorder(promos, i, i + 1, 'promos');
      case 'activa':
        return commit((batch) => batch.update(r, { activa: !p.activa })).catch((er) => fail(er, 'Actualizar'));
      case 'borrar':
        if (!confirm(`¿Borrar la promo "${p.titulo}"? No se puede deshacer.`)) return;
        commit((batch) => batch.delete(r))
          .then(async () => {
            try {
              await deleteObject(ref(storage, p.path));
            } catch (er) {
              if ((er as { code?: string }).code !== 'storage/object-not-found') console.warn(er);
            }
            toast('Promo borrada. Acordate de publicar.');
          })
          .catch((er) => fail(er, 'Borrar promo'));
    }
  });

  list.addEventListener('change', (e) => {
    const el = e.target as HTMLInputElement;
    if (!el.classList.contains('titulo')) return;
    const id = el.closest<HTMLElement>('.promo-item')!.dataset.id!;
    const titulo = el.value.trim();
    const actual = promos.find((p) => p.id === id);
    if (!titulo || !actual) {
      el.value = actual?.titulo ?? '';
      return;
    }
    if (titulo === actual.titulo) return;
    commit((b) => b.update(doc(db, 'promos', id), { titulo }))
      .then(() => toast('Título actualizado.'))
      .catch((er) => fail(er, 'Actualizar título'));
  });
}

function renderPromos() {
  const list = $('#promos-list');
  const tpl = $<HTMLTemplateElement>('#tpl-promo');
  list.replaceChildren(
    ...promos.map((p, i) => {
      const li = (tpl.content.cloneNode(true) as DocumentFragment).firstElementChild as HTMLElement;
      li.dataset.id = p.id;
      li.classList.toggle('oculta', !p.activa);
      const img = li.querySelector('img')!;
      img.src = p.url;
      img.alt = p.titulo;
      li.querySelector<HTMLInputElement>('.titulo')!.value = p.titulo;
      li.querySelector<HTMLButtonElement>('[data-act=up]')!.disabled = i === 0;
      li.querySelector<HTMLButtonElement>('[data-act=down]')!.disabled = i === promos.length - 1;
      const vis = li.querySelector<HTMLButtonElement>('.t-visible')!;
      vis.setAttribute('aria-pressed', String(p.activa));
      vis.textContent = p.activa ? 'Visible' : 'Oculta';
      return li;
    }),
  );
  $('#promos-empty').hidden = promos.length > 0;
  $('#count-promos').textContent = `(${promos.length})`;
}

// ── Suscripciones en vivo ───────────────────────────────────────────
function subscribe() {
  unsubs.push(
    onSnapshot(query(collection(db, 'sabores'), orderBy('orden')), (snap) => {
      sabores = snap.docs.map((d) => ({ id: d.id, ...(d.data() as Omit<Sabor, 'id'>) }));
      renderSabores();
    }, (e) => fail(e, 'Cargar sabores')),
    onSnapshot(query(collection(db, 'promos'), orderBy('orden')), (snap) => {
      promos = snap.docs.map((d) => ({ id: d.id, ...(d.data() as Omit<Promo, 'id'>) }));
      renderPromos();
    }, (e) => fail(e, 'Cargar promos')),
    onSnapshot(doc(db, 'meta', 'estado'), (snap) => renderEstado((snap.data() as Estado) ?? {}),
      (e) => fail(e, 'Cargar estado')),
  );
}

function unsubscribe() {
  unsubs.forEach((u) => u());
  unsubs = [];
}

// ── Arranque ────────────────────────────────────────────────────────
export function initAdmin() {
  initLogin();
  initTabs();
  initPublicar();
  initSabores();
  initPromos();

  onAuthStateChanged(auth, (user) => {
    unsubscribe();
    if (user && user.email === ADMIN_EMAIL) {
      showView('app');
      subscribe();
    } else {
      if (user) signOut(auth); // cualquier otra cuenta, afuera
      showView('login');
      setTimeout(() => $<HTMLInputElement>('#password').focus(), 0);
    }
  });
}
