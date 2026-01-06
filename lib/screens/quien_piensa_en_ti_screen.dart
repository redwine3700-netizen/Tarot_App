import 'dart:math';
import 'package:flutter/material.dart';

import '../models/tarot_models.dart';

class QuienPiensaEnTiScreen extends StatefulWidget {
  const QuienPiensaEnTiScreen({super.key});

  @override
  State<QuienPiensaEnTiScreen> createState() => _QuienPiensaEnTiScreenState();
}

class _QuienPiensaEnTiScreenState extends State<QuienPiensaEnTiScreen> {
  final Random _random = Random();

  List<TarotCard>? _tirada;
  List<bool> _revelada = List<bool>.filled(6, false);

  bool _revelando = false;
  bool _mostrarLecturaFinal = false;

  static const List<String> _posiciones6 = [
    'Energía de la persona',
    'Qué siente por ti',
    'Lo que muestra o aparenta',
    'Qué le impide acercarse',
    'Qué podrías hacer tú',
    'Hacia dónde va la conexión',
  ];

  @override
  void initState() {
    super.initState();
    _generarTirada();
  }

  void _generarTirada() {
    final barajadas = [...cartasTarot]..shuffle();
    setState(() {
      _tirada = barajadas.take(6).toList();
      _revelada = List<bool>.filled(6, false);
      _revelando = false;
      _mostrarLecturaFinal = false;
    });
  }

  Future<void> _revelarDeAUno() async {
    if (_tirada == null) return;
    if (_revelando) return;

    setState(() {
      _revelando = true;
      _mostrarLecturaFinal = false;
      _revelada = List<bool>.filled(6, false);
    });

    for (int i = 0; i < 6; i++) {
      await Future.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _revelada[i] = true);
    }

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() {
      _revelando = false;
      _mostrarLecturaFinal = true;
    });
  }

  Widget _flipCard({
    required bool showFront,
    required Widget front,
    required Widget back,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: showFront ? 1 : 0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        final angle = value * 3.1415926535;
        final isFrontVisible = value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          child: isFrontVisible
              ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(3.1415926535),
            child: front,
          )
              : back,
        );
      },
    );
  }

  String _intro() {
    const opciones = [
      'Respira… esta lectura muestra una verdad suave, sin forzar nada.',
      'Quédate un segundo en silencio: lo real se siente en calma.',
      'Confía en tu intuición: tu corazón entiende antes que tu mente.',
    ];
    return opciones[0];
  }

  String _interpretarCartaEnPosicion(TarotCard carta, int pos) {
    final base = carta.significado.trim();
    switch (pos) {
      case 0:
        return 'La energía general se siente así: $base';
      case 1:
        return 'En el fondo, sus sentimientos se mueven así: $base';
      case 2:
        return 'Lo que muestra hacia afuera sugiere que: $base';
      case 3:
        return 'El freno principal parece venir de esto: $base';
      case 4:
        return 'Tu mejor camino ahora es este: $base';
      case 5:
      default:
        return 'La tendencia del camino apunta a esto: $base';
    }
  }

  String _lecturaUnificada() {
    if (_tirada == null) return '';

    final t0 = _interpretarCartaEnPosicion(_tirada![0], 0);
    final t1 = _interpretarCartaEnPosicion(_tirada![1], 1);
    final t2 = _interpretarCartaEnPosicion(_tirada![2], 2);
    final t3 = _interpretarCartaEnPosicion(_tirada![3], 3);
    final t4 = _interpretarCartaEnPosicion(_tirada![4], 4);
    final t5 = _interpretarCartaEnPosicion(_tirada![5], 5);

    return '✨ Lectura completa\n'
        '${_intro()}\n\n'
        '🌙 Energía general:\n$t0\n\n'
        '💗 Lo que siente:\n$t1\n\n'
        '🎭 Lo que muestra:\n$t2\n\n'
        '🧱 Lo que le frena:\n$t3\n\n'
        '🫶 Tu guía:\n$t4\n\n'
        '🔮 Hacia dónde va:\n$t5\n\n'
        'Consejo final: no persigas señales. Observa quién se acerca con paz.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Quién piensa en ti?'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF140A24), Color(0xFF1C1036)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Revela 6 cartas. Se darán vuelta una por una y luego aparecerá una lectura completa.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _generarTirada,
                        child: const Text('Nueva tirada ♻️'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_tirada == null || _revelando) ? null : _revelarDeAUno,
                        child: Text(_revelando ? 'Revelando…' : 'Revelar ✨'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_tirada != null) _buildCardsRowSeis(context, _tirada!),
                if (_mostrarLecturaFinal) ...[
                  const SizedBox(height: 18),
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFFD700), width: 1),
                      ),
                      child: Text(
                        _lecturaUnificada(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardsRowSeis(BuildContext context, List<TarotCard> cards) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];

          return SizedBox(
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _flipCard(
                      showFront: _revelada[index],
                      front: AspectRatio(
                        aspectRatio: 3 / 5,
                        child: Image.asset(card.imagePath, fit: BoxFit.cover),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1744), Color(0xFF3A2060)],
                          ),
                          border: Border.all(color: const Color(0xFFFFD700), width: 1),
                        ),
                        child: const Center(
                          child: Icon(Icons.auto_awesome, color: Color(0xFFFFD700)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _posiciones6[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFD700),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _revelada[index] ? card.nombre : '—',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
