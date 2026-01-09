import 'dart:math';
import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import 'pendulum_screen.dart';
import 'mystic_tools_screen.dart';
import 'tarot/tarot_reading_screen.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum TarotFocus { general, love, work, money }

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  TarotFocus _currentFocus =
      TarotFocus.love; // o TarotFocus.general si ya existe

  String _readingType = "general"; // "amor", "trabajo", "dinero"
  bool _isPremium = false; // después lo conectamos con tu premium real
  Map<String, dynamic>? _copyData;

  String _readingTypeFromFocus(TarotFocus focus) {
    switch (focus) {
      case TarotFocus.love:
        return "amor";
      case TarotFocus.work:
        return "trabajo";
      case TarotFocus.money:
        return "dinero";
      default:
        return "general";
    }
  }

  String _packIdFor(String readingType, bool isPremium) {
    final tier = isPremium ? "premium" : "free";
    return "es_${readingType}_$tier";
  }

  Map<String, dynamic> _findPackOrFallback(
    List packs,
    String readingType,
    bool isPremium,
  ) {
    final desiredId = _packIdFor(readingType, isPremium);
    final fallbackId = _packIdFor("general", isPremium);

    Map<String, dynamic>? desired;
    Map<String, dynamic>? fallback;

    for (final item in packs) {
      final p = item as Map<String, dynamic>;
      final id = p["id"];
      if (id == desiredId) desired = p;
      if (id == fallbackId) fallback = p;
    }

    return desired ?? fallback ?? (packs.first as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _loadCopyPacksEs() async {
    final jsonString = await rootBundle.loadString(
      'assets/copy/copy_packs_es.json',
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

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

  String _normalizeCardKey(String name) {
    // "El Sol" -> "EL_SOL" (ajusta si tus keys son distintas)
    final s = name
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ü', 'U')
        .replaceAll('Ñ', 'N')
        .replaceAll(RegExp(r'[^A-Z0-9 ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    return s;
  }

  String _pick(List<dynamic> list) => list[_random.nextInt(list.length)] as String;

  String _posKeyFor(String spreadName, int index) {
    final is3 = spreadName.contains('3');
    if (is3) return const ['pasado', 'presente', 'futuro'][index];

    // 6 cartas (puedes cambiar nombres si quieres)
    return const [
      'energia',
      'bloqueo',
      'ayuda',
      'consejo',
      'resultado',
      'clave'
    ][index];
  }

  String _composeMeaning({
    required TarotCard card,
    required String area,     // "general" | "amor" | "trabajo" | "dinero"
    required String posKey,   // "pasado" | "presente" | "futuro" | etc
    required bool is3Cards,
  }) {
    if (_copyData == null) return card.significado;

    final banks = _copyData!['banks'] as Map<String, dynamic>;

    // posiciones: para 3 usamos posicion_3; para 6 puedes reutilizar o crear otro bank después
    final posBank = (banks[is3Cards ? 'posicion_3' : 'posicion_3'] as Map<String, dynamic>);
    final posList = (posBank[posKey] as List<dynamic>?) ?? const [];
    final lensBank = banks['lente_area'] as Map<String, dynamic>;
    final lensList = (lensBank[area] as List<dynamic>?) ?? const [];
    final microList = (banks['microacciones'] as List<dynamic>?) ?? const [];

    final shortMap = (banks['significado_corto'] as Map<String, dynamic>?) ?? {};
    final key = _normalizeCardKey(card.nombre);
    final variants = (shortMap[key] as List<dynamic>?)?.cast<String>();

    final pos = posList.isNotEmpty ? _pick(posList) : '';
    final lens = lensList.isNotEmpty ? _pick(lensList) : '';
    final short = (variants != null && variants.isNotEmpty)
        ? variants[_random.nextInt(variants.length)]
        : card.significado;
    final micro = microList.isNotEmpty ? _pick(microList) : '';

    // armado final premium: corto + variado
    return [
      if (pos.isNotEmpty) pos,
      if (lens.isNotEmpty) lens,
      short,
      if (micro.isNotEmpty) micro,
    ].join('\n');
  }


  // ----------------- TEXTOS SEGÚN ENFOQUE -----------------

  String _focusLabel() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return 'Amor';
      case TarotFocus.work:
        return 'Trabajo';
      case TarotFocus.money:
        return 'Dinero';
      case TarotFocus.general:
        return 'General';
    }
  }

  String _title3Cards() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return '3 cartas para iluminar tu camino en el amor';
      case TarotFocus.work:
        return '3 cartas para entender tu camino laboral';
      case TarotFocus.money:
        return '3 cartas para desbloquear tu abundancia';
      case TarotFocus.general:
        return '3 cartas para descubrir tus energias';
    }
  }

  String _desc3Cards() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return 'Cierra los ojos, piensa en esa situación amorosa que te inquieta y deja que el tarot te susurre una respuesta.';
      case TarotFocus.work:
        return 'Piensa en tu trabajo, proyectos o metas. Estas cartas te mostrarán pasado, presente y tendencia en tu camino profesional.';
      case TarotFocus.money:
        return 'Conéctate con tus finanzas y deseos de estabilidad. Estas cartas te muestran qué energía rodea tu prosperidad y recursos.';
      case TarotFocus.general:
        return 'Descubre lo que las cartas aconsejan para ti a nivel general.';
    }
  }

  String _title6Cards() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return '¿Quién está pensando en ti?';
      case TarotFocus.work:
        return '¿Qué oportunidad se acerca?';
      case TarotFocus.money:
        return '¿Qué puerta de abundancia se abre?';
      case TarotFocus.general:
        return '¿Qué energias estan a nivel general?';
    }
  }

  String _desc6Cards() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return 'Elige 6 cartas para intuir qué tipo de persona o energía amorosa podría estar acercándose a tu vida.';
      case TarotFocus.work:
        return 'Revela 6 cartas para intuir qué proyectos, personas o cambios laborales pueden estar tocando a tu puerta.';
      case TarotFocus.money:
        return 'Revela 6 cartas para intuir qué caminos, ideas o ayudas podrían abrirse para mejorar tu economía.';
      case TarotFocus.general:
        return 'Revela 6 cartas para descubrir tus energias a nivel general.';
    }
  }

  String _labelJuegoFichas() {
    switch (_currentFocus) {
      case TarotFocus.love:
        return 'Deja que las iniciales te sugieran el nombre o apellido, de tu alguien especial que pienza en ti o situaciones donde el amor quiere florecer.';
      case TarotFocus.work:
        return 'Permite que las letras te inspiren ideas, proyectos o personas clave para tu crecimiento profesional.';
      case TarotFocus.money:
        return 'Observa qué letras aparecen y qué palabras de abundancia se forman en tu mente (clientes, ciudades, ideas…).';
      case TarotFocus.general:
        return 'Deja que tu intuición te recuerde algo de tu vida a nivel general.';
    }
  }

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
                      child: Image.asset(card.imagePath, fit: BoxFit.cover),
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

  void _abrirLecturaCompleta(List<TarotCard> cards, String spreadName) {
    final is3 = spreadName.contains('3');

    final lite = cards.asMap().entries.map((entry) {
      final i = entry.key;
      final c = entry.value;

      final posKey = _posKeyFor(spreadName, i);

      return TarotCardLite(
        name: c.nombre,
        imageAsset: c.imagePath,

        // ✅ ahora cada área sale distinta y además cambia por posición
        meaningGeneral: _composeMeaning(card: c, area: 'general', posKey: posKey, is3Cards: is3),
        meaningLove:    _composeMeaning(card: c, area: 'amor',    posKey: posKey, is3Cards: is3),
        meaningWork:    _composeMeaning(card: c, area: 'trabajo', posKey: posKey, is3Cards: is3),
        meaningMoney:   _composeMeaning(card: c, area: 'dinero',  posKey: posKey, is3Cards: is3),
      );
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TarotReadingScreen(
          title: "Lectura completa — ${_focusLabel()}",
          spreadName: spreadName,
          cards: lite,
          question: null,
          initialArea: _readingType,
        ),
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
          _labelJuegoFichas(),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                      : const Icon(Icons.star_border, color: dorado),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Fichas reveladas: $_contadorFichasSeleccionadas / $_maxFichasSeleccionadas',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _readingType = _readingTypeFromFocus(_currentFocus);
    _loadCopyPacksEs()
        .then((data) {
          setState(() {
            _copyData = data;
          });

          final packs = data["packs"] as List;
          final pack = _findPackOrFallback(packs, _readingType, _isPremium);
          debugPrint("USING PACK (init): ${pack['id']}");
        })
        .catchError((e) {
          debugPrint('ERROR loading copy packs: $e');
        });
  }

  // ----------------- BUILD -----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dorado = Color(0xFFFFD700);

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
            colors: [Color(0xFF140A24), Color(0xFF1C1036), Color(0xFF2C1D4A)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔁 Selector de enfoque
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: dorado.withOpacity(0.4), width: 1.1),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enfoque de la lectura',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: dorado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Elige en qué área quieres que el tarot ponga más luz hoy.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Amor ❤️'),
                            selected: _currentFocus == TarotFocus.love,
                            onSelected: (_) {
                              setState(() {
                                _currentFocus = TarotFocus.love;
                                _readingType = _readingTypeFromFocus(
                                  _currentFocus,
                                );
                              });
                            },
                            selectedColor: dorado.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.love
                                  ? dorado
                                  : Colors.white70,
                            ),
                            backgroundColor: Colors.black.withOpacity(0.6),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.love
                                    ? dorado
                                    : Colors.white24,
                              ),
                            ),
                          ),
                          ChoiceChip(
                            label: const Text('Trabajo 💼'),
                            selected: _currentFocus == TarotFocus.work,
                            onSelected: (_) {
                              setState(() {
                                _currentFocus = TarotFocus.work;
                                _readingType = _readingTypeFromFocus(_currentFocus);
                              });
                            },

                            selectedColor: dorado.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.work
                                  ? dorado
                                  : Colors.white70,
                            ),
                            backgroundColor: Colors.black.withOpacity(0.6),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.work
                                    ? dorado
                                    : Colors.white24,
                              ),
                            ),
                          ),
                          ChoiceChip(
                            label: const Text('Dinero 💰'),
                            selected: _currentFocus == TarotFocus.money,
                            onSelected: (_) {
                              setState(() {
                                _currentFocus = TarotFocus.money;
                                _readingType = _readingTypeFromFocus(
                                  _currentFocus,
                                );
                              });
                            },
                            selectedColor: dorado.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.money
                                  ? dorado
                                  : Colors.white70,
                            ),
                            backgroundColor: Colors.black.withOpacity(0.6),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.money
                                    ? dorado
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enfoque actual: ${_focusLabel()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔮 3 cartas
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: dorado.withOpacity(0.4), width: 1.1),
                ),
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title3Cards(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: dorado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _desc3Cards(),
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
                      if (_lecturaTresCartas != null)
                        const SizedBox(height: 12),
                      if (_lecturaTresCartas != null)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _abrirLecturaCompleta(
                              _lecturaTresCartas!,
                              "Tirada de 3 cartas",
                            ),
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text("Ver lectura completa"),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 😍 6 cartas
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: dorado.withOpacity(0.2), width: 1),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title6Cards(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: dorado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _desc6Cards(),
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
                      if (_lecturaSeisCartas != null)
                        const SizedBox(height: 12),
                      if (_lecturaSeisCartas != null)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _abrirLecturaCompleta(
                              _lecturaSeisCartas!,
                              "Tirada de 6 cartas",
                            ),
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text("Ver lectura completa"),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ❓ Sí / No
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: dorado.withOpacity(0.2), width: 1),
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
                          color: dorado,
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
                                        _resultadoSiNo!,
                                      ),
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
                  side: BorderSide(color: dorado.withOpacity(0.2), width: 1),
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
                  side: BorderSide(color: dorado.withOpacity(0.2), width: 1),
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
                          color: dorado,
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

              const SizedBox(height: 24),

              // 🎡 Dados mágicos & Ruleta & Flor
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: dorado.withOpacity(0.2), width: 1),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dados, ruleta y flor del amor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: dorado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si quieres jugar aún más con la energía del día, explora los dados mágicos, la ruleta de mensajes y la flor del amor.',
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
                                builder: (_) => const MysticToolsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.casino),
                          label: const Text('Abrir juegos mágicos'),
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
