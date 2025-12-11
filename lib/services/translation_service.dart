import 'dart:convert';
import 'package:http/http.dart' as http;

/// SERVICIO DE TRADUCCIÓN (inglés → español) usando Google Cloud Translate
class TranslationService {
  // 🔐 Pon aquí tu API key real
  static const _apiKey = 'AIzaSyA7NUebUIBZi4WwwSSFaCgbSsd1MKevCj4';

  static const _url =
      'https://translation.googleapis.com/language/translate/v2';

  static String _cleanHtmlEntities(String text) {
    return text
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&');
  }

  static Future<String> toSpanish(String text) async {
    if (text.trim().isEmpty) return text;

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'q': text,
          'source': 'en',
          'target': 'es',
          'format': 'text',
        }),
      );

      if (response.statusCode != 200) {
        // Si falla la API, devolvemos el texto original en inglés
        return text;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final translations = data['data']?['translations'] as List<dynamic>?;

      if (translations == null || translations.isEmpty) {
        return text;
      }

      final translatedText =
          translations.first['translatedText']?.toString() ?? text;

      return _cleanHtmlEntities(translatedText);
    } catch (_) {
      // Cualquier error de red o parsing → devolvemos el texto original
      return text;
    }
  }
}
