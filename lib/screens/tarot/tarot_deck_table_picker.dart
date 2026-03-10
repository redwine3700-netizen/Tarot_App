import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/tarot_models.dart'; // ajusta a tu ruta real

class TarotDeckTablePicker extends StatefulWidget {
  final List<TarotCard> fullDeck;
  final int maxCards; // 6, 3, etc.
  final int columns; // para grid (6 cartas -> 2)
  final Color borderColor;
  final Color panelColor;
  final String backAssetPath; // reverso
  final void Function(List<TarotCard> selected) onComplete;

  const TarotDeckTablePicker({
    super.key,
    required this.fullDeck,
    required this.onComplete,
    this.maxCards = 6,
    this.columns = 2,
    required this.borderColor,
    required this.panelColor,
    required this.backAssetPath,
  });

  @override
  State<TarotDeckTablePicker> createState() => _TarotDeckTablePickerState();
}

class _PickCard {
  final TarotCard card;
  final bool reversed;
  const _PickCard(this.card, this.reversed);
}

class _TarotDeckTablePickerState extends State<TarotDeckTablePicker> {
  final Random _rand = Random();
  late List<TarotCard> _deck;
  final List<_PickCard> _table = [];

  @override
  void initState() {
    super.initState();
    _deck = List<TarotCard>.from(widget.fullDeck)..shuffle();
  }

  void _draw() {
    if (_table.length >= widget.maxCards) return;
    if (_deck.isEmpty) return;

    final reversed = _rand.nextBool();
    setState(() {
      _table.add(_PickCard(_deck.removeLast(), reversed));
    });
  }

  void _openCard(_PickCard data) {
    final c = data.card;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.panelColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: widget.borderColor.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 360,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: widget.borderColor.withOpacity(0.6)),
                ),
                child: Transform.rotate(
                  angle: data.reversed ? pi : 0,
                  child: Image.asset(c.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                c.nombre + (data.reversed ? ' (Invertida)' : ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                c.significado,
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final complete = _table.length == widget.maxCards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Toca el mazo para elegir tus cartas',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),

        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: _draw,
            child: Opacity(
              opacity: complete ? 0.4 : 1,
              child: Container(
                width: 92,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: widget.borderColor.withOpacity(0.85)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(widget.backAssetPath, fit: BoxFit.cover),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _table.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (_, i) {
            final data = _table[i];
            return GestureDetector(
              onTap: () => _openCard(data),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Transform.rotate(
                  angle: data.reversed ? pi : 0,
                  child: Image.asset(data.card.imagePath, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 14),

        if (complete)
          ElevatedButton(
            onPressed: () {
              widget.onComplete(_table.map((e) => e.card).toList());
            },
            child: const Text('Ver lectura'),
          ),
      ],
    );
  }
}
