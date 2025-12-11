import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import '../services/horoscope_api_service.dart';

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopos'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: signos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (context, index) {
          final signo = signos[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HoroscopeDetailScreen(sign: signo),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFD700).withOpacity(0.25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signo.nombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      signo.fecha,
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      signo.resumenHoy,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
    setState(() {
      _loadingDaily = true;
    });
    try {
      final data =
          await HoroscopeApiService.fetchTodayForSign(widget.sign.nombre);
      setState(() {
        _daily = data;
      });
    } catch (_) {
      // Fallback local
      setState(() {
        _daily = DailyHoroscope(
          description: widget.sign.resumenHoy,
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      setState(() {
        _loadingDaily = false;
      });
    }
  }

  Future<void> _loadWeekly() async {
    if (_weekly != null || _loadingWeekly) return;
    setState(() {
      _loadingWeekly = true;
    });
    try {
      final data =
          await HoroscopeApiService.fetchWeeklyForSign(widget.sign.nombre);
      setState(() {
        _weekly = data;
      });
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
      setState(() {
        _loadingWeekly = false;
      });
    }
  }

  Future<void> _loadMonthly() async {
    if (_monthly != null || _loadingMonthly) return;
    setState(() {
      _loadingMonthly = true;
    });
    try {
      final data =
          await HoroscopeApiService.fetchMonthlyForSign(widget.sign.nombre);
      setState(() {
        _monthly = data;
      });
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
      setState(() {
        _loadingMonthly = false;
      });
    }
  }

  Widget _buildGeneralBlock(String title, DailyHoroscope? data, bool loading) {
    final theme = Theme.of(context);

    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (data == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No se pudo cargar la información en este momento.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Ánimo: ${data.mood}  •  Color: ${data.color}  •  Número: ${data.luckyNumber}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildLoveWorkHealth() {
    final theme = Theme.of(context);
    final sign = widget.sign;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Amor',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sign.amor,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Trabajo y dinero',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sign.dinero,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Salud y energía',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sign.salud,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sign = widget.sign;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(sign.nombre),
          bottom: TabBar(
            indicatorColor: const Color(0xFFFFD700),
            tabs: const [
              Tab(text: 'Hoy'),
              Tab(text: 'Semana'),
              Tab(text: 'Mes'),
            ],
            onTap: (index) {
              if (index == 1) {
                _loadWeekly();
              } else if (index == 2) {
                _loadMonthly();
              }
            },
          ),
        ),
        body: TabBarView(
          children: [
            // HOY
            ListView(
              children: [
                _buildGeneralBlock(
                  'Mensaje general de hoy',
                  _daily,
                  _loadingDaily,
                ),
                _buildLoveWorkHealth(),
              ],
            ),
            // SEMANA
            ListView(
              children: [
                _buildGeneralBlock(
                  'Energía de la semana',
                  _weekly,
                  _loadingWeekly,
                ),
                _buildLoveWorkHealth(),
              ],
            ),
            // MES
            ListView(
              children: [
                _buildGeneralBlock(
                  'Energía del mes',
                  _monthly,
                  _loadingMonthly,
                ),
                _buildLoveWorkHealth(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
