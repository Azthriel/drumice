import 'package:drum_ice/utils/whatsapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seo/seo.dart';

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
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.97),
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
                const FaIcon(
                  FontAwesomeIcons.iceCream,
                  color: AppTheme.pink,
                  size: 22,
                ),
                const SizedBox(width: 10),
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
            const _WhatsAppButton(),
          ] else ...[
            // ── Menú hamburguesa ──────────────────────────────────
            PopupMenuButton<_NavOption>(
              icon: const FaIcon(
                FontAwesomeIcons.bars,
                color: AppTheme.darkBrown,
                size: 22,
              ),
              color: AppTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                _menuItem(
                  _NavOption.inicio,
                  FontAwesomeIcons.house,
                  'Inicio',
                ),
                _menuItem(
                  _NavOption.historia,
                  FontAwesomeIcons.bookOpen,
                  'Historia',
                ),
                _menuItem(
                  _NavOption.sabores,
                  FontAwesomeIcons.iceCream,
                  'Sabores',
                ),
                _menuItem(
                  _NavOption.pedidos,
                  FontAwesomeIcons.whatsapp,
                  'Pedidos',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<_NavOption> _menuItem(
    _NavOption opt,
    FaIconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: opt,
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: AppTheme.mediumBrown),
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
  static const _url = 'https://wa.me/5491176025184';

  const _WhatsAppButton();

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      href: _url,
      anchor: 'Hacer pedido por WhatsApp',
      child: ElevatedButton.icon(
        onPressed: () => launchWhatsApp('+5491176025184',
            '¡Hola Drum Ice! Vengo de la página y quiero hacer un pedido.',
            source: 'navbar_whatsapp_button'),
        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
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
