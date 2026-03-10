import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/tarot_cards.dart';
import '../../models/tarot_models.dart';

class TarotCardPickerScreen extends StatefulWidget {
  final int cardsNeeded;
  final String title;

  const TarotCardPickerScreen({
    super.key,
    required this.cardsNeeded,
    required this.title,
  });

  @override
  State<TarotCardPickerScreen> createState() => _TarotCardPickerScreenState();
}

class _TarotCardPickerScreenState extends State<TarotCardPickerScreen> {
  final List<TarotCard> _deck = [];
  final List<TarotCard> _selected = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _fanOpen = false;
  bool _fanAnimatingOpen = false;
  int _fanSweepIndex = -1;
  bool _isAnimatingSelection = false;
  int? _highlightedFanIndex;

  static const Color _bg = Color(0xFF140B1F);
  static const Color _panel = Color(0xFF1E1230);
  static const Color _accentFill = Color(0xFFFFE7D0);
  static const Color _accentBorder = Color(0xFFEAC19C);

  @override
  void initState() {
    super.initState();
    _deck.addAll(List<TarotCard>.from(cartasTarot)..shuffle(Random()));
  }

  Future<void> _playCardSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/card_flip_magic.wav'));
    } catch (_) {}
  }

  Future<void> _toggleFan() async {
    if (_selected.length >= widget.cardsNeeded) return;

    if (_fanOpen) {
      setState(() {
        _fanOpen = false;
        _fanAnimatingOpen = false;
        _fanSweepIndex = -1;
      });
      return;
    }

    final visibleCount = _deck.take(24).length;

    setState(() {
      _fanOpen = true;
      _fanAnimatingOpen = true;
      _fanSweepIndex = -1;
    });

    for (int i = 0; i < visibleCount; i++) {
      await Future.delayed(const Duration(milliseconds: 90));
      if (!mounted || !_fanOpen) return;

      setState(() {
        _fanSweepIndex = i;
      });
    }

    if (!mounted) return;
    setState(() {
      _fanAnimatingOpen = false;
    });
  }

  Future<void> _selectFromFan(int index) async {
    if (_isAnimatingSelection) return;
    if (_selected.length >= widget.cardsNeeded) return;
    if (index < 0 || index >= _deck.length) return;

    final card = _deck[index];

    setState(() {
      _isAnimatingSelection = true;
      _highlightedFanIndex = index;
    });

    HapticFeedback.lightImpact();
    await _playCardSound();

    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    setState(() {
      _deck.removeAt(index);
      _selected.add(card);
      _highlightedFanIndex = null;

      if (_selected.length >= widget.cardsNeeded || _deck.isEmpty) {
        _fanOpen = false;
        _fanAnimatingOpen = false;
        _fanSweepIndex = -1;
      }
    });

    await Future.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    setState(() {
      _isAnimatingSelection = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _deckBackCard({
    double width = 76,
    double height = 116,
    double angle = 0,
    VoidCallback? onTap,
    double opacity = 1,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _accentBorder.withOpacity(0.85),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.24),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/tarot/cards/reverso.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFanDeck() {
    final canPickMore = _selected.length < widget.cardsNeeded;
    final visibleDeck = _deck.take(24).toList();

    return SizedBox(
      width: double.infinity,
      height: 340,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = 76.0;
          final cardHeight = 116.0;

          final centerX = constraints.maxWidth / 2;
          final circleCenterY = 260.0;

          final radius = 185.0;
          final spreadDeg = 78.0;
          final spreadRad = spreadDeg * pi / 180.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (!_fanOpen)
                Center(
                  child: _deckBackCard(
                    width: cardWidth,
                    height: cardHeight,
                    onTap: canPickMore ? _toggleFan : null,
                    opacity: canPickMore ? 1 : 0.35,
                  ),
                ),

              if (_fanOpen)
                ...List.generate(visibleDeck.length, (i) {
                  final total = visibleDeck.length;
                  final t = total == 1 ? 0.5 : i / (total - 1);

                  final angle = (-spreadRad / 2) + (spreadRad * t);
                  final isHighlighted = _highlightedFanIndex == i;
                  final isDeployed = !_fanAnimatingOpen || i <= _fanSweepIndex;

                  final x = centerX + radius * sin(angle) - (cardWidth / 2);
                  final y = circleCenterY - radius * cos(angle);
                  final top = y + (isHighlighted ? -24 : 0);

                  return Positioned(
                    left: x,
                    top: top,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 140),
                      opacity: isDeployed ? 1.0 : 0.0,
                      child: Transform.rotate(
                        angle: angle,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (canPickMore && !_isAnimatingSelection)
                              ? () => _selectFromFan(i)
                              : null,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 180),
                            scale: isHighlighted ? 1.08 : 1.0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: cardWidth,
                              height: cardHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _accentBorder.withOpacity(
                                    isHighlighted ? 1 : 0.85,
                                  ),
                                  width: isHighlighted ? 1.8 : 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.26),
                                    blurRadius: 16,
                                    offset: const Offset(0, 10),
                                  ),
                                  if (isHighlighted)
                                    BoxShadow(
                                      color: _accentFill.withOpacity(0.34),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/tarot/cards/reverso.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

              if (_fanOpen)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton.icon(
                      onPressed: _toggleFan,
                      icon: const Icon(Icons.keyboard_arrow_up),
                      label: const Text('Cerrar abanico'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedRow() {
    if (_selected.isEmpty) {
      return Text(
        'Elige ${widget.cardsNeeded} carta(s) desde el abanico',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.72),
          fontSize: 15,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selected.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.cardsNeeded == 3 ? 3 : 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, i) {
        final c = _selected[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _accentBorder.withOpacity(0.45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      c.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _selected.length == widget.cardsNeeded;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text('Elige ${widget.cardsNeeded} cartas'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: _accentBorder.withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selected.length} de ${widget.cardsNeeded} elegidas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildFanDeck(),
                  const SizedBox(height: 12),
                  _buildSelectedRow(),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ready
                          ? () => Navigator.pop(
                        context,
                        List<TarotCard>.from(_selected),
                      )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white12,
                        disabledForegroundColor: Colors.white38,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        ready
                            ? 'Confirmar selección'
                            : 'Elige ${widget.cardsNeeded - _selected.length} carta(s) más',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}