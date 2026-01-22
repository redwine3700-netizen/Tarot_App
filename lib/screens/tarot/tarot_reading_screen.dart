import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/user_prefs.dart';
import '../../state/tarot_mode.dart';
import '../../state/tarot_state.dart';

/// Modelo simple para que lo adaptes a tu TarotCard real.
/// Si ya tienes clase TarotCard, puedes borrar esto y usar la tuya.
class TarotCardLite {
  final String name;
  final String imageAsset; // ej: 'assets/tarot/01_magician.png'
  final String meaningGeneral;
  final String meaningLove;
  final String meaningWork;
  final String meaningMoney;

  const TarotCardLite({
    required this.name,
    required this.imageAsset,
    required this.meaningGeneral,
    required this.meaningLove,
    required this.meaningWork,
    required this.meaningMoney,
  });
}

enum AccentStyle { dorado, rosado }

class TarotReadingScreen extends StatefulWidget {
  /// Área inicial que venía desde el flujo anterior.
  /// Igual la lectura deluxe usa el modo global (TarotState) para el copy.
  final String initialArea; // "general" | "amor" | "trabajo" | "dinero"

  final String title;
  final List<TarotCardLite> cards; // 3 o 6
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

class _TarotReadingScreenState extends State<TarotReadingScreen>
    with TickerProviderStateMixin {
  AccentStyle _accent = AccentStyle.dorado;
  bool _fullReading = true;

  // ===== Paleta romántica suave (oscura + pasteles) =====
  static const _bgBase1 = Color(0xFF1A1124);
  static const _bgBase2 = Color(0xFF0F0B1A);

  static const _panelGold1 = Color(0xFF2A1B3D);
  static const _panelGold2 = Color(0xFF1C1330);

  static const _panelRose1 = Color(0xFF2B1630);
  static const _panelRose2 = Color(0xFF1B1023);

  static const _champFill = Color(0xFFFFE7D0);
  static const _champBorder = Color(0xFFEAC19C);

  static const _roseFill = Color(0xFFFFD6E5);
  static const _roseBorder = Color(0xFFFF7FB3);

  Color get _bg1 => _bgBase1;

  Color get _bg2 => _bgBase2;

  List<Color> get _panelBg => _accent == AccentStyle.dorado
      ? const [_panelGold1, _panelGold2]
      : const [_panelRose1, _panelRose2];

  Color get _accentFill =>
      _accent == AccentStyle.dorado ? _champFill : _roseFill;

  Color get _accentBorder =>
      _accent == AccentStyle.dorado ? _champBorder : _roseBorder;

  Color get _panelBorder => _accentBorder;

  double get _panelBorderWidth => _accent == AccentStyle.dorado ? 1.6 : 2.2;

  Color get _borderColor => _accentBorder;

  Color get _glowColor => _accentFill;

  // Compatibilidad: botones usan _gold/_pink
  Color get _gold => _accentFill;

  Color get _pink => _accentBorder;

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await UserPrefs.getUserName();
    if (!mounted) return;
    setState(() => _userName = UserPrefs.formatName(name));
  }

  @override
  Widget build(BuildContext context) {
    final isSix = widget.cards.length >= 6;
    final count = isSix ? 6 : 3;

    return ValueListenableBuilder<TarotMode>(
      valueListenable: TarotState.instance.mode,
      builder: (context, mode, _) {
        final area = _areaFromMode(mode); // 'amor' | 'trabajo' | 'dinero'
        final areaName = _areaTitle(area);
        final prefix = _userName.isEmpty ? '' : '$_userName, ';

        final labels = _positionLabelsForCount(count);

        return Scaffold(
          backgroundColor: _bg1,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            actions: [
              IconButton(
                tooltip: "Copiar lectura",
                onPressed: () => _copyReading(context, mode),
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bg1, _bg2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                children: [
                  _HeaderCard(
                    spreadName: widget.spreadName,
                    question: widget.question,
                    gold: _borderColor,
                    pink: _glowColor,
                    selectedStyle: _accent,
                    onStyleChanged: (s) => setState(() => _accent = s),
                    fullReading: _fullReading,
                    onToggleFullReading: () =>
                        setState(() => _fullReading = !_fullReading),
                  ),
                  const SizedBox(height: 14),

                  // ===== Cartas =====
                  _GlassPanel(
                    gold: _accentBorder,
                    pink: _accentFill,
                    bgColors: _panelBg,
                    borderColor: _panelBorder,
                    borderWidth: _panelBorderWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSix ? "Tus 6 cartas" : "Tus 3 cartas",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (!isSix)
                            SizedBox(
                              height: 240,
                              child: Row(
                                children: List.generate(3, (i) {
                                  final label = labels[i];
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: i == 2 ? 0 : 10,
                                      ),
                                      child: _CardTile(
                                        indexLabel: label,
                                        card: widget.cards[i],
                                        gold: _borderColor,
                                        pink: _glowColor,
                                        onTap: () => _openCardDetails(
                                          context,
                                          widget.cards[i],
                                          label,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.64,
                                  ),
                              itemBuilder: (ctx, i) {
                                final label = labels[i];
                                return _CardTile(
                                  indexLabel: label,
                                  card: widget.cards[i],
                                  gold: _borderColor,
                                  pink: _glowColor,
                                  onTap: () => _openCardDetails(
                                    context,
                                    widget.cards[i],
                                    label,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Interpretación (DELUXE por posiciones + enfoque actual) =====
                  _GlassPanel(
                    gold: _accentBorder,
                    pink: _accentFill,
                    bgColors: _panelBg,
                    borderColor: _panelBorder,
                    borderWidth: _panelBorderWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Interpretación ($areaName)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "$prefix${_interpretationDeluxe(area, count)}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.88),
                              height: 1.28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Resumen + microacción (enfoque actual) =====
                  _GlassPanel(
                    gold: _accentBorder,
                    pink: _accentFill,
                    bgColors: _panelBg,
                    borderColor: _panelBorder,
                    borderWidth: _panelBorderWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Resumen",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _InfoBox(
                            color: _colorForArea(area),
                            text: _summaryForArea(area),
                          ),
                          const SizedBox(height: 10),
                          _InfoBox(
                            color: _colorForArea(area),
                            text: _microActionForArea(area),
                          ),
                          const SizedBox(height: 12),

                          // Lectura completa (opcional)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: _fullReading
                                ? Column(
                                    children: [
                                      _Section(
                                        icon: _iconForArea(area),
                                        title: "Lectura completa ($areaName)",
                                        text: _joinMeaningsForArea(
                                          area,
                                          (c) => _meaningForArea(c, area),
                                          count: count,
                                        ),
                                        color: _colorForArea(area),
                                      ),
                                      const SizedBox(height: 12),
                                      ExpansionTile(
                                        title: const Text(
                                          "Ver otras áreas",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        collapsedIconColor: Colors.white70,
                                        iconColor: Colors.white70,
                                        children: _otherAreas(area).map((
                                          other,
                                        ) {
                                          final otherName = _areaTitle(other);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: _Section(
                                              icon: _iconForArea(other),
                                              title: otherName,
                                              text: _joinMiniMeaningsForArea(
                                                other,
                                                (c) =>
                                                    _meaningForArea(c, other),
                                                count: count,
                                              ),
                                              color: _colorForArea(other),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          child: const Text("Volver"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _copyReading(context, mode),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: _pink.withOpacity(0.7)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          child: const Text("Copiar lectura"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ====================== DELUXE helpers ======================

  String _interpretationDeluxe(String area, int count) {
    final labels = _positionLabelsForCount(count);
    final lines = List.generate(count, (i) {
      final card = widget.cards[i];
      final label = labels[i];
      final meaning = _meaningForArea(card, area);
      return "• $label: $meaning";
    });
    return lines.join("\n\n");
  }

  String _areaFromMode(TarotMode mode) {
    switch (mode) {
      case TarotMode.love:
        return "amor";
      case TarotMode.work:
        return "trabajo";
      case TarotMode.money:
        return "dinero";
    }
  }

  String _areaTitle(String area) {
    switch (area.toLowerCase()) {
      case "amor":
        return "Amor";
      case "trabajo":
        return "Trabajo";
      case "dinero":
        return "Dinero";
      default:
        return "General";
    }
  }

  List<String> _positionLabelsForCount(int count) {
    if (count >= 6) return List.generate(6, (i) => _labelFor6(i));
    return List.generate(3, (i) => _labelFor3(i));
  }

  // ====================== Copy DELUXE ======================

  Future<void> _copyReading(BuildContext context, TarotMode mode) async {
    final area = _areaFromMode(mode);
    final areaName = _areaTitle(area);

    final count = widget.cards.length >= 6 ? 6 : 3;
    final labels = _positionLabelsForCount(count);

    final header = <String>[
      widget.title,
      widget.spreadName,
      "Enfoque: $areaName",
      if (widget.question != null && widget.question!.trim().isNotEmpty)
        "Pregunta: ${widget.question!.trim()}",
      "",
    ];

    final cardsBlock = <String>[
      "Cartas:",
      ...List.generate(count, (i) {
        final card = widget.cards[i];
        return "• ${labels[i]}: ${card.name}";
      }),
      "",
    ];

    final interpretationLines = <String>[
      "Interpretación ($areaName):",
      ...List.generate(count, (i) {
        final card = widget.cards[i];
        final meaning = _meaningForArea(card, area);
        return "• ${labels[i]}: $meaning";
      }),
      "",
    ];

    final closing = <String>[_microActionForArea(area)];

    final text = [
      ...header,
      ...cardsBlock,
      ...interpretationLines,
      ...closing,
    ].join("\n");

    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Lectura copiada ✅")));
  }

  // ====================== Modal detalles ======================

  void _openCardDetails(
    BuildContext context,
    TarotCardLite card,
    String posLabel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final bgColors = _panelBg;
        final border = _borderColor;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: bgColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: border.withOpacity(0.55),
                width: _panelBorderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "$posLabel — ${card.name}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AspectRatio(
                        aspectRatio: 0.70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(card.imageAsset, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: border.withOpacity(0.70),
                                    width: _panelBorderWidth,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _MiniMeaning(
                        title: "General",
                        text: card.meaningGeneral,
                        color: border,
                      ),
                      const SizedBox(height: 8),
                      _MiniMeaning(
                        title: "Amor",
                        text: card.meaningLove,
                        color: border,
                      ),
                      const SizedBox(height: 8),
                      _MiniMeaning(
                        title: "Trabajo",
                        text: card.meaningWork,
                        color: border,
                      ),
                      const SizedBox(height: 8),
                      _MiniMeaning(
                        title: "Dinero",
                        text: card.meaningMoney,
                        color: border,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ====================== Helpers existentes (limpios) ======================

  String _meaningForArea(TarotCardLite c, String area) {
    switch (area) {
      case "amor":
        return c.meaningLove;
      case "trabajo":
        return c.meaningWork;
      case "dinero":
        return c.meaningMoney;
      default:
        return c.meaningGeneral;
    }
  }

  List<String> _otherAreas(String current) {
    const all = ["general", "amor", "trabajo", "dinero"];
    return all.where((a) => a != current).toList();
  }

  String _joinMiniMeaningsForArea(
    String area,
    String Function(TarotCardLite c) pick, {
    required int count,
  }) {
    final labels = _positionLabelsForCount(count);
    final buff = StringBuffer();
    for (int i = 0; i < count; i++) {
      final full = pick(widget.cards[i]);
      final mini = _firstSentence(full);
      buff.writeln("• ${labels[i]} — ${widget.cards[i].name}: $mini");
    }
    return buff.toString().trim();
  }

  String _joinMeaningsForArea(
    String area,
    String Function(TarotCardLite c) pick, {
    required int count,
  }) {
    final labels = _positionLabelsForCount(count);
    final buff = StringBuffer();
    for (int i = 0; i < count; i++) {
      final full = pick(widget.cards[i]);
      buff.writeln("• ${labels[i]} — ${widget.cards[i].name}: $full");
    }
    return buff.toString().trim();
  }

  String _summaryForArea(String area) {
    final a = area.toLowerCase();
    if (a.contains("amor") || a.contains("love")) {
      return "Resumen: hoy manda la honestidad emocional.\nSeñales por hechos, no por suposiciones.";
    }
    if (a.contains("trab") || a.contains("work")) {
      return "Resumen: ordena el tablero y protege tu foco.\nGana el movimiento correcto, no el más rápido.";
    }
    if (a.contains("din") || a.contains("money")) {
      return "Resumen: corta fugas y vuelve al control.\nOrden primero, expansión después.";
    }
    return "Resumen: mira el mensaje central y actúa con calma.\nLo simple hoy vale más que lo perfecto.";
  }

  String _microActionForArea(String area) {
    final a = area.toLowerCase();
    if (a.contains("amor") || a.contains("love")) {
      return "Microacción única: envía un mensaje claro y corto: “¿Hablamos esta semana?”\nLuego suelta el control y observa la respuesta real.";
    }
    if (a.contains("trab") || a.contains("work")) {
      return "Microacción única: sprint 20 min.\nElige 1 tarea clave y completa el primer 30% hoy (sin multitarea).";
    }
    if (a.contains("din") || a.contains("money")) {
      return "Microacción única: identifica 1 fuga (suscripción/gasto hormiga) y córtala por 30 días.\nEse gesto ordena tu energía financiera.";
    }
    return "Microacción única: elige 1 cosa y hazla hoy, pequeña pero completa.";
  }

  IconData _iconForArea(String area) {
    switch (area) {
      case "amor":
        return Icons.favorite_rounded;
      case "trabajo":
        return Icons.work_rounded;
      case "dinero":
        return Icons.attach_money_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _colorForArea(String area) {
    switch (area) {
      case "amor":
        return _pink;
      case "trabajo":
        return Colors.white;
      case "dinero":
        return _gold;
      default:
        return _gold;
    }
  }

  String _firstSentence(String s) {
    final t = s.trim();
    if (t.isEmpty) return "";
    final idx = t.indexOf(RegExp(r'[.!?]\s'));
    if (idx == -1) return t.length <= 90 ? t : "${t.substring(0, 90)}…";
    return t.substring(0, idx + 1);
  }

  String _labelFor3(int i) {
    switch (i) {
      case 0:
        return "Energía actual";
      case 1:
        return "Influencia";
      default:
        return "Consejo";
    }
  }

  String _labelFor6(int i) {
    const labels = [
      "Energía central",
      "Ayuda",
      "Bloqueo",
      "Lo que no ves",
      "Consejo",
      "Resultado",
    ];
    return labels[i.clamp(0, labels.length - 1)];
  }
}

class _HeaderCard extends StatelessWidget {
  final String spreadName;
  final String? question; // <- nullable
  final Color gold;
  final Color pink;

  final AccentStyle selectedStyle; // <- AccentStyle
  final ValueChanged<AccentStyle> onStyleChanged; // <- AccentStyle

  final bool fullReading;
  final VoidCallback onToggleFullReading;

  const _HeaderCard({
    required this.spreadName,
    required this.question,
    required this.gold,
    required this.pink,
    required this.selectedStyle,
    required this.onStyleChanged,
    required this.fullReading,
    required this.onToggleFullReading,
  });

  @override
  Widget build(BuildContext context) {
    final border = gold.withOpacity(0.55);
    final bg = Colors.white.withOpacity(0.06);

    // Ajusta estos estilos a los que EXISTEN en tu enum AccentStyle:
    // Ejemplo: AccentStyle.rose, AccentStyle.gold, AccentStyle.purple...
    Widget styleChip(AccentStyle style, String label) {
      final selected = selectedStyle == style;
      return InkWell(
        onTap: () => onStyleChanged(style),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? pink.withOpacity(0.18)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? pink.withOpacity(0.65)
                  : Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(selected ? 0.95 : 0.75),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spreadName,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            (question == null || question!.trim().isEmpty)
                ? "Sin pregunta"
                : question!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AccentStyle.values.map((s) {
              final raw = s.toString().split('.').last; // compatible
              final label = raw
                  .replaceAll('_', ' ')
                  .toUpperCase(); // o deja raw tal cual
              return styleChip(s, label);
            }).toList(),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onToggleFullReading,
              icon: Icon(
                fullReading
                    ? Icons.unfold_less_rounded
                    : Icons.unfold_more_rounded,
                color: Colors.white.withOpacity(0.85),
                size: 18,
              ),
              label: Text(
                fullReading ? "Ver menos" : "Ver lectura completa",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== UI components ======================
class _CardTile extends StatelessWidget {
  final String indexLabel;
  final TarotCardLite card;
  final Color gold;
  final Color pink;
  final VoidCallback onTap;

  const _CardTile({
    required this.indexLabel,
    required this.card,
    required this.gold,
    required this.pink,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            indexLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          AspectRatio(
            aspectRatio: 0.70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(card.imageAsset, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: gold.withOpacity(0.55),
                        width: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.text,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? color.withOpacity(0.18)
              : Colors.white.withOpacity(0.06),
          border: Border.all(color: color.withOpacity(selected ? 0.60 : 0.30)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Color gold;
  final Color pink;
  final Widget child;

  final List<Color>? bgColors;
  final Color? borderColor;
  final double? borderWidth;

  const _GlassPanel({
    super.key,
    required this.gold,
    required this.pink,
    required this.child,
    this.bgColors,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        bgColors ??
        [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.03)];
    final border = borderColor ?? gold.withOpacity(0.4);
    final bW = borderWidth ?? 1.6;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: bg,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: border.withOpacity(0.55), width: bW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _Section({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMeaning extends StatelessWidget {
  final String title;
  final String text;
  final Color color;

  const _MiniMeaning({
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final Color color;
  final String text;

  const _InfoBox({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, height: 1.25),
      ),
    );
  }
}
