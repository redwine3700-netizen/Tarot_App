import 'dart:math';
import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import 'pendulum_screen.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final Random _random = Random();

  // Tirada 3 cartas
  List<TarotCard>? _lecturaTresCartas;

  // Tirada 6 cartas
  List<TarotCard>? _lecturaSeisCartas;

  // Sí / No
  TarotCard? _cartaSiNo;
  YesNoResult? _resultadoSiNo;

  // Juego de fichas (20 letras, elige 6)
  static const int _totalFichas = 20;
  static const int _maxFichasSeleccionadas = 6;
  List<String> _fichasLetras = [];
  List<bool> _fichasReveladas = [];
  int _contadorFichasSeleccionadas = 0;
  bool _juegoFichasIniciado = false;

  // ----------------- LÓGICA CARTAS -----------------

  List<TarotCard> _generarLectura(int cantidad) {
    final List<TarotCard> mazo = List.of(cartasTarot);
    mazo.shuffle(_random);
    return mazo.take(cantidad).toList();
  }

  void _hacerLecturaTresCartas() {
    setState(() {
      _lecturaTresCartas = _generarLectura(3);
    });
  }

  void _hacerLecturaSeisCartas() {
    setState(() {
      _lecturaSeisCartas = _generarLectura(6);
    });
  }

  void _hacerSiNo() {
    final card = cartasTarot[_random.nextInt(cartasTarot.length)];
    final result = yesNoMap[card.nombre] ?? YesNoResult.maybe;

    setState(() {
      _cartaSiNo = card;
      _resultadoSiNo = result;
    });
  }

  String _textoResultadoSiNo(YesNoResult result) {
    switch (result) {
      case YesNoResult.yes:
        return 'La energía se inclina hacia un SÍ. Confía en avanzar, pero escucha también tu intuición.';
      case YesNoResult.no:
        return 'La energía se inclina hacia un NO. Tal vez necesites cambiar el plan, el ritmo o las expectativas.';
      case YesNoResult.maybe:
        return 'La respuesta es un TAL VEZ. Hay factores que aún no están claros, espera señales antes de decidir.';
    }
  }

  Color _colorResultadoSiNo(YesNoResult result) {
    switch (result) {
      case YesNoResult.yes:
        return Colors.greenAccent;
      case YesNoResult.no:
        return Colors.redAccent;
      case YesNoResult.maybe:
        return Colors.amberAccent;
    }
  }

  Widget _buildCardsRow(List<TarotCard> cards) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 3 / 5,
                      child: Image.asset(
                        card.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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

  // ----------------- LÓGICA JUEGO FICHAS -----------------

  void _iniciarJuegoFichas() {
    const letras = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
    final random = Random();

    final List<String> nuevas = [];
    for (int i = 0; i < _totalFichas; i++) {
      nuevas.add(letras[random.nextInt(letras.length)]);
    }

    setState(() {
      _fichasLetras = nuevas;
      _fichasReveladas = List<bool>.filled(_totalFichas, false);
      _contadorFichasSeleccionadas = 0;
      _juegoFichasIniciado = true;
    });
  }

  void _onTapFicha(int index) {
    if (!_juegoFichasIniciado) return;
    if (_fichasReveladas[index]) return;
    if (_contadorFichasSeleccionadas >= _maxFichasSeleccionadas) return;

    setState(() {
      _fichasReveladas[index] = true;
      _contadorFichasSeleccionadas++;
    });
  }

  Widget _buildJuegoFichasSection(ThemeData theme) {
    const dorado = Color(0xFFFFD700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Juego de letras: elige 6 fichas',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Toca hasta 6 fichas para revelar letras. Después, deja que tu intuición juegue: '
              '¿qué nombres o palabras te vienen a la mente?',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _iniciarJuegoFichas,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: dorado,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: dorado),
              ),
            ),
            child: Text(
              _juegoFichasIniciado ? 'Volver a jugar' : 'Iniciar juego',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_juegoFichasIniciado) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_fichasLetras.length, (index) {
              final revelada = _fichasReveladas[index];

              return GestureDetector(
                onTap: () => _onTapFicha(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: revelada ? dorado : Colors.white24,
                      width: 1.2,
                    ),
                    boxShadow: revelada
                        ? [
                      BoxShadow(
                        color: dorado.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: revelada
                      ? Text(
                    _fichasLetras[index],
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: dorado,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : const Icon(
                    Icons.star_border,
                    color: dorado,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Fichas reveladas: $_contadorFichasSeleccionadas / $_maxFichasSeleccionadas',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No necesitas formar una palabra perfecta. Deja que las letras despierten recuerdos, nombres o ideas.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white60,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  // ----------------- BUILD -----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot del amor'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔮 3 cartas amor
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.4),
                    width: 1.1,
                  ),
                ),
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 cartas para iluminar tu camino en el amor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cierra los ojos, piensa en esa situación amorosa que te inquieta y deja que el tarot te susurre una respuesta.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hacerLecturaTresCartas,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Revelar 3 cartas ✨'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_lecturaTresCartas != null)
                        _buildCardsRow(_lecturaTresCartas!),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 😍 6 cartas: quién está pensando en ti
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Quién está pensando en ti?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Elige 6 cartas para intuir qué tipo de energía, historia o persona podría estar acercándose a tu vida.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hacerLecturaSeisCartas,
                          child: const Text('Revelar 6 cartas'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_lecturaSeisCartas != null)
                        _buildCardsRow(_lecturaSeisCartas!),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ❓ Pregunta SÍ / NO
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pregunta de SÍ / NO',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Formula una pregunta clara de sí o no. Respira profundo y deja que una carta responda por ti.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hacerSiNo,
                          child: const Text('Revelar respuesta'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_cartaSiNo != null && _resultadoSiNo != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: 80,
                                height: 130,
                                child: Image.asset(
                                  _cartaSiNo!.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _cartaSiNo!.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _cartaSiNo!.significado,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _resultadoSiNo == YesNoResult.yes
                                        ? 'Energía: SÍ'
                                        : _resultadoSiNo == YesNoResult.no
                                        ? 'Energía: NO'
                                        : 'Energía: TAL VEZ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _colorResultadoSiNo(
                                          _resultadoSiNo!),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _textoResultadoSiNo(_resultadoSiNo!),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🎲 Juego de fichas
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildJuegoFichasSection(theme),
                ),
              ),

              const SizedBox(height: 24),

              // 🔗 Péndulo del amor
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Péndulo del amor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si quieres una respuesta más mágica, pregunta al péndulo y observa cómo se mueve: '
                            'arriba/abajo (sí), lados (no), círculo (tal vez).',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PendulumScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.podcasts),
                          label: const Text('Ir al péndulo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
