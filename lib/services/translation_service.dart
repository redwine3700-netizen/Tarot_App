import 'dart:convert';
import 'package:http/http.dart' as http;

/// SERVICIO DE TRADUCCIÓN (inglés → español) usando Google Cloud Translate
class TranslationService {
  // 👉 Reemplaza por tu API KEY real de Google
  static const _apiKey = 'TU_API_KEY_DE_GOOGLE_TRANSLATE';

  static const _url =
      'https://translation.googleapis.com/language/translate/v2';

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
        return text;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final translations = data['data']?['translations'] as List<dynamic>?;

      if (translations == null || translations.isEmpty) {
        return text;
      }

      final translatedText =
          translations.first['translatedText']?.toString() ?? text;

      return translatedText;
    } catch (_) {
      return text;
    }
  }
}
