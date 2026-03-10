import 'package:flutter/material.dart';
import '../models/tarot_card.dart';

class TarotFanSelector extends StatelessWidget {
  final List<TarotCard> deck;
  final bool fanOpen;
  final int? highlightedIndex;
  final Function(int) onSelectCard;
  final VoidCallback onToggleFan;

  const TarotFanSelector({
    super.key,
    required this.deck,
    required this.fanOpen,
    required this.highlightedIndex,
    required this.onSelectCard,
    required this.onToggleFan,
  });

  @override
  Widget build(BuildContext context) {
    if (!fanOpen) {
      return GestureDetector(
        onTap: onToggleFan,
        child: Image.asset(
          'assets/tarot/cards/reverso.png',
          width: 80,
        ),
      );
    }

    final spreadRad = 1.1;
    final radius = 220.0;
    final centerX = MediaQuery.of(context).size.width / 2;
    final circleCenterY = 520.0;

    return SizedBox(
      height: 320,
      child: Stack(
        children: List.generate(deck.length, (i) {
          final total = deck.length;
          final t = total == 1 ? 0.5 : i / (total - 1);

          final angle = (-spreadRad / 2) + (spreadRad * t);
          final isHighlighted = highlightedIndex == i;

          final cardWidth = 72.0;

          final x = centerX + radius * sin(angle) - (cardWidth / 2);
          final y = circleCenterY - radius * cos(angle);

          return Positioned(
            left: x,
            top: y + (isHighlighted ? -24 : 0),
            child: GestureDetector(
              onTap: () => onSelectCard(i),
              child: Transform.rotate(
                angle: angle,
                child: Image.asset(
                  'assets/tarot/cards/reverso.png',
                  width: cardWidth,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}