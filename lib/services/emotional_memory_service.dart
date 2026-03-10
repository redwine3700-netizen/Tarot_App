import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmotionalMemoryService {
  static const _kName = 'user_name';
  static const _kEstado = 'estado_emocional';
  static const _kFoco = 'foco_relacional';
  static const _kUltimaLectura = 'ultima_lectura';
  static const _kHistory = 'emotional_history';
  static const _kLastCheckin = 'last_emotional_checkin';
  static const _kProcessDay = 'emotional_process_day';

  // Guardar nombre
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, name);
  }

  // Leer nombre
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kName);
  }

  // Guardar estado emocional (tranquilo, confundido, ansioso…)
  Future<void> saveEstado(String estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEstado, estado);
  }

  Future<String?> getEstado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEstado);
  }

  // Guardar foco relacional (ex, nueva persona, relación actual)
  Future<void> saveFoco(String foco) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFoco, foco);
  }

  Future<String?> getFoco() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kFoco);
  }

  // Guardar última lectura (timestamp simple)
  Future<void> saveUltimaLectura() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUltimaLectura, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime?> getUltimaLectura() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_kUltimaLectura);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> saveLastCheckinNow() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _kLastCheckin,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<DateTime?> getLastCheckin() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_kLastCheckin);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> saveProcessDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kProcessDay, day);
  }

  Future<int> getProcessDay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kProcessDay) ?? 0;
  }

  Future<void> addHistoryEntry({
    required String estado,
    required String foco,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final current = prefs.getString(_kHistory);
    final List<dynamic> list =
    current != null ? jsonDecode(current) as List<dynamic> : [];

    list.insert(0, {
      'estado': estado,
      'foco': foco,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // dejamos solo los últimos 20 registros
    final trimmed = list.take(20).toList();

    await prefs.setString(_kHistory, jsonEncode(trimmed));
  }


  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getString(_kHistory);

    if (current == null || current.trim().isEmpty) return [];

    final List<dynamic> list = jsonDecode(current) as List<dynamic>;

    return list
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}