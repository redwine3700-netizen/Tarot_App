import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import '../services/horoscope_api_service.dart';

class HoroscopeScreen extends StatelessWidget {
  final bool isPremium;

  const HoroscopeScreen({
    super.key,
    required this.isPremium,
  });


  String _zodiacSymbol(String name) {
    final n = name.toLowerCase().trim();
    if (n.contains('aries')) return '♈';
    if (n.contains('tauro')) return '♉';
    if (n.contains('géminis') || n.contains('geminis')) return '♊';
    if (n.contains('cáncer') || n.contains('cancer')) return '♋';
    if (n.contains('leo')) return '♌';
    if (n.contains('virgo')) return '♍';
    if (n.contains('libra')) return '♎';
    if (n.contains('escorpio') || n.contains('scorpio')) return '♏';
    if (n.contains('sagitario')) return '♐';
    if (n.contains('capricornio')) return '♑';
    if (n.contains('acuario')) return '♒';
    if (n.contains('piscis')) return '♓';
    return '✦';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopos'),
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
            colors: [
              Color(0xFF0B0618),
              Color(0xFF120C2C),
              Color(0xFF1E163F),
            ],
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: signos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final signo = signos[index];
              final symbol = _zodiacSymbol(signo.nombre);

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HoroscopeDetailScreen(sign: signo),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.primary.withOpacity(0.22),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.55),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título + símbolo (donde estaban tus ✨)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                signo.nombre,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: scheme.primary.withOpacity(0.35),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                symbol,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: scheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          signo.fecha,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.70),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: Text(
                            signo.resumenHoy,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.92),
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HoroscopeDetailScreen extends StatefulWidget {
  final HoroscopeSign sign;

  const HoroscopeDetailScreen({super.key, required this.sign});

  @override
  State<HoroscopeDetailScreen> createState() => _HoroscopeDetailScreenState();
}

class _HoroscopeDetailScreenState extends State<HoroscopeDetailScreen> {
  DailyHoroscope? _daily;
  DailyHoroscope? _weekly;
  DailyHoroscope? _monthly;

  bool _loadingDaily = false;
  bool _loadingWeekly = false;
  bool _loadingMonthly = false;

  @override
  void initState() {
    super.initState();
    _loadDaily();
  }

  Future<void> _loadDaily() async {
    setState(() => _loadingDaily = true);
    try {
      final data = await HoroscopeApiService.fetchTodayForSign(widget.sign.nombre);
      setState(() => _daily = data);
    } catch (_) {
      setState(() {
        _daily = DailyHoroscope(
          description: widget.sign.resumenHoy,
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      setState(() => _loadingDaily = false);
    }
  }

  Future<void> _loadWeekly() async {
    if (_weekly != null || _loadingWeekly) return;
    setState(() => _loadingWeekly = true);
    try {
      final data = await HoroscopeApiService.fetchWeeklyForSign(widget.sign.nombre);
      setState(() => _weekly = data);
    } catch (_) {
      setState(() {
        _weekly = DailyHoroscope(
          description:
          'Tendencia semanal: ${widget.sign.resumenHoy} (adaptada a toda la semana).',
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      setState(() => _loadingWeekly = false);
    }
  }

  Future<void> _loadMonthly() async {
    if (_monthly != null || _loadingMonthly) return;
    setState(() => _loadingMonthly = true);
    try {
      final data = await HoroscopeApiService.fetchMonthlyForSign(widget.sign.nombre);
      setState(() => _monthly = data);
    } catch (_) {
      setState(() {
        _monthly = DailyHoroscope(
          description:
          'Tendencia del mes: ${widget.sign.resumenHoy} (proyectada para el mes).',
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      setState(() => _loadingMonthly = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.sign.nombre),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            onTap: (i) {
              if (i == 1) _loadWeekly();
              if (i == 2) _loadMonthly();
            },
            indicatorColor: scheme.primary,
            labelColor: scheme.onSurface,
            unselectedLabelColor: scheme.onSurface.withOpacity(0.65),
            tabs: const [
              Tab(text: 'Hoy'),
              Tab(text: 'Semana'),
              Tab(text: 'Mes'),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B0618),
                Color(0xFF120C2C),
                Color(0xFF1E163F),
              ],
            ),
          ),
          child: SafeArea(
            child: TabBarView(
              children: [
                _HoroscopeTab(
                  loading: _loadingDaily,
                  data: _daily,
                  fallbackText: widget.sign.resumenHoy,
                ),
                _HoroscopeTab(
                  loading: _loadingWeekly,
                  data: _weekly,
                  fallbackText: widget.sign.resumenHoy,
                ),
                _HoroscopeTab(
                  loading: _loadingMonthly,
                  data: _monthly,
                  fallbackText: widget.sign.resumenHoy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoroscopeTab extends StatelessWidget {
  final bool loading;
  final DailyHoroscope? data;
  final String fallbackText;

  const _HoroscopeTab({
    required this.loading,
    required this.data,
    required this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final text = data?.description ?? fallbackText;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: scheme.primary.withOpacity(0.22),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.35,
                color: scheme.onSurface.withOpacity(0.92),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (data != null) ...[
          _miniRow(context, 'Mood', data!.mood),
          _miniRow(context, 'Color', data!.color),
          _miniRow(context, 'Número', data!.luckyNumber),
        ],
      ],
    );
  }

  Widget _miniRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.70),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withOpacity(0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
