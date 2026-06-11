import 'package:drum_ice/utils/whatsapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seo/seo.dart';

import '../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.88),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.palePink, AppTheme.paleBlue],
          stops: [0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 28 : 80,
          vertical: 72,
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _HeroIllustration(size: 220),
                  const SizedBox(height: 40),
                  ..._textContent(context, isMobile),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _textContent(context, isMobile),
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Expanded(
                    flex: 45,
                    child: _HeroIllustration(size: 380),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _textContent(BuildContext context, bool isMobile) {
    final align = isMobile ? TextAlign.center : TextAlign.left;

    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.lightBlue.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.lightBlue),
        ),
        child: Seo.text(
          text: 'Inspirado en Drum Island · One Piece',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.mountain,
                size: 12,
                color: AppTheme.darkBrown,
              ),
              const SizedBox(width: 8),
              Text(
                'Inspirado en Drum Island · One Piece',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkBrown,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Seo.text(
        text: 'Drum Ice',
        style: TextTagStyle.h1,
        child: Text(
          'Drum Ice',
          textAlign: align,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isMobile ? 52 : 72,
                color: AppTheme.darkBrown,
              ),
        ),
      ),
      Seo.text(
        text: 'Heladería artesanal',
        style: TextTagStyle.h2,
        child: Text(
          'Heladería artesanal',
          textAlign: align,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isMobile ? 26 : 34,
                color: const Color(0xFFC06898),
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      const SizedBox(height: 24),
      Seo.text(
        text:
            'El helado que cura todo. 30 sabores artesanales únicos, inspirados en la magia de la ficción. Pedidos por WhatsApp. Retiro y envíos a zona Hurlingham, Buenos Aires.',
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            'El helado que cura todo. ✨\n'
            '30 sabores artesanales únicos, inspirados en la magia de la ficción. '
            'Pedidos por WhatsApp · Retiro y envíos a zona Hurlingham, Buenos Aires.',
            textAlign: align,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      const SizedBox(height: 44),
      Wrap(
        alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
        spacing: 16,
        runSpacing: 12,
        children: [
          Seo.link(
            href: 'https://wa.me/5491154748921',
            anchor: 'Hacer pedido por WhatsApp a Drum Ice',
            child: ElevatedButton.icon(
              onPressed: () => launchWhatsApp('+5491154748921', '¡Hola Drum Ice! Vengo de la página y quiero hacer un pedido.'),
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
              label: const Text('Hacer pedido'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pink,
                foregroundColor: AppTheme.darkBrown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                textStyle: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.iceCream, size: 15),
            label: const Text('Ver sabores'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.darkBrown,
              side: const BorderSide(color: AppTheme.pink, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 48),
      Wrap(
        alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
        spacing: 24,
        runSpacing: 8,
        children: const [
          _TrustBadge(
            icon: FontAwesomeIcons.iceCream,
            label: '30 sabores',
          ),
          _TrustBadge(
            icon: FontAwesomeIcons.motorcycle,
            label: 'Envíos a zona Hurlingham',
          ),
          _TrustBadge(
            icon: FontAwesomeIcons.whatsapp,
            label: 'Pedido por WhatsApp',
          ),
        ],
      ),
    ];
  }
}

class _TrustBadge extends StatelessWidget {
  final FaIconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: AppTheme.pink),
          const SizedBox(width: 7),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.mediumBrown),
          ),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  final double size;
  const _HeroIllustration({required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Seo.image(
        src: 'assets/images/hero.png',
        alt: 'Drum Ice - helados artesanales de Drum Island',
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [AppTheme.softPink, AppTheme.palePink],
              radius: 0.8,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.pink.withValues(alpha: 0.35),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/hero.png',
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
