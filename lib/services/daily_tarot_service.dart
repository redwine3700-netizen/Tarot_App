import 'dart:math';

class DailyTarotService {
  static int dailyIndex({required int deckLength}) {
    if (deckLength <= 0) return 0;

    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final rng = Random(seed);

    return rng.nextInt(deckLength);
  }
}
