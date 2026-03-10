import 'package:flutter/material.dart';

import '../models/horoscope_models.dart';
import '../services/horoscope_api_service.dart';
import '../services/user_prefs.dart';

String symbolForSignName(String name) {
  switch (name.toLowerCase()) {
    case 'aries':
      return '♈';
    case 'tauro':
      return '♉';
    case 'géminis':
    case 'geminis':
      return '♊';
    case 'cáncer':
    case 'cancer':
      return '♋';
    case 'leo':
      return '♌';
    case 'virgo':
      return '♍';
    case 'libra':
      return '♎';
    case 'escorpio':
      return '♏';
    case 'sagitario':
      return '♐';
    case 'capricornio':
      return '♑';
    case 'acuario':
      return '♒';
    case 'piscis':
      return '♓';
    default:
      return '✦';
  }
}

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  // Lista local para que no dependas de otro archivo.
  // IMPORTANTE: usa los mismos campos que tú ya vienes usando: nombre, fecha, resumenHoy.
  static final List<HoroscopeSign> signos = [
    HoroscopeSign(nombre: 'Aries', fecha: '21 mar – 19 abr', resumenHoy: 'Avanza con decisión, pero sin apurarte.'),
    HoroscopeSign(nombre: 'Tauro', fecha: '20 abr – 20 may', resumenHoy: 'Ordena tu energía y prioriza lo simple.'),
    HoroscopeSign(nombre: 'Géminis', fecha: '21 may – 20 jun', resumenHoy: 'Conversa, pregunta y abre opciones.'),
    HoroscopeSign(nombre: 'Cáncer', fecha: '21 jun – 22 jul', resumenHoy: 'Escucha tu intuición; cuida tu espacio.'),
    HoroscopeSign(nombre: 'Leo', fecha: '23 jul – 22 ago', resumenHoy: 'Brilla, pero desde la calma y el enfoque.'),
    HoroscopeSign(nombre: 'Virgo', fecha: '23 ago – 22 sep', resumenHoy: 'Pequeños ajustes hoy = gran avance mañana.'),
    HoroscopeSign(nombre: 'Libra', fecha: '23 sep – 22 oct', resumenHoy: 'Equilibrio: decide sin complacer a todos.'),
    HoroscopeSign(nombre: 'Escorpio', fecha: '23 oct – 21 nov', resumenHoy: 'Profundiza: una verdad te libera.'),
    HoroscopeSign(nombre: 'Sagitario', fecha: '22 nov – 21 dic', resumenHoy: 'Expande tu visión y planifica el siguiente paso.'),
    HoroscopeSign(nombre: 'Capricornio', fecha: '22 dic – 19 ene', resumenHoy: 'Constancia y estructura: hoy se construye.'),
    HoroscopeSign(nombre: 'Acuario', fecha: '20 ene – 18 feb', resumenHoy: 'Ideas nuevas: aterrízalas en algo concreto.'),
    HoroscopeSign(nombre: 'Piscis', fecha: '19 feb – 20 mar', resumenHoy: 'Sensibilidad + límites = paz interior.'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopos'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            itemCount: signos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final signo = signos[index];
              return _SignTile(
                symbol: symbolForSignName(signo.nombre),
                name: signo.nombre,
                dates: signo.fecha,
                summary: signo.resumenHoy,
                borderColor: scheme.primary.withOpacity(0.35),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HoroscopeDetailScreen(sign: signo),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SignTile extends StatelessWidget {
  final String symbol;
  final String name;
  final String dates;
  final String summary;
  final VoidCallback onTap;
  final Color borderColor;

  const _SignTile({
    required this.symbol,
    required this.name,
    required this.dates,
    required this.summary,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.25),
                border: Border.all(color: scheme.primary.withOpacity(0.55)),
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: scheme.primary,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dates,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      height: 1.2,
                      fontSize: 13,
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

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadDaily();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await UserPrefs.getUserName();
      if (!mounted) return;
      setState(() => _userName = UserPrefs.formatName(name));
    } catch (_) {}
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
      if (mounted) setState(() => _loadingDaily = false);
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
          description: 'Tendencia semanal: ${widget.sign.resumenHoy}',
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      if (mounted) setState(() => _loadingWeekly = false);
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
          description: 'Tendencia del mes: ${widget.sign.resumenHoy}',
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
      });
    } finally {
      if (mounted) setState(() => _loadingMonthly = false);
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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
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
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ===== OPCIÓN B (la que te gusta): icono grande + textos =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(color: scheme.primary.withOpacity(0.22)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.25),
                            border: Border.all(color: scheme.primary.withOpacity(0.55)),
                          ),
                          child: Center(
                            child: Text(
                              symbolForSignName(widget.sign.nombre),
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: scheme.primary,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.sign.nombre,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.sign.fecha,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.78),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.sign.resumenHoy,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: TabBarView(
                    children: [
                      _HoroscopeTab(
                        loading: _loadingDaily,
                        data: _daily,
                        fallbackText: widget.sign.resumenHoy,
                        userName: _userName,
                      ),
                      _HoroscopeTab(
                        loading: _loadingWeekly,
                        data: _weekly,
                        fallbackText: widget.sign.resumenHoy,
                        userName: _userName,
                      ),
                      _HoroscopeTab(
                        loading: _loadingMonthly,
                        data: _monthly,
                        fallbackText: widget.sign.resumenHoy,
                        userName: _userName,
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

class _HoroscopeTab extends StatelessWidget {
  final bool loading;
  final DailyHoroscope? data;
  final String fallbackText;
  final String userName;

  const _HoroscopeTab({
    required this.loading,
    required this.data,
    required this.fallbackText,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final desc = (data?.description ?? fallbackText).trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: scheme.primary.withOpacity(0.22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userName.trim().isNotEmpty)
                Text(
                  'Para ti, $userName ✨',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              if (userName.trim().isNotEmpty) const SizedBox(height: 10),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  height: 1.55,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _MiniPill(label: 'Ánimo', value: data?.mood ?? '—'),
                  const SizedBox(width: 10),
                  _MiniPill(label: 'Color', value: data?.color ?? '—'),
                  const SizedBox(width: 10),
                  _MiniPill(label: 'N°', value: data?.luckyNumber ?? '—'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final String value;

  const _MiniPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.06),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
