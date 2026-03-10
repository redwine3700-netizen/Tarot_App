import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Carga y expone textos/copies desde assets.
/// - copy_packs_es.json   -> packs (lecturas)
/// - copy_meta_es.json    -> meta global (microacciones, cierres, etc.)
/// - ux_deluxe_es.json    -> textos UX / ritual / premium
class CopyLoader {
  CopyLoader._();
  static final CopyLoader instance = CopyLoader._();

  static const String _packsPath = 'assets/copy/copy_packs_es.json';
  static const String _metaPath = 'assets/copy/copy_meta_es.json';
  static const String _uxPath = 'assets/copy/ux_deluxe_es.json';

  bool _loaded = false;

  Map<String, dynamic> _packsRoot = <String, dynamic>{};
  Map<String, dynamic> _metaRoot = <String, dynamic>{};
  Map<String, dynamic> _uxRoot = <String, dynamic>{};

  /// Carga una sola vez (cache). Llama esto al iniciar la app.
  Future<void> loadAll({bool forceReload = false}) async {
    if (_loaded && !forceReload) return;

    try {
      final packsStr = await rootBundle.loadString(_packsPath);
      final metaStr = await rootBundle.loadString(_metaPath);
      final uxStr = await rootBundle.loadString(_uxPath);

      final packsJson = jsonDecode(packsStr);
      final metaJson = jsonDecode(metaStr);
      final uxJson = jsonDecode(uxStr);

      if (packsJson is! Map<String, dynamic>) {
        throw FormatException('$_packsPath no es un objeto JSON (Map).');
      }
      if (metaJson is! Map<String, dynamic>) {
        throw FormatException('$_metaPath no es un objeto JSON (Map).');
      }
      if (uxJson is! Map<String, dynamic>) {
        throw FormatException('$_uxPath no es un objeto JSON (Map).');
      }

      _packsRoot = packsJson;
      _metaRoot = metaJson;
      _uxRoot = uxJson;

      _loaded = true;
    } catch (e, st) {
      // En debug, esto ayuda muchísimo a detectar rutas/JSON roto.
      debugPrint('CopyLoader.loadAll ERROR: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // -----------------------
  // Accesos básicos
  // -----------------------

  List<dynamic> get packs => (_packsRoot['packs'] as List<dynamic>?) ?? const [];

  Map<String, dynamic> get meta =>
      (_metaRoot['meta'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

  Map<String, dynamic> get ux => _uxRoot;

  // -----------------------
  // Helpers de uso frecuente
  // -----------------------

  /// Busca un pack por id (ej: "es_general_free").
  Map<String, dynamic>? packById(String id) {
    for (final p in packs) {
      if (p is Map<String, dynamic> && p['id'] == id) return p;
    }
    return null;
  }

  /// Obtiene un texto UX por path tipo "home.title" o "ritual.subtitle".
  /// Devuelve null si no existe.
  String? uxText(String dottedPath) {
    dynamic cur = _uxRoot;
    for (final key in dottedPath.split('.')) {
      if (cur is Map<String, dynamic> && cur.containsKey(key)) {
        cur = cur[key];
      } else {
        return null;
      }
    }
    return (cur is String) ? cur : null;
  }

  /// Devuelve una lista de microacciones globales si existen en meta.
  List<dynamic> get microacciones =>
      (meta['microacciones'] as List<dynamic>?) ?? const [];
}
