import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import '../services/horoscope_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TarotCard? _cartaDelDia;
  bool _cargandoCarta = true;

  HoroscopeSign? _signoPreferido;
  bool _cargandoSigno = true;

  DailyHoroscope? _horoscopoHoy;
  bool _cargandoHoroscopo = true;
  String? _errorHoroscopo;

  @override
  void initState() {
    super.initState();
    _cargarCartaDelDia();
    _cargarSignoPreferido();
  }

  Future<void> _cargarCartaDelDia() async {
    final carta = await DailyCardManager.getOrGenerateDailyCard();
    setState(() {
      _cartaDelDia = carta;
      _cargandoCarta = false;
    });
  }

  Future<void> _cargarSignoPreferido() async {
    final signo = await UserPreferences.getPreferredSign();
    setState(() {
      _signoPreferido = signo;
      _cargandoSigno = false;
    });

    if (signo != null) {
      await _cargarHoroscopoHoy();
    } else {
      setState(() {
        _cargandoHoroscopo = false;
      });
    }
  }

  Future<void> _cargarHoroscopoHoy() async {
    final signo = _signoPreferido;
    if (signo == null) {
      setState(() {
        _cargandoHoroscopo = false;
      });
      return;
    }

    setState(() {
      _cargandoHoroscopo = true;
      _errorHoroscopo = null;
    });

    try {
      final data = await HoroscopeApiService.fetchTodayForSign(signo.nombre);
      setState(() {
        _horoscopoHoy = data;
        _cargandoHoroscopo = false;
        _errorHoroscopo = null;
      });
    } catch (e) {
      // 👉 Si la API falla, usamos tu texto local
      setState(() {
        _horoscopoHoy = DailyHoroscope(
          description: signo.resumenHoy,
          mood: '—',
          color: '—',
          luckyNumber: '—',
        );
        _cargandoHoroscopo = false;
        _errorHoroscopo = null; // no mostramos error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
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
              Color(0xFF0B0618), // violeta oscuro
              Color(0xFF120C2C), // más profundo
              Color(0xFF1E163F), // toque místico
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // aquí se mantiene TODO lo que ya tenías en la lista:
              // Carta del día, Horóscopo del día, Mensaje del día...
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                    width: 1.2,
                  ),
                ),
                elevation: 12,
                shadowColor: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carta del día',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 👇 aquí va igual todo tu contenido de carta del día
                      if (_cargandoCarta) ...[
                        const SizedBox(
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ] else if (_cartaDelDia != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AspectRatio(
                            aspectRatio: 3 / 5,
                            child: Image.asset(
                              _cartaDelDia!.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _cartaDelDia!.nombre,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _cartaDelDia!.significado,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ] else ...[
                        const Text('Aún no hay carta del día disponible'),
                      ],
                    ],
                  ),
                ),
              ),

              // 👉 Después de este Card, dejas igual los otros Card
              // de horóscopo del día y mensaje del día,
              // pero si quieres repite el mismo estilo de Card.
            ],
          ),
        ),
      ),
    );

  }
}
