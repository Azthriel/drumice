// Lectura de Firestore EN EL BUILD (no en el navegador) vía REST.
// Las colecciones `sabores` y `promos` tienen lectura pública en las reglas,
// así que no hacen falta credenciales: funciona igual en local y en GitHub Actions.

import seed from '../data/sabores-seed.json';
import { firebaseConfig } from './firebase-config';

export interface Sabor {
  id: string;
  nombre: string;
  orden: number;
  agotado: boolean;
  nuevo: boolean;
}

export interface Promo {
  id: string;
  titulo: string; // alt + SEO + mensaje de WhatsApp
  url: string; // download URL de Firebase Storage
  ancho: number;
  alto: number;
  orden: number;
  activa: boolean;
}

const PROJECT_ID = firebaseConfig.projectId;
const BASE = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents`;

type FsValue = {
  stringValue?: string;
  integerValue?: string;
  doubleValue?: number;
  booleanValue?: boolean;
};
type FsDoc = { name: string; fields?: Record<string, FsValue> };

function str(v?: FsValue, fallback = ''): string {
  return v?.stringValue ?? fallback;
}
function num(v?: FsValue, fallback = 0): number {
  if (v?.integerValue !== undefined) return Number(v.integerValue);
  if (v?.doubleValue !== undefined) return v.doubleValue;
  return fallback;
}
function bool(v?: FsValue, fallback = false): boolean {
  return v?.booleanValue ?? fallback;
}

async function listCollection(collection: string): Promise<FsDoc[]> {
  const docs: FsDoc[] = [];
  let pageToken = '';
  do {
    const url = `${BASE}/${collection}?pageSize=300${pageToken ? `&pageToken=${pageToken}` : ''}`;
    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`Firestore ${collection}: HTTP ${res.status} ${await res.text()}`);
    }
    const json = (await res.json()) as { documents?: FsDoc[]; nextPageToken?: string };
    docs.push(...(json.documents ?? []));
    pageToken = json.nextPageToken ?? '';
  } while (pageToken);
  return docs;
}

const idOf = (d: FsDoc) => d.name.split('/').pop() ?? '';

// Cache por build: index y 404 comparten los mismos datos sin pedirlos dos veces.
let saboresCache: Promise<Sabor[]> | undefined;
let promosCache: Promise<Promo[]> | undefined;

export function getSabores(): Promise<Sabor[]> {
  saboresCache ??= (async () => {
    try {
      const docs = await listCollection('sabores');
      if (docs.length === 0) {
        console.warn('[drumice] `sabores` está vacía en Firestore → uso sabores-seed.json');
        return seedSabores();
      }
      return docs
        .map((d) => ({
          id: idOf(d),
          nombre: str(d.fields?.nombre).trim(),
          orden: num(d.fields?.orden, 999),
          agotado: bool(d.fields?.agotado),
          nuevo: bool(d.fields?.nuevo),
        }))
        .filter((s) => s.nombre)
        .sort((a, b) => a.orden - b.orden || a.nombre.localeCompare(b.nombre, 'es'));
    } catch (err) {
      console.warn('[drumice] No pude leer `sabores` de Firestore → uso sabores-seed.json', (err as Error).message);
      return seedSabores();
    }
  })();
  return saboresCache;
}

export function getPromos(): Promise<Promo[]> {
  promosCache ??= (async () => {
    try {
      const docs = await listCollection('promos');
      return docs
        .map((d) => ({
          id: idOf(d),
          titulo: str(d.fields?.titulo, 'Promo Drum Ice').trim(),
          url: str(d.fields?.url),
          ancho: num(d.fields?.ancho, 1080),
          alto: num(d.fields?.alto, 1920),
          orden: num(d.fields?.orden, 999),
          activa: bool(d.fields?.activa, true),
        }))
        .filter((p) => p.activa && p.url)
        .sort((a, b) => a.orden - b.orden);
    } catch (err) {
      console.warn('[drumice] No pude leer `promos` de Firestore → sección oculta', (err as Error).message);
      return [];
    }
  })();
  return promosCache;
}

function seedSabores(): Sabor[] {
  return seed.map((s, i) => ({ id: `seed-${i}`, ...s}));
}
