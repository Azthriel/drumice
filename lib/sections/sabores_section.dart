import 'package:drum_ice/utils/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seo/seo.dart';

import '../data/sabores.dart';
import '../theme/app_theme.dart';

class SaboresSection extends StatefulWidget {
  const SaboresSection({super.key});

  @override
  State<SaboresSection> createState() => _SaboresSectionState();
}

class _SaboresSectionState extends State<SaboresSection> {
  String _query = '';

  List<Sabor> get _filtered {
    if (_query.trim().isEmpty) return sabores;
    final q = _query.toLowerCase();
    return sabores.where((s) => s.nombre.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: const Color(0xFFFAF5FF),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 80,
        vertical: 88,
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────
          Seo.text(
            text: 'Nuestros Sabores',
            style: TextTagStyle.h2,
            child: Text(
              'Nuestros Sabores',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 8),
          Seo.text(
            text: '30 sabores artesanales únicos para elegir',
            child: Text(
              '30 sabores artesanales únicos para elegir',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 12),
          _accentBar(AppTheme.lightBlue),
          const SizedBox(height: 44),

          // ── Buscador ─────────────────────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: TextField(
              onChanged: (v) {
                setState(() => _query = v);
                if (v.trim().length >= 3) {
                  // evita spam con cada letra
                  AnalyticsService.logSaborSearch(v);
                }
                if (v.trim().isNotEmpty) {
                  AnalyticsService.logSaborResult(
                    query: v,
                    results: _filtered.length,
                  );
                }
              },
              decoration: const InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 16,
                    color: AppTheme.lightBrown,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                hintText: 'Buscá tu sabor favorito...',
              ),
            ),
          ),
          const SizedBox(height: 48),

          // ── Grid de sabores ───────────────────────────────────────
          if (_filtered.isEmpty)
            _EmptyState(query: _query)
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _filtered.map((s) => _SaborChip(sabor: s)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _accentBar(Color color) => Container(
        width: 64,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class _SaborChip extends StatefulWidget {
  final Sabor sabor;
  const _SaborChip({required this.sabor});

  @override
  State<_SaborChip> createState() => _SaborChipState();
}

class _SaborChipState extends State<_SaborChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Seo.text(
        text: widget.sabor.nombre,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _hover ? AppTheme.softPink : AppTheme.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: _hover
                  ? AppTheme.pink
                  : AppTheme.pink.withValues(alpha: 0.35),
              width: _hover ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.pink.withValues(alpha: _hover ? 0.18 : 0.06),
                blurRadius: _hover ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.iceCream,
                size: 13,
                color: _hover
                    ? AppTheme.darkBrown
                    : AppTheme.pink.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                widget.sabor.nombre,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkBrown,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FaIcon(
          FontAwesomeIcons.faceSadTear,
          size: 48,
          color: AppTheme.lightBrown,
        ),
        const SizedBox(height: 16),
        Seo.text(
          text: 'No encontramos "$query" entre nuestros sabores.',
          child: Text(
            'No encontramos "$query" entre nuestros sabores.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '¡Pero podés sugerirlo por WhatsApp!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
