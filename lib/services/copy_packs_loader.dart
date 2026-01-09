import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CopyPacksLoader {
  static const String _assetPath = 'assets/copy/copy_packs_es.json';

  static Future<Map<String, dynamic>> loadEs() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
