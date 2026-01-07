import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ====== UI helpers (glow + card + pill + gold button) ======

const _kGold = Color(0xFFFFD700);
const _kBg1 = Color(0xFF140A24);
const _kBg2 = Color(0xFF1C1036);
const _kBg3 = Color(0xFF2C1D4A);

TextStyle _glowText(TextStyle base, {Color glow = _kGold}) {
  return base.copyWith(
    letterSpacing: 0.25,
    shadows: [
      Shadow(color: glow.withOpacity(0.55), blurRadius: 14),
      const Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 2)),
    ],
  );
}

Widget _mysticCard({required Widget child, EdgeInsets padding = const EdgeInsets.all(16)}) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [_kBg3, _kBg2, _kBg1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white24, width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 22, offset: const Offset(0, 12)),
      ],
    ),
    child: Padding(padding: padding, child: child),
  );
}

ButtonStyle _goldButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: _kGold,
    foregroundColor: Colors.black,
    elevation: 12,
    shadowColor: _kGold.withOpacity(0.25),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.2),
  );
}

Widget _resultPill(
    String text, {
      Key? key,
      IconData icon = Icons.auto_awesome,
    }) {
  return Container(
    key: key,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.45),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: _kGold.withOpacity(0.75)),
      boxShadow: [BoxShadow(color: _kGold.withOpacity(0.18), blurRadius: 14)],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _kGold, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: _glowText(
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    ),
  );
}

// ======================= SCREEN =======================

class MysticToolsScreen extends StatelessWidget {
  const MysticToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Herramientas mágicas',
            style: _glowText(
              (theme.textTheme.titleLarge ?? const TextStyle(fontSize: 20)).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: _kGold,
            tabs: [
              Tab(text: 'Dados mágicos'),
              Tab(text: 'Ruleta de mensajes'),
              Tab(text: 'Flor del amor'),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_kBg1, _kBg2, _kBg3],
            ),
          ),
          child: const SafeArea(
            child: TabBarView(
              children: [
                MysticDiceTab(),
                MagicRouletteTab(),
                FlowerPetalTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= DADOS =======================

class MysticDiceTab extends StatefulWidget {
  const MysticDiceTab({super.key});

  @override
  State<MysticDiceTab> createState() => _MysticDiceTabState();
}

class _MysticDiceTabState extends State<MysticDiceTab> {
  final Random _random = Random();

  static const List<String> _diceMessages = [
    'Nuevo comienzo: algo hermoso quiere entrar a tu vida.',
    'Confía en tu intuición, ya sabes más de lo que crees.',
    'Pide ayuda: no tienes por qué poder con todo solo.',
    'Viene una sorpresa dulce, mantén el corazón abierto.',
    'Es momento de soltar una preocupación que ya pesó demasiado.',
    'Celebra un pequeño logro de hoy, aunque parezca mínimo.',
  ];

  int _currentValue = 1;
  String _currentMessage = _diceMessages[0];
  bool _rolling = false;

  Future<void> _rollDice() async {
    if (_rolling) return;

    setState(() => _rolling = true);

    await Future.delayed(const Duration(milliseconds: 420));

    final newValue = 1 + _random.nextInt(6);
    final newMessage = _diceMessages[newValue - 1];

    if (!mounted) return;

    setState(() {
      _currentValue = newValue;
      _currentMessage = newMessage;
      _rolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: _mysticCard(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Lanza el dado y recibe un mensaje.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kGold.withOpacity(0.75), width: 2),
                boxShadow: [
                  BoxShadow(color: _kGold.withOpacity(0.10), blurRadius: 20),
                  BoxShadow(color: Colors.black.withOpacity(0.60), blurRadius: 22, offset: const Offset(0, 14)),
                ],
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Text(
                  '$_currentValue',
                  key: ValueKey(_currentValue),
                  style: _glowText(
                    theme.textTheme.displayMedium?.copyWith(
                      color: _kGold,
                      fontWeight: FontWeight.w900,
                    ) ??
                        const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: _kGold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _resultPill(
                _currentMessage,
                key: ValueKey(_currentMessage),
                icon: Icons.casino,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rollDice,
                style: _goldButtonStyle(),
                child: Text(_rolling ? 'Lanzando...' : 'Lanzar dado mágico 🎲'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ======================= RULETA =======================


class MagicRouletteTab extends StatefulWidget {
  const MagicRouletteTab({super.key});

  @override
  State<MagicRouletteTab> createState() => _MagicRouletteTabState();
}

class _MagicRouletteTabState extends State<MagicRouletteTab> {
  final Random _random = Random();

  static const List<String> _items = [
    'Sí, avanza',
    'No por ahora',
    'Tal vez',
    'Confía',
    'Cambia el enfoque',
    'Paciencia',
    'Sorpresa',
    'Protege tu energía',
  ];

  String? _currentMessage;
  bool _spinning = false;

  double _turns = 0.0;

  Future<void> _spinRoulette() async {
    if (_spinning) return;

    setState(() {
      _spinning = true;
      _currentMessage = null;
    });

    final n = _items.length;

    // Segmento destino
    final index = _random.nextInt(n);

    // Turns por segmento
    final segmentTurns = 1.0 / n;
    // Centro del segmento elegido
    final centerOffsetTurns = (index + 0.5) * segmentTurns;

    // Vueltas extra + aterrizaje alineado con el puntero arriba
    final extra = 3 + _random.nextInt(3); // 3..5
    final targetTurns = extra.toDouble() + (1.0 - centerOffsetTurns);

    setState(() => _turns += targetTurns);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _currentMessage = _items[index];
      _spinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: _mysticCard(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Gira la ruleta y deja que el destino te hable.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 22),

            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedRotation(
                      turns: _turns,
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      child: CustomPaint(
                        size: const Size(260, 260),
                        painter: _SegmentWheelPainter(items: _items),
                      ),
                    ),
                    // Centro
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        shape: BoxShape.circle,
                        border: Border.all(color: _kGold.withOpacity(0.9), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: _kGold, size: 42),
                          const SizedBox(height: 6),
                          Text(
                            'GIRA',
                            style: _glowText(
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Puntero arriba
                    const Positioned(
                      top: 2,
                      child: Icon(Icons.arrow_drop_down, size: 48, color: _kGold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            if (_currentMessage != null)
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _resultPill(
                    _currentMessage!,
                    key: ValueKey(_currentMessage),
                    icon: Icons.blur_circular,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _spinRoulette,
                style: _goldButtonStyle(),
                child: Text(_spinning ? 'Girando...' : 'Girar ruleta ✨'),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SegmentWheelPainter extends CustomPainter {
  final List<String> items;
  _SegmentWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Fondo
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF2C1D4A), Color(0xFF140A24)],
      ).createShader(rect);
    canvas.drawCircle(center, radius, bgPaint);

    // Aros
    final ringPaint = Paint()
      ..color = _kGold.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius * 0.92, ringPaint);
    canvas.drawCircle(center, radius * 0.62, ringPaint);

    final n = items.length;
    final seg = 2 * pi / n;

    for (int i = 0; i < n; i++) {
      final start = -pi / 2 + seg * i;

      // Segmento
      final fill = Paint()
        ..color = (i.isEven ? Colors.white : Colors.white70).withOpacity(0.10)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, start, seg, true, fill);

      // Separador
      final sepPaint = Paint()
        ..color = _kGold.withOpacity(0.20)
        ..strokeWidth = 2;

      final p2 = Offset(
        center.dx + radius * cos(start),
        center.dy + radius * sin(start),
      );
      canvas.drawLine(center, p2, sepPaint);

      // Texto
      final text = items[i].toUpperCase();
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: radius * 0.72);

      final mid = start + seg / 2;
      final textRadius = radius * 0.72;
      final offset = Offset(
        center.dx + textRadius * cos(mid),
        center.dy + textRadius * sin(mid),
      );

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(mid + pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Borde final
    final borderPaint = Paint()
      ..color = _kGold.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SegmentWheelPainter oldDelegate) => false;
}

// ======================= FLOR =======================

class FlowerPetalTab extends StatefulWidget {
  const FlowerPetalTab({super.key});

  @override
  State<FlowerPetalTab> createState() => _FlowerPetalTabState();
}

class _FlowerPetalTabState extends State<FlowerPetalTab> {
  final Random _random = Random();

  static const List<String> _midMessages = [
    'Te piensa a ratitos.',
    'Le mueves el corazón.',
    'Se hace el fuerte, pero le importas.',
    'Duda, pero siente algo.',
    'Te sueña más de lo que admite.',
  ];

  static const List<String> _finalMessages = [
    'Te elige desde el corazón.',
    'Te quiere más de lo que imaginas.',
    'Hay un lazo muy especial entre ustedes.',
    'Si se atreviera, daría un paso hacia ti.',
    'Lo que sienten es mutuo de alguna forma.',
  ];

  late List<bool> _petalsAlive;
  int _totalPetals = 0;
  String? _currentMessage;
  String? _finalMessageChosen;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _startNewFlower();
  }

  void _startNewFlower() {
    setState(() {
      _totalPetals = 10 + _random.nextInt(5);
      _petalsAlive = List<bool>.filled(_totalPetals, true);
      _finished = false;
      _currentMessage = 'Piensa en esa persona especial mientras deshojas la flor.';
      _finalMessageChosen = _finalMessages[_random.nextInt(_finalMessages.length)];
    });
  }

  void _pluckPetal(int index) {
    if (_finished) return;
    if (!_petalsAlive[index]) return;

    setState(() {
      _petalsAlive[index] = false;
      final remaining = _petalsAlive.where((p) => p).length;

      if (remaining == 0) {
        _finished = true;
        _currentMessage = _finalMessageChosen;
      } else {
        _currentMessage = _midMessages[_random.nextInt(_midMessages.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: _mysticCard(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Toca los pétalos uno a uno y deja que la flor te susurre un mensaje.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = 0; i < _petalsAlive.length; i++) _buildPetalInCircle(i),
                      _centerFlower(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            if (_currentMessage != null)
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _resultPill(
                    _currentMessage!,
                    key: ValueKey(_currentMessage),
                    icon: Icons.local_florist,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startNewFlower,
                style: _goldButtonStyle(),
                child: Text(_finished ? 'Deshojar otra flor 🌼' : 'Nueva flor 🌼'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  Widget _buildPetalInCircle(int index) {
    final alive = _petalsAlive[index];
    final total = _petalsAlive.length;

    final angle = (-pi / 2) + (2 * pi * index / total);
    final radius = 105.0;

    return Positioned(
      left: 150 + radius * cos(angle) - 30,
      top: 150 + radius * sin(angle) - 40,
      child: GestureDetector(
        onTap: () => _pluckPetal(index),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: alive ? 1.0 : 0.08,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: alive ? 1.0 : 0.88,
            child: Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pinkAccent.withOpacity(0.95),
                    Colors.pinkAccent.withOpacity(0.65),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _kGold.withOpacity(alive ? 0.8 : 0.25),
                  width: 1.2,
                ),
                boxShadow: [
                  if (alive)
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: alive
                  ? const Icon(Icons.favorite, size: 24, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _centerFlower() {
    return Container(
      width: 98,
      height: 98,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.86),
        border: Border.all(color: _kGold.withOpacity(0.95), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 12, offset: const Offset(0, 6)),
          BoxShadow(color: _kGold.withOpacity(0.10), blurRadius: 18),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.local_florist, color: _kGold, size: 30),
          SizedBox(height: 4),
          Text(
            'Flor\ndel amor',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kGold,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

}

