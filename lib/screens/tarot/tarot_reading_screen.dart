import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';

import '../../models/tarot_models.dart';
import '../../services/copy_loader.dart';
import '../../data/tarot_cards.dart';
import '../../services/emotional_memory_service.dart';
import 'widgets/emotional_process_section.dart';
import 'helpers/emotional_process_helpers.dart';
import 'helpers/process_day_logic.dart';
import 'emotional_process_screen.dart';
import 'emotional_history_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tarot_card_picker_screen.dart';



enum AccentStyle { dorado, rosado }

// Copy helpers (picks deterministic text from JSON packs/meta)
Map<String, dynamic>? _packById(String id) {
  return CopyLoader.instance.packById(id);
}

String _pickText(List<dynamic>? items, {int seed = 0}) {
  if (items == null || items.isEmpty) return '';
  // Selección simple determinista (para no “bailar” cada rebuild)
  final idx = seed % items.length;
  final it = items[idx];
  if (it is Map && it['text'] != null) return it['text'].toString();
  return '';
}

class TarotReadingScreen extends StatefulWidget {
  final String initialArea; // "general" | "amor" | "trabajo" | "dinero"
  final String title;
  final List<TarotCard> cards; // 3 o 6 (legacy/compat)
  final String spreadName;
  final String? question;

  const TarotReadingScreen({
    super.key,
    required this.title,
    required this.cards,
    required this.spreadName,
    this.question,
    this.initialArea = "general",
  });

  @override
  State<TarotReadingScreen> createState() => _TarotReadingScreenState();
}

class _TarotReadingScreenState extends State<TarotReadingScreen> {
  AccentStyle _accent = AccentStyle.dorado;
  bool _fullReading = true;

  // === NUEVO FLUJO 6 CARTAS: mazo -> mesa -> tocar = significado -> botón ver lectura ===

  List<TarotCard> _deck = <TarotCard>[];
  final List<TarotCard> _tableCards = [];
  List<TarotCard>? _selectedForReading;

  bool _fanOpen = false;

  int _fanSweepIndex = -1;
  bool _fanAnimatingOpen = false;

  bool _isAnimatingSelection = false;
  int? _highlightedFanIndex;
  String? _revealingCardName;
  int? _revealingCardIndex;

  TarotCard? _flyingCard;
  double _flyingLeft = 0;
  double _flyingTop = 0;
  double _flyingAngle = 0;
  double _flyingScale = 1.0;
  bool _showFlyingCard = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // === LECTURA DESDE JSON (CopyLoader) ===
  String _readingIntro = '';
  String? _readingSummary;
  String? _readingFull;

  String? _prevEstado;
  DateTime? _prevUltimaLectura;
  String? _prevFoco;
  List<Map<String, dynamic>> _emotionalHistory = [];

  int _processDay = 0;

  static const _estados = [
    'tranquilo',
    'confundido',
    'ansioso',
    'esperanzado',
    'triste',
  ];

  static const _focosRelacionales = [
    'ex pareja',
    'relación actual',
    'conociendo a alguien',
    'duelo o pérdida',
    'amor propio',
  ];

  static const _kLastCheckin = 'last_emotional_checkin';

  int _readingSeed = 0;

  Color get _bg => const Color(0xFF140B1F);

  Color get _panel => const Color(0xFF1E1230);

  Color get _goldFill => const Color(0xFFFFE7D0);

  Color get _goldBorder => const Color(0xFFEAC19C);

  Color get _pinkFill => const Color(0xFFFFD6EA);

  Color get _pinkBorder => const Color(0xFFFF9BC9);

  Color get _accentFill =>
      _accent == AccentStyle.dorado ? _goldFill : _pinkFill;

  Color get _accentBorder =>
      _accent == AccentStyle.dorado ? _goldBorder : _pinkBorder;

  Future<void> _loadEmotionalMemory() async {
    final memory = EmotionalMemoryService();
    final estado = await memory.getEstado();
    final ultima = await memory.getUltimaLectura();
    final foco = await memory.getFoco();
    final history = await memory.getHistory();
    final processDay = await memory.getProcessDay();

    if (!mounted) return;
    setState(() {
      _prevEstado = estado;
      _prevUltimaLectura = ultima;
      _prevFoco = foco;
      _emotionalHistory = history;
      _processDay = processDay;
    });
  }

  Future<bool> _shouldAskForCheckin() async {
    final memory = EmotionalMemoryService();

    final estado = await memory.getEstado();
    final foco = await memory.getFoco();
    final lastCheckin = await memory.getLastCheckin();

    if ((estado ?? '')
        .trim()
        .isEmpty || (foco ?? '')
        .trim()
        .isEmpty) {
      return true;
    }

    if (lastCheckin == null) {
      return true;
    }

    final diff = DateTime.now().difference(lastCheckin);

    return diff.inHours >= 24;
  }

  Future<void> _promptEstadoYFoco() async {
    String? estadoSel;
    String? focoSel;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Check-in emocional',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '¿Cómo te sientes hoy?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _estados.map((e) {
                        final selected = estadoSel == e;
                        return ChoiceChip(
                          label: Text(e),
                          selected: selected,
                          onSelected: (_) => setLocal(() => estadoSel = e),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿En qué está tu foco?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _focosRelacionales.map((f) {
                        final selected = focoSel == f;
                        return ChoiceChip(
                          label: Text(f),
                          selected: selected,
                          onSelected: (_) => setLocal(() => focoSel = f),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Ahora no'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != true) return;

    final memory = EmotionalMemoryService();

    if ((estadoSel ?? '')
        .trim()
        .isNotEmpty) {
      await memory.saveEstado(estadoSel!.trim());
    }

    if ((focoSel ?? '')
        .trim()
        .isNotEmpty) {
      await memory.saveFoco(focoSel!.trim());
    }

    if ((estadoSel ?? '')
        .trim()
        .isNotEmpty &&
        (focoSel ?? '')
            .trim()
            .isNotEmpty) {
      await memory.addHistoryEntry(
        estado: estadoSel!.trim(),
        foco: focoSel!.trim(),
      );
    }

    await memory.saveLastCheckinNow();
  }

  @override
  void initState() {
    super.initState();
    _initDeckIfNeeded();
    _loadEmotionalMemory();
    Future.microtask(_initAutoReadingIfNeeded);
  }

  void _initDeckIfNeeded() {
    if (widget.cards.length == 6 || widget.cards.length == 3) {
      _deck = List<TarotCard>.from(cartasTarot)
        ..shuffle(Random());
      _tableCards.clear();
      _selectedForReading = null;
      _fanOpen = false;
      _isAnimatingSelection = false;
    } else {
      _deck = <TarotCard>[];
    }
  }

  Future<void> _initAutoReadingIfNeeded() async {
    // Para 6 cartas lo dejas manual, como ya está ahora.
    if (widget.cards.length == 6 || widget.cards.length == 3) return;

    // Si no hay cartas, no hacemos nada.
    if (widget.cards.isEmpty) return;

    final selected = List<TarotCard>.from(widget.cards);

    setState(() {
      _selectedForReading = selected;

      // Para que también se vean en el panel de cartas
      _tableCards
        ..clear()
        ..addAll(selected);
    });

    await _buildReadingFromJson(cards: selected);

    if (mounted) {
      setState(() {});
    }
  }

  String _normalizeArea(String a) {
    final x = a.trim().toLowerCase();
    if (x.isEmpty) return 'general';

    if (x == 'amor' || x == 'love') return 'amor';
    if (x == 'trabajo' || x == 'work') return 'trabajo';
    if (x == 'dinero' || x == 'money') return 'dinero';
    if (x == 'general') return 'general';

    return 'general';
  }

  Map<String, dynamic>? _findTarotReadingPack(String area) {
    final a = _normalizeArea(area);

    // Intenta free primero, luego premium (por si después lo activas)
    return _packById('es_${a}_free') ?? _packById('es_${a}_premium');
  }

  int _seedFromCards(List<TarotCard> cards) {
    int s = 17;
    for (final c in cards) {
      s = (s * 31) ^ c.nombre.hashCode;
    }
    final q = (widget.question ?? '').trim();
    if (q.isNotEmpty) s = (s * 31) ^ q.hashCode;
    s = (s * 31) ^ widget.spreadName.hashCode;
    s = (s * 31) ^ widget.initialArea.hashCode;
    return s.abs();
  }

  Future<void> _buildReadingFromJson({required List<TarotCard> cards}) async {
    final seed = _seedFromCards(cards);

    final pack = _findTarotReadingPack(widget.initialArea);

    final summaryItems = pack?['summary'] as List<dynamic>?;
    final fullItems = pack?['full'] as List<dynamic>?;

    final memory = EmotionalMemoryService();
    final name = await memory.getName();
    final prevEstado = await memory.getEstado();
    final prevUltima = await memory.getUltimaLectura();
    final prevFoco = await memory.getFoco();

    final history = await memory.getHistory();

    String changeMessage = '';

    if (history.length >= 2) {
      final current = history[0];
      final previous = history[1];

      final currentEstado = (current['estado'] ?? '').toString();
      final previousEstado = (previous['estado'] ?? '').toString();

      final currentFoco = (current['foco'] ?? '').toString();
      final previousFoco = (previous['foco'] ?? '').toString();

      if (currentEstado.isNotEmpty &&
          previousEstado.isNotEmpty &&
          currentEstado != previousEstado) {
        changeMessage =
        'Pasaste de "$previousEstado" a "$currentEstado". Tu energía se está moviendo.';
      }

      if (currentFoco.isNotEmpty &&
          previousFoco.isNotEmpty &&
          currentFoco != previousFoco) {
        if (changeMessage.isNotEmpty) {
          changeMessage += '\n';
        }
        changeMessage +=
        'Tu foco cambió de "$previousFoco" a "$currentFoco". Eso también habla de tu proceso.';
      }
    }

    String intro = '';
    final n = (name ?? '').trim();
    final quien = n.isNotEmpty ? '$n, ' : '';

    if ((prevEstado ?? '').isNotEmpty && (prevFoco ?? '').isNotEmpty) {
      intro =
      '${quien}la última vez estabas "$prevEstado" con foco en "$prevFoco". Hoy miremos qué cambió.\n\n';
    } else if ((prevEstado ?? '').isNotEmpty && prevUltima != null) {
      intro =
      '${quien}la última vez estabas "$prevEstado". Hoy miremos qué cambió.\n\n';
    } else if ((prevFoco ?? '').isNotEmpty) {
      intro = '${quien}hoy vamos a mirar tu energía en "$prevFoco".\n\n';
    }
    if (changeMessage.isNotEmpty) {
      intro = '$changeMessage\n\n$intro';
    }

    final s = _pickText(summaryItems, seed: seed).trim();
    final f = _pickText(fullItems, seed: seed).trim();

    setState(() {
      _readingSeed = seed;

      _readingSummary = s.isNotEmpty
          ? s
          : 'Resumen: Las cartas sugieren un camino de ajuste y claridad. Observa el mensaje principal de cada carta y actúa con calma.';

      _readingIntro = intro;

      _readingFull = f.isNotEmpty
          ? f
          : 'Lectura completa: Mira el hilo común entre tus cartas. ¿Qué te piden reforzar, soltar o decidir hoy? Usa los significados como guía y elige un paso pequeño y concreto.';
    });

    await memory.saveUltimaLectura();

    final shouldAsk = await _shouldAskForCheckin();
    if (shouldAsk) {
      await _promptEstadoYFoco();
    }

    await _loadEmotionalMemory();
  }

  Future<void> _toggleFan() async {
    if (widget.cards.length != 6 && widget.cards.length != 3) return;
    if (_tableCards.length >= widget.cards.length) return;

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
      await Future.delayed(const Duration(milliseconds: 95));
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
    if (widget.cards.length != 6 && widget.cards.length != 3) return;
    if (_tableCards.length >= widget.cards.length) return;
    if (index < 0 || index >= _deck.length) return;

    final card = _deck[index];
    final insertIndex = _tableCards.length;

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
      _tableCards.add(card);
      _revealingCardName = card.nombre;
      _revealingCardIndex = insertIndex;
      _highlightedFanIndex = null;

      if (_tableCards.length >= widget.cards.length || _deck.isEmpty) {
        _fanOpen = false;
      }
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    setState(() {
      _revealingCardName = null;
      _revealingCardIndex = null;
      _isAnimatingSelection = false;
    });
  }

  void _showCardPreview(TarotCard c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _accentBorder.withOpacity(0.55)),
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
                  border: Border.all(color: _accentBorder.withOpacity(0.6)),
                ),
                child: Image.asset(c.imagePath, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(
                c.nombre,
                style: TextStyle(
                  color: _accentFill,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
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

  Future<void> _playCardSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('sounds/card_flip_magic.wav'),
        volume: 0.35,
      );
    } catch (_) {}
  }

  Widget _deckBackCard({
    double width = 72,
    double height = 112,
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
                  color: Colors.black.withOpacity(0.22),
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


  Widget _flyingCardWidget(TarotCard card) {
    return IgnorePointer(
      child: AnimatedPositioned(
        duration: const Duration(milliseconds: 1900),
        curve: Curves.easeInOutQuart,
        left: _flyingLeft,
        top: _flyingTop,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          scale: _flyingScale,
          child: Transform.rotate(
            angle: _flyingAngle,
            child: Container(
              width: 76,
              height: 116,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _accentBorder.withOpacity(0.95)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: _accentFill.withOpacity(0.36),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                card.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _panel,
                  alignment: Alignment.center,
                  child: Text(
                    '★',
                    style: TextStyle(
                      color: _accentFill,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFanDeck() {
    final canPickMore = _tableCards.length < widget.cards.length;
    final visibleDeck = _deck.take(24).toList();

    return SizedBox(
      width: double.infinity,
      height: 240,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = 76.0;
          final cardHeight = 116.0;

          final centerX = constraints.maxWidth / 2;
          final circleCenterY = _fanOpen ? 250.0 : 290.0;

          // reduce esto para "juntar" el abanico sin angostarlo artificialmente
          final radius = _fanOpen ? 175.0 : 260.0;
          final spreadDeg = _fanOpen ? 72.0 : 8.0;
          final spreadRad = spreadDeg * pi / 180.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedOpacity(
                opacity: _fanOpen ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 220),
                child: IgnorePointer(
                  ignoring: _fanOpen,
                  child: Center(
                    child: _deckBackCard(
                      width: cardWidth,
                      height: cardHeight,
                      onTap: canPickMore ? _toggleFan : null,
                      opacity: canPickMore ? 1 : 0.35,
                    ),
                  ),
                ),
              ),

              if (_fanOpen)
                ...List.generate(visibleDeck.length, (i) {
                  final total = visibleDeck.length;
                  final t = total == 1 ? 0.5 : i / (total - 1);

                  final angle = (-spreadRad / 2) + (spreadRad * t);
                  final isHighlighted = _highlightedFanIndex == i;

                  final isDeployed = !_fanAnimatingOpen || i <= _fanSweepIndex;

                  final deployedX = centerX + radius * sin(angle) - (cardWidth / 2);
                  final deployedY = circleCenterY - radius * cos(angle);

                  final closedX = centerX - (cardWidth / 2);
                  final closedY = circleCenterY + 2;

                  final x = isDeployed ? deployedX : closedX;
                  final y = isDeployed ? deployedY : closedY;

                  final top = y + (isHighlighted ? -24 : 0);

                  return Positioned(
                    left: x,
                    top: top,
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

  Future<void> _openCardPicker() async {
    final selected = await Navigator.push<List<TarotCard>>(
      context,
      MaterialPageRoute(
        builder: (_) => TarotCardPickerScreen(
          cardsNeeded: widget.cards.length,
          title: widget.spreadName,
        ),
      ),
    );

    if (!mounted || selected == null || selected.isEmpty) return;

    setState(() {
      _tableCards
        ..clear()
        ..addAll(selected);
      _selectedForReading = List<TarotCard>.from(selected);
      _fanOpen = false;
      _fanAnimatingOpen = false;
      _fanSweepIndex = -1;
    });
  }

  Widget _buildSelectedTable() {
    if (_tableCards.isEmpty) {
      return const SizedBox.shrink();
    }


    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tableCards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: widget.cards.length == 3 ? 0.46 : 0.60,
      ),
      itemBuilder: (context, i) {
        final c = _tableCards[i];
        final isRevealing = _revealingCardIndex == i;

        return AnimatedScale(
          duration: const Duration(milliseconds: 260),
          scale: isRevealing ? 1.08 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 16),
                ),
                if (isRevealing)
                  BoxShadow(
                    color: _accentFill.withOpacity(0.30),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isRevealing ? 0.0 : 1.0,
                  end: 1.0,
                ),
                duration: Duration(
                  milliseconds: isRevealing ? 620 : 220,
                ),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final angle = (1 - value) * pi;
                  final isFront = angle <= pi / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0015)
                      ..rotateY(angle),
                    child: isFront
                        ? child
                        : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Image.asset(
                        'assets/tarot/cards/reverso.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  c.imagePath,
                  key: ValueKey(c.nombre),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  void _copyToClipboard() {
    final cardsUsed = _selectedForReading ?? widget.cards;

    final summaryText = _readingSummary ?? '';
    final fullText = _readingFull ?? '';
    final readingTitle = _fullReading ? 'Interpretación' : 'Resumen';
    final readingText = _fullReading ? fullText : summaryText;

    final buffer = StringBuffer();
    buffer.writeln(widget.title);
    buffer.writeln('Tirada: ${widget.spreadName}');
    if ((widget.question ?? '')
        .trim()
        .isNotEmpty) {
      buffer.writeln('Pregunta: ${widget.question}');
    }
    buffer.writeln('');
    buffer.writeln('Cartas y significado:');
    buffer.writeln('');

    for (int i = 0; i < cardsUsed.length; i++) {
      final c = cardsUsed[i];
      buffer.writeln('${i + 1}. ${c.nombre}');
      buffer.writeln('   ${c.significado}');
      buffer.writeln('');
    }

    if (readingText
        .trim()
        .isNotEmpty) {
      buffer.writeln('---');
      buffer.writeln('$readingTitle:');
      buffer.writeln(readingText.trim());
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copiado al portapapeles')));
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Cartas que se usarán para lectura/copy:
    // - Si el usuario ya eligió con el mazo (6 cartas) -> _selectedForReading
    // - Si no -> widget.cards (3 cartas / flujo antiguo)
    final readingCards = _selectedForReading ?? widget.cards;

    final needsPick =
        (widget.cards.length == 6 || widget.cards.length == 3) &&
            (_selectedForReading == null || _selectedForReading!.isEmpty);

    final summaryText = _readingSummary ?? 'Generando resumen...';
    final fullText = _readingFull ?? 'Generando lectura completa...';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Estilo Dorado',
            onPressed: () => setState(() => _accent = AccentStyle.dorado),
            icon: Icon(
              Icons.auto_awesome,
              color: _accent == AccentStyle.dorado
                  ? _goldBorder
                  : Colors.white70,
            ),
          ),
          IconButton(
            tooltip: 'Estilo Rosado',
            onPressed: () => setState(() => _accent = AccentStyle.rosado),
            icon: Icon(
              Icons.favorite,
              color: _accent == AccentStyle.rosado
                  ? _pinkBorder
                  : Colors.white70,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _panelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title('Tirada: ${widget.spreadName}'),
                      const SizedBox(height: 8),
                      Text(
                        'Respira, conecta contigo y deja que las cartas hablen.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Colors.white.withOpacity(0.78),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if ((widget.question ?? '').trim().isNotEmpty)
                        Text(
                          'Pregunta: ${widget.question}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _chip(
                              label: _fullReading ? 'Lectura completa' : 'Resumen',
                              onTap: () =>
                                  setState(() => _fullReading = !_fullReading),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _chip(
                              label: 'Copiar',
                              icon: Icons.copy,
                              onTap: _copyToClipboard,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // === CARTAS ===
                _panelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title('Cartas'),
                      const SizedBox(height: 12),

                      if (widget.cards.length == 6 || widget.cards.length == 3) ...[
                        Text(
                          _tableCards.isEmpty
                              ? 'Elige tus cartas en una pantalla dedicada para ver el abanico completo'
                              : 'Estas son las cartas que elegiste para tu lectura',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: KeyedSubtree(
                            key: ValueKey(_tableCards.map((e) => e.nombre).join('|')),
                            child: _buildSelectedTable(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openCardPicker,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            child: Text(
                              _tableCards.length < widget.cards.length
                                  ? 'Elegir ${widget.cards.length} cartas'
                                  : 'Cambiar cartas',
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _tableCards.length < widget.cards.length
                                ? null
                                : () async {
                              final selected = List<TarotCard>.from(_tableCards);

                              await _buildReadingFromJson(cards: selected);

                              if (mounted) {
                                setState(() {
                                  _selectedForReading = selected;
                                  _fanOpen = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                              foregroundColor: Colors.black,
                              disabledBackgroundColor: Colors.white12,
                              disabledForegroundColor: Colors.white38,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            child: Text(
                              _tableCards.length < widget.cards.length
                                  ? 'Elige ${widget.cards.length - _tableCards.length} carta(s) más'
                                  : 'Ver lectura',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // === RESULTADO / LECTURA ===
                _panelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: _title(_fullReading ? 'Interpretación' : 'Resumen'),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 72,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.65),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _fullReading ? (_readingFull ?? '') : (_readingSummary ?? ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.65,
                          color: Colors.white.withOpacity(0.96),
                        ),
                      ),
                      if (!needsPick && _readingIntro.trim().isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.28),
                            ),
                          ),
                          child: Text(
                            _readingIntro.trim(),
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      if (needsPick)
                        const Text(
                          'Selecciona las cartas para tu tirada y presiona “Ver lectura”.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      if (!needsPick && readingCards.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text(
                          'Cartas usadas: ${readingCards.map((e) => e.nombre).join(' • ')}',
                          style: const TextStyle(
                            color: Colors.white38,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmotionalProcessScreen(),
                        ),
                      );
                      await _loadEmotionalMemory();
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Ver mi proceso emocional'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _accentFill,
                      side: BorderSide(color: _accentBorder.withOpacity(0.45)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmotionalHistoryScreen(),
                        ),
                      );
                      await _loadEmotionalMemory();
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Ver historial emocional'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _accentFill,
                      side: BorderSide(color: _accentBorder.withOpacity(0.45)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //if (_showFlyingCard && _flyingCard != null)
             //_flyingCardWidget(_flyingCard!),
          ],
        ),
      ),
    );
  }

  Widget _panelCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.28),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: Color(0xFFFFD700),
      ),
    );
  }

  Widget _chip({
    required String label,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: _accentBorder.withOpacity(0.45), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: _accentFill),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(color: _accentFill, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }


  Widget _cardRow(TarotCard c) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showCardPreview(c),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _accentBorder.withOpacity(0.35)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 90,
                height: 130,
                child: Image.asset(c.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.significado,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, height: 1.25),
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
