import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CopyPack {
  final Map<String, dynamic> _data;
  CopyPack(this._data);

  String s(String path, {String fallback = ""}) {
    final v = _get(path);
    if (v == null) return fallback;
    return v.toString();
  }

  List<Map<String, dynamic>> ml(String path) {
    final v = _get(path);
    if (v is List) {
      return v
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return const [];
  }

  List<String> sl(String path) {
    final v = _get(path);
    if (v is List) return v.map((e) => e.toString()).toList();
    return const [];
  }

  dynamic _get(String path) {
    dynamic cur = _data;
    for (final part in path.split('.')) {
      if (cur is Map<String, dynamic>) {
        cur = cur[part];
      } else {
        return null;
      }
    }
    return cur;
  }
}

class CopyPacksLoader {
  static const String _assetPath = 'assets/copy/copy_packs_es.json';

  static Future<CopyPack> loadEs() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return CopyPack(map);
  }
}
