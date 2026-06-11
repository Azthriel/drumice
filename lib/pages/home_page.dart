import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import '../sections/navbar_section.dart';
import '../sections/hero_section.dart';
import '../sections/historia_section.dart';
import '../sections/sabores_section.dart';
import '../sections/pedidos_section.dart';
import '../widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  final _heroKey = GlobalKey();
  final _historiaKey = GlobalKey();
  final _saboresKey = GlobalKey();
  final _pedidosKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Seo.head(
      tags: const [
        MetaTag(
          name: 'title',
          content:
              'Drum Ice 🍦 | Heladería Artesanal - Hurlingham, Buenos Aires',
        ),
        MetaTag(
          name: 'description',
          content:
              'Drum Ice: 30 sabores artesanales inspirados en Drum Island de One Piece. '
              'Pedidos por WhatsApp al +54 9 11 5474-8921. Retiro en Hurlingham, Buenos Aires.',
        ),
        MetaTag(
          name: 'keywords',
          content: 'helado artesanal, heladería Hurlingham, pedidos WhatsApp, '
              'Drum Island, One Piece, helados Buenos Aires',
        ),
        LinkTag(rel: 'canonical', href: 'https://drumice.com.ar'),
      ],
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: NavbarSection(
                onHeroTap: () => _scrollTo(_heroKey),
                onHistoriaTap: () => _scrollTo(_historiaKey),
                onSaboresTop: () => _scrollTo(_saboresKey),
                onPedidosTap: () => _scrollTo(_pedidosKey),
              ),
            ),
            SliverToBoxAdapter(
              child: HeroSection(key: _heroKey),
            ),
            SliverToBoxAdapter(
              child: HistoriaSection(key: _historiaKey),
            ),
            SliverToBoxAdapter(
              child: SaboresSection(key: _saboresKey),
            ),
            SliverToBoxAdapter(
              child: PedidosSection(key: _pedidosKey),
            ),
            const SliverToBoxAdapter(
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
