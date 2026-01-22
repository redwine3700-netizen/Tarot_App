import 'dart:math';
import 'package:flutter/material.dart';
import '../services/copy_pack.dart';

class HomeScreen extends StatefulWidget {
  final void Function(String route, Map<String, dynamic>? args) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _energyPick;
  String? _forYouPick;

  void _pickOnce(CopyPack copy) {
    if (_energyPick != null && _forYouPick != null) return;

    final rng = Random();
    final energy = copy.sl('home.energy.values');
    final forYou = copy.sl('home.for_you.lines');

    _energyPick = energy.isEmpty ? null : energy[rng.nextInt(energy.length)];
    _forYouPick = forYou.isEmpty ? null : forYou[rng.nextInt(forYou.length)];
  }

  void _handleMainAction(String id) {
    if (id == 'tarot_quick') {
      widget.onNavigate('tarot/open', {'spread': 1, 'focus': 'amor'});
      return;
    }
    if (id == 'tarot_3') {
      widget.onNavigate('tarot/open', {'spread': 3, 'focus': 'amor'});
      return;
    }
    if (id == 'tarot_6') {
      widget.onNavigate('tarot/open', {'spread': 6, 'focus': 'amor'});
      return;
    }
  }

  void _handleTool(String id) {
    // Más adelante lo conectamos a la pantalla exacta de cada tool
    widget.onNavigate('tarot/open', {'tool': id});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CopyPack>(
      future: CopyPack.load('assets/copy/ux_deluxe_es.json'),
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
