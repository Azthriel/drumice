import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../theme/app_theme.dart';

class HistoriaSection extends StatelessWidget {
  const HistoriaSection({super.key});

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
          // ── Título ───────────────────────────────────────────────
          Seo.text(
            text: '¿Qué es Drum Ice?',
            style: TextTagStyle.h2,
            child: Text(
              '¿Qué es Drum Ice?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 12),
          const _Divider(color: AppTheme.pink),
          const SizedBox(height: 56),

          // ── Tres tarjetas ─────────────────────────────────────────
          isMobile
              ? Column(
                  children: _cards(context)
                      .map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: w,
                          ))
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cards(context)
                      .map((w) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: w,
                            ),
                          ))
                      .toList(),
                ),

          const SizedBox(height: 72),

          // ── Historia larga ────────────────────────────────────────
          _HistoriaCard(isMobile: isMobile),
        ],
      ),
    );
  }

  List<Widget> _cards(BuildContext context) {
    return const [
      _InfoCard(
        emoji: '🏔️',
        color: AppTheme.paleBlue,
        accentColor: AppTheme.lightBlue,
        title: 'Drum Island',
        description:
            'Inspirados en la isla más nevada y acogedora de One Piece: '
            'el hogar del gran Doctor Tony Tony Chopper, donde la nieve y el cuidado van de la mano.',
      ),
      _InfoCard(
        emoji: '🍦',
        color: AppTheme.palePink,
        accentColor: AppTheme.pink,
        title: '30 Sabores',
        description:
            'Cada sabor es una aventura. Desde los clásicos de siempre hasta '
            'creaciones únicas que no vas a encontrar en ningún otro lado.',
      ),
      _InfoCard(
        emoji: '📦',
        color: Color(0xFFF0FFF4),
        accentColor: Color(0xFF9BDEAC),
        title: 'Solo retiro',
        description:
            'Coordinás el día y horario por WhatsApp, venís a Hurlingham '
            'y te llevás tu helado fresco y artesanal.',
      ),
    ];
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji;
  final Color color;
  final Color accentColor;
  final String title;
  final String description;

  const _InfoCard({
    required this.emoji,
    required this.color,
    required this.accentColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accentColor.withValues(alpha:0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha:0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 18),
          Seo.text(
            text: title,
            style: TextTagStyle.h3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 10),
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

class _HistoriaCard extends StatelessWidget {
  final bool isMobile;
  const _HistoriaCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 28 : 52),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.paleBlue, AppTheme.palePink],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _content(context),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏴‍☠️', style: TextStyle(fontSize: 64)),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _content(context),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _content(BuildContext context) {
    return [
      if (MediaQuery.of(context).size.width < 768) ...[
        const Text('🏴‍☠️', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
      ],
      Seo.text(
        text: 'La historia detrás de Drum Ice',
        style: TextTagStyle.h3,
        child: Text(
          'La historia detrás de Drum Ice',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      const SizedBox(height: 16),
      Seo.text(
        text:
            'Drum Ice nació del amor por los helados artesanales y por One Piece. '
            'Drum Island es la isla de Tony Tony Chopper, el médico más adorable de los Piratas Sombrero de Paja. '
            'Un lugar nevado, mágico, donde todo parece curar el alma. '
            'Esa misma energía es la que queremos transmitir con cada pote: '
            'helado hecho con cariño, sabores que sorprenden, y la calidez de algo verdaderamente artesanal.',
        child: Text(
          'Drum Ice nació del amor por los helados artesanales y por One Piece. '
          'Drum Island es la isla de Tony Tony Chopper, el médico más adorable de los Piratas Sombrero de Paja. '
          'Un lugar nevado, mágico, donde todo parece curar el alma. '
          'Esa misma energía es la que queremos transmitir con cada pote: '
          'helado hecho con cariño, sabores que sorprenden, y la calidez de algo verdaderamente artesanal.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ];
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
