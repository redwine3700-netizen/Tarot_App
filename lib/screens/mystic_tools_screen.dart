import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MysticToolsScreen extends StatelessWidget {
  const MysticToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 👉 Tres pestañas: dados, ruleta, flor
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Herramientas mágicas'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Color(0xFFFFD700),
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
              colors: [
                Color(0xFF140A24),
                Color(0xFF1C1036),
                Color(0xFF2C1D4A),
              ],
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

// ------------------------ DADOS MÁGICOS ------------------------

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

    setState(() {
      _rolling = true;
    });

    // Pequeña animación de cambio rápido
    const totalSteps = 10;
    const stepDuration = Duration(milliseconds: 60);

    for (int i = 0; i < totalSteps; i++) {
      await Future.delayed(stepDuration);
      if (!mounted) return;
      final newValue = _random.nextInt(6) + 1;
      setState(() {
        _currentValue = newValue;
        _currentMessage = _diceMessages[newValue - 1];
      });
    }

    if (!mounted) return;
    setState(() {
      _rolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dorado = Color(0xFFFFD700);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Lanza el dado y recibe un mensaje para tu energía de hoy.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: dorado.withOpacity(0.7),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_currentValue',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: dorado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _rollDice,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                _rolling ? 'Lanzando...' : 'Lanzar dado mágico 🎲',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ------------------------ RULETA DE MENSAJES ------------------------

class MagicRouletteTab extends StatefulWidget {
  const MagicRouletteTab({super.key});

  @override
  State<MagicRouletteTab> createState() => _MagicRouletteTabState();
}

class _MagicRouletteTabState extends State<MagicRouletteTab> {
  final Random _random = Random();

  static const List<String> _messages = [
    'Mereces un amor tranquilo, que te abrace el alma.',
    'Lo que es para ti no necesita empujones, solo espacio.',
    'Estás más cerca de lo que sueñas de lo que imaginas.',
    'Tu sensibilidad no es un problema, es tu superpoder.',
    'Hoy date al menos un gesto de cariño a ti mism@.',
    'El universo ya escuchó lo que pediste, confía en el proceso.',
    'Nada que sea auténtico se pierde: se transforma.',
    'Cuando te eliges a ti, todo lo demás se ordena.',
  ];

  String? _currentMessage;
  bool _spinning = false;
  double _rotationTurns = 0;

  Future<void> _spinRoulette() async {
    if (_spinning) return;

    setState(() {
      _spinning = true;
      _rotationTurns += 3 + _random.nextDouble() * 3; // entre 3 y 6 vueltas
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final newMessage = _messages[_random.nextInt(_messages.length)];

    setState(() {
      _currentMessage = newMessage;
      _spinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dorado = Color(0xFFFFD700);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Gira la ruleta y recibe un mensaje lindo para tu día.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedRotation(
                    turns: _rotationTurns,
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const SweepGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFB39DDB),
                            Color(0xFFFF80AB),
                            Color(0xFFFFD700),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: dorado.withOpacity(0.9),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.star,
                      color: dorado,
                      size: 48,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: dorado,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_currentMessage != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dorado.withOpacity(0.6),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                _currentMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _spinRoulette,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                _spinning ? 'Girando...' : 'Girar ruleta ✨',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ------------------------ FLOR DEL AMOR ------------------------

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
      _totalPetals = 10 + _random.nextInt(5); // entre 10 y 14 pétalos
      _petalsAlive = List<bool>.filled(_totalPetals, true);
      _finished = false;
      _currentMessage =
      'Piensa en esa persona especial mientras deshojas la flor.';
      _finalMessageChosen =
      _finalMessages[_random.nextInt(_finalMessages.length)];
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
        _currentMessage =
        _midMessages[_random.nextInt(_midMessages.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dorado = Color(0xFFFFD700);

    return Padding(
      padding: const EdgeInsets.all(16),
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
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_petalsAlive.length, (index) {
                        final alive = _petalsAlive[index];
                        return GestureDetector(
                          onTap: () => _pluckPetal(index),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: alive ? 1.0 : 0.1,
                            child: Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: alive
                                    ? Colors.pinkAccent.withOpacity(0.85)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: dorado.withOpacity(
                                      alive ? 0.7 : 0.2),
                                  width: 1.2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: alive
                                  ? const Icon(
                                Icons.favorite,
                                size: 24,
                                color: Colors.white,
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      }),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.85),
                        border: Border.all(
                          color: dorado.withOpacity(0.9),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.local_florist,
                            color: Color(0xFFFFD700),
                            size: 30,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Flor\ndel amor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_currentMessage != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dorado.withOpacity(0.6),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                _currentMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startNewFlower,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                _finished ? 'Deshojar otra flor 🌼' : 'Nueva flor 🌼',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
