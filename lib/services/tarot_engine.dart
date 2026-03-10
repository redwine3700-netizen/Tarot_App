import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/tarot_cards.dart';
import '../models/tarot_models.dart';

enum TarotSpreadType {
  oneCard,
  threeCards,
  sixCards,
}

class DrawnTarotCard {
  final TarotCard card;
  final bool isReversed;
  final String position;

  const DrawnTarotCard({
    required this.card,
    required this.isReversed,
    required this.position,
  });

  String get displayName =>
      isReversed ? '${card.nombre} · Invertida' : card.nombre;
}

class TarotReading {
  final TarotSpreadType type;
  final DateTime createdAt;
  final List<DrawnTarotCard> cards;

  const TarotReading({
    required this.type,
    required this.createdAt,
    required this.cards,
  });

  bool get isEmpty => cards.isEmpty;
}

class TarotEngine {
  TarotEngine({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const String _prefsRecentCardsKey = 'tarot_recent_cards';
  static const String _prefsDailyCardDateKey = 'tarot_daily_card_date';
  static const String _prefsDailyCardNameKey = 'tarot_daily_card_name';
  static const String _prefsDailyCardReversedKey = 'tarot_daily_card_reversed';

  /// =========================
  /// API pública
  /// =========================

  Future<TarotReading> drawOneCard({
    bool allowReversed = true,
    bool avoidRecentCards = true,
  }) async {
    return _drawSpread(
      type: TarotSpreadType.oneCard,
      count: 1,
      positions: const ['Mensaje para ti'],
      allowReversed: allowReversed,
      avoidRecentCards: avoidRecentCards,
    );
  }

  Future<TarotReading> drawThreeCards({
    bool allowReversed = true,
    bool avoidRecentCards = true,
  }) async {
    return _drawSpread(
      type: TarotSpreadType.threeCards,
      count: 3,
      positions: const ['Pasado', 'Presente', 'Futuro'],
      allowReversed: allowReversed,
      avoidRecentCards: avoidRecentCards,
    );
  }

  Future<TarotReading> drawSixCards({
    bool allowReversed = true,
    bool avoidRecentCards = true,
  }) async {
    return _drawSpread(
      type: TarotSpreadType.sixCards,
      count: 6,
      positions: const [
        'Situación actual',
        'Obstáculo',
        'Energía inconsciente',
        'Consejo',
        'Influencias externas',
        'Resultado',
      ],
      allowReversed: allowReversed,
      avoidRecentCards: avoidRecentCards,
    );
  }

  /// Carta del día:
  /// - si ya se sacó hoy, devuelve la misma
  /// - si no, genera una nueva y la guarda
  Future<DrawnTarotCard> drawDailyCard({
    bool allowReversed = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString(_prefsDailyCardDateKey);
    final savedName = prefs.getString(_prefsDailyCardNameKey);
    final savedReversed = prefs.getBool(_prefsDailyCardReversedKey) ?? false;

    final now = DateTime.now();
    final todayKey = _formatDateKey(now);

    if (savedDate == todayKey && savedName != null && savedName.isNotEmpty) {
      final existing = buscarCartaTarot(savedName);
      if (existing != null) {
        return DrawnTarotCard(
          card: existing,
          isReversed: savedReversed,
          position: 'Carta del día',
        );
      }
    }

    final reading = await _drawSpread(
      type: TarotSpreadType.oneCard,
      count: 1,
      positions: const ['Carta del día'],
      allowReversed: allowReversed,
      avoidRecentCards: true,
      saveInRecent: true,
    );

    final card = reading.cards.first;

    await prefs.setString(_prefsDailyCardDateKey, todayKey);
    await prefs.setString(_prefsDailyCardNameKey, card.card.nombre);
    await prefs.setBool(_prefsDailyCardReversedKey, card.isReversed);

    return card;
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsRecentCardsKey);
    await prefs.remove(_prefsDailyCardDateKey);
    await prefs.remove(_prefsDailyCardNameKey);
    await prefs.remove(_prefsDailyCardReversedKey);
  }

  Future<List<String>> getRecentCardNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_prefsRecentCardsKey) ?? <String>[];
  }

  /// =========================
  /// Núcleo interno
  /// =========================

  Future<TarotReading> _drawSpread({
    required TarotSpreadType type,
    required int count,
    required List<String> positions,
    required bool allowReversed,
    required bool avoidRecentCards,
    bool saveInRecent = true,
  }) async {
    final recentNames = avoidRecentCards ? await getRecentCardNames() : <String>[];
    final recentSet = recentNames.map(_normalizeName).toSet();

    final fullDeck = List<TarotCard>.from(cartasTarot);

    List<TarotCard> availableDeck = fullDeck
        .where((card) => !recentSet.contains(_normalizeName(card.nombre)))
        .toList();

    // Si el filtro deja muy pocas cartas, volvemos al mazo completo.
    if (availableDeck.length < count) {
      availableDeck = fullDeck;
    }

    availableDeck.shuffle(_random);

    final selected = availableDeck.take(count).toList();

    final drawn = <DrawnTarotCard>[];
    for (int i = 0; i < selected.length; i++) {
      drawn.add(
        DrawnTarotCard(
          card: selected[i],
          isReversed: allowReversed ? _random.nextBool() : false,
          position: positions[i],
        ),
      );
    }

    if (saveInRecent) {
      await _saveRecentCards(drawn.map((e) => e.card.nombre).toList());
    }

    return TarotReading(
      type: type,
      createdAt: DateTime.now(),
      cards: drawn,
    );
  }

  Future<void> _saveRecentCards(List<String> newCards) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_prefsRecentCardsKey) ?? <String>[];

    final merged = <String>[
      ...newCards,
      ...current,
    ];

    final seen = <String>{};
    final cleaned = <String>[];

    for (final name in merged) {
      final normalized = _normalizeName(name);
      if (seen.contains(normalized)) continue;
      seen.add(normalized);
      cleaned.add(name);
    }

    // Guarda solo las últimas 12 para no bloquear demasiado el mazo.
    await prefs.setStringList(
      _prefsRecentCardsKey,
      cleaned.take(12).toList(),
    );
  }

  String _formatDateKey(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _normalizeName(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}