import 'dart:math';
import 'package:flutter/material.dart';
import '../services/tarot_engine.dart';

import '../data/tarot_cards.dart';
import '../models/tarot_models.dart';
import 'tarot/tarot_quick_screen.dart';
import 'tarot/tarot_reading_screen.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final _rng = Random();
  final TarotEngine _engine = TarotEngine();

  TarotReading? _reading;
  bool _loading = false;
  String _title = 'Elige una tirada';

  Future<void> _drawSpread(TarotSpreadType type) async {
    setState(() {
      _loading = true;
    });

    try {
      TarotReading reading;

      switch (type) {
        case TarotSpreadType.oneCard:
          reading = await _engine.drawOneCard(
            allowReversed: true,
            avoidRecentCards: true,
          );
          break;

        case TarotSpreadType.threeCards:
          reading = await _engine.drawThreeCards(
            allowReversed: true,
            avoidRecentCards: true,
          );
          break;

        case TarotSpreadType.sixCards:
          reading = await _engine.drawSixCards(
            allowReversed: true,
            avoidRecentCards: true,
          );
          break;
      }

      setState(() {
        _reading = reading;
        _title = _spreadTitle(type);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al sacar la tirada: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _spreadTitle(TarotSpreadType type) {
    switch (type) {
      case TarotSpreadType.oneCard:
        return 'Tirada de 1 carta';
      case TarotSpreadType.threeCards:
        return 'Tirada de 3 cartas';
      case TarotSpreadType.sixCards:
        return 'Tirada de 6 cartas';
    }
  }

  List<TarotCard> _generarLectura(int cantidad) {
    final mazo = List<TarotCard>.of(cartasTarot);
    mazo.shuffle(_rng);
    return mazo.take(cantidad).toList();
  }

  void _openQuick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TarotQuickScreen(deck: cartasTarot)),
    );
  }

  void _open3() {
    final lectura = _generarLectura(3);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarotReadingScreen(
          title: 'Tirada 3 cartas',
          spreadName: 'Pasado • Presente • Futuro',
          cards: lectura,
        ),
      ),
    );
  }

  void _open6() {
    final lectura = _generarLectura(6);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarotReadingScreen(
          title: 'Tirada 6 cartas',
          spreadName: 'Profundiza con detalle',
          cards: lectura,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    Widget actionCard({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFFFD700)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Tarot'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          actionCard(
            icon: Icons.auto_awesome_rounded,
            title: 'Tarot rápido',
            subtitle: 'Una carta para tu día',
            onTap: _openQuick,
          ),
          actionCard(
            icon: Icons.filter_3_rounded,
            title: 'Tirada 3 cartas',
            subtitle: 'Pasado • Presente • Futuro',
            onTap: _open3,
          ),
          actionCard(
            icon: Icons.filter_6_rounded,
            title: 'Tirada 6 cartas',
            subtitle: 'Profundiza con detalle',
            onTap: _open6,
          ),
        ],
      ),
    );
  }
}
