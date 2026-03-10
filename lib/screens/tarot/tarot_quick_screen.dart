import 'package:flutter/material.dart';
import '../../models/tarot_models.dart';
import '../../services/daily_tarot_service.dart';

class TarotQuickScreen extends StatelessWidget {
  final List<TarotCard> deck;
  const TarotQuickScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final idx = DailyTarotService.dailyIndex(deckLength: deck.length);
    final card = deck.isEmpty ? null : deck[idx];

    return Scaffold(
      appBar: AppBar(title: const Text('Tarot rápido')),
      body: card == null
          ? const Center(child: Text('No hay cartas cargadas.'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(card.imagePath, fit: BoxFit.cover),
            ),
            const SizedBox(height: 14),
            Text(
              card.nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(card.significado, style: const TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
