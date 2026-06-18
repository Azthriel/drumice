import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quarks_footer/quarks_footer.dart';
import 'package:seo/seo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const _instagramUrl = 'https://www.instagram.com/drum.ice_/';

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
                    _LinksBlock(
                      isMobile: isMobile,
                      instagramUrl: _instagramUrl,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _LogoBlock(isMobile: isMobile)),
                    _LinksBlock(
                      isMobile: isMobile,
                      instagramUrl: _instagramUrl,
                    ),
                  ],
                ),
          const SizedBox(height: 48),
          const QuarksFooter(
              backgroundColor: AppTheme.darkBg, textColor: Colors.white),
        ],
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
        Seo.text(
          text:
              'Pedidos por WhatsApp al +54 9 11 7602-5184. Retiro y envíos a zona Hurlingham.',
          child: Text(
            'Pedidos por WhatsApp · Retiro y envíos a zona Hurlingham',
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
  final String instagramUrl;

  const _LinksBlock({
    required this.isMobile,
    required this.instagramUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        const _FooterLink(
          icon: FontAwesomeIcons.whatsapp,
          label: 'WhatsApp',
          url: 'https://wa.me/5491176025184',
          color: AppTheme.whatsappGreen,
        ),
        const SizedBox(height: 10),
        _FooterLink(
          icon: FontAwesomeIcons.instagram,
          label: 'Instagram',
          url: instagramUrl,
          color: const Color(0xFFE1306C),
        ),
        const SizedBox(height: 10),
        const _FooterLink(
          icon: FontAwesomeIcons.locationDot,
          label: 'Hurlingham, Buenos Aires',
          url: 'https://maps.google.com/?q=Hurlingham+Buenos+Aires',
          color: Colors.white54,
        ),
        const SizedBox(height: 10),
        const _FooterLink(
          icon: FontAwesomeIcons.skull,
          label: 'Inspirado en One Piece',
          url: 'https://onepiece.fandom.com/wiki/Drum_Island',
          color: Colors.white38,
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final String url;
  final Color color;

  const _FooterLink({
    required this.icon,
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
              FaIcon(
                widget.icon,
                size: 15,
                color:
                    _hover ? widget.color : widget.color.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: _hover
                          ? widget.color
                          : widget.color.withValues(alpha: 0.7),
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
