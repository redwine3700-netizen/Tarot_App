import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// MODELO DE CARTA DE TAROT
class TarotCard {
  final String nombre;
  final String significado;
  final String imagePath;

  TarotCard({
    required this.nombre,
    required this.significado,
    required this.imagePath,
  });
}

/// MAZO BÁSICO DE CARTAS (22 arcanos mayores)
final List<TarotCard> cartasTarot = [
  TarotCard(
    nombre: 'El Loco',
    significado:
    'Estás frente a un nuevo comienzo. Hay algo en tu corazón que quiere saltar, aunque la mente no tenga todo claro. Atrévete a dar un paso con confianza: la vida se encargará de mostrarte el camino mientras avanzas. El riesgo más grande sería quedarte inmóvil por miedo..',
    imagePath: 'assets/tarot/loco.png',
  ),
  TarotCard(
    nombre: 'El Mago',
    significado:
    'Tienes todas las herramientas que necesitas: talento, experiencia y una chispa de magia interna. Hoy es un día para decir “sí” a tus ideas y empezar a materializarlas, aunque sea con un pequeño gesto. Tu palabra tiene poder: úsala para crear, no para sabotearte',
    imagePath: 'assets/tarot/mago.png',
  ),
  TarotCard(
    nombre: 'La Sacerdotisa',
    significado:
    'Hay respuestas que no están afuera, sino en tu mundo interior. Esta carta te invita a bajar el ruido, observar tus sueños, tus corazonadas, esos pequeños mensajes que la vida te susurra. No te apures en tomar decisiones: primero escucha lo que tu intuición viene diciendo hace tiempo.',
    imagePath: 'assets/tarot/sacerdotisa.png',
  ),
  TarotCard(
    nombre: 'La Emperatriz',
    significado:
    'Es momento de nutrir y dejarte nutrir. La Emperatriz habla de abundancia, creatividad, amor propio y belleza en lo cotidiano. Rodéate de cosas y personas que te hagan bien. Dale espacio a tu cuerpo, a tu placer, a crear algo desde el corazón sin presión de “hacerlo perfecto”.',
    imagePath: 'assets/tarot/emperatriz.png',
  ),
  TarotCard(
    nombre: 'El Emperador',
    significado:
    'Hoy la vida te pide estructura, límites sanos y decisión. Es tiempo de ordenar, poner reglas claras o hacerte respetar. El Emperador te recuerda que puedes ser firme sin dejar de ser amoroso. Organiza, planifica y demuestra con hechos que te tomas en serio tu propio camino.',
    imagePath: 'assets/tarot/emperador.png',
  ),
  TarotCard(
    nombre: 'El Sumo Sacerdote',
    significado:
    'Tus creencias, valores y principios están en primer plano. Esta carta te invita a aprender, enseñar o buscar guía espiritual o emocional. Puede ser momento de pedir consejo a alguien sabio, o de asumir tú ese rol para otros. Lo importante es que lo que hagas esté alineado con lo que realmente crees.',
    imagePath: 'assets/tarot/sacerdote.png',
  ),
  TarotCard(
    nombre: 'Los Enamorados',
    significado:
    'No se trata solo de amor romántico, sino de elecciones desde el corazón. Hay una decisión importante frente a ti, y tu alma ya sabe la respuesta. Esta carta te recuerda que elegir desde el miedo trae confusión, y elegir desde el amor trae paz, aunque el camino sea desafiante.',
    imagePath: 'assets/tarot/enamorados.png',
  ),
  TarotCard(
    nombre: 'El Carro',
    significado:
    'Energía de avance, determinación y enfoque. El Carro te anima a tomar las riendas y dirigir tu vida con claridad. Es un buen momento para moverte, viajar, iniciar un proyecto o retomar algo que habías pausado. La clave es no dispersarte: elige un rumbo y avanza con confianza.',
    imagePath: 'assets/tarot/carro.png',
  ),
  TarotCard(
    nombre: 'La Justicia',
    significado:
    'Hoy la balanza busca equilibrio. Puede haber temas de decisiones, papeles, acuerdos o consecuencias que llegan. Esta carta te invita a ser honesto contigo mismo y con los demás. ¿Lo que estás haciendo es justo para ti? Alinear tu vida con tu verdad interior es el acto de justicia más grande.',
    imagePath: 'assets/tarot/justicia.png',
  ),
  TarotCard(
    nombre: 'El Ermitaño',
    significado:
    'Necesitas un momento a solas para reconectar contigo. El Ermitaño no habla de soledad vacía, sino de pausas sagradas. Apaga un poco el ruido, las opiniones y las distracciones. En el silencio, una luz interna se enciende y te muestra cuál es el siguiente paso, aunque sea pequeño.',
    imagePath: 'assets/tarot/ermitaño.png',
  ),
  TarotCard(
    nombre: 'La Rueda de la Fortuna',
    significado:
    'La vida se está moviendo y hay cosas que simplemente están cambiando, lo quieras o no. La Rueda te recuerda que nada es permanente: lo que sube, baja, y lo que baja, en algún momento vuelve a subir. Confía en el ciclo y pregúntate: ¿cómo puedo aprovechar esta vuelta a mi favor?',
    imagePath: 'assets/tarot/fortuna.png',
  ),
  TarotCard(
    nombre: 'La Fuerza',
    significado:
    'Tu poder no está en gritar más fuerte ni en controlar todo, sino en tu suavidad firme. La Fuerza habla de domar tus impulsos con cariño, no con castigo. Hoy puedes transformar rabia, miedo o ansiedad en coraje, paciencia y compasión hacia ti y hacia otros.',
    imagePath: 'assets/tarot/fuerza.png',
  ),
  TarotCard(
    nombre: 'El Colgado',
    significado:
    'Una pausa obligada, un “no sale como quería” o un bloqueo aparente. El Colgado te pide mirar la situación desde otro ángulo. A veces el avance real viene cuando dejamos de pelear con lo que es. Ríndete un momento, suelta la prisa y permite que la vida te muestre una perspectiva nueva..',
    imagePath: 'assets/tarot/colgado.png',
  ),
  TarotCard(
    nombre: 'La Muerte',
    significado:
    'Un ciclo está terminando, quieras o no. Esta carta no anuncia tragedia, sino transformación profunda. Algo que ya cumplió su función necesita soltarse para dar lugar a una nueva etapa. Duele despedirse, pero detrás de esta puerta cerrada hay espacio para una versión más auténtica de ti.',
    imagePath: 'assets/tarot/muerte.png',
  ),
  TarotCard(
    nombre: 'La Templanza',
    significado:
    'Hoy el mensaje es equilibrio, calma y mezcla armoniosa. Nada de extremos: ni todo blanco ni todo negro. La Templanza te invita a ir más lento, respirar, bajar la intensidad y encontrar el punto medio que te hace bien. Poco a poco, sin apuro, también es un camino poderoso.',
    imagePath: 'assets/tarot/templanza.png',
  ),
  TarotCard(
    nombre: 'El Diablo',
    significado:
    'Aparecen a la luz apegos, miedos, tentaciones o hábitos que te tienen atrapado. Esta carta no viene a asustarte, sino a mostrarte cadenas que ya están listas para romperse. ¿Dónde te estás quedando por comodidad, culpa o miedo? Reconocerlo es el primer paso para liberarte.',
    imagePath: 'assets/tarot/diablo.png',
  ),
  TarotCard(
    nombre: 'La Torre',
    significado:
    'Algo inesperado puede sacudir tus planes, creencias o estructuras. Aunque se sienta duro, la Torre derrumba lo que estaba construido sobre bases frágiles. Después del impacto, quedará solo lo verdadero. Esta carta te invita a confiar en que, tras el caos, viene un nuevo orden más honesto.',
    imagePath: 'assets/tarot/torre.png',
  ),
  TarotCard(
    nombre: 'La Estrella',
    significado:
    'Esperanza, guía y sanación. La Estrella aparece cuando necesitas un recordatorio de que no estás solo y que lo mejor aún puede llegar. Es un buen momento para soñar, manifestar y alimentar tu fe en ti y en la vida. Permítete descansar y volver a creer.',
    imagePath: 'assets/tarot/estrella.png',
  ),
  TarotCard(
    nombre: 'La Luna',
    significado:
    'El terreno está movedizo, las emociones pueden estar intensas o confusas. La Luna te habla de miedos, ilusiones y sensaciones que no logras explicar. No tomes decisiones apresuradas: observa, siente, escribe, sueña. Lo oculto se revelará con el tiempo si te das espacio para sentir.',
    imagePath: 'assets/tarot/luna.png',
  ),
  TarotCard(
    nombre: 'El Sol',
    significado:
    'Alegría, claridad y buena energía. El Sol ilumina lo que antes se veía confuso y trae una sensación de alivio. Es un excelente momento para compartir, agradecer y disfrutar lo que ya has logrado. Deja entrar la luz y permítete celebrar tus pequeñas y grandes victorias.',
    imagePath: 'assets/tarot/sol.png',
  ),
  TarotCard(
    nombre: 'El Juicio',
    significado:
    'Es una llamada de despertar. Hay algo en tu vida que pide revisión: patrones, relaciones, trabajo, hábitos. El Juicio te invita a hacer balance sin culparte, y a decidir qué parte de ti está lista para renacer. Es tiempo de perdonarte y avanzar más liviano.',
    imagePath: 'assets/tarot/juicio.png',
  ),
  TarotCard(
    nombre: 'El Mundo',
    significado:
    'Cierre de ciclo exitoso, integración y expansión. Has aprendido algo importante y ahora puedes ir a una nueva etapa con más sabiduría. El Mundo te habla de logros, viajes, conexiones y sentir que “cuadra” una pieza que antes no entendías. Agradece tu camino: no has llegado por casualidad.',
    imagePath: 'assets/tarot/mundo.png',
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

    if (savedDate == todayString &&
        savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < cartasTarot.length) {
      return cartasTarot[savedIndex];
    }

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

  const HoroscopeSign({
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
    amor: 'Una conversación pendiente puede traer claridad y cercanía.',
    dinero: 'Ideas nuevas pueden abrirte puertas. Anota todo lo que se te ocurra.',
    salud: 'Descansa tu mente desconectando un rato de pantallas.',
  ),
  HoroscopeSign(
    nombre: 'Cáncer',
    fecha: '21 de junio - 22 de julio',
    resumenHoy:
    'La emoción está más sensible hoy. Escucha lo que sientes.',
    amor:
    'Necesitas contención y cariño. Rodéate de personas que te hagan bien.',
    dinero: 'Buen día para planear a largo plazo y pensar en seguridad.',
    salud: 'Protege tu energía evitando discusiones innecesarias.',
  ),
  HoroscopeSign(
    nombre: 'Leo',
    fecha: '23 de julio - 22 de agosto',
    resumenHoy:
    'Tu brillo natural se nota. Día ideal para mostrar tus talentos.',
    amor: 'Un gesto romántico puede fortalecer mucho un vínculo.',
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
    amor: 'Buen día para acuerdos, disculpas y reconciliación.',
    dinero: 'Piensa en alianzas o trabajos en equipo. Juntos avanzan más.',
    salud: 'Rodéate de belleza: música, arte o naturaleza te harán muy bien.',
  ),
  HoroscopeSign(
    nombre: 'Escorpio',
    fecha: '23 de octubre - 21 de noviembre',
    resumenHoy:
    'Las emociones van profundas. No temas mirar adentro.',
    amor:
    'La intensidad puede unir o separar. Elige comunicar en vez de controlar.',
    dinero: 'Transformar una vieja idea puede traer nuevas oportunidades.',
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
                  if (_cargandoCarta) ...[
                    const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ] else if (_cartaDelDia != null) ...[
                    // 👉 Imagen de la carta del día
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 3 / 5,
                        child: Image.asset(
                          _cartaDelDia!.imagePath, // usa tu imagePath
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 👉 Nombre de la carta
                    Text(
                      _cartaDelDia!.nombre,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 👉 Significado corto
                    Text(
                      _cartaDelDia!.significado,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ] else ...[
                    const Text('Aún no hay carta del día disponible'),
                  ]

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
      tiradaTres = null;
      cartaDelDiaRevelada = false;
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
      cartaDelDia = null;
      tiradaRevelada = List<bool>.filled(3, false);
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
              Color(0xFF130024),
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
                      imagePath: cartaDelDia!.imagePath,
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
                        imagePath: tiradaTres![i].imagePath,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 3 / 5,
          child: Image.asset(
            'assets/tarot/reverso.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }




  Widget _buildFrontCardContent({
    required String titulo,
    required String nombre,
    required String significado,
    required String imagePath,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 3 / 5,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white38,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elige tu signo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: signos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final sign = signos[index];
                  return _HoroscopeCard(sign: sign);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoroscopeCard extends StatelessWidget {
  final HoroscopeSign sign;

  const _HoroscopeCard({required this.sign});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF160B2A),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera: nombre + fecha
                    Text(
                      sign.nombre,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.fecha,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Resumen
                    Text(
                      'Resumen de hoy',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.resumenHoy,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amor
                    Text(
                      'Amor',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.amor,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dinero
                    Text(
                      'Dinero',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.dinero,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Salud
                    Text(
                      'Salud',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.salud,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2C1B47),
              Color(0xFF12061F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFFFFD54F), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sign.nombre,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sign.fecha,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
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
  bool _temaOscuroActivado = true;

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
          // Tu signo
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
                      icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
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
