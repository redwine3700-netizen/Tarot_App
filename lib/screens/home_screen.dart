import 'dart:math';

import 'package:flutter/material.dart';

import '../models/tarot_models.dart';
import 'tarot_screen.dart';
import 'horoscope_screen.dart';
import 'mystic_tools_screen.dart';
import '../services/user_prefs.dart';


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
      if (cartasTarot.isEmpty) {
        _cartaDelDia = null;
        _cargandoCarta = false;
        return;
      }
      _cartaDelDia = cartasTarot[_random.nextInt(cartasTarot.length)];
      _cargandoCarta = false;

    });
  }
  void _mostrarCartaDelDiaSheet() {
    if (_cartaDelDia == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        final dorado = const Color(0xFFD6B15E);

        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0C1E),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: dorado.withOpacity(0.35), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Text(
                  'Carta del día ✨',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: dorado,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 110,
                        height: 170,
                        child: Image.asset(
                          _cartaDelDia!.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) {
                            return Container(
                              color: Colors.black26,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white70,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cartaDelDia!.nombre,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _cartaDelDia!.significado,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _generarCartaDelDia();
                        },
                        icon: const Icon(Icons.casino),
                        label: const Text('Volver a sacar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TarotScreen()),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Ir al Tarot'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dorado = scheme.primary;
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
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {}, // si no tienes esta función, pon: () {}
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: dorado, size: 20),
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: dorado.withOpacity(0.6), width: 0.8),
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
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_cartaDelDia != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: 90,
                                  height: 140,
                                  child: Image.asset(
                                    _cartaDelDia!.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) {
                                      return Container(
                                        color: Colors.black26,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.image_not_supported, color: Colors.white70),
                                      );
                                    },
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
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _cartaDelDia!.significado,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: _generarCartaDelDia,
                                        icon: const Icon(Icons.casino),
                                        label: const Text('Volver a sacar'),
                                        style: TextButton.styleFrom(foregroundColor: dorado),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const Text('Aún no hay carta del día disponible.'),
                        ],
                      ],
                    ),
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
                                builder: (_) => const HoroscopeScreen(isPremium: false),
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
