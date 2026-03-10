import 'package:flutter/material.dart';
import 'widgets/emotional_process_section.dart';
import '../../services/emotional_memory_service.dart';
import 'helpers/emotional_process_helpers.dart';
import 'emotional_history_screen.dart';

class EmotionalProcessScreen extends StatefulWidget {
  const EmotionalProcessScreen({super.key});

  @override
  State<EmotionalProcessScreen> createState() => _EmotionalProcessScreenState();
}

class _EmotionalProcessScreenState extends State<EmotionalProcessScreen> {

  int _processDay = 0;
  List<Map<String, dynamic>> _emotionalHistory = [];

  final Color _accentFill = const Color(0xFFFFD700);
  final Color _accentBorder = const Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    _loadMemory();
  }

  Future<void> _loadMemory() async {
    final memory = EmotionalMemoryService();

    final day = await memory.getProcessDay();
    final history = await memory.getHistory();

    setState(() {
      _processDay = day ?? 0;
      _emotionalHistory = history;
    });
  }

  Future<void> _updateEstado() async {
    String? estadoSel;
    String? focoSel;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Check-in emocional',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      '¿Cómo te sientes hoy?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['tranquilo', 'confundido', 'ansioso', 'esperanzado', 'triste'].map((e) {
                        final selected = estadoSel == e;
                        return ChoiceChip(
                          label: Text(e),
                          selected: selected,
                          onSelected: (_) => setLocal(() => estadoSel = e),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      '¿En qué está tu foco?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'ex pareja',
                        'relación actual',
                        'conociendo a alguien',
                        'duelo o pérdida',
                        'amor propio',
                      ].map((f) {
                        final selected = focoSel == f;
                        return ChoiceChip(
                          label: Text(f),
                          selected: selected,
                          onSelected: (_) => setLocal(() => focoSel = f),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Ahora no'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != true) return;

    final memory = EmotionalMemoryService();

    if ((estadoSel ?? '').trim().isNotEmpty) {
      await memory.saveEstado(estadoSel!.trim());
    }

    if ((focoSel ?? '').trim().isNotEmpty) {
      await memory.saveFoco(focoSel!.trim());
    }

    if ((estadoSel ?? '').trim().isNotEmpty &&
        (focoSel ?? '').trim().isNotEmpty) {
      await memory.addHistoryEntry(
        estado: estadoSel!.trim(),
        foco: focoSel!.trim(),
      );
    }

    await memory.saveLastCheckinNow();
    await _loadMemory();
  }

  Map<String, List<Map<String, dynamic>>> _groupHistoryByDate(
      List<Map<String, dynamic>> history,
      ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in history) {
      final ts = item['timestamp'] as int?;
      if (ts == null) continue;

      final key = formatHistoryDate(ts);
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Proceso emocional"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: EmotionalProcessSection(
          processDay: _processDay,
          processMessage: processMessage(_processDay),
          processAction: processAction(_processDay),
          processTitle: processTitle(_processDay),
          processClosing: processClosing(_processDay),
          accentFill: _accentFill,
          accentBorder: _accentBorder,

          onUpdateEmotionalState: _updateEstado,

          onStartProcess: () async {
            final memory = EmotionalMemoryService();
            setState(() {
              _processDay = 1;
            });
            await memory.saveProcessDay(1);
          },

          onContinueProcess: () async {
            final memory = EmotionalMemoryService();
            final nextDay = _processDay + 1;

            setState(() {
              _processDay = nextDay;
            });

            await memory.saveProcessDay(nextDay);
          },

          onRestartProcess: () async {
            final memory = EmotionalMemoryService();

            setState(() {
              _processDay = 0;
            });

            await memory.saveProcessDay(0);
          },
          onOpenFullHistory: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmotionalHistoryScreen(
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}