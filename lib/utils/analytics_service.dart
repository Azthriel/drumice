import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // WhatsApp
  static Future<void> logWhatsAppClick({required String source}) =>
      _analytics.logEvent(
        name: 'whatsapp_click',
        parameters: {'source': source},
      );

  // Búsqueda de sabores
  static Future<void> logSaborSearch(String query) =>
      _analytics.logSearch(searchTerm: query);

  // Sabor encontrado / no encontrado
  static Future<void> logSaborResult({
    required String query,
    required int results,
  }) =>
      _analytics.logEvent(
        name: 'sabor_search_result',
        parameters: {'query': query, 'results': results},
      );
}
