import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TombolaTab extends StatefulWidget {
  const TombolaTab({super.key});

  @override
  State<TombolaTab> createState() => _TombolaTabState();
}

class _TombolaTabState extends State<TombolaTab> {
  static const int _maxNumber = 49;
  static const int _count = 6;

  static const String _prefsHistoryKey = 'tombola_history_v1';

  static const Color _gold = Color(0xFFFFD700);
  static const Color _pink = Color(0xFFFF4FD8);
  static const Color _bg1 = Color(0xFF140A24);
  static const Color _bg2 = Color(0xFF1C1036);
  static const Color _bg3 = Color(0xFF2C1D4A);

  final Random _rng = Random();

  late List<int> _draw;
  int _revealed = 0;
  int _mixTick = 0;

  // Historial persistente (últimas 10)
  final List<_HistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _newDraw();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsHistoryKey) ?? [];

    final loaded = <_HistoryItem>[];
    for (final s in list) {
      try {
        final map = jsonDecode(s) as Map<String, dynamic>;
        loaded.add(_HistoryItem.fromJson(map));
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _history
        ..clear()
        ..addAll(loaded);
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _history.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList(_prefsHistoryKey, list);
  }

  void _addToHistory(List<int> nums) {
    _history.insert(0, _HistoryItem(DateTime.now(), List<int>.from(nums)));
    if (_history.length > 10) _history.removeLast();
    _saveHistory();
  }

  void _newDraw() {
    final pool = List<int>.generate(_maxNumber, (i) => i + 1);
    pool.shuffle(_rng);
    _draw = pool.take(_count).toList();
    _revealed = 0;
    _mixTick++; // remolino en nueva tirada
    setState(() {});
  }

  void _revealNext() {
    if (_revealed >= _count) return;

    setState(() {
      _revealed++;
      _mixTick++;

      if (_revealed == _count) {
        _addToHistory(_draw); // guarda tirada completa
      }
    });

    if (_revealed == _count) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  String _format(List<int> list) =>
      list.map((n) => n.toString().padLeft(2, '0')).join(' - ');

  Future<void> _copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copiado ✅"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copy() async {
    if (_revealed == 0) return;

    final revealedList = _draw.take(_revealed).toList();
    final isFull = _revealed == _count;

    final text = isFull
        ? "Tómbola Mundial (1–49): ${_format(_draw)}"
        : "Tómbola Mundial (parcial): ${_format(revealedList)}";

    await _copyText(text);
  }

  Future<void> _openHistory() async {
    if (_history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aún no hay tiradas en el historial")),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xFF12091D),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Historial (últimas 10)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white12),
                  itemBuilder: (context, i) {
                    final item = _history[i];
                    final textNums = item.nums
                        .map((n) => n.toString().padLeft(2, '0'))
                        .join(' - ');

                    final time =
                        "${item.time.day.toString().padLeft(2, '0')}/"
                        "${item.time.month.toString().padLeft(2, '0')} "
                        "${item.time.hour.toString().padLeft(2, '0')}:"
                        "${item.time.minute.toString().padLeft(2, '0')}";

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        textNums,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        time,
                        style: TextStyle(color: Colors.white.withOpacity(0.65)),
                      ),
                      trailing: IconButton(
                        tooltip: "Copiar",
                        icon: const Icon(Icons.copy_rounded,
                            color: Color(0xFFFFD700)),
                        onPressed: () =>
                            _copyText("Tómbola Mundial (1–49): $textNums"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ButtonStyle _goldButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _gold,
      foregroundColor: Colors.black,
      elevation: 12,
      shadowColor: _gold.withOpacity(0.25),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_bg3, _bg2, _bg1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white24, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 6),
                Text(
                  'Saca 6 números del 1 al 49 y revela uno a uno ✨',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 320,
                  child: _TombolaMachineView(
                    numbers: _draw,
                    revealed: _revealed,
                    mixTick: _mixTick,
                    gold: _gold,
                    pink: _pink,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _revealed == 0
                      ? "Listo para empezar"
                      : _revealed < _count
                      ? "Revelados: $_revealed / $_count"
                      : "¡Tirada completa! 🔮",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _newDraw,
                        style: _goldButtonStyle(),
                        child: const Text("Nueva tirada"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _revealed >= _count ? null : _revealNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _revealed >= _count ? Colors.white10 : _pink,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: Text(_revealed >= _count ? "Revelado" : "Revelar"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.35),
                    border: Border.all(color: _gold.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _revealed == 0
                              ? "Resultado: —"
                              : _revealed == _count
                              ? "Resultado: ${_format(_draw)}"
                              : "Parcial: ${_format(_draw.take(_revealed).toList())}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _history.isEmpty ? null : _openHistory,
                        tooltip: "Historial",
                        icon: Icon(
                          Icons.history_rounded,
                          color: _history.isEmpty ? Colors.white24 : _gold,
                        ),
                      ),
                      IconButton(
                        onPressed: _revealed == 0 ? null : _copy,
                        tooltip: "Copiar",
                        icon: Icon(
                          Icons.copy_rounded,
                          color: _revealed == 0 ? Colors.white24 : _gold,
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
    );
  }
}

class _TombolaMachineView extends StatefulWidget {
  final List<int> numbers;
  final int revealed;
  final int mixTick;
  final Color gold;
  final Color pink;

  const _TombolaMachineView({
    required this.numbers,
    required this.revealed,
    required this.mixTick,
    required this.gold,
    required this.pink,
  });

  @override
  State<_TombolaMachineView> createState() => _TombolaMachineViewState();
}

class _TombolaMachineViewState extends State<_TombolaMachineView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pop;
  late final AnimationController _floatCtrl;

  bool _celebrate = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _pop = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<void> _burstMix() async {
    final normal = _floatCtrl.duration ?? const Duration(seconds: 6);

    _floatCtrl.stop();
    _floatCtrl.duration = const Duration(milliseconds: 900);
    _floatCtrl.repeat();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    _floatCtrl.stop();
    _floatCtrl.duration = normal;
    _floatCtrl.repeat();
  }

  @override
  void didUpdateWidget(covariant _TombolaMachineView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.revealed > oldWidget.revealed) {
      _ctrl.forward(from: 0);

      if (widget.revealed == 6) {
        _celebrate = true;
        setState(() {});
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() => _celebrate = false);
        });
      }
    }

    if (widget.mixTick != oldWidget.mixTick) {
      _burstMix();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.white.withOpacity(0.06);
    final border = widget.gold.withOpacity(0.28);

    final idx = (widget.revealed - 1).clamp(0, widget.numbers.length - 1);
    final hasBallOut = widget.revealed > 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: border, width: 1.2),
            color: bg,
            boxShadow: [
              BoxShadow(
                color: widget.pink.withOpacity(0.10),
                blurRadius: 26,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedBuilder(
                animation: _floatCtrl,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _FloatingBallsPainter(
                      t: _floatCtrl.value,
                      numbers: widget.numbers,
                      gold: widget.gold,
                      pink: widget.pink,
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 84,
          child: Container(
            width: 12,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: widget.gold.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(
                  color: widget.pink.withOpacity(0.10),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          child: Container(
            width: 240,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black.withOpacity(0.25),
              border: Border.all(color: widget.gold.withOpacity(0.22)),
            ),
            child: Center(
              child: Text(
                hasBallOut ? "Sale: ${widget.numbers[idx]}" : "Pulsa Revelar",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 98,
          child: AnimatedBuilder(
            animation: _pop,
            builder: (_, __) {
              final t = _pop.value;
              final dy = lerpDouble(70, 0, t)!;
              return Transform.translate(
                offset: Offset(0, dy),
                child: Opacity(
                  opacity: hasBallOut ? 1 : 0,
                  child: _GlassBall(
                    label: hasBallOut ? widget.numbers[idx].toString() : "?",
                    gold: widget.gold,
                    pink: widget.pink,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _celebrate ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: AnimatedBuilder(
                animation: _floatCtrl,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _SparklesPainter(
                      t: _floatCtrl.value,
                      gold: widget.gold,
                      pink: widget.pink,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassBall extends StatelessWidget {
  final String label;
  final Color gold;
  final Color pink;

  const _GlassBall({
    required this.label,
    required this.gold,
    required this.pink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 1.1,
          colors: [Colors.white.withOpacity(0.40), gold.withOpacity(0.85)],
        ),
        border: Border.all(color: pink.withOpacity(0.55), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.22),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _FloatingBallsPainter extends CustomPainter {
  final double t;
  final List<int> numbers;
  final Color gold;
  final Color pink;

  _FloatingBallsPainter({
    required this.t,
    required this.numbers,
    required this.gold,
    required this.pink,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 12);
    final minSide = min(size.width, size.height);

    final glow = Paint()..color = Colors.white.withOpacity(0.06);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.38, size.height * 0.32),
        width: size.width * 0.62,
        height: 95,
      ),
      glow,
    );

    for (int i = 0; i < 10; i++) {
      final a = (i * 2 * pi / 10) + (t * 2 * pi);
      final r = minSide * (0.18 + (i % 3) * 0.03);
      final pos = center + Offset(cos(a) * r, sin(a) * r * 0.7);
      final p = Paint()..color = Colors.white.withOpacity(0.05);
      canvas.drawCircle(pos, 10 + (i % 3) * 2, p);
    }

    final balls = <_BallRender>[];

    for (int i = 0; i < numbers.length; i++) {
      final speed = 0.55 + i * 0.08;
      final angle = (i * 2 * pi / numbers.length) + (t * 2 * pi * speed);

      final baseR = minSide * 0.23;
      final wobble = sin((t * 2 * pi) + i) * (minSide * 0.02);
      final r = baseR + wobble;

      final x = cos(angle) * r;
      final y = sin(angle) * r * 0.65;

      final pos = center + Offset(x, y);

      final depth = (y / (minSide * 0.23)).clamp(-1.0, 1.0);
      final radius = 17.0 + (depth + 1.0) * 3.0;
      final alpha = 0.35 + (depth + 1.0) * 0.30;

      balls.add(
        _BallRender(
          pos: pos,
          depth: depth,
          radius: radius,
          alpha: alpha,
          number: numbers[i],
          index: i,
        ),
      );
    }

    balls.sort((a, b) => a.depth.compareTo(b.depth));

    for (final b in balls) {
      _drawBall(canvas, b.pos, b.radius, b.number.toString(), b.index, b.alpha);
    }
  }

  void _drawBall(
      Canvas canvas,
      Offset c,
      double radius,
      String label,
      int i,
      double alpha,
      ) {
    final rect = Rect.fromCircle(center: c, radius: radius);
    final baseColor = i.isEven ? gold : pink;

    final shader = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 1.2,
      colors: [
        Colors.white.withOpacity(0.35 * alpha),
        baseColor.withOpacity(0.22 * alpha),
        Colors.transparent,
      ],
    ).createShader(rect);

    final p = Paint()..shader = shader;
    canvas.drawCircle(c, radius, p);

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = baseColor.withOpacity(0.55 * alpha);
    canvas.drawCircle(c, radius, border);

    final hi = Paint()..color = Colors.white.withOpacity(0.10 * alpha);
    canvas.drawCircle(
      c + Offset(-radius * 0.25, -radius * 0.25),
      radius * 0.35,
      hi,
    );

    final fontSize = (radius * 0.70).clamp(12.0, 16.0);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white.withOpacity(0.92 * alpha),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _FloatingBallsPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.numbers != numbers;
  }
}

class _BallRender {
  final Offset pos;
  final double depth;
  final double radius;
  final double alpha;
  final int number;
  final int index;

  _BallRender({
    required this.pos,
    required this.depth,
    required this.radius,
    required this.alpha,
    required this.number,
    required this.index,
  });
}

class _SparklesPainter extends CustomPainter {
  final double t;
  final Color gold;
  final Color pink;

  _SparklesPainter({required this.t, required this.gold, required this.pink});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;

    final w = max(1, size.width.toInt());
    final h = max(1, size.height.toInt());

    for (int i = 0; i < 18; i++) {
      final x = (i * 73) % w;
      final y = (i * 41) % h;

      final phase = (t * 2 * pi) + i;
      final alpha = (0.25 + 0.35 * sin(phase).abs()).clamp(0.0, 1.0);

      p.color = (i.isEven ? gold : pink).withOpacity(alpha * 0.35);

      final r = 2.0 + (i % 3) * 1.2;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklesPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _HistoryItem {
  final DateTime time;
  final List<int> nums;

  _HistoryItem(this.time, this.nums);

  Map<String, dynamic> toJson() => {
    't': time.millisecondsSinceEpoch,
    'n': nums,
  };

  factory _HistoryItem.fromJson(Map<String, dynamic> json) {
    final t = (json['t'] as num).toInt();
    final n = (json['n'] as List).map((e) => (e as num).toInt()).toList();
    return _HistoryItem(DateTime.fromMillisecondsSinceEpoch(t), n);
  }
}


