import 'mystic_tools_screen.dart';
import 'pendulum_screen.dart';
import 'horoscope_screen.dart';
import 'tarot/tarot_quick_screen.dart';
import 'tarot/tarot_reading_screen.dart';
import '../models/tarot_models.dart';
import '../data/tarot_cards.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/copy_packs_loader.dart';


class HomeScreen extends StatefulWidget {
  final void Function(String route, Map<String, dynamic>? args) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = Random();

  List<TarotCard> _generarLectura(int cantidad) {
    final mazo = List<TarotCard>.of(cartasTarot);
    mazo.shuffle(_random);
    return mazo.take(cantidad).toList();
  }



String? _energyPick;
  String? _forYouPick;
  List<String> _sl(Map<String, dynamic> map, String path) {
    dynamic cur = map;
    for (final part in path.split('.')) {
      if (cur is Map<String, dynamic>) {
        cur = cur[part];
      } else {
        return const [];
      }
    }
    if (cur is List) return cur.map((e) => e.toString()).toList();
    return const [];
  }



  void _pickOnce(CopyPack copy) {
    if (_energyPick != null && _forYouPick != null) return;

    final rng = Random();
    final energy = copy.sl('home.energy.values');
    final forYou = copy.sl('home.for_you.lines');



    _energyPick = energy.isEmpty ? null : energy[rng.nextInt(energy.length)];
    _forYouPick = forYou.isEmpty ? null : forYou[rng.nextInt(forYou.length)];
  }

  void _handleMainAction(String id) {
    switch (id) {
      case 'tarot_quick':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TarotQuickScreen(deck: cartasTarot),
          ),
        );
        return;


      case 'tarot_3': {
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
        return;
      }

      case 'tarot_6': {
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
        return;
      }


      default:
      // Si tienes otras acciones, las dejas aquí
        break;
    }
  }


  void _handleTool(String id) {
    switch (id) {
      case 'pendulo':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PendulumScreen()),
        );
        return;

      case 'horoscopo':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HoroscopeScreen()),
        );
        return;

      case 'dados':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MysticToolsScreen(initialTab: 0)),
        );
        return;

      case 'ruleta':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MysticToolsScreen(initialTab: 1)),
        );
        return;

      case 'flor_amor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MysticToolsScreen(initialTab: 2)),
        );
        return;

      case 'tombola':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MysticToolsScreen(initialTab: 3)),
        );
        return;

    }
  }
  Widget _toolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String id,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _handleTool(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFFFD700)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.55)),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CopyPack>(
      future: CopyPacksLoader.loadEs(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: Text('No se pudo cargar el contenido.')));
        }

        final copy = snap.data!;
        _pickOnce(copy);

        final theme = Theme.of(context);
        final dorado = theme.colorScheme.primary;

        final actions = copy.ml('home.actions');
        final tools = copy.ml('home.tools.items');

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // HERO
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy.s('home.hero.title', fallback: 'Bienvenido a tu ritual'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: dorado,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          copy.s('home.hero.subtitle', fallback: 'Elige una herramienta y déjate guiar.'),
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        if ((_energyPick ?? '').isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: dorado.withOpacity(0.35)),
                              color: theme.colorScheme.surface.withOpacity(0.22),
                            ),
                            child: Text(
                              "${copy.s('home.energy.label', fallback: 'Energía')}: $_energyPick",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ACCIONES PRINCIPALES
                ...actions.map((a) {
                  final id = (a['id'] ?? '').toString();
                  final title = (a['title'] ?? '').toString();
                  final subtitle = (a['subtitle'] ?? '').toString();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => _handleMainAction(id),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, color: dorado, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(subtitle, style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 18),

                // TOOLS
                Text(
                  copy.s('home.tools.title', fallback: 'Herramientas místicas'),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tools.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final t = tools[i];
                      final id = (t['id'] ?? '').toString();
                      final title = (t['title'] ?? '').toString();
                      final subtitle = (t['subtitle'] ?? '').toString();

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _handleTool(id),
                        child: Container(
                          width: 170,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: dorado.withOpacity(0.28)),
                            color: theme.colorScheme.surface.withOpacity(0.22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),

                _toolCard(
                  title: 'Péndulo',
                  subtitle: 'Sí / No con intención',
                  icon: Icons.circle_outlined,
                  id: 'pendulo',
                ),
                const SizedBox(height: 12),

                _toolCard(
                  title: 'Dados',
                  subtitle: 'Decisión rápida y divertida',
                  icon: Icons.casino,
                  id: 'dados',
                ),
                const SizedBox(height: 12),

                _toolCard(
                  title: 'Ruleta',
                  subtitle: 'Gira y deja que el destino elija',
                  icon: Icons.refresh_rounded,
                  id: 'ruleta',
                ),
                const SizedBox(height: 12),

                _toolCard(
                  title: 'Horóscopo',
                  subtitle: 'Tu energía del día',
                  icon: Icons.nightlight_round,
                  id: 'horoscopo',
                ),


                const SizedBox(height: 18),

                // PARA TI
                if ((_forYouPick ?? '').isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_fix_high, color: dorado, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  copy.s('home.for_you.title', fallback: 'Para ti'),
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(_forYouPick!, style: theme.textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
