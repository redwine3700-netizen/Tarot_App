// lib/state/tarot_mode.dart

enum TarotMode { general, love, work, money }

extension TarotModeX on TarotMode {
  /// Para mapear a tu "area" usada en los banks/copy.
  String get areaKey {
    switch (this) {
      case TarotMode.general:
        return "general";
      case TarotMode.love:
        return "amor";
      case TarotMode.work:
        return "trabajo";
      case TarotMode.money:
        return "dinero";
    }
  }

  /// Título humano para UI
  String get title {
    switch (this) {
      case TarotMode.general:
        return "General";
      case TarotMode.love:
        return "Amor";
      case TarotMode.work:
        return "Trabajo";
      case TarotMode.money:
        return "Dinero";
    }
  }
}
