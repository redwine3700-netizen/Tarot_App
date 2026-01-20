import 'dart:ui';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/tarot_screen.dart';
import 'screens/horoscope_screen.dart';
import 'screens/settings_screen.dart';
import 'package:tarot_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot & Horóscopos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // ⭐ por ahora para probar (después lo conectamos a compra)
  bool get isPremium => true;

  late final List<Widget> _pages = [
    const HomeScreen(),
    const TarotScreen(),
    HoroscopeScreen(isPremium: isPremium),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],

      // ✅ Glass bar: mantiene el tema y se ve pro sobre cualquier pantalla
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.55),
              border: Border(
                top: BorderSide(color: scheme.outline.withOpacity(0.25)),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: scheme.primary,
              unselectedItemColor: scheme.onSurface.withOpacity(0.65),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Tarot'),
                BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: 'Horóscopos'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
