import 'dart:math';

import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import 'tarot_screen.dart';
import 'horoscope_screen.dart';
import 'mystic_tools_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Random _random = Random();

  TarotCard? _cartaDelDia;
  bool _cargandoCarta = false;

  @override
  void initState() {
    super.initState();
    _generarCartaDelDia();
  }

  void _generarCartaDelDia() async {
    setState(() {
      _cargandoCarta = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _cartaDelDia = cartasTarot[_random.nextInt(cartasTarot.length)];
      _cargandoCarta = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dorado = Color(0xFFFFD700);

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
              Color(0xFF0B0618),
              Color(0xFF120C2C),
              Color(0xFF1E163F),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🌟 Header
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu espacio de magia diaria ✨',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: dorado,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Respira profundo y elige qué parte de tu vida quieres iluminar hoy.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Sección: Lecturas para hoy
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  'Lecturas para hoy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🃏 Carta del día
              Card(
                color: Colors.black.withOpacity(0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: dorado.withOpacity(0.5),
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
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: dorado,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Carta del día',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: dorado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: dorado.withOpacity(0.6),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              'Tarot del Sol',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: dorado,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_cargandoCarta)
                        const SizedBox(
                          height: 140,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_cartaDelDia != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AspectRatio(
                                aspectRatio: 3 / 5,
                                child: SizedBox(
                                  height: 140,
                                  child: Image.asset(
                                    _cartaDelDia!.imagePath,
                                    fit: BoxFit.cover,
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
                                    _cartaDelDia!.nombre,
                                    style:
                                    theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _cartaDelDia!.significado,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                            _cargandoCarta ? null : _generarCartaDelDia,
                            child: const Text('Volver a sacar'),
                          ),
                        ),
                      ] else ...[
                        const Text('Aún no hay carta del día disponible.'),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ♈ Horóscopos de hoy
              Card(
                color: Colors.black.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: dorado.withOpacity(0.3),
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.nightlight_round,
                            color: dorado,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Horóscopos de hoy',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: dorado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Descubre cómo se mueven hoy las estrellas en amor, trabajo y energía general para tu signo.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HoroscopeScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Ver horóscopos'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Juegos y rituales
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Juegos y rituales',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🎡 Explora tus rituales y juegos
              Card(
                color: Colors.black.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: dorado.withOpacity(0.25),
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: dorado,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rituales y juegos místicos',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: dorado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tarot del amor, péndulo, dados mágicos, ruleta de mensajes y la flor del amor: elige cómo quieres jugar con la energía del día.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const TarotScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('Ir al Tarot'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const MysticToolsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.casino),
                              label: const Text('Juegos mágicos'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
