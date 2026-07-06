import 'dart:async';
import 'package:drum_ice/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:quarks_version_checker/quarks_version_checker.dart';
import 'package:seo/seo.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'utils/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  unawaited(() async {
    try {
      await AppVersionChecker.instance.start();
    } catch (_) {}
  }());

  runApp(const DrumIceApp());
}

class DrumIceApp extends StatelessWidget {
  const DrumIceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: MaterialApp(
        title: 'Drum Ice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        navigatorObservers: [AnalyticsService.observer],
        routes: {
          '/': (_) => const HomePage(),
        },
        onUnknownRoute: (_) => MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        ),
      ),
    );
  }
}
