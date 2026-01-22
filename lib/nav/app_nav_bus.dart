import 'package:flutter/foundation.dart';

class HomeTarotRequest {
  final int spread; // 1, 3, 6
  final String focus; // 'amor' | 'trabajo' | 'dinero' | 'general'
  const HomeTarotRequest({required this.spread, required this.focus});
}

final ValueNotifier<HomeTarotRequest?> homeTarotRequest = ValueNotifier<HomeTarotRequest?>(null);
