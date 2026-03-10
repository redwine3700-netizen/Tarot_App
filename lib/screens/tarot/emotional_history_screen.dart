import 'package:flutter/material.dart';
import '../../services/emotional_memory_service.dart';
import 'helpers/emotional_process_helpers.dart';


class EmotionalHistoryScreen extends StatefulWidget {
  const EmotionalHistoryScreen({super.key});

  @override
  State<EmotionalHistoryScreen> createState() => _EmotionalHistoryScreenState();
}

class _EmotionalHistoryScreenState extends State<EmotionalHistoryScreen> {
  List<Map<String, dynamic>> _emotionalHistory = [];

  final Color _bg = const Color(0xFF140B1F);
  final Color _panel = const Color(0xFF1E1230);
  final Color _accentFill = const Color(0xFFFFE7D0);
  final Color _accentBorder = const Color(0xFFEAC19C);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final memory = EmotionalMemoryService();
    final history = await memory.getHistory();

    if (!mounted) return;
    setState(() {
      _emotionalHistory = history;
    });
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _accentBorder.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _accentFill,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
    final groupedHistory = _groupHistoryByDate(_emotionalHistory);
    final groupedKeys = groupedHistory.keys.toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Historial emocional'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _accentBorder.withOpacity(0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu proceso reciente',
                    style: TextStyle(
                      color: _accentFill,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    historyInsight(_emotionalHistory),
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_emotionalHistory.isEmpty)
                    const Text(
                      'Aún no hay registros emocionales.',
                      style: TextStyle(color: Colors.white70),
                    ),

                  ...groupedKeys.map((dateLabel) {
                    final items = groupedHistory[dateLabel]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 6),
                          child: Text(
                            dateLabel,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...items.map((item) {
                          final estado = (item['estado'] ?? '').toString();
                          final foco = (item['foco'] ?? '').toString();

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (estado.isNotEmpty) _miniTag(estado),
                                if (foco.isNotEmpty) _miniTag(foco),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}