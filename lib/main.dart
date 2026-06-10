import 'package:drum_ice/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:seo/seo.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DrumIceApp());
}

class DrumIceApp extends StatelessWidget {
  const DrumIceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      // WidgetTree es la implementación recomendada (vs SemanticsTree experimental)
      tree: WidgetTree(context: context),
      child: MaterialApp(
        title: 'Drum Ice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}
