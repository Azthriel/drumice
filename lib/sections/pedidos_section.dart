import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class PedidosSection extends StatelessWidget {
  const PedidosSection({super.key});

  static const _waUrl =
      'https://wa.me/5491154748921?text=Hola%20Drum%20Ice!%20Quiero%20hacer%20un%20pedido%20%F0%9F%8D%A6';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 80,
        vertical: 88,
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────
          Seo.text(
            text: '¿Cómo hacer un pedido?',
            style: TextTagStyle.h2,
            child: Text(
              '¿Cómo hacer un pedido?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 12),
          _AccentBar(),
          const SizedBox(height: 56),

          // ── Pasos ─────────────────────────────────────────────────
          isMobile
              ? Column(
                  children: _steps(context)
                      .map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: w,
                          ))
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _steps(context)
                      .map((w) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: w,
                            ),
                          ))
                      .toList(),
                ),

          const SizedBox(height: 72),

          // ── CTA card ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 28 : 52),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.softPink, AppTheme.paleBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                Seo.text(
                  text: '¡Pedí ahora por WhatsApp!',
                  style: TextTagStyle.h3,
                  child: Text(
                    '¡Pedí ahora por WhatsApp! 💬',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Seo.text(
                  text: '+54 9 11 5474-8921 · Solo retiro · Hurlingham, Buenos Aires',
                  child: Text(
                    '+54 9 11 5474-8921  ·  Solo retiro  ·  Hurlingham, Buenos Aires',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 36),
                Seo.link(
                  href: _waUrl,
                  anchor: 'Escribir a Drum Ice por WhatsApp para hacer un pedido de helado',
                  child: ElevatedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(_waUrl)),
                    icon: const Text('💬', style: TextStyle(fontSize: 22)),
                    label: const Text('Escribinos por WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.whatsappGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _steps(BuildContext context) {
    return [
      const _StepCard(
        number: '1',
        emoji: '📋',
        title: 'Elegí tus sabores',
        description:
            'Revisá nuestros 30 sabores y armá tu combinación favorita.',
      ),
      const _StepCard(
        number: '2',
        emoji: '💬',
        title: 'Escribinos por WhatsApp',
        description:
            'Mandanos un mensaje al +54 9 11 5474-8921 con tu pedido y acordamos el retiro.',
      ),
      const _StepCard(
        number: '3',
        emoji: '🏡',
        title: 'Retirá en Hurlingham',
        description:
            'Coordinamos día y horario. Venís y te llevás tu helado artesanal fresquito.',
      ),
    ];
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String emoji;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.palePink,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.pink.withValues(alpha:0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppTheme.pink,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: AppTheme.darkBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(emoji, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 16),
          Seo.text(
            text: title,
            style: TextTagStyle.h3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Seo.text(
            text: description,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 64,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.pink,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
