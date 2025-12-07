import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/api_models.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


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
enum YesNoResult { yes, no, maybe }

const Map<String, YesNoResult> yesNoMap = {
  'El Sol': YesNoResult.yes,
  'El Mundo': YesNoResult.yes,
  'La Estrella': YesNoResult.yes,
  'El Carro': YesNoResult.yes,
  'El Mago': YesNoResult.yes,
  'La Emperatriz': YesNoResult.yes,
  'La Fuerza': YesNoResult.yes,
  'La Templanza': YesNoResult.yes,

  'La Torre': YesNoResult.no,
  'El Diablo': YesNoResult.no,
  'La Muerte': YesNoResult.no,

  'El Colgado': YesNoResult.maybe,
  'La Rueda de la Fortuna': YesNoResult.maybe,
  'El Ermitaño': YesNoResult.maybe,
  'La Luna': YesNoResult.maybe,
  'La Justicia': YesNoResult.maybe,
  'El Juicio': YesNoResult.maybe,

  // El resto, si no está aquí, los trataremos como "Tal vez" por defecto
};

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
/// MODELO DE HORÓSCOPO DIARIO OBTENIDO DESDE API
// Modelo (déjalo como lo tienes o así):
class DailyHoroscope {
  final String description;
  final String mood;
  final String color;
  final String luckyNumber;

  DailyHoroscope({
    required this.description,
    required this.mood,
    required this.color,
    required this.luckyNumber,
  });

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) {
    return DailyHoroscope(
      description: json['description'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      color: json['color'] as String? ?? '',
      luckyNumber: json['lucky_number']?.toString() ?? '',
    );
  }
}

/// SERVICIO DE TRADUCCIÓN (inglés → español) usando Google Cloud Translate
class TranslationService {
  // 👉 AQUÍ PEGAS TU API KEY DE GOOGLE
  static const _apiKey = 'AIzaSyA7NUebUIBZi4WwwSSFaCgbSsd1MKevCj4';

  static const _url =
      'https://translation.googleapis.com/language/translate/v2';

  static Future<String> toSpanish(String text) async {
    if (text.trim().isEmpty) return text;

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'q': text,
          'source': 'en',
          'target': 'es',
          'format': 'text',
        }),
      );

      if (response.statusCode != 200) {
        // Si falla la traducción, devolvemos el texto original (en inglés)
        return text;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final translations = data['data']?['translations'] as List<dynamic>?;

      if (translations == null || translations.isEmpty) {
        return text;
      }

      final translatedText =
          translations.first['translatedText']?.toString() ?? text;

      return translatedText;
    } catch (_) {
      // Si hay cualquier error de red, devolvemos el original
      return text;
    }
  }
}


class HoroscopeApiService {
  // Nueva API más estable
  static const _baseUrl =
      'https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily';

  static String _mapSpanishToEnglishSign(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'aries':
        return 'aries';
      case 'tauro':
        return 'taurus';
      case 'géminis':
      case 'geminis':
        return 'gemini';
      case 'cáncer':
      case 'cancer':
        return 'cancer';
      case 'leo':
        return 'leo';
      case 'virgo':
        return 'virgo';
      case 'libra':
        return 'libra';
      case 'escorpio':
        return 'scorpio';
      case 'sagitario':
        return 'sagittarius';
      case 'capricornio':
        return 'capricorn';
      case 'acuario':
        return 'aquarius';
      case 'piscis':
        return 'pisces';
      default:
        return 'aries';
    }
  }

  static Future<DailyHoroscope> fetchTodayForSign(String nombreSigno) async {
    final signEn = _mapSpanishToEnglishSign(nombreSigno);

    // Usamos la nueva API
    final uri = Uri.parse('$_baseUrl?sign=$signEn&day=today');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
          'Error ${response.statusCode} al obtener horóscopo para "$nombreSigno" (enviado "$signEn")');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = (body['data'] ?? {}) as Map<String, dynamic>;

    final englishDescription = data['horoscope_data']?.toString() ?? '';

    // 👇 Aquí traducimos a español usando la clase TranslationService
    final spanishDescription =
    await TranslationService.toSpanish(englishDescription);

    return DailyHoroscope(
      description: spanishDescription,
      mood: data['mood']?.toString() ?? '—',
      color: data['color']?.toString() ?? '—',
      luckyNumber: (data['lucky_number'] ?? '—').toString(),
    );
  }
}


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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
                      style: theme.textTheme.bodyMedium,
                    ),
                  ] else ...[
                    const Text('Aún no hay carta del día disponible'),
                  ],
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
                  if (_cargandoSigno || _cargandoHoroscopo)
                    const Text('Cargando tu horóscopo de hoy...')
                  else if (_signoPreferido != null &&
                      _horoscopoHoy != null) ...[
                    Text(
                      _signoPreferido!.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _horoscopoHoy!.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ánimo de hoy: ${_horoscopoHoy!.mood}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Color de la suerte: ${_horoscopoHoy!.color}  •  Número: ${_horoscopoHoy!.luckyNumber}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ] else if (_errorHoroscopo != null) ...[
                    Text(
                      _errorHoroscopo!,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.redAccent),
                    ),
                  ] else ...[
                    const Text(
                      'Configura tu signo en la pestaña Perfil para ver tu horóscopo aquí.',
                    ),
                  ],
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
  // Carta del día
  TarotCard? cartaDelDia;
  bool cartaDelDiaRevelada = false;

  // Tirada de 3 cartas
  List<TarotCard>? tiradaTres;
  List<bool> tiradaRevelada = [];
  TarotReadingResponse? _lecturaTresCartas;

  // Pregunta SÍ / NO
  TarotCard? _cartaSiNo;
  String? _resultadoSiNo;
  String? _mensajeSiNo;

  // Tirada de letras A/B/C
  List<TarotCard>? _tiradaLetras;
  int? _indiceLetraElegida;

  // Juego de fichas (20 letras, elige 6)
  static const int _totalFichas = 20;
  static const int _maxFichasSeleccionadas = 6;
  List<String> _fichasLetras = [];
  List<bool> _fichasReveladas = [];
  int _contadorFichasSeleccionadas = 0;
  bool _juegoFichasIniciado = false;

  // ----------------- LÓGICA CARTA DEL DÍA -----------------

  void _mostrarCartaDelDia() async {
    final carta = await DailyCardManager.getOrGenerateDailyCard();
    setState(() {
      cartaDelDia = carta;
      cartaDelDiaRevelada = false;

      tiradaTres = null;
      tiradaRevelada = [];
      _lecturaTresCartas = null;

      _tiradaLetras = null;
      _indiceLetraElegida = null;

      _cartaSiNo = null;
      _resultadoSiNo = null;
      _mensajeSiNo = null;

      _juegoFichasIniciado = false;
      _fichasLetras = [];
      _fichasReveladas = [];
      _contadorFichasSeleccionadas = 0;
    });
  }

  // ----------------- LÓGICA TIRADA 3 CARTAS -----------------

  void _tirarTresCartas() {
    final cartasBarajadas = [...cartasTarot]..shuffle();
    final seleccionadas = cartasBarajadas.take(3).toList();
    setState(() {
      tiradaTres = seleccionadas;
      tiradaRevelada = [false, false, false];

      _lecturaTresCartas = _generarLecturaTresCartasLocal(
        seleccionadas[0],
        seleccionadas[1],
        seleccionadas[2],
      );

      cartaDelDia = null;
      cartaDelDiaRevelada = false;

      _tiradaLetras = null;
      _indiceLetraElegida = null;

      _cartaSiNo = null;
      _resultadoSiNo = null;
      _mensajeSiNo = null;

      _juegoFichasIniciado = false;
      _fichasLetras = [];
      _fichasReveladas = [];
      _contadorFichasSeleccionadas = 0;
    });
  }

  void _prepararTiradaLetras() {
    final cartasBarajadas = [...cartasTarot]..shuffle();
    setState(() {
      _tiradaLetras = cartasBarajadas.take(3).toList();
      _indiceLetraElegida = null;

      cartaDelDia = null;
      cartaDelDiaRevelada = false;

      tiradaTres = null;
      tiradaRevelada = [];
      _lecturaTresCartas = null;

      _cartaSiNo = null;
      _resultadoSiNo = null;
      _mensajeSiNo = null;

      _juegoFichasIniciado = false;
      _fichasLetras = [];
      _fichasReveladas = [];
      _contadorFichasSeleccionadas = 0;
    });
  }

  TarotReadingResponse _generarLecturaTresCartasLocal(
      TarotCard pasada,
      TarotCard presente,
      TarotCard futura,
      ) {
    final titulo =
        'Una historia entre ${pasada.nombre}, ${presente.nombre} y ${futura.nombre}';

    final resumen =
        'Tu lectura muestra un proceso que va desde la energía de ${pasada.nombre.toLowerCase()} '
        'hasta la influencia de ${futura.nombre.toLowerCase()}, con ${presente.nombre.toLowerCase()} marcando tu presente. '
        'Las cartas hablan de un camino que se está moviendo y de decisiones que te acercan a una versión más auténtica de ti.';

    final textoPasado =
        'En tu PASADO, ${pasada.nombre} sugiere: ${pasada.significado}';

    final textoPresente =
        'En tu PRESENTE, ${presente.nombre} señala: ${presente.significado}';

    final textoFuturo =
        'De cara al FUTURO, ${futura.nombre} te invita a: ${futura.significado}';

    final consejo =
        'En conjunto, estas tres cartas te recuerdan que cada etapa ha tenido un sentido. '
        'Honra lo que ya viviste, observa con honestidad lo que estás decidiendo hoy '
        'y permite que el futuro te sorprenda sin aferrarte a lo que ya no encaja con tu alma.';

    return TarotReadingResponse(
      title: titulo,
      summary: resumen,
      past: textoPasado,
      present: textoPresente,
      future: textoFuturo,
      advice: consejo,
    );
  }

  // ----------------- LÓGICA SÍ / NO -----------------

  void _hacerPreguntaSiNo() {
    final cartasBarajadas = [...cartasTarot]..shuffle();
    final carta = cartasBarajadas.first;

    final tipo = yesNoMap[carta.nombre] ?? YesNoResult.maybe;

    String resultado;
    String mensaje;

    switch (tipo) {
      case YesNoResult.yes:
        resultado = 'Sí';
        mensaje =
        'La energía de ${carta.nombre} se inclina claramente hacia un SÍ. '
            'Esta carta habla de avance, apertura y puertas que se abren. '
            'Si tu corazón siente entusiasmo y coherencia, este es un buen momento para confiar.';
        break;
      case YesNoResult.no:
        resultado = 'No';
        mensaje =
        '${carta.nombre} señala que, por ahora, la respuesta se inclina hacia un NO. '
            'Puede que no sea el momento, que falte información o que algo no esté alineado contigo. '
            'Tómate un tiempo para revisar tus motivos y proteger tu energía.';
        break;
      case YesNoResult.maybe:
        resultado = 'Tal vez / Aún no';
        mensaje =
        'Con ${carta.nombre}, la respuesta no es un sí o un no absoluto. '
            'Esta carta habla de procesos, cambios y tiempos que aún se están acomodando. '
            'La vida te invita a observar más, esperar señales y no forzar la situación todavía.';
        break;
    }

    setState(() {
      _cartaSiNo = carta;
      _resultadoSiNo = resultado;
      _mensajeSiNo = mensaje;
    });
  }

  // ----------------- LÓGICA JUEGO FICHAS -----------------

  void _iniciarJuegoFichas() {
    const letras = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
    final random = Random();

    final List<String> nuevas = [];
    for (int i = 0; i < _totalFichas; i++) {
      nuevas.add(letras[random.nextInt(letras.length)]);
    }

    setState(() {
      _fichasLetras = nuevas;
      _fichasReveladas = List<bool>.filled(_totalFichas, false);
      _contadorFichasSeleccionadas = 0;
      _juegoFichasIniciado = true;
    });
  }

  void _onTapFicha(int index) {
    if (!_juegoFichasIniciado) return;
    if (_fichasReveladas[index]) return;
    if (_contadorFichasSeleccionadas >= _maxFichasSeleccionadas) return;

    setState(() {
      _fichasReveladas[index] = true;
      _contadorFichasSeleccionadas++;
    });
  }

  // ----------------- DETALLE EN MODAL -----------------

  void _mostrarCartaDetalle(
      BuildContext context,
      TarotCard carta,
      String contextoTitulo,
      ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF12051F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Text(
                    contextoTitulo,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    carta.nombre,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 3 / 5,
                        child: Image.asset(
                          carta.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    carta.significado,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ----------------- BUILD -----------------

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
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _prepararTiradaLetras,
                  child: const Text('Tirada de letras (A, B, C)'),
                ),


                const SizedBox(height: 24),

                // -------- Carta del día --------
                if (cartaDelDia != null) ...[
                  Text(
                    'Toca la carta para revelar tu mensaje:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 230,
                    child: _buildFlipCard(
                      revelada: cartaDelDiaRevelada,
                      onTapReveal: () {
                        setState(() {
                          cartaDelDiaRevelada = true;
                        });
                      },
                      onTapWhenRevealed: () {
                        if (cartaDelDia != null) {
                          _mostrarCartaDetalle(
                            context,
                            cartaDelDia!,
                            'Carta del día',
                          );
                        }
                      },
                      backChild: _buildBackCardContent(),
                      frontChild: _buildFrontCardThumbnail(
                        cartaDelDia!.imagePath,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: _mostrarCartaDelDia,
                  child: const Text('Carta del día'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _tirarTresCartas,
                  child: const Text('Tirada de 3 cartas'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _prepararTiradaLetras,
                  child: const Text('Tirada de letras (A, B, C)'),
                ),
                const SizedBox(height: 8),

// 👉 NUEVO BOTÓN PÉNDULO
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PendulumScreen(),
                      ),
                    );
                  },
                  child: const Text('Péndulo (Sí / No)'),
                ),


                // -------- Tirada 3 cartas --------
                if (tiradaTres != null) ...[
                  Text(
                    'Toca cada carta para revelar Pasado, Presente y Futuro:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 210,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < tiradaTres!.length; i++) ...[
                          Expanded(
                            child: _buildFlipCard(
                              revelada: tiradaRevelada[i],
                              onTapReveal: () {
                                setState(() {
                                  tiradaRevelada[i] = true;
                                });
                              },
                              onTapWhenRevealed: () {
                                final tituloPosicion =
                                ['Pasado', 'Presente', 'Futuro'][i];
                                _mostrarCartaDetalle(
                                  context,
                                  tiradaTres![i],
                                  tituloPosicion,
                                );
                              },
                              backChild: _buildBackCardContent(
                                etiqueta: ['Pasado', 'Presente', 'Futuro'][i],
                              ),
                              frontChild: _buildFrontCardThumbnail(
                                tiradaTres![i].imagePath,
                              ),
                            ),
                          ),
                          if (i < tiradaTres!.length - 1)
                            const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_lecturaTresCartas != null) ...[
                    Text(
                      'Lectura general',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLecturaTresCartasCard(theme),
                  ],
                  const SizedBox(height: 24),
                ],

                // -------- Tirada letras A/B/C --------
                if (_tiradaLetras != null) ...[
                  Text(
                    'Tirada de letras (A, B, C)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Piensa en una situación o tema y elige la letra que más te llame: '
                        'A, B o C. Esa será tu carta y tu mensaje.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLetraOption(
                          letra: 'A',
                          index: 0,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildLetraOption(
                          letra: 'B',
                          index: 1,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildLetraOption(
                          letra: 'C',
                          index: 2,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  if (_indiceLetraElegida != null) ...[
                    const SizedBox(height: 16),
                    _buildResultadoLetra(theme),
                  ],
                  const SizedBox(height: 24),
                ],

                // -------- Juego fichas --------
                _buildJuegoFichasSection(theme),

                // -------- Pregunta SÍ / NO --------
                const SizedBox(height: 8),
                Text(
                  'Pregunta de SÍ / NO',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Piensa en una pregunta que pueda responderse con sí o no. '
                      'Respira profundo, concéntrate un momento y cuando te sientas listo, toca el botón.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _hacerPreguntaSiNo,
                    child: const Text('Revelar respuesta'),
                  ),
                ),
                const SizedBox(height: 16),
                if (_cartaSiNo != null) ...[
                  _buildResultadoSiNo(theme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------- WIDGETS DE APOYO -----------------

  Widget _buildLetraOption({
    required String letra,
    required int index,
    required ThemeData theme,
  }) {
    final seleccionada = _indiceLetraElegida == index;
    final estaCarta = _tiradaLetras![index];

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _indiceLetraElegida = index;
        });
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2C1B47),
              Color(0xFF160B2A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: seleccionada
                ? const Color(0xFFFFD700)
                : Colors.white24,
            width: seleccionada ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              letra,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              estaCarta.nombre,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultadoLetra(ThemeData theme) {
    final indice = _indiceLetraElegida!;
    final carta = _tiradaLetras![indice];
    final letra = ['A', 'B', 'C'][indice];

    return Card(
      color: const Color(0xFF160B2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFFFD700),
          width: 1,
        ),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mensaje para la letra $letra',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 3 / 5,
                  child: Image.asset(
                    carta.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                carta.nombre,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              carta.significado,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJuegoFichasSection(ThemeData theme) {
    const dorado = Color(0xFFFFD700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Juego de letras: elige 6 fichas',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Toca hasta 6 fichas para revelar letras. Después, deja que tu intuición juegue: '
              '¿qué nombres o palabras te vienen a la mente?',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _iniciarJuegoFichas,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: dorado,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: dorado),
              ),
            ),
            child: Text(
              _juegoFichasIniciado ? 'Volver a jugar' : 'Iniciar juego',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_juegoFichasIniciado) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_fichasLetras.length, (index) {
              final revelada = _fichasReveladas[index];

              return GestureDetector(
                onTap: () => _onTapFicha(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: revelada ? dorado : dorado.withOpacity(0.6),
                      width: 2,
                    ),
                    boxShadow: revelada
                        ? [
                      BoxShadow(
                        color: dorado.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: revelada
                      ? Text(
                    _fichasLetras[index],
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: dorado,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : const Icon(
                    Icons.star_border,
                    color: dorado,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Fichas reveladas: $_contadorFichasSeleccionadas / $_maxFichasSeleccionadas',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No necesitas formar una palabra perfecta. Deja que las letras despierten recuerdos, nombres o ideas.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white60,
              height: 1.3,
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResultadoSiNo(ThemeData theme) {
    final carta = _cartaSiNo!;
    final resultado = _resultadoSiNo ?? '';
    final mensaje = _mensajeSiNo ?? '';

    Color colorResultado;
    if (resultado.startsWith('Sí')) {
      colorResultado = const Color(0xFF4CAF50); // verde
    } else if (resultado.startsWith('No')) {
      colorResultado = const Color(0xFFF44336); // rojo
    } else {
      colorResultado = const Color(0xFFFFD700); // dorado
    }

    return Card(
      color: const Color(0xFF160B2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFFFD700),
          width: 1,
        ),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 3 / 5,
                  child: Image.asset(
                    carta.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Respuesta: $resultado',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorResultado,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                carta.nombre,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipCard({
    required bool revelada,
    required VoidCallback onTapReveal,
    VoidCallback? onTapWhenRevealed,
    required Widget backChild,
    required Widget frontChild,
  }) {
    return GestureDetector(
      onTap: () {
        if (!revelada) {
          onTapReveal();
        } else {
          if (onTapWhenRevealed != null) {
            onTapWhenRevealed!();
          }
        }
      },
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
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/tarot/reverso.png',
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Text(
                  etiqueta,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCardThumbnail(String imagePath) {
    return Card(
      key: const ValueKey('frontThumb'),
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
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLecturaTresCartasCard(ThemeData theme) {
    final lectura = _lecturaTresCartas!;
    return Card(
      color: const Color(0xFF160B2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFFFD700),
          width: 1,
        ),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lectura.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lectura.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _buildLecturaSection('Pasado', lectura.past, theme),
            const SizedBox(height: 12),
            _buildLecturaSection('Presente', lectura.present, theme),
            const SizedBox(height: 12),
            _buildLecturaSection('Futuro', lectura.future, theme),
            const SizedBox(height: 16),
            Text(
              'Consejo',
              style: theme.textTheme.titleSmall?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lectura.advice,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturaSection(
      String titulo,
      String texto,
      ThemeData theme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: theme.textTheme.titleSmall?.copyWith(
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          texto,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ],
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
  backgroundColor: Colors.black,
  body: ListView.builder(
  itemCount: signos.length,
  itemBuilder: (context, index) {
  final signo = signos[index];
  return ListTile(
  leading: const Icon(Icons.nightlight_round, color: Color(0xFFFFD700)),
  title: Text(
  signo.nombre,
  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
  ),
  subtitle: Text(
  signo.fecha,
  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
  ),
  trailing: const Icon(Icons.chevron_right, color: Colors.white70),
  onTap: () {
  Navigator.of(context).push(
  MaterialPageRoute(
  builder: (_) => HoroscopeDetailScreen(signo: signo),
  ),
  );
  },
  );
  },
  ),
  );
  }
  }
class HoroscopeDetailScreen extends StatelessWidget {
  final HoroscopeSign signo;

  const HoroscopeDetailScreen({super.key, required this.signo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(signo.nombre),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<DailyHoroscope>(
        future: HoroscopeApiService.fetchTodayForSign(signo.nombre),
        builder: (context, snapshot) {
          // ⏳ Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Si la API responde bien, usamos esos datos
          if (snapshot.hasData) {
            final h = snapshot.data!;
            return _buildContent(
              theme,
              titulo: signo.nombre,
              rangoFechas: signo.fecha,
              descripcion: h.description,
              mood: h.mood,
              color: h.color,
              numero: h.luckyNumber,
              avisoLocal: null,
            );
          }

          // ❌ Si hay error o no hay datos → usamos TU texto local
          return _buildContent(
            theme,
            titulo: signo.nombre,
            rangoFechas: signo.fecha,
            descripcion: signo.resumenHoy,
            mood: '—',
            color: '—',
            numero: '—',
            avisoLocal:
            'Mostrando texto guardado porque el servicio en línea no está disponible.',
          );
        },
      ),
    );
  }

  Widget _buildContent(
      ThemeData theme, {
        required String titulo,
        required String rangoFechas,
        required String descripcion,
        required String mood,
        required String color,
        required String numero,
        String? avisoLocal,
      }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              rangoFechas,
              style:
              theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              descripcion,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(height: 1.4, color: Colors.white),
            ),
            const SizedBox(height: 16),
            if (avisoLocal != null) ...[
              Text(
                avisoLocal,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.amberAccent),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Ánimo: $mood',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            Text(
              'Color de la suerte: $color',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            Text(
              'Número de la suerte: $numero',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
          ],
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

enum PendulumPattern {
  none,
  yesVertical,   // SÍ → arriba / abajo
  noHorizontal,  // NO → izquierda / derecha
  maybeCircle,   // TAL VEZ → movimiento circular / elíptico
}

/// ------------------- PÉNDULO VISTA SUPERIOR -------------------
class PendulumScreen extends StatefulWidget {
  const PendulumScreen({super.key});

  @override
  State<PendulumScreen> createState() => _PendulumScreenState();
}

class _PendulumScreenState extends State<PendulumScreen>
    with SingleTickerProviderStateMixin {
  String? _pregunta;
  String? _resultado;
  String? _mensaje;

  // Movimiento base (acelerómetro + órbita)
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _targetX = 0.0;
  double _targetY = 0.0;

  double _speed = 0.0;
  double _lastX = 0.0, _lastY = 0.0;

  double _orbitAngle = 0.0;

  // Impulso extra cuando consultamos el péndulo
  double _tapBoost = 0.0;

  // Patrón según la respuesta
  PendulumPattern _pattern = PendulumPattern.none;
  double _patternPhase = 0.0;

  // Pasos del ritual (texto de ayuda)
  int _paso = 1;

  late AnimationController _pulseController;
  StreamSubscription<AccelerometerEvent>? _accelSub;

  @override
  void initState() {
    super.initState();

    // Pulso suave (respiración del péndulo)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Escuchar acelerómetro
    _accelSub = accelerometerEvents.listen((event) {
      const factor = 3.5;

      final x = (event.x * factor).clamp(-60.0, 60.0);
      final y = (event.y * factor).clamp(-60.0, 60.0);

      setState(() {
        _targetX = x;
        _targetY = y;
      });
    });

    // Inercia + velocidad + órbita + fase de patrón + decaimiento del impulso
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        const suavizado = 0.08;

        final oldX = _offsetX;
        final oldY = _offsetY;

        // Inercia hacia el objetivo
        _offsetX += (_targetX - _offsetX) * suavizado;
        _offsetY += (_targetY - _offsetY) * suavizado;

        final vx = _offsetX - oldX;
        final vy = _offsetY - oldY;
        final instante = sqrt(vx * vx + vy * vy);

        _speed = _speed * 0.85 + instante * 0.15;

        // Órbita base
        _orbitAngle += 0.03;
        if (_orbitAngle > 2 * pi) {
          _orbitAngle -= 2 * pi;
        }

        // Fase del patrón (SÍ / NO / TAL VEZ)
        if (_pattern != PendulumPattern.none) {
          _patternPhase += 0.08;
          if (_patternPhase > 2 * pi) {
            _patternPhase -= 2 * pi;
          }
        }

        _lastX = _offsetX;
        _lastY = _offsetY;

        // El impulso extra se va apagando (controla cuánto rato “trabaja”)
        if (_tapBoost > 0.0) {
          _tapBoost *= 0.99; // más cerca de 1.0 = dura más tiempo
          if (_tapBoost < 0.01) {
            _tapBoost = 0.0;
            _pattern = PendulumPattern.none;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _avanzarPaso() {
    setState(() {
      if (_paso < 3) {
        _paso++;
      } else {
        _paso = 1;
      }
    });
  }

  Widget _buildGuiaPasos(ThemeData theme) {
    String titulo;
    String descripcion;
    String textoBoton;

    switch (_paso) {
      case 1:
        titulo = '1 • Formula tu pregunta';
        descripcion =
        'Piensa en una pregunta clara que pueda responderse con SÍ o NO. '
            'Evita preguntas demasiado abiertas o con muchas condiciones. '
            'Respira profundo y conecta con lo que de verdad quieres saber.';
        textoBoton = 'Ya tengo mi pregunta';
        break;
      case 2:
        titulo = '2 • Equilibra el péndulo';
        descripcion =
        'Apoya el celular sobre una superficie lo más plana posible. '
            'Espera unos segundos mientras el movimiento se calma. '
            'Cuando sientas que todo está estable, pasa al siguiente paso.';
        textoBoton = 'Péndulo equilibrado';
        break;
      case 3:
      default:
        titulo = '3 • Observa la respuesta';
        descripcion =
        'Mantén tu pregunta en mente y observa el movimiento desde la vista superior:\n\n'
            '• Más vertical (arriba / abajo) → energía hacia un SÍ.\n'
            '• Más horizontal (izquierda / derecha) → energía hacia un NO.\n'
            '• Más circular o elíptico → TAL VEZ / AÚN NO.\n\n'
            'Tómalo como una guía energética, no como una sentencia absoluta.';
        textoBoton = 'Volver a empezar';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          descripcion,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            onPressed: _avanzarPaso,
            child: Text(textoBoton),
          ),
        ),
      ],
    );
  }

  void _consultarPendulo() {
    final random = Random();
    final valor = random.nextInt(3); // 0,1,2

    String resultado;
    String mensaje;
    PendulumPattern patron;

    if (valor == 0) {
      resultado = 'Sí';
      mensaje =
      'La energía del péndulo se alinea hacia un SÍ. Observa un movimiento más vertical, como respirando de arriba hacia abajo.';
      patron = PendulumPattern.yesVertical;
    } else if (valor == 1) {
      resultado = 'No';
      mensaje =
      'El movimiento se inclina hacia el NO. El vaivén horizontal indica que la energía se desvía de ese camino.';
      patron = PendulumPattern.noHorizontal;
    } else {
      resultado = 'Tal vez / Aún no';
      mensaje =
      'La energía todavía no se define por completo. El movimiento circular o elíptico muestra que hay variables en juego.';
      patron = PendulumPattern.maybeCircle;
    }

    // 1) Al tocar el botón: limpiamos respuesta visible y disparamos movimiento
    setState(() {
      _resultado = null;
      _mensaje = null;

      _tapBoost = 1.0;        // mucho movimiento al comienzo
      _pattern = patron;      // patrón según la respuesta
      _patternPhase = 0.0;
    });

    // 2) Después de unos segundos, mostramos la respuesta (cuando ya casi se ha calmado)
    Timer(const Duration(seconds: 6), () {
      if (!mounted) return;

      setState(() {
        _resultado = resultado;
        _mensaje = mensaje;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Péndulo'),
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
              children: [
                _buildGuiaPasos(theme),

                const SizedBox(height: 24),

                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFFFD700),
                  decoration: InputDecoration(
                    labelText: 'Escribe tu pregunta (opcional)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF1A0C2D),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white38,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFD700),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _pregunta = value;
                  },
                ),

                const SizedBox(height: 24),

                // --------- VISTA SUPERIOR DEL PÉNDULO ---------
                SizedBox(
                  height: 260,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      // Pulso (respiración)
                      final t = _pulseController.value;
                      final double baseScale =
                          1.0 + sin(t * 2 * pi) * 0.04;
                      final double scaleBoost =
                          1.0 + _tapBoost * 0.18;
                      final double scale =
                          baseScale * scaleBoost;

                      // ¿Celular quieto?
                      final bool isStill = _speed < 1.0;
                      final double idleFactor =
                      isStill ? 1.0 : 0.25;

                      // Órbita base
                      final double idleRadiusBase =
                          10.0 + _tapBoost * 40.0;
                      final double orbitX =
                          cos(_orbitAngle) *
                              idleRadiusBase *
                              idleFactor;
                      final double orbitY =
                          sin(_orbitAngle) *
                              idleRadiusBase *
                              0.7 *
                              idleFactor;

                      // Posición base por acelerómetro
                      const double basePenduloY = 20.0;
                      final double baseX = _offsetX;
                      final double baseY =
                          _offsetY + basePenduloY;

                      // Patrón extra de respuesta (SÍ / NO / TAL VEZ)
                      double patternX = 0.0;
                      double patternY = 0.0;
                      const double patternAmplitude = 32.0;

                      if (_tapBoost > 0.0 &&
                          _pattern != PendulumPattern.none) {
                        final double a = _patternPhase;

                        switch (_pattern) {
                          case PendulumPattern.yesVertical:
                            patternY = sin(a) *
                                patternAmplitude *
                                _tapBoost;
                            break;
                          case PendulumPattern.noHorizontal:
                            patternX = sin(a) *
                                patternAmplitude *
                                _tapBoost;
                            break;
                          case PendulumPattern.maybeCircle:
                            patternX = cos(a) *
                                patternAmplitude *
                                _tapBoost;
                            patternY = sin(a) *
                                patternAmplitude *
                                0.7 *
                                _tapBoost;
                            break;
                          case PendulumPattern.none:
                            break;
                        }
                      }

                      // Posición final
                      final double tipX =
                          baseX + orbitX + patternX;
                      final double tipY =
                          baseY + orbitY + patternY;

                      // Cadena de perlitas hacia “adelante”
                      const int segmentos = 5;
                      const double chainLength = 70.0;

                      final double anchorX = tipX;
                      final double anchorY =
                          tipY + 10.0;

                      final List<Widget> chain = [];
                      for (int i = 1; i <= segmentos; i++) {
                        final double factor =
                            i / (segmentos + 1);

                        final double dx = anchorX;
                        final double dy =
                            anchorY + factor * chainLength;

                        final double esferaScale =
                            0.7 + factor * 0.4;
                        final double esferaSize =
                            18.0 * esferaScale;

                        final bool esVioleta = i.isOdd;
                        final String assetEsfera = esVioleta
                            ? 'assets/tarot/pendulo_chain_violeta.png'
                            : 'assets/tarot/pendulo_chain_rosa.png';

                        chain.add(
                          Transform.translate(
                            offset: Offset(dx, dy),
                            child: Image.asset(
                              assetEsfera,
                              width: esferaSize,
                              height: esferaSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/tarot/pendulo_top_bg.png',
                            fit: BoxFit.contain,
                          ),
                          Transform.translate(
                            offset: Offset(tipX, tipY),
                            child: Transform.scale(
                              scale: scale,
                              child: Image.asset(
                                'assets/tarot/pendulo_top_cristal.png',
                                width: 110,
                                height: 110,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          ...chain,
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _consultarPendulo,
                  child: const Text(
                    'Consultar péndulo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 24),

                if (_resultado != null) ...[
                  Text(
                    'Respuesta: $_resultado',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_pregunta != null &&
                      _pregunta!.trim().isNotEmpty) ...[
                    Text(
                      'Pregunta: "${_pregunta!}"',
                      textAlign: TextAlign.center,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    _mensaje ?? '',
                    textAlign: TextAlign.center,
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
