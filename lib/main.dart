import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// MODELO DE CARTA DE TAROT
class TarotCard {
  final String nombre;
  final String significado;

  TarotCard({
    required this.nombre,
    required this.significado,
  });
}

/// MAZO BÁSICO DE CARTAS
final List<TarotCard> cartasTarot = [
  TarotCard(
    nombre: 'El Loco',
    significado:
    'Nuevos comienzos, salto de fe y aventura. Confía en el viaje y déjate llevar.',
  ),
  TarotCard(
    nombre: 'El Mago',
    significado:
    'Poder personal, acción e iniciativa. Tienes todo para manifestar tus deseos.',
  ),
  TarotCard(
    nombre: 'La Sacerdotisa',
    significado:
    'Intuición, misterio y sabiduría interior. Escucha tu voz interna.',
  ),
  TarotCard(
    nombre: 'La Emperatriz',
    significado:
    'Abundancia, amor, creatividad y energía maternal. Momento de florecimiento.',
  ),
  TarotCard(
    nombre: 'El Emperador',
    significado:
    'Orden, estructura, autoridad y seguridad. Toma el control con firmeza.',
  ),
  TarotCard(
    nombre: 'El Sumo Sacerdote',
    significado:
    'Guía espiritual, tradición y aprendizaje. Busca consejo y estabilidad.',
  ),
  TarotCard(
    nombre: 'Los Enamorados',
    significado:
    'Amor, decisiones importantes y conexión profunda. Elige con el corazón.',
  ),
  TarotCard(
    nombre: 'El Carro',
    significado:
    'Determinación, victoria y avance. Vas en la dirección correcta.',
  ),
  TarotCard(
    nombre: 'La Justicia',
    significado:
    'Verdad, equilibrio y decisiones justas. Actúa con responsabilidad.',
  ),
  TarotCard(
    nombre: 'El Ermitaño',
    significado:
    'Introspección, soledad elegida y búsqueda de respuestas. Mira hacia dentro.',
  ),
  TarotCard(
    nombre: 'La Rueda de la Fortuna',
    significado:
    'Cambios, destino y ciclos. Algo grande está por moverse a tu favor.',
  ),
  TarotCard(
    nombre: 'La Fuerza',
    significado:
    'Valentía, control emocional y compasión. Tu fuerza está en tu calma.',
  ),
  TarotCard(
    nombre: 'El Colgado',
    significado:
    'Pausa, reflexión y nuevos puntos de vista. Deja ir lo que ya no sirve.',
  ),
  TarotCard(
    nombre: 'La Muerte',
    significado:
    'Transformación profunda, cierres necesarios y renacimiento. Algo nuevo comienza.',
  ),
  TarotCard(
    nombre: 'La Templanza',
    significado:
    'Paciencia, armonía y equilibrio. Avanza con calma y claridad.',
  ),
  TarotCard(
    nombre: 'El Diablo',
    significado:
    'Tentaciones, ataduras y deseos intensos. Reconoce lo que te limita.',
  ),
  TarotCard(
    nombre: 'La Torre',
    significado:
    'Cambios inesperados, revelaciones y liberación. Se cae lo que ya no sirve.',
  ),
  TarotCard(
    nombre: 'La Estrella',
    significado:
    'Esperanza, guía divina, paz y sanación. Se acerca lo que anhelas.',
  ),
  TarotCard(
    nombre: 'La Luna',
    significado:
    'Intuición, emociones ocultas y sueños. No todo es lo que parece.',
  ),
  TarotCard(
    nombre: 'El Sol',
    significado:
    'Éxito, alegría, claridad y bendiciones. Buenas noticias llegan a tu vida.',
  ),
  TarotCard(
    nombre: 'El Juicio',
    significado:
    'Renovación, cambio de conciencia y despertar interior. Segunda oportunidad.',
  ),
  TarotCard(
    nombre: 'El Mundo',
    significado:
    'Cierre de ciclos, logros y realización. Estás alcanzando una meta importante.',
  ),
];

/// GESTOR DE CARTA DEL DÍA (persistente)
class DailyCardManager {
  static const _keyIndex = 'daily_card_index';
  static const _keyDate = 'daily_card_date';

  static Future<TarotCard> getOrGenerateDailyCard() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final todayString = '${now.year}-${now.month}-${now.day}';

    final savedDate = prefs.getString(_keyDate);
    final savedIndex = prefs.getInt(_keyIndex);

    // Si ya hay carta guardada para hoy, la reutilizamos
    if (savedDate == todayString &&
        savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < cartasTarot.length) {
      return cartasTarot[savedIndex];
    }

    // Si no hay carta de hoy, generamos una nueva
    final random = Random();
    final newIndex = random.nextInt(cartasTarot.length);

    await prefs.setString(_keyDate, todayString);
    await prefs.setInt(_keyIndex, newIndex);

    return cartasTarot[newIndex];
  }
}

/// PREFERENCIAS DE USUARIO (signo preferido)
class UserPreferences {
  static const _keyPreferredSign = 'preferred_sign';

  static Future<void> setPreferredSign(String nombreSigno) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPreferredSign, nombreSigno);
  }

  static Future<HoroscopeSign?> getPreferredSign() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString(_keyPreferredSign);

    if (nombre == null) {
      return signos.isNotEmpty ? signos.first : null;
    }

    try {
      return signos.firstWhere((s) => s.nombre == nombre);
    } catch (_) {
      return signos.isNotEmpty ? signos.first : null;
    }
  }
}

/// MODELO DE SIGNO
class HoroscopeSign {
  final String nombre;
  final String fecha;
  final String resumenHoy;
  final String amor;
  final String dinero;
  final String salud;

  HoroscopeSign({
    required this.nombre,
    required this.fecha,
    required this.resumenHoy,
    required this.amor,
    required this.dinero,
    required this.salud,
  });
}

/// LISTA DE SIGNOS
final List<HoroscopeSign> signos = [
  HoroscopeSign(
    nombre: 'Aries',
    fecha: '21 de marzo - 19 de abril',
    resumenHoy:
    'Energía alta y ganas de avanzar. Buen día para tomar decisiones rápidas.',
    amor:
    'Sé directo, pero cuida tus palabras. Una conversación sincera puede aclarar mucho.',
    dinero:
    'Momento ideal para organizar gastos y enfocarte en una meta concreta.',
    salud: 'Canaliza tu energía en movimiento físico para evitar tensiones.',
  ),
  HoroscopeSign(
    nombre: 'Tauro',
    fecha: '20 de abril - 20 de mayo',
    resumenHoy: 'Necesitas estabilidad y calma. Busca espacios tranquilos.',
    amor:
    'Valora los pequeños gestos. Una muestra de cariño sincero te hará sentir en casa.',
    dinero:
    'No te apresures a gastar. Es un buen día para ahorrar o revisar cuentas.',
    salud: 'Cuida tu alimentación y evita excesos. Tu cuerpo agradecerá la estabilidad.',
  ),
  HoroscopeSign(
    nombre: 'Géminis',
    fecha: '21 de mayo - 20 de junio',
    resumenHoy:
    'Tu mente está muy activa. Buen día para comunicar y aprender.',
    amor:
    'Una conversación pendiente puede traer claridad y cercanía.',
    dinero:
    'Ideas nuevas pueden abrirte puertas. Anota todo lo que se te ocurra.',
    salud: 'Descansa tu mente desconectando un rato de pantallas.',
  ),
  HoroscopeSign(
    nombre: 'Cáncer',
    fecha: '21 de junio - 22 de julio',
    resumenHoy:
    'La emoción está más sensible hoy. Escucha lo que sientes.',
    amor:
    'Necesitas contención y cariño. Rodéate de personas que te hagan bien.',
    dinero:
    'Buen día para planear a largo plazo y pensar en seguridad.',
    salud: 'Protege tu energía evitando discusiones innecesarias.',
  ),
  HoroscopeSign(
    nombre: 'Leo',
    fecha: '23 de julio - 22 de agosto',
    resumenHoy:
    'Tu brillo natural se nota. Día ideal para mostrar tus talentos.',
    amor:
    'Un gesto romántico puede fortalecer mucho un vínculo.',
    dinero:
    'Confía en tu liderazgo, pero evita el orgullo en decisiones financieras.',
    salud: 'Muévete, baila o haz algo que te haga sentir vital y seguro.',
  ),
  HoroscopeSign(
    nombre: 'Virgo',
    fecha: '23 de agosto - 22 de septiembre',
    resumenHoy:
    'La organización te dará paz mental. Pon orden en tus pendientes.',
    amor:
    'Hablar con honestidad, pero sin criticar tanto, hará que te escuchen mejor.',
    dinero:
    'Momento ideal para revisar detalles de contratos o cuentas.',
    salud: 'Cuida tu sistema nervioso con pausas y respiración consciente.',
  ),
  HoroscopeSign(
    nombre: 'Libra',
    fecha: '23 de septiembre - 22 de octubre',
    resumenHoy:
    'Buscas equilibrio y armonía. Evita extremos.',
    amor:
    'Buen día para acuerdos, disculpas y reconciliación.',
    dinero:
    'Piensa en alianzas o trabajos en equipo. Juntos avanzan más.',
    salud: 'Rodéate de belleza: música, arte o naturaleza te harán muy bien.',
  ),
  HoroscopeSign(
    nombre: 'Escorpio',
    fecha: '23 de octubre - 21 de noviembre',
    resumenHoy:
    'Las emociones van profundas. No temas mirar adentro.',
    amor:
    'La intensidad puede unir o separar. Elige comunicar en vez de controlar.',
    dinero:
    'Transformar una vieja idea puede traer nuevas oportunidades.',
    salud: 'Descarga la tensión con ejercicio o escritura.',
  ),
  HoroscopeSign(
    nombre: 'Sagitario',
    fecha: '22 de noviembre - 21 de diciembre',
    resumenHoy:
    'Necesitas libertad y expansión. Sueña en grande.',
    amor:
    'Una conversación espontánea puede darte una grata sorpresa.',
    dinero:
    'Buen día para aprender algo nuevo que beneficie tu futuro laboral.',
    salud: 'Salir al aire libre te renovará la energía.',
  ),
  HoroscopeSign(
    nombre: 'Capricornio',
    fecha: '22 de diciembre - 19 de enero',
    resumenHoy:
    'Responsabilidad y concentración. Puedes avanzar mucho si te organizas.',
    amor:
    'Valora la lealtad y los compromisos. No temas mostrar tu lado sensible.',
    dinero:
    'Buen momento para pensar en metas a largo plazo y estabilidad.',
    salud: 'Cuida tus huesos y articulaciones. El descanso también es productividad.',
  ),
  HoroscopeSign(
    nombre: 'Acuario',
    fecha: '20 de enero - 18 de febrero',
    resumenHoy:
    'Ideas originales y ganas de cambiar las cosas.',
    amor:
    'Ser auténtico atraerá a las personas correctas.',
    dinero:
    'Piensa “fuera de la caja”: una idea diferente puede rendir frutos.',
    salud: 'Busca espacios de libertad y aire fresco para despejar tu mente.',
  ),
  HoroscopeSign(
    nombre: 'Piscis',
    fecha: '19 de febrero - 20 de marzo',
    resumenHoy:
    'Tu intuición está muy despierta. Confía en lo que sientes.',
    amor:
    'La sensibilidad te conecta profundamente con otros. No temas mostrarla.',
    dinero:
    'Escucha tu intuición antes de tomar decisiones importantes.',
    salud: 'El descanso emocional es clave: música, agua, silencio.',
  ),
];

/// APP ROOT
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // dorado
          secondary: Color(0xFFB39DDB), // morado
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

/// SHELL CON BOTTOM NAV
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    TarotScreen(),
    HoroscopeScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
            icon: Icon(Icons.nightlight_round),
            label: 'Horóscopos',
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

/// ------------------- HOME -------------------
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Carta del día
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_cargandoCarta)
                    const Text('Cargando tu carta mística de hoy...')
                  else if (_cartaDelDia != null) ...[
                    Text(
                      _cartaDelDia!.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cartaDelDia!.significado,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ] else
                    const Text(
                      'No se pudo cargar la carta del día. Intenta de nuevo más tarde.',
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Horóscopo del día
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horóscopo del día',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_cargandoSigno)
                    const Text('Cargando tu signo preferido...')
                  else if (_signoPreferido != null) ...[
                    Text(
                      _signoPreferido!.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _signoPreferido!.resumenHoy,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ] else
                    const Text(
                      'Configura tu signo en la pestaña Perfil para ver tu horóscopo aquí.',
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Mensaje del día
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mensaje del día',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Mantén tu energía en equilibrio y confía en tu intuición.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------- TAROT -------------------
class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  TarotCard? cartaDelDia;
  List<TarotCard>? tiradaTres;

  bool cartaDelDiaRevelada = false;
  List<bool> tiradaRevelada = [];

  void _mostrarCartaDelDia() async {
    final carta = await DailyCardManager.getOrGenerateDailyCard();
    setState(() {
      cartaDelDia = carta;
      tiradaTres = null; // limpiamos tirada
      cartaDelDiaRevelada = false; // vuelve boca abajo
    });
  }

  void _tirarTresCartas() {
    final random = Random();
    final indices = <int>{};
    while (indices.length < 3) {
      indices.add(random.nextInt(cartasTarot.length));
    }
    setState(() {
      tiradaTres = indices.map((i) => cartasTarot[i]).toList();
      cartaDelDia = null; // limpiamos carta del día
      tiradaRevelada = List<bool>.filled(3, false); // todas boca abajo
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xFF130024), // morado muy oscuro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Elige una opción para tu lectura:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _mostrarCartaDelDia,
                  child: const Text('Carta del día'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _tirarTresCartas,
                  child: const Text('Tirada de 3 cartas'),
                ),
                const SizedBox(height: 24),

                if (cartaDelDia != null) ...[
                  Text(
                    'Toca la carta para revelar tu mensaje:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildFlipCard(
                    revelada: cartaDelDiaRevelada,
                    onTap: () {
                      setState(() {
                        cartaDelDiaRevelada = true;
                      });
                    },
                    backChild: _buildBackCardContent(),
                    frontChild: _buildFrontCardContent(
                      titulo: 'Carta del día',
                      nombre: cartaDelDia!.nombre,
                      significado: cartaDelDia!.significado,
                      theme: theme,
                    ),
                  ),
                ],

                if (tiradaTres != null) ...[
                  Text(
                    'Toca cada carta para revelar Pasado, Presente y Futuro:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < tiradaTres!.length; i++) ...[
                    _buildFlipCard(
                      revelada: tiradaRevelada[i],
                      onTap: () {
                        setState(() {
                          tiradaRevelada[i] = true;
                        });
                      },
                      backChild: _buildBackCardContent(
                        etiqueta: ['Pasado', 'Presente', 'Futuro'][i],
                      ),
                      frontChild: _buildFrontCardContent(
                        titulo: ['Pasado', 'Presente', 'Futuro'][i],
                        nombre: tiradaTres![i].nombre,
                        significado: tiradaTres![i].significado,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlipCard({
    required bool revelada,
    required VoidCallback onTap,
    required Widget backChild,
    required Widget frontChild,
  }) {
    return GestureDetector(
      onTap: revelada ? null : onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
        child: revelada ? frontChild : backChild,
      ),
    );
  }

  Widget _buildBackCardContent({String etiqueta = 'Carta de tarot'}) {
    return Card(
      key: const ValueKey('back'),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFFFD700),
          width: 2,
        ),
      ),
      elevation: 10,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A0B2E),
              Color(0xFF000000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD700),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                etiqueta,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Toca para revelar',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCardContent({
    required String titulo,
    required String nombre,
    required String significado,
    required ThemeData theme,
  }) {
    return Card(
      key: const ValueKey('front'),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFFFD700),
          width: 1.5,
        ),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: theme.textTheme.titleSmall?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              significado,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------- HORÓSCOPOS -------------------
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: signos.length,
        itemBuilder: (context, index) {
          final signo = signos[index];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signo.nombre,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    signo.fecha,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    signo.resumenHoy,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amor: ${signo.amor}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dinero: ${signo.dinero}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Salud: ${signo.salud}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ------------------- PERFIL / AJUSTES -------------------
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _signoSeleccionado;
  bool _notificacionesActivadas = true;
  bool _temaOscuroActivado = true; // placeholder

  @override
  void initState() {
    super.initState();
    _cargarSignoPreferido();
  }

  Future<void> _cargarSignoPreferido() async {
    final signoPref = await UserPreferences.getPreferredSign();
    setState(() {
      _signoSeleccionado =
          signoPref?.nombre ?? (signos.isNotEmpty ? signos.first.nombre : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil & Ajustes'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card: Tu signo
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu signo',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_signoSeleccionado == null)
                    const Text('Cargando signos...')
                  else
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: _signoSeleccionado,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: signos
                          .map(
                            (s) => DropdownMenuItem<String>(
                          value: s.nombre,
                          child: Text(
                            s.nombre,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (value) async {
                        if (value == null) return;
                        setState(() {
                          _signoSeleccionado = value;
                        });
                        await UserPreferences.setPreferredSign(value);
                      },
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu signo se usará para mostrarte primero tu horóscopo y carta del día.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notificaciones
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: Text(
                'Notificaciones diarias',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Recibir aviso de carta del día y horóscopo.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              value: _notificacionesActivadas,
              activeColor: const Color(0xFFFFD700),
              onChanged: (value) {
                setState(() {
                  _notificacionesActivadas = value;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Tema oscuro (placeholder)
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: Text(
                'Tema oscuro',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Por ahora siempre está activo. Más adelante podrás cambiar el estilo.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              value: _temaOscuroActivado,
              activeColor: const Color(0xFFFFD700),
              onChanged: (value) {
                setState(() {
                  _temaOscuroActivado = value;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Información
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versión 1.0.0\n\nEsta app es tu compañera mística diaria para tarot y horóscopos.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Próximamente: modo premium, historial de lecturas y más.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
