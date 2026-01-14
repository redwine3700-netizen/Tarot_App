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

class TarotReadingScreen extends StatelessWidget {
  final String initialArea; // "general" | "amor" | "trabajo" | "dinero"
  final String title; // ej: "Lectura del Amor"
  final List<TarotCardLite> cards; // 3 o 6 cartas (las que salieron)
  final String spreadName; // ej: "Tirada de 3" o "Tirada de 6"
  final String? question; // opcional: la pregunta del usuario

  const TarotReadingScreen({
    super.key,
    required this.title,
    required this.cards,
    required this.spreadName,
    this.question,
    this.initialArea = "general",
  });

  static const _gold = Color(0xFFFFD700);
  static const _pink = Color(0xFFFF4FD8);
  static const _bg1 = Color(0xFF12091D);
  static const _bg2 = Color(0xFF1C1036);

  @override
  Widget build(BuildContext context) {
    final isSix = cards.length >= 6;

    return Scaffold(
      backgroundColor: _bg1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            tooltip: "Copiar lectura",
            onPressed: () => _copyReading(context),
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bg2, _bg1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            children: [
              _HeaderCard(
                spreadName: spreadName,
                question: question,
                gold: _gold,
                pink: _pink,
              ),
              const SizedBox(height: 14),

              // Zona de cartas
              _GlassPanel(
                gold: _gold,
                pink: _pink,
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

                    // Layout: 3 en fila / 6 en grid 3x2
                    if (!isSix)
                      Row(
                        children: List.generate(3, (i) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i == 2 ? 0 : 10),
                              child: _CardTile(
                                indexLabel: _labelFor3(i),
                                card: cards[i],
                                gold: _gold,
                                pink: _pink,
                                onTap: () => _openCardDetails(
                                  context,
                                  cards[i],
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
                        itemCount: cards.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.64,
                        ),
                        itemBuilder: (ctx, i) {
                          return _CardTile(
                            indexLabel: _labelFor6(i, category: initialArea),
                            card: cards[i],
                            gold: _gold,
                            pink: _pink,
                            onTap: () => _openCardDetails(
                              context,
                              cards[i],
                              _labelFor6(i, category: initialArea),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Interpretación completa (secciones)
              // Interpretación completa (enfoque + otras áreas opcional)
              _GlassPanel(
                gold: _gold,
                pink: _pink,
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

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _colorForArea(initialArea).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _colorForArea(initialArea).withOpacity(0.35)),
                      ),
                      child: Text(
                        _summaryForArea(initialArea),
                        style: const TextStyle(height: 1.25),
                      ),
                    ),
                    const SizedBox(height: 10),


                    // ✅ SOLO el enfoque elegido
                    _Section(
                      icon: _iconForArea(initialArea),
                      title: _titleForArea(initialArea),
                      text: _joinMeaningsForArea(
                        initialArea,
                            (c) => _meaningForArea(c, initialArea),
                      ),
                      color: _colorForArea(initialArea),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _colorForArea(initialArea).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _colorForArea(initialArea).withOpacity(0.35)),
                      ),
                      child: Text(
                        _microActionForArea(initialArea),
                        style: const TextStyle(height: 1.25),
                      ),
                    ),


                    const SizedBox(height: 12),

                    // ✅ Otras áreas (resumen)
                    ExpansionTile(
                      title: const Text(
                        "Ver otras áreas",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      subtitle: Text(
                        "Miradas orientativas, si lo deseas.",
                        style: TextStyle(color: Colors.white54),
                      ),
                      collapsedIconColor: Colors.white70,
                      iconColor: Colors.white70,
                      children: _otherAreas(initialArea).map((area) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _Section(
                            icon: _iconForArea(area),
                            title: _titleForArea(area),
                            text: _joinMiniMeaningsForArea(area, (c) => _meaningForArea(c, area)),

                            color: _colorForArea(area),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // CTA
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

  String _joinMiniMeaningsForArea(
      String area,
      String Function(TarotCardLite c) pick,
      ) {
    final buff = StringBuffer();
    for (int i = 0; i < cards.length; i++) {
      final label = cards.length >= 6
          ? _labelFor6BySection(i, area) // ✅ ahora sí: "Amor", "Trabajo", "Dinero", "Mensaje general"
          : _labelFor3(i);

      final full = pick(cards[i]);
      final mini = _firstSentence(full);
      buff.writeln("• $label — ${cards[i].name}: $mini");
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
  String _joinMeaningsForArea(
      String area,
      String Function(TarotCardLite c) pick,
      ) {
    final buff = StringBuffer();
    for (int i = 0; i < cards.length; i++) {
      final label = cards.length >= 6
          ? _labelFor6BySection(i, area)
          : _labelFor3(i);

      final full = pick(cards[i]);
      buff.writeln("• $label — ${cards[i].name}: $full");
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

  String _joinMiniMeanings(String Function(TarotCardLite c) pick) {
    final buff = StringBuffer();
    for (int i = 0; i < cards.length; i++) {
      final label = cards.length >= 6
      ?_labelFor6BySection(i, "$title $spreadName") // <-- "Amor", "Trabajo", "Dinero", "Mensaje general"
          : _labelFor3(i);
      final full = pick(cards[i]);
      final mini = _firstSentence(full);
      buff.writeln("• $label — ${cards[i].name}: $mini");
    }
    return buff.toString().trim();
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
    // Fallback: si nadie pasa category, usamos el área/título que ya están en pantalla
    final ctx = (category ?? "$initialArea $title $spreadName").toLowerCase().trim();

    // 0: Energía, 1: Tú, 2: (varía), 3: Bloqueo, 4: Consejo, 5: Resultado
    final thirdLabel = (ctx.contains("trabajo") || ctx.contains("work"))
        ? "Entorno Laboral"
        : (ctx.contains("dinero") || ctx.contains("money"))
        ? "Factor externo"
        : "Tú persona especial";

    final labels = [
      "Energía",
      "Tú",
      thirdLabel,
      "Bloqueo",
      "Consejo",
      "Resultado",
    ];

    return labels[i.clamp(0, labels.length - 1)];
  }

  String _labelFor6BySection(int i, String section) {
    final s = section.toLowerCase();

    final thirdLabel = s.contains("amor")
        ? "Tú persona especial"
        : (s.contains("trab") || s.contains("work"))
        ? "Entorno laboral" // o "Actor clave"
        : (s.contains("din") || s.contains("money"))
        ? "Factor externo"
        : "Influencia"; // Mensaje general

    final labels = [
      "Energía",
      "Tú",
      thirdLabel,
      "Bloqueo",
      "Consejo",
      "Resultado",
    ];

    return labels[i.clamp(0, labels.length - 1)];
  }




  Future<void> _copyReading(BuildContext context) async {
    final text = [
      title,
      spreadName,
      if (question != null && question!.trim().isNotEmpty) "Pregunta: $question",
      "",
      "Resumen:",
      _summaryForArea(initialArea),
      "",
      "Cartas:",
      ...List.generate(cards.length, (i) {
        final label = cards.length >= 6
            ? _labelFor6(i, category: initialArea)
            : _labelFor3(i);
        return "• $label: ${cards[i].name}";
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
      _microActionForArea(initialArea),
    ].join("\n");

    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lectura copiada ✅")),
    );
  }



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
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          child: _GlassPanel(
            gold: _gold,
            pink: _pink,
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
                              color: _gold.withOpacity(0.65),
                              width: 1.2,
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
                  color: _gold,
                ),
                const SizedBox(height: 8),
                _MiniMeaning(
                  title: "Amor",
                  text: card.meaningLove,
                  color: _pink,
                ),
                const SizedBox(height: 8),
                _MiniMeaning(
                  title: "Trabajo",
                  text: card.meaningWork,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                _MiniMeaning(
                  title: "Dinero",
                  text: card.meaningMoney,
                  color: _gold,
                ),
              ],
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
  final String initialArea;
  final Color gold;
  final Color pink;

  const _HeaderCard({
    required this.spreadName,
    required this.question,
    this.initialArea = "general",
    required this.gold,
    required this.pink,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      gold: gold,
      pink: pink,
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
              _Chip(text: "Dorado", color: gold),
              const SizedBox(width: 8),
              _Chip(text: "Rosado", color: pink),
              const SizedBox(width: 8),
              _Chip(text: "Lectura completa", color: Colors.white),
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

  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.16),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.92),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final Color gold;
  final Color pink;

  const _GlassPanel({
    required this.child,
    required this.gold,
    required this.pink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: gold.withOpacity(0.28), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.10),
            blurRadius: 26,
            spreadRadius: 2,
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
