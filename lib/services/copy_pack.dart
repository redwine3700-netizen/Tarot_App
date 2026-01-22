import 'dart:convert';
import 'package:flutter/services.dart';

class CopyPack {
  final Map<String, dynamic> _data;
  CopyPack(this._data);

  static Future<CopyPack> load(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final map = json.decode(raw) as Map<String, dynamic>;
    return CopyPack(map);
  }

  dynamic getPath(String path) {
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

  String s(String path, {String fallback = ""}) {
    final v = getPath(path);
    return v is String ? v : fallback;
  }

  List<String> sl(String path) {
    final v = getPath(path);
    if (v is List) return v.whereType<String>().toList();
    return const [];
  }

  List<Map<String, dynamic>> ml(String path) {
    final v = getPath(path);
    if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    return const [];
  }
}
