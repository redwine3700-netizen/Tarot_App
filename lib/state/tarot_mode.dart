enum TarotMode { love, work, money }

extension TarotModeX on TarotMode {
  String get key {
    switch (this) {
      case TarotMode.love:
        return 'love';
      case TarotMode.work:
        return 'work';
      case TarotMode.money:
        return 'money';
    }
  }

  String get label {
    switch (this) {
      case TarotMode.love:
        return 'Amor';
      case TarotMode.work:
        return 'Trabajo';
      case TarotMode.money:
        return 'Dinero';
    }
  }
}
