// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://drumice.com.ar',
  trailingSlash: 'never',
  build: {
    format: 'file', // /404.html, /admin.html → Firebase con cleanUrls
  },
  image: {
    // Fotos de promos subidas desde /admin a Firebase Storage.
    // Astro las descarga en el build y genera el srcset optimizado.
    domains: ['firebasestorage.googleapis.com'],
  },
  vite: {
    // El SDK de Firebase del panel /admin pesa ~600 KB; solo se carga en /admin.
    build: { chunkSizeWarningLimit: 800 },
  },
  integrations: [
    sitemap({
      filter: (page) => !page.includes('/admin') && !page.includes('/404'),
      changefreq: 'weekly',
      priority: 1.0,
      lastmod: new Date(),
    }),
  ],
});
