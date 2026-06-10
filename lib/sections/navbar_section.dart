import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class NavbarSection extends StatefulWidget {
  final VoidCallback onHeroTap;
  final VoidCallback onHistoriaTap;
  final VoidCallback onSaboresTop;
  final VoidCallback onPedidosTap;

  const NavbarSection({
    super.key,
    required this.onHeroTap,
    required this.onHistoriaTap,
    required this.onSaboresTop,
    required this.onPedidosTap,
  });

  @override
  State<NavbarSection> createState() => _NavbarSectionState();
}

class _NavbarSectionState extends State<NavbarSection> {
  // bool _isScrolled = false;

  // Sticky con sombra al hacer scroll
  @override
  void initState() {
    super.initState();
    // El CustomScrollView del HomePage maneja el scroll;
    // este estado se puede conectar si se pasa un ScrollController.
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha:0.97),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFFFE0EF), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 48,
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Logo ──────────────────────────────────────────────────
          GestureDetector(
            onTap: widget.onHeroTap,
            child: Row(
              children: [
                const Text('🍦', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Seo.text(
                  text: 'Drum Ice',
                  child: Text(
                    'Drum Ice',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.darkBrown,
                          fontSize: 22,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Links desktop ─────────────────────────────────────────
          if (!isMobile) ...[
            _NavLink(label: 'Inicio', onTap: widget.onHeroTap),
            _NavLink(label: 'Historia', onTap: widget.onHistoriaTap),
            _NavLink(label: 'Sabores', onTap: widget.onSaboresTop),
            _NavLink(label: 'Pedidos', onTap: widget.onPedidosTap),
            const SizedBox(width: 12),
            _WhatsAppButton(),
          ] else ...[
            // ── Menú hamburguesa ──────────────────────────────────
            PopupMenuButton<_NavOption>(
              icon: const Icon(Icons.menu_rounded, color: AppTheme.darkBrown, size: 28),
              color: AppTheme.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: (opt) {
                switch (opt) {
                  case _NavOption.inicio:
                    widget.onHeroTap();
                  case _NavOption.historia:
                    widget.onHistoriaTap();
                  case _NavOption.sabores:
                    widget.onSaboresTop();
                  case _NavOption.pedidos:
                    widget.onPedidosTap();
                }
              },
              itemBuilder: (_) => [
                _menuItem(_NavOption.inicio, '🏠', 'Inicio'),
                _menuItem(_NavOption.historia, '📖', 'Historia'),
                _menuItem(_NavOption.sabores, '🍦', 'Sabores'),
                _menuItem(_NavOption.pedidos, '💬', 'Pedidos'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<_NavOption> _menuItem(_NavOption opt, String emoji, String label) {
    return PopupMenuItem(
      value: opt,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

enum _NavOption { inicio, historia, sabores, pedidos }

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Seo.link(
            href: '#',
            anchor: widget.label,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: _hover ? AppTheme.pink : AppTheme.mediumBrown,
                    fontWeight: FontWeight.w600,
                  ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}

class _WhatsAppButton extends StatelessWidget {
  static const _url = 'https://wa.me/5491154748921';

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      href: _url,
      anchor: 'Hacer pedido por WhatsApp',
      child: ElevatedButton.icon(
        onPressed: () => launchUrl(Uri.parse(_url)),
        icon: const Text('💬', style: TextStyle(fontSize: 16)),
        label: const Text('Pedir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.pink,
          foregroundColor: AppTheme.darkBrown,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
