import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/tarot_screen.dart';
// import 'screens/horoscope_screen.dart';
import 'screens/settings_screen.dart';
import 'services/copy_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Errores Flutter (UI)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FLUTTER ERROR: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };

  // ✅ Errores Dart no atrapados
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('DART ERROR: $error');
    debugPrintStack(stackTrace: stack);
    return true;
  };

  // ✅ Widget de error visible (opcional, pero útil en debug)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          details.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  };

  // ✅ Carga JSON (packs + meta + ux)
  await CopyLoader.instance.loadAll();

  // ✅ Solo un runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot & Horóscopos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFB39DDB),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
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

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // Recibe eventos desde Home (botones, tools, etc.)
  void _handleHomeNav(String route, Map<String, dynamic>? args) {
    if (route == 'tarot/open') {
      setState(() => _selectedIndex = 1); // tab Tarot
    } else if (route == 'horoscope/open') {
      setState(() => _selectedIndex = 2);
    } else if (route == 'profile/open') {
      setState(() => _selectedIndex = 3);
    } else {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onNavigate: _handleHomeNav),
      const TarotScreen(),
      // const HoroscopeScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Tarot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
