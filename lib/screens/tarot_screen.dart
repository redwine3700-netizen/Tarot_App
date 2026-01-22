import '../state/tarot_state.dart';
import '../state/tarot_mode.dart';

import '../nav/app_nav_bus.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/tarot_models.dart';
import 'mystic_tools_screen.dart';
import 'pendulum_screen.dart';
import 'tarot/tarot_reading_screen.dart';

enum ActionTone { direct, gentle, reflective, alert, opening, grounding }

ActionTone toneForPosition(String posKey) {
  switch (posKey) {
    case 'energia_central':
      return ActionTone.reflective;
    case 'ayuda':
      return ActionTone.gentle;
    case 'bloqueo':
      return ActionTone.alert;
    case 'lo_que_no_ves':
      return ActionTone.reflective;
    case 'consejo':
      return ActionTone.opening;
    case 'resultado':
      return ActionTone.grounding;
    default:
      return ActionTone.direct;
  }
}

String actionLabel(ActionTone tone) {
  switch (tone) {
    case ActionTone.direct:
      return 'Microacción';
    case ActionTone.gentle:
      return 'Pequeño gesto';
    case ActionTone.reflective:
      return 'Sugerencia práctica';
    case ActionTone.alert:
      return 'Punto de atención';
    case ActionTone.opening:
      return 'Invitación';
    case ActionTone.grounding:
      return 'Anclaje';
  }
}



enum TarotFocus { general, love, work, money }

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  // ===== Theme helpers (evita errores de scheme/theme en métodos) =====
  ThemeData get theme => Theme.of(context);

  ColorScheme get scheme => theme.colorScheme;

  /// Mantengo el nombre "dorado" para no romper tu UI,
  /// pero ahora es el acento principal del tema (rosé).
  Color get dorado => scheme.primary;

  // ===== Estado enfoque / packs =====
  TarotFocus _currentFocus = TarotFocus.love;
  String _readingType = "general";
  bool _isPremium = false;
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

  final _rnd = Random();

  String _pick(List<dynamic> list) {
    if (list.isEmpty) return '';
    final v = list[_random.nextInt(list.length)];
    return v?.toString() ?? '';
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

  // Tiradas
  List<TarotCard>? _lecturaTresCartas;
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

  // ===== Copys dinámicos por carta =====
  String _normalizeCardKey(String name) {
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
  String _posLabelFor(int i, int count) {
    if (count == 3) {
      // Ajusta a tus posiciones de 3 si quieres
      return switch (i) {
        0 => "energía",
        1 => "consejo",
        _ => "resultado",
      };
    }
    // 6 cartas (según tu UI)
    return switch (i) {
      0 => "energía central",
      1 => "ayuda",
      2 => "bloqueo",
      3 => "lo que no ves",
      4 => "consejo",
      _ => "resultado",
    };
  }
  String _introHuman({
    required String userName,
    required String posLabel,
    required String cardName,
  }) {
    return "$userName, tu $posLabel en $cardName te dice:";
  }


  String _posKeyFor(int index, int cardsCount) {
    final is3 = cardsCount == 3;
    if (is3) return const ['pasado', 'presente', 'futuro'][index];

    // OJO: para 6, deja EXACTAMENTE 6 keys (no 7)
    return const [
      'energia',
      'tu',
      'tercero',
      'bloqueo',
      'consejo',
      'resultado',
    ][index];
  }

  void _abrirLecturaCompleta(List<TarotCard> cards, String spreadName) {
    final count = cards.length; // 3 o 6
    final userName = "Mauricio";

    String areaIntro(String areaLabel) {
      return "$userName, esta es tu lectura completa ($areaLabel).\n"
          "Tómala como un mapa: observa patrones, luego decide una microacción.\n";
    }

    final lite = cards.asMap().entries.map((entry) {
      final i = entry.key;
      final c = entry.value;
      final posKey = _posKeyFor(i, count);
      final posLabel = _posLabelFor(i, count);

      final headerLine = "• $posLabel — ${c.nombre}";

      final isLast = i == count - 1;

// Importante: aquí NO va intro humano repetido
      final general = _composeMeaning(
        card: c,
        area: 'general',
        posKey: posKey,
        is3Cards: count == 3,
        includeLens: i == 0,      // lente solo 1 vez
        includeMicro: isLast,     // ✅ microacción solo al final
      );

      final amor = _composeMeaning(
        card: c,
        area: 'amor',
        posKey: posKey,
        is3Cards: count == 3,
        includeLens: i == 0,
        includeMicro: isLast,     // ✅
      );

      final trabajo = _composeMeaning(
        card: c,
        area: 'trabajo',
        posKey: posKey,
        is3Cards: count == 3,
        includeLens: i == 0,
        includeMicro: isLast,     // ✅
      );

      final dinero = _composeMeaning(
        card: c,
        area: 'dinero',
        posKey: posKey,
        is3Cards: count == 3,
        includeLens: i == 0,
        includeMicro: isLast,     // ✅
      );

      return TarotCardLite(
        name: c.nombre,
        imageAsset: c.imagePath,
        meaningGeneral: "$headerLine\n$general",
        meaningLove: "$headerLine\n$amor",
        meaningWork: "$headerLine\n$trabajo",
        meaningMoney: "$headerLine\n$dinero",
      );

    }).toList();

    // ✅ Pega un intro global al principio de cada área (solo 1 vez)
    // Si TarotCardLite es inmutable, creamos una lista nueva “con intro”.
    final introGeneral = areaIntro("General");
    final introAmor = areaIntro("Amor");
    final introTrabajo = areaIntro("Trabajo");
    final introDinero = areaIntro("Dinero");

    final liteWithAreaIntro = <TarotCardLite>[
      TarotCardLite(
        name: "",
        imageAsset: "",
        meaningGeneral: introGeneral,
        meaningLove: introAmor,
        meaningWork: introTrabajo,
        meaningMoney: introDinero,
      ),
      ...lite,
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarotReadingScreen(
          title: spreadName,
          spreadName: spreadName,
          initialArea: _focusLabel().toLowerCase(),
          cards: liteWithAreaIntro,
        ),
      ),
    );
  }

  Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }


  String _introByPosition(String posKey, {required bool is3Cards}) {
    // Variantes para que no suene repetitivo
    String pick(List<String> xs) => xs[_random.nextInt(xs.length)];

    if (is3Cards) {
      switch (posKey) {
        case 'pasado':
          return pick([
            "Lo que viene de antes todavía influye en lo que sientes hoy.\n\n",
            "Aquí aparece el origen de esta historia: algo del pasado sigue marcando.\n\n",
            "Esta es la raíz de lo que estás viviendo.\n\n",
          ]);
        case 'presente':
          return pick([
            "Esto es lo que está más activo ahora mismo.\n\n",
            "Aquí está el pulso del presente: lo que se mueve hoy.\n\n",
            "Esta carta muestra tu realidad actual con claridad.\n\n",
          ]);
        case 'futuro':
          return pick([
            "Hacia aquí se encamina la energía si sigues igual.\n\n",
            "Este es el rumbo probable: lo que puede manifestarse.\n\n",
            "La tendencia que se viene se marca así.\n\n",
          ]);
        default:
          return pick([
            "Mira esto con calma: aquí hay una clave.\n\n",
            "Esta parte trae un mensaje importante.\n\n",
          ]);
      }
    }

    // 6 cartas
    switch (posKey) {
      case 'energia':
        return pick([
          "En el centro de esta tirada aparece la energía que lo mueve todo.\n\n",
          "La base de la lectura parte desde esta vibración principal.\n\n",
          "Aquí se ve el tono general de lo que estás viviendo.\n\n",
        ]);
      case 'tu':
        return pick([
          "Esto habla de ti: cómo estás sintiendo, actuando o interpretando la situación.\n\n",
          "Tu papel aquí es clave, y esta carta lo muestra con honestidad.\n\n",
          "Así se ve tu energía en este momento.\n\n",
        ]);
      case 'tercero':
        return pick([
          "Ahora aparece la otra parte: su energía, intención o postura.\n\n",
          "Esto refleja lo que trae la otra persona o el entorno.\n\n",
          "Aquí se ve el “otro lado” de la historia.\n\n",
        ]);
      case 'bloqueo':
        return pick([
          "Este es el punto que frena o complica, pero también revela qué trabajar.\n\n",
          "Aquí está el nudo: lo que se interpone o desgasta.\n\n",
          "Este bloqueo no es castigo: es información.\n\n",
        ]);
      case 'consejo':
        return pick([
          "El consejo aquí es claro y práctico.\n\n",
          "Esto es lo que más te conviene hacer ahora.\n\n",
          "Si necesitas una guía, esta carta te la da.\n\n",
        ]);
      case 'resultado':
        return pick([
          "Si sigues este camino, esto es lo que tiende a manifestarse.\n\n",
          "La proyección de todo esto se ve así.\n\n",
          "Esto es hacia donde se ordena la historia.\n\n",
        ]);
      default:
        return pick([
          "Mira esto con calma: aquí hay una clave.\n\n",
          "Hay un mensaje importante en esta parte.\n\n",
        ]);
    }
  }

  String intro({
    required String userName,
    required String position,
    required String cardName,
  }) {
    return "$userName, en tu $position, $cardName te muestra lo siguiente:";
  }

  String _stripMicroPrefix(String s) {
    final t = s.trim();
    final lower = t.toLowerCase();
    if (lower.startsWith('microacción:')) {
      return t.substring('microacción:'.length).trim();
    }
    if (lower.startsWith('microaccion:')) {
      return t.substring('microaccion:'.length).trim();
    }
    return t;
  }

  String _composeMeaning({
    required TarotCard card,
    required String area,
    required String posKey,
    required bool is3Cards,
    bool includeLens = true,   // ✅ NUEVO
    bool includeMicro = true, // ✅ NUEVO
  }) {

    if (_copyData == null) return card.significado;

    final root = _asMap(_copyData);
    final banks = _asMap(root['banks']);
    if (banks.isEmpty) return card.significado;

    final posBankKey = is3Cards ? 'posicion_3' : 'posicion_6';
    final posBank = _asMap(banks[posBankKey]);
    final posList = (posBank[posKey] is List)
        ? (posBank[posKey] as List).cast<dynamic>()
        : const <dynamic>[];

    final lensBank = _asMap(banks['lente_area']);
    final lensList = (lensBank[area] is List)
        ? (lensBank[area] as List).cast<dynamic>()
        : const <dynamic>[];

    // ✅ microList definido correctamente
    final microList = (banks['microacciones'] is List)
        ? (banks['microacciones'] as List).cast<dynamic>()
        : const <dynamic>[];

    final microRaw = microList.isNotEmpty ? _pick(microList) : '';
    final micro = microRaw.isNotEmpty ? _stripMicroPrefix(microRaw) : '';

    final shortMap = _asMap(banks['significado_corto']);
    final key = _normalizeCardKey(card.nombre);
    final variantsRaw = shortMap[key];
    final variants = (variantsRaw is List)
        ? variantsRaw.cast<dynamic>().whereType<String>().toList()
        : null;

    final pos = posList.isNotEmpty ? _pick(posList) : '';
    final lens = lensList.isNotEmpty ? _pick(lensList) : '';
    final short = (variants != null && variants.isNotEmpty)
        ? variants[_random.nextInt(variants.length)]
        : card.significado;

    final tone = toneForPosition(posKey);
    final label = actionLabel(tone);
    final microLine = micro.isNotEmpty ? "$label: $micro" : "";

    return [
      if (pos.isNotEmpty) pos,
      if (includeLens && lens.isNotEmpty) lens,
      short,
      if (includeMicro && micro.isNotEmpty) 'Microacción: $micro', // ✅ clave
    ].join('\n');

  }
  // ✅ CIERRA _composeMeaning AQUÍ// ✅ CIERRA _composeMeaning AQUÍ

// ===== Textos por enfoque =====
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

  // ===== Lógica cartas =====
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

  void _setFocus(TarotFocus focus) {
    final mode = switch (focus) {
      TarotFocus.love => TarotMode.love,
      TarotFocus.work => TarotMode.work,
      TarotFocus.money => TarotMode.money,
      TarotFocus.general => TarotMode.love, // o el que prefieras como default
    };

    TarotState.instance.setMode(mode);

    setState(() {
      _currentFocus = focus;
      _readingType = _readingTypeFromFocus(_currentFocus);
    });
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
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

  // ===== Juego fichas =====
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

  Widget _buildJuegoFichasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Juego de letras: elige 6 fichas',
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _labelJuegoFichas(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface.withOpacity(0.75),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _iniciarJuegoFichas,
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary.withOpacity(0.18),
              foregroundColor: scheme.onSurface,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: scheme.primary.withOpacity(0.45)),
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
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: revelada
                          ? scheme.primary.withOpacity(0.55)
                          : scheme.outline.withOpacity(0.35),
                      width: 1.2,
                    ),
                    boxShadow: revelada
                        ? [
                            BoxShadow(
                              color: scheme.primary.withOpacity(0.25),
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
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(Icons.star_border, color: scheme.primary),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Fichas reveladas: $_contadorFichasSeleccionadas / $_maxFichasSeleccionadas',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.75),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    homeTarotRequest.addListener(_handleHomeRequest);

    _readingType = _readingTypeFromFocus(_currentFocus);

    _loadCopyPacksEs().then((data) {
      if (!mounted) return;
      setState(() {
        _copyData = data;
      });
    });
  }

  @override
  void dispose() {
    homeTarotRequest.removeListener(_handleHomeRequest);
    super.dispose();
  }

  void _handleHomeRequest() {
    final req = homeTarotRequest.value;
    if (req == null) return;

    // Limpia la orden para que no se repita
    homeTarotRequest.value = null;

    // Ajusta enfoque según req.focus
    TarotFocus focus;
    switch (req.focus) {
      case 'trabajo':
        focus = TarotFocus.work;
        break;
      case 'dinero':
        focus = TarotFocus.money;
        break;
      case 'general':
        focus = TarotFocus.general;
        break;
      case 'amor':
      default:
        focus = TarotFocus.love;
        break;
    }

    // Aplica enfoque + tipo de lectura
    setState(() {
      _currentFocus = focus;
      _readingType = _readingTypeFromFocus(_currentFocus);
    });

    // Genera cartas según spread
    final int n = (req.spread == 1) ? 1 : req.spread;
    final cards = _generarLectura(n);

    // Abre lectura completa post-frame (para evitar errores de Navigator durante setState)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (req.spread == 1) {
        // Puedes decidir si 1 carta abre lectura completa o solo muestra algo simple.
        _abrirLecturaCompleta(cards, "Tarot rápido (1 carta)");
        return;
      }

      final spreadName = (req.spread == 3)
          ? "Tirada de 3 cartas"
          : "Tirada de 6 cartas";
      _abrirLecturaCompleta(cards, spreadName);
    });
  }

  // ===== BUILD =====
  @override
  Widget build(BuildContext context) {
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.4),
                    width: 1.1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
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
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Elige en qué área quieres que el tarot ponga más luz hoy.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Amor ❤️'),
                            selected: _currentFocus == TarotFocus.love,
                            onSelected: (_) => _setFocus(TarotFocus.love),
                            selectedColor: scheme.primary.withOpacity(0.18),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.love
                                  ? scheme.primary
                                  : scheme.onSurface.withOpacity(0.75),
                            ),
                            backgroundColor: scheme.surface.withOpacity(0.75),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.love
                                    ? scheme.primary.withOpacity(0.6)
                                    : scheme.outline.withOpacity(0.35),
                              ),
                            ),
                          ),

                          ChoiceChip(
                            label: const Text('Trabajo 💼'),
                            selected: _currentFocus == TarotFocus.work,
                            onSelected: (_) => _setFocus(TarotFocus.work),
                            selectedColor: scheme.primary.withOpacity(0.18),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.work
                                  ? scheme.primary
                                  : scheme.onSurface.withOpacity(0.75),
                            ),
                            backgroundColor: scheme.surface.withOpacity(0.75),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.work
                                    ? scheme.primary.withOpacity(0.6)
                                    : scheme.outline.withOpacity(0.35),
                              ),
                            ),
                          ),

                          ChoiceChip(
                            label: const Text('Dinero 💰'),
                            selected: _currentFocus == TarotFocus.money,
                            onSelected: (_) => _setFocus(TarotFocus.money),
                            selectedColor: scheme.primary.withOpacity(0.18),
                            labelStyle: TextStyle(
                              color: _currentFocus == TarotFocus.money
                                  ? scheme.primary
                                  : scheme.onSurface.withOpacity(0.75),
                            ),
                            backgroundColor: scheme.surface.withOpacity(0.75),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: _currentFocus == TarotFocus.money
                                    ? scheme.primary.withOpacity(0.6)
                                    : scheme.outline.withOpacity(0.35),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enfoque actual: ${_focusLabel()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.25),
                    width: 1.0,
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
                        _title3Cards(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _desc3Cards(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.9),
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.2),
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
                        _title6Cards(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _desc6Cards(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.9),
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
                            onPressed: () {
                              debugPrint(
                                "BTN 6 lectura completa: len=${_lecturaSeisCartas?.length}",
                              );
                              if (_lecturaSeisCartas == null ||
                                  _lecturaSeisCartas!.length < 6)
                                return;
                              _abrirLecturaCompleta(
                                _lecturaSeisCartas!,
                                "Tirada de 6 cartas",
                              );
                            },
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.2),
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
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Formula una pregunta clara de sí o no. Respira profundo y deja que una carta responda por ti.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.9),
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
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _cartaSiNo!.significado,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurface.withOpacity(0.85),
                                    ),
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurface.withOpacity(0.8),
                                    ),
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildJuegoFichasSection(),
                ),
              ),

              const SizedBox(height: 24),

              // 🔗 Péndulo del amor
              Card(
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.2),
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
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si quieres una respuesta más mágica, pregunta al péndulo y observa cómo se mueve: '
                        'arriba/abajo (sí), lados (no), círculo (tal vez).',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.9),
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
                color: scheme.surface.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.primary.withOpacity(0.2),
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
                        'Dados, ruleta y flor del amor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si quieres jugar aún más con la energía del día, explora los dados mágicos, la ruleta de mensajes y la flor del amor.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.9),
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
