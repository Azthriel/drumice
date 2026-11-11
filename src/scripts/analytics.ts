// Mismos nombres de evento que AnalyticsService de Flutter,
// así los reportes de GA4/Firebase siguen andando sin cambios.

declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void;
  }
}

export function track(name: string, params: Record<string, unknown> = {}): void {
  window.gtag?.('event', name, params);
}

/** Cualquier <a data-wa-source="..."> dispara `whatsapp_click` con su source. */
export function initWhatsAppTracking(): void {
  document.addEventListener('click', (e) => {
    const link = (e.target as HTMLElement | null)?.closest<HTMLAnchorElement>('a[data-wa-source]');
    if (link) track('whatsapp_click', { source: link.dataset.waSource });
  });
}

export function logSaborSearch(query: string): void {
  track('search', { search_term: query });
}

export function logSaborResult(query: string, results: number): void {
  track('sabor_search_result', { query, results });
}
