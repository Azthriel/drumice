// Datos fijos del negocio. Un solo lugar para cambiarlos.

export const SITE = {
  name: 'Drum Ice',
  url: 'https://drumice.com.ar',
  title: 'Drum Ice 🍦 | Heladería Artesanal - Hurlingham, Buenos Aires',
  locality: 'Hurlingham',
  region: 'Buenos Aires',
  instagram: 'https://www.instagram.com/drum.ice_/',
  maps: 'https://maps.google.com/?q=Hurlingham+Buenos+Aires',
  onePieceWiki: 'https://onepiece.fandom.com/wiki/Drum_Island',
} as const;

export const PHONE = {
  wa: '5491176025184', // formato wa.me
  display: '+54 9 11 7602-5184',
  e164: '+5491176025184',
} as const;

export const WA_DEFAULT_MSG =
  '¡Hola Drum Ice! Vengo de la página y quiero hacer un pedido.';

export function waLink(message: string = WA_DEFAULT_MSG): string {
  return `https://wa.me/${PHONE.wa}?text=${encodeURIComponent(message)}`;
}
