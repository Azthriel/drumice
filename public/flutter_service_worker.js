// Kill-switch del service worker de la versión Flutter.
// Quien visitó la web vieja puede tener registrado flutter_service_worker.js
// cacheando main.dart.js e index.html. El navegador busca actualizaciones de este
// archivo en cada navegación: al encontrar esta versión, borra los caches,
// se desregistra y recarga las pestañas abiertas con la web nueva.
// Se puede borrar dentro de unos meses.

self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(keys.map((k) => caches.delete(k)));
      await self.registration.unregister();
      const clients = await self.clients.matchAll({ type: 'window' });
      clients.forEach((client) => client.navigate(client.url));
    })(),
  );
});
