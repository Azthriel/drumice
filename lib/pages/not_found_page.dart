import 'package:drum_ice/utils/whatsapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import '../theme/app_theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Seo.head(
      tags: const [
        MetaTag(
            name: 'title', content: '404 - Página no encontrada | Drum Ice'),
        MetaTag(name: 'robots', content: 'noindex, follow'),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 32 : 80,
              vertical: 64,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Ilustración ──────────────────────────────────────
                Container(
                  width: isMobile ? 180 : 220,
                  height: isMobile ? 180 : 220,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [AppTheme.softPink, AppTheme.palePink],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.pink.withValues(alpha: 0.3),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '🏔️',
                      style: TextStyle(fontSize: isMobile ? 72 : 90),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── 404 ──────────────────────────────────────────────
                Seo.text(
                  text: '404',
                  style: TextTagStyle.h1,
                  child: Text(
                    '404',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: isMobile ? 80 : 100,
                          color: AppTheme.pink,
                          letterSpacing: -4,
                        ),
                  ),
                ),

                const SizedBox(height: 8),

                Seo.text(
                  text: 'Esta isla no existe en el Grand Line',
                  style: TextTagStyle.h2,
                  child: Text(
                    'Esta isla no existe en el Grand Line',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),

                const SizedBox(height: 16),

                Seo.text(
                  text:
                      'Parece que te perdiste navegando. La página que buscás no existe, pero nuestros helados sí.',
                  child: Text(
                    'Parece que te perdiste navegando. La página que buscás no existe,\npero nuestros helados sí. 🍦',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                const SizedBox(height: 48),

                // ── CTAs ─────────────────────────────────────────────
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (_) => false),
                      icon: const Text('🏠', style: TextStyle(fontSize: 18)),
                      label: const Text('Volver al inicio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.pink,
                        foregroundColor: AppTheme.darkBrown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => launchWhatsApp('+5491176025184',
                          '¡Hola Drum Ice! Me perdí buscando una página, pero quiero hacer un pedido.',
                          source: '404_page'),
                      icon: const Text('💬', style: TextStyle(fontSize: 18)),
                      label: const Text('Hacer un pedido'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.darkBrown,
                        side:
                            const BorderSide(color: AppTheme.pink, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 17,
                        ),
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
