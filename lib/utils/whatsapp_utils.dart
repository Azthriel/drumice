import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

String normalizeArgentinePhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  if (digits.startsWith('54') && digits.length >= 11) return digits;
  if (digits.startsWith('0')) return '54${digits.substring(1)}';
  return '54$digits';
}

Future<void> launchWhatsApp(String phone, String message) async {
  final normalized = normalizeArgentinePhone(phone);
  if (normalized.isEmpty) {
    debugPrint('Número vacío o inválido: $phone');
    return;
  }

  final uri = Uri.parse(
    'https://wa.me/$normalized?text=${Uri.encodeComponent(message)}',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  } else {
    debugPrint('No se pudo abrir WhatsApp para $normalized');
  }
}