import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String initialArea; // "general" | "amor" | "trabajo" | "dinero"
  final String title;
  final List<TarotCardLite> cards;
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
  bool _fullReading = true; // lectura completa ON por defecto

  // ===== Paleta romántica suave (oscura + pasteles) =====

  // Fondo general (plum night)
  static const _bgBase1 = Color(0xFF1A1124);
  static const _bgBase2 = Color(0xFF0F0B1A);

  // Panel glass (un poquito más claro)
  static const _panelGold1 = Color(0xFF2A1B3D);
  static const _panelGold2 = Color(0xFF1C1330);

  // Panel rosado (tinte más romántico)
  static const _panelRose1 = Color(0xFF2B1630);
  static const _panelRose2 = Color(0xFF1B1023);

  // Acentos pastel (por luminosidad se diferencian mejor)
  // Dorado = champagne
  static const _champFill   = Color(0xFFFFE7D0);
  static const _champBorder = Color(0xFFEAC19C);

  // Rosado = rose/lavender (más evidente)
  static const _roseFill    = Color(0xFFFFD6E5);
  static const _roseBorder  = Color(0xFFFF7FB3);

  Color get _bg1 => _bgBase1;
  Color get _bg2 => _bgBase2;

  // Fondo de panel cambia con el toggle (se nota más)
  List<Color> get _panelBg => _accent == AccentStyle.dorado
      ? const [_panelGold1, _panelGold2]
      : const [_panelRose1, _panelRose2];

  // Acento activo
  Color get _accentFill =>
      _accent == AccentStyle.dorado ? _champFill : _roseFill;

  Color get _accentBorder =>
      _accent == AccentStyle.dorado ? _champBorder : _roseBorder;

  // Bordes y “glow”
  Color get _panelBorder => _accentBorder;
  double get _panelBorderWidth => _accent == AccentStyle.dorado ? 1.6 : 2.2;

  Color get _borderColor => _accentBorder;
  Color get _glowColor => _accentFill;

  // ✅ Compatibilidad: tu UI todavía usa _gold/_pink en botones y _colorForArea
  Color get _gold => _accentFill;
  Color get _pink => _accentBorder;


  @override
  Widget build(BuildContext context) {
    final isSix = widget.cards.length >= 6;

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
            onPressed: () => _copyReading(context),
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
                onToggleFullReading: () => setState(() => _fullReading = !_fullReading),
              ),

              const SizedBox(height: 14),

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
                        Row(
                          children: List.generate(3, (i) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: i == 2 ? 0 : 10),
                                child: _CardTile(
                                  indexLabel: _labelFor3(i),
                                  card: widget.cards[i],
                                  gold: _borderColor,
                                  pink: _glowColor,
                                  onTap: () => _openCardDetails(
                                    context,
                                    widget.cards[i],
                                    _labelFor3(i),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.64,
                          ),
                          itemBuilder: (ctx, i) {
                            final label = _labelFor6(i, category: widget.initialArea);
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
                        "Interpretación",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Resumen
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _colorForArea(widget.initialArea).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _colorForArea(widget.initialArea).withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _summaryForArea(widget.initialArea),
                          style: const TextStyle(height: 1.25),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Microacción
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _colorForArea(widget.initialArea).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _colorForArea(widget.initialArea).withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _microActionForArea(widget.initialArea),
                          style: const TextStyle(height: 1.25),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✅ AnimatedSize (sin saltos)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topCenter,
                        child: _fullReading
                            ? Column(
                          children: [
                            _Section(
                              icon: _iconForArea(widget.initialArea),
                              title: _titleForArea(widget.initialArea),
                              text: _joinMeaningsForArea(
                                widget.initialArea,
                                    (c) => _meaningForArea(c, widget.initialArea),
                              ),
                              color: _colorForArea(widget.initialArea),
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
                              children: _otherAreas(widget.initialArea).map((area) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: _Section(
                                    icon: _iconForArea(area),
                                    title: _titleForArea(area),
                                    text: _joinMiniMeaningsForArea(
                                      area,
                                          (c) => _meaningForArea(c, area),
                                    ),
                                    color: _colorForArea(area),
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
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      child: const Text("Volver"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _copyReading(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: _pink.withOpacity(0.7)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
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
  }

  // ====== Helpers (los tuyos, iguales, solo 1 ajuste de texto) ======

  String _joinMiniMeaningsForArea(String area, String Function(TarotCardLite c) pick) {
    final buff = StringBuffer();
    for (int i = 0; i < widget.cards.length; i++) {
      final label = widget.cards.length >= 6 ? _labelFor6BySection(i, area) : _labelFor3(i);
      final full = pick(widget.cards[i]);
      final mini = _firstSentence(full);
      buff.writeln("• $label — ${widget.cards[i].name}: $mini");
    }
    return buff.toString().trim();
  }

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

  String _titleForArea(String area) {
    switch (area) {
      case "amor":
        return "Amor";
      case "trabajo":
        return "Trabajo";
      case "dinero":
        return "Dinero";
      default:
        return "Mensaje general";
    }
  }

  String _joinMeaningsForArea(String area, String Function(TarotCardLite c) pick) {
    final buff = StringBuffer();
    for (int i = 0; i < widget.cards.length; i++) {
      final label = widget.cards.length >= 6 ? _labelFor6BySection(i, area) : _labelFor3(i);
      final full = pick(widget.cards[i]);
      buff.writeln("• $label — ${widget.cards[i].name}: $full");
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
        return "Pasado";
      case 1:
        return "Presente";
      default:
        return "Futuro";
    }
  }

  String _labelFor6(int i, {String? category}) {
    final ctx = (category ?? "${widget.initialArea} ${widget.title} ${widget.spreadName}")
        .toLowerCase()
        .trim();

    final thirdLabel = (ctx.contains("trabajo") || ctx.contains("work"))
        ? "Entorno laboral"
        : (ctx.contains("dinero") || ctx.contains("money"))
        ? "Factor externo"
        : "Tu persona especial";

    final labels = ["Energía", "Tú", thirdLabel, "Bloqueo", "Consejo", "Resultado"];
    return labels[i.clamp(0, labels.length - 1)];
  }

  String _labelFor6BySection(int i, String section) {
    final s = section.toLowerCase();

    final thirdLabel = s.contains("amor")
        ? "Tu persona especial"
        : (s.contains("trab") || s.contains("work"))
        ? "Entorno laboral"
        : (s.contains("din") || s.contains("money"))
        ? "Factor externo"
        : "Influencia";

    final labels = ["Energía", "Tú", thirdLabel, "Bloqueo", "Consejo", "Resultado"];
    return labels[i.clamp(0, labels.length - 1)];
  }

  Future<void> _copyReading(BuildContext context) async {
    final text = [
      widget.title,
      widget.spreadName,
      if (widget.question != null && widget.question!.trim().isNotEmpty)
        "Pregunta: ${widget.question}",
      "",
      "Resumen:",
      _summaryForArea(widget.initialArea),
      "",
      "Cartas:",
      ...List.generate(widget.cards.length, (i) {
        final label = widget.cards.length >= 6 ? _labelFor6(i, category: widget.initialArea) : _labelFor3(i);
        return "• $label: ${widget.cards[i].name}";
      }),
      "",
      "Interpretación:",
      _joinMeaningsForArea("general", (c) => _meaningForArea(c, "general")),
      "",
      "Amor:",
      _joinMeaningsForArea("amor", (c) => _meaningForArea(c, "amor")),
      "",
      "Trabajo:",
      _joinMeaningsForArea("trabajo", (c) => _meaningForArea(c, "trabajo")),
      "",
      "Dinero:",
      _joinMeaningsForArea("dinero", (c) => _meaningForArea(c, "dinero")),
      "",
      _microActionForArea(widget.initialArea),
    ].join("\n");

    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lectura copiada ✅")),
    );
  }

  void _openCardDetails(BuildContext context, TarotCardLite card, String posLabel) {
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
                            icon: const Icon(Icons.close_rounded, color: Colors.white70),
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
                      _MiniMeaning(title: "General", text: card.meaningGeneral, color: border),
                      const SizedBox(height: 8),
                      _MiniMeaning(title: "Amor", text: card.meaningLove, color: border),
                      const SizedBox(height: 8),
                      _MiniMeaning(title: "Trabajo", text: card.meaningWork, color: border),
                      const SizedBox(height: 8),
                      _MiniMeaning(title: "Dinero", text: card.meaningMoney, color: border),
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
}


class _HeaderCard extends StatelessWidget {
  final String spreadName;
  final String? question;
  final Color gold;
  final Color pink;

  final AccentStyle selectedStyle;
  final ValueChanged<AccentStyle> onStyleChanged;

  final bool fullReading;
  final VoidCallback onToggleFullReading;

  const _HeaderCard({
    super.key,
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
    final accent = selectedStyle == AccentStyle.dorado ? gold : pink;

    final headerBgColors = selectedStyle == AccentStyle.dorado
        ? const [Color(0xFF2A1B3D), Color(0xFF1C1330)]
        : const [Color(0xFF2B1630), Color(0xFF1B1023)];

    return _GlassPanel(
      gold: gold,
      pink: pink,
      bgColors: headerBgColors,
      borderColor: accent,
      borderWidth: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spreadName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          if (question != null && question!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Pregunta: $question",
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              _Chip(
                text: "Dorado",
                color: gold,
                selected: selectedStyle == AccentStyle.dorado,
                onTap: () => onStyleChanged(AccentStyle.dorado),
              ),
              const SizedBox(width: 8),
              _Chip(
                text: "Rosado",
                color: pink,
                selected: selectedStyle == AccentStyle.rosado,
                onTap: () => onStyleChanged(AccentStyle.rosado),
              ),
              const SizedBox(width: 8),
              _Chip(
                text: fullReading ? "Completa ✅" : "Completa",
                color: accent,
                selected: fullReading,
                onTap: onToggleFullReading,
              ),
            ],
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
  final VoidCallback? onTap;

  const _Chip({
    required this.text,
    required this.color,
    this.selected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? color.withOpacity(0.26) : color.withOpacity(0.16);
    final border = selected ? color.withOpacity(0.70) : color.withOpacity(0.35);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: bg,
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w800,
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

  // NUEVO (opcionales)
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
    final scheme = Theme.of(context).colorScheme;

    // Fondo pastel oscuro (femenino y suave)
    final colors = bgColors ??
        [
          scheme.surface,
          scheme.surfaceContainerHighest,
        ];

    final border = (borderColor ?? scheme.primary).withOpacity(0.55);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: borderWidth ?? 1.2),
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
class _AccentSheetShell extends StatelessWidget {
  final AccentStyle accent;
  final Widget child;

  const _AccentSheetShell({
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
  final bgColors = accent == AccentStyle.dorado
  ? const [Color(0xFF1C1036), Color(0xFF12091D)] // dorado (tu actual)
      : const [Color(0xFF1A1026), Color(0xFF120B1C)]; // pastel violeta-rosa (suave)0916)];

  final border = accent == AccentStyle.dorado
  ? const Color(0xFFFFD700)
      : const Color(0xFFFFB6D5); // rosado pastel real

  return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: border.withOpacity(0.55),
          width: accent == AccentStyle.dorado ? 1.2 : 2.0, // extra visible
        ),
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
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(card.imageAsset, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: gold.withOpacity(0.65),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black.withOpacity(0.35),
                      border: Border.all(color: pink.withOpacity(0.35)),
                    ),
                    child: Text(
                      indexLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(0.22),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color.withOpacity(0.95)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              height: 1.28,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.22),
        border: Border.all(color: color.withOpacity(0.26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.95),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}