import 'package:flutter/foundation.dart';
import 'tarot_mode.dart';

class TarotState {
  TarotState._();
  static final TarotState instance = TarotState._();

  /// Modo global para toda la app (Home + Tarot + Lectura).
  final ValueNotifier<TarotMode> mode = ValueNotifier<TarotMode>(TarotMode.love);

  void setMode(TarotMode m) => mode.value = m;
}
