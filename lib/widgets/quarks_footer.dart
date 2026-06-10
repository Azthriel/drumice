import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

/// Footer nativo para Flutter Web.
/// Equivalente al quarks_footer package (que es Flutter-only y no se puede usar en Jaspr).
class QuarksFooter extends StatelessWidget {
  const QuarksFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 640;

    return Container(
      color: AppTheme.darkBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 64,
        vertical: 48,
      ),
      child: Column(
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _LogoBlock(isMobile: isMobile),
                    const SizedBox(height: 32),
                    _LinksBlock(isMobile: isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _LogoBlock(isMobile: isMobile)),
                    _LinksBlock(isMobile: isMobile),
                  ],
                ),

          const SizedBox(height: 40),
          Divider(color: Colors.white.withValues(alpha:0.08)),
          const SizedBox(height: 24),

          // ── Copyright + Made by Quarks ────────────────────────────
          isMobile
              ? Column(
                  children: [
                    _copyright(context),
                    const SizedBox(height: 8),
                    _madeBy(context),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _copyright(context),
                    _madeBy(context),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _copyright(BuildContext context) {
    return Seo.text(
      text: '© 2025 Drum Ice. Todos los derechos reservados.',
      child: Text(
        '© 2025 Drum Ice. Todos los derechos reservados.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white24,
            ),
      ),
    );
  }

  Widget _madeBy(BuildContext context) {
    return Seo.link(
      href: 'https://quarksstudio.com.ar',
      anchor: 'Quarks Studio – desarrollo de apps Flutter',
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://quarksstudio.com.ar')),
        child: Text(
          'Made with ❤️ by Quarks Studio',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white38,
              ),
        ),
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  final bool isMobile;
  const _LogoBlock({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍦', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Seo.text(
              text: 'Drum Ice',
              child: Text(
                'Drum Ice',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Seo.text(
          text: 'Heladería artesanal · Hurlingham, Buenos Aires',
          child: Text(
            'Heladería artesanal\nHurlingham, Buenos Aires',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white38,
                ),
          ),
        ),
        const SizedBox(height: 20),
        // Schema adicional para Google
        Seo.text(
          text: 'Pedidos por WhatsApp al +54 9 11 5474-8921. Solo retiro.',
          child: Text(
            'Pedidos por WhatsApp · Solo retiro',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white24,
                ),
          ),
        ),
      ],
    );
  }
}

class _LinksBlock extends StatelessWidget {
  final bool isMobile;
  const _LinksBlock({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: const [
        _FooterLink(
          emoji: '💬',
          label: 'WhatsApp',
          url: 'https://wa.me/5491154748921',
          color: AppTheme.whatsappGreen,
        ),
        SizedBox(height: 10),
        _FooterLink(
          emoji: '📍',
          label: 'Hurlingham, Buenos Aires',
          url: 'https://maps.google.com/?q=Hurlingham+Buenos+Aires',
          color: Colors.white54,
        ),
        SizedBox(height: 10),
        _FooterLink(
          emoji: '🏴‍☠️',
          label: 'Inspirado en One Piece',
          url: 'https://onepiece.fandom.com/wiki/Drum_Island',
          color: Colors.white38,
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String emoji;
  final String label;
  final String url;
  final Color color;

  const _FooterLink({
    required this.emoji,
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Seo.link(
        href: widget.url,
        anchor: widget.label,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: _hover
                          ? widget.color
                          : widget.color.withValues(alpha:0.7),
                    ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
