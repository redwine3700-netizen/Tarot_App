import '../models/horoscope_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/tarot_models.dart';
import 'translation_service.dart';

class HoroscopeApiService {
  // Base de la API (sin /daily para poder usar weekly y monthly también)
  static const _baseUrl =
      'https://horoscope-app-api.vercel.app/api/v1/get-horoscope';

  static String _mapSpanishToEnglishSign(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'aries':
        return 'aries';
      case 'tauro':
        return 'taurus';
      case 'géminis':
      case 'geminis':
        return 'gemini';
      case 'cáncer':
      case 'cancer':
        return 'cancer';
      case 'leo':
        return 'leo';
      case 'virgo':
        return 'virgo';
      case 'libra':
        return 'libra';
      case 'escorpio':
        return 'scorpio';
      case 'sagitario':
        return 'sagittarius';
      case 'capricornio':
        return 'capricorn';
      case 'acuario':
        return 'aquarius';
      case 'piscis':
        return 'pisces';
      default:
        return 'aries';
    }
  }

  /// Método interno que llama a daily/weekly/monthly y traduce al español.
  static Future<DailyHoroscope> _fetchAndTranslate({
    required String endpoint, // '/daily', '/weekly', '/monthly'
    required String nombreSigno,
    String? day, // solo se usa para daily
  }) async {
    final signEn = _mapSpanishToEnglishSign(nombreSigno);

    final buffer = StringBuffer('$_baseUrl$endpoint?sign=$signEn');
    if (day != null) {
      buffer.write('&day=$day');
    }
    final uri = Uri.parse(buffer.toString());

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error ${response.statusCode} al obtener horóscopo para "$nombreSigno" (modo $endpoint, enviado "$signEn")',
      );
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final dynamic rawData = body['data'];

    // Normalizamos "data" a un Map<String,dynamic>
    final Map<String, dynamic> data;
    if (rawData is Map<String, dynamic>) {
      data = rawData;
    } else {
      data = {'horoscope_data': rawData};
    }

    final englishDescription =
    (data['horoscope_data'] ?? data['horoscope'] ?? rawData ?? '')
        .toString();

    // Traducción al español (si falla, devuelve el texto original)
    final spanishDescription =
    await TranslationService.toSpanish(englishDescription);

    final mood = data['mood']?.toString() ?? '—';
    final color = data['color']?.toString() ?? '—';
    final luckyNumber = (data['lucky_number'] ?? '—').toString();

    return DailyHoroscope(
      description: spanishDescription,
      mood: mood,
      color: color,
      luckyNumber: luckyNumber,
    );
  }

  // 🔸 Diario
  static Future<DailyHoroscope> fetchTodayForSign(String nombreSigno) {
    return _fetchAndTranslate(
      endpoint: '/daily',
      nombreSigno: nombreSigno,
      day: 'today',
    );
  }

  // 🔸 Semanal
  static Future<DailyHoroscope> fetchWeeklyForSign(String nombreSigno) {
    return _fetchAndTranslate(
      endpoint: '/weekly',
      nombreSigno: nombreSigno,
    );
  }

  // 🔸 Mensual
  static Future<DailyHoroscope> fetchMonthlyForSign(String nombreSigno) {
    return _fetchAndTranslate(
      endpoint: '/monthly',
      nombreSigno: nombreSigno,
    );
  }
}
