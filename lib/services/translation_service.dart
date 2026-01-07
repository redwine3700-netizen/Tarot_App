import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static final Map<String, String> _cache = {};

  static const String _apiKey =
  String.fromEnvironment('TRANSLATE_API_KEY', defaultValue: '');

  static const String _url =
      'https://translation.googleapis.com/language/translate/v2';

  static String _cleanHtmlEntities(String text) {
    return text
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&');
  }

  static Future<String> toSpanish(String text) async {
    final t = text.trim();
    if (t.isEmpty) return text;
    if (_apiKey.isEmpty) return text;

    final cached = _cache[t];
    if (cached != null) return cached;

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');

      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'q': t,
          'source': 'en',
          'target': 'es',
          'format': 'text',
        }),
      );

      if (response.statusCode != 200) return text;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final translations = (data['data']?['translations'] as List?) ?? const [];

      if (translations.isEmpty) return text;

      final translated = _cleanHtmlEntities(
        translations.first['translatedText']?.toString() ?? text,
      );

      _cache[t] = translated;
      return translated;
    } catch (_) {
      return text;
    }
  }
}
