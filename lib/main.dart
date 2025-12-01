import 'dart:math';
import 'package:flutter/material.dart';

/// MODELO DE CARTA DE TAROT
class TarotCard {
  final String nombre;
  final String significado;

  TarotCard({
    required this.nombre,
    required this.significado,
  });
}

/// MAZO BÁSICO DE CARTAS (puedes agregar más)
final List<TarotCard> cartasTarot = [
  TarotCard(
    nombre: 'El Loco',
    significado: 'Nuevos comienzos, salto de fe y aventura. Confía en el viaje y déjate llevar.',
  ),
  TarotCard(
    nombre: 'El Mago',
    significado: 'Poder personal, acción e iniciativa. Tienes todo para manifestar tus deseos.',
  ),
  TarotCard(
    nombre: 'La Sacerdotisa',
    significado: 'Intuición, misterio y sabiduría interior. Escucha tu voz interna.',
  ),
  TarotCard(
    nombre: 'La Emperatriz',
    significado: 'Abundancia, amor, creatividad y energía maternal. Momento de florecimiento.',
  ),
  TarotCard(
    nombre: 'El Emperador',
    significado: 'Orden, estructura, autoridad y seguridad. Toma el control con firmeza.',
  ),
  TarotCard(
    nombre: 'El Sumo Sacerdote',
    significado: 'Guía espiritual, tradición y aprendizaje. Busca consejo y estabilidad.',
  ),
  TarotCard(
    nombre: 'Los Enamorados',
    significado: 'Amor, decisiones importantes y conexión profunda. Elige con el corazón.',
  ),
  TarotCard(
    nombre: 'El Carro',
    significado: 'Determinación, victoria y avance. Vas en la dirección correcta.',
  ),
  TarotCard(
    nombre: 'La Justicia',
    significado: 'Verdad, equilibrio y decisiones justas. Actúa con responsabilidad.',
  ),
  TarotCard(
    nombre: 'El Ermitaño',
    significado: 'Introspección, soledad elegida y búsqueda de respuestas. Mira hacia dentro.',
  ),
  TarotCard(
    nombre: 'La Rueda de la Fortuna',
    significado: 'Cambios, destino y ciclos. Algo grande está por moverse a tu favor.',
  ),
  TarotCard(
    nombre: 'La Fuerza',
    significado: 'Valentía, control emocional y compasión. Tu fuerza está en tu calma.',
  ),
  TarotCard(
    nombre: 'El Colgado',
    significado: 'Pausa, reflexión y nuevos puntos de vista. Deja ir lo que ya no sirve.',
  ),
  TarotCard(
    nombre: 'La Muerte',
    significado: 'Transformación profunda, cierres necesarios y renacimiento. Algo nuevo comienza.',
  ),
  TarotCard(
    nombre: 'La Templanza',
    significado: 'Paciencia, armonía y equilibrio. Avanza con calma y claridad.',
  ),
  TarotCard(
    nombre: 'El Diablo',
    significado: 'Tentaciones, ataduras y deseos intensos. Reconoce lo que te limita.',
  ),
  TarotCard(
    nombre: 'La Torre',
    significado: 'Cambios inesperados, revelaciones y liberación. Se cae lo que ya no sirve.',
  ),
  TarotCard(
    nombre: 'La Estrella',
    significado: 'Esperanza, guía divina, paz y sanación. Se acerca lo que anhelas.',
  ),
  TarotCard(
    nombre: 'La Luna',
    significado: 'Intuición, emociones ocultas y sueños. No todo es lo que parece.',
  ),
  TarotCard(
    nombre: 'El Sol',
    significado: 'Éxito, alegría, claridad y bendiciones. Buenas noticias llegan a tu vida.',
  ),
  TarotCard(
    nombre: 'El Juicio',
    significado: 'Renovación, cambio de conciencia y despertar interior. Segunda oportunidad.',
  ),
  TarotCard(
    nombre: 'El Mundo',
    significado: 'Cierre de ciclos, logros y realización. Estás alcanzando una meta importante.',
  ),
];

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

final List<HoroscopeSign> signos = [
  HoroscopeSign(
    nombre: 'Aries',
    fecha: '21 de marzo - 19 de abril',
    resumenHoy: 'Energía alta y ganas de avanzar. Buen día para tomar decisiones rápidas.',
    amor: 'Sé directo, pero cuida tus palabras. Una conversación sincera puede aclarar mucho.',
    dinero: 'Momento ideal para organizar gastos y enfocarte en una meta concreta.',
    salud: 'Canaliza tu energía en movimiento físico para evitar tensiones.',
  ),
  HoroscopeSign(
    nombre: 'Tauro',
    fecha: '20 de abril - 20 de mayo',
    resumenHoy: 'Necesitas estabilidad y calma. Busca espacios tranquilos.',
    amor: 'Valora los pequeños gestos. Una muestra de cariño sincero te hará sentir en casa.',
    dinero: 'No te apresures a gastar. Es un buen día para ahorrar o revisar cuentas.',
    salud: 'Cuida tu alimentación y evita excesos. Tu cuerpo agradecerá la estabilidad.',
  ),
  HoroscopeSign(
    nombre: 'Géminis',
    fecha: '21 de mayo - 20 de junio',
    resumenHoy: 'Tu mente está muy activa. Buen día para comunicar y aprender.',
    amor: 'Una conversación pendiente puede traer claridad y cercanía.',
    dinero: 'Ideas nuevas pueden abrirte puertas. Anota todo lo que se te ocurra.',
    salud: 'Descansa tu mente desconectando un rato de pantallas.',
  ),
  HoroscopeSign(
    nombre: 'Cáncer',
    fecha: '21 de junio - 22 de julio',
    resumenHoy: 'La emoción está más sensible hoy. Escucha lo que sientes.',
    amor: 'Necesitas contención y cariño. Rodéate de personas que te hagan bien.',
    dinero: 'Buen día para planear a largo plazo y pensar en seguridad.',
    salud: 'Protege tu energía evitando discusiones innecesarias.',
  ),
  HoroscopeSign(
    nombre: 'Leo',
    fecha: '23 de julio - 22 de agosto',
    resumenHoy: 'Tu brillo natural se nota. Día ideal para mostrar tus talentos.',
    amor: 'Un gesto romántico puede fortalecer mucho un vínculo.',
    dinero: 'Confía en tu liderazgo, pero evita el orgullo en decisiones financieras.',
    salud: 'Muévete, baila o haz algo que te haga sentir vital y seguro.',
  ),
  HoroscopeSign(
    nombre: 'Virgo',
    fecha: '23 de agosto - 22 de septiembre',
    resumenHoy: 'La organización te dará paz mental. Pon orden en tus pendientes.',
    amor: 'Hablar con honestidad, pero sin criticar tanto, hará que te escuchen mejor.',
    dinero: 'Momento ideal para revisar detalles de contratos o cuentas.',
    salud: 'Cuida tu sistema nervioso con pausas y respiración consciente.',
  ),
  HoroscopeSign(
    nombre: 'Libra',
    fecha: '23 de septiembre - 22 de octubre',
    resumenHoy: 'Buscas equilibrio y armonía. Evita extremos.',
    amor: 'Buen día para acuerdos, disculpas y reconciliación.',
    dinero: 'Piensa en alianzas o trabajos en equipo. Juntos avanzan más.',
    salud: 'Rodéate de belleza: música, arte o naturaleza te harán muy bien.',
  ),
  HoroscopeSign(
    nombre: 'Escorpio',
    fecha: '23 de octubre - 21 de noviembre',
    resumenHoy: 'Las emociones van profundas. No temas mirar adentro.',
    amor: 'La intensidad puede unir o separar. Elige comunicar en vez de controlar.',
    dinero: 'Transformar una vieja idea puede traer nuevas oportunidades.',
    salud: 'Descarga la tensión con ejercicio o escritura.',
  ),
  HoroscopeSign(
    nombre: 'Sagitario',
    fecha: '22 de noviembre - 21 de diciembre',
    resumenHoy: 'Necesitas libertad y expansión. Sueña en grande.',
    amor: 'Una conversación espontánea puede darte una grata sorpresa.',
    dinero: 'Buen día para aprender algo nuevo que beneficie tu futuro laboral.',
    salud: 'Salir al aire libre te renovará la energía.',
  ),
  HoroscopeSign(
    nombre: 'Capricornio',
    fecha: '22 de diciembre - 19 de enero',
    resumenHoy: 'Responsabilidad y foco. Día para avanzar en metas concretas.',
    amor: 'Mostrar tu lado sensible fortalecerá tus vínculos.',
    dinero: 'Tu esfuerzo a largo plazo empieza a dar frutos. No te detengas.',
    salud: 'Descansa lo suficiente, tu cuerpo necesita recargar.',
  ),
  HoroscopeSign(
    nombre: 'Acuario',
    fecha: '20 de enero - 18 de febrero',
    resumenHoy: 'Ideas originales y ganas de cambiar rutinas.',
    amor: 'La autenticidad te hará más atractivo/a que cualquier pose.',
    dinero: 'Piensa diferente: una solución creativa puede resolver un problema.',
    salud: 'Necesitas tiempo para ti, sin tantas exigencias externas.',
  ),
  HoroscopeSign(
    nombre: 'Piscis',
    fecha: '19 de febrero - 20 de marzo',
    resumenHoy: 'Sensibilidad e intuición muy activas. Escucha tus presentimientos.',
    amor: 'Un momento romántico o espiritual puede unir aún más un vínculo.',
    dinero: 'Imaginación al servicio de tus proyectos puede abrir caminos nuevos.',
    salud: 'Protege tus emociones con límites sanos y descanso profundo.',
  ),
];



void main() {
  runApp(const TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

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
    SettingsScreen(), // NUEVO
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
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  Text(
                    'Pronto aquí aparecerá una carta mística personalizada para ti.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                  Text(
                    'Aquí verás tu horóscopo diario cuando lo implementemos.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                    'Mensaje del día',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mantén tu energía en equilibrio y confía en tu intuición.',
                    style: theme.textTheme.bodyMedium,
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

  void _mostrarCartaDelDia() {
    if (cartasTarot.isEmpty) return;

    final random = Random();
    setState(() {
      cartaDelDia = cartasTarot[random.nextInt(cartasTarot.length)];
      tiradaTres = null;
    });
  }

  void _tirarTresCartas() {
    if (cartasTarot.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Necesitas al menos 3 cartas en el mazo para esta tirada.',
          ),
        ),
      );
      return;
    }

    final random = Random();
    final barajadas = List<TarotCard>.from(cartasTarot)..shuffle(random);

    setState(() {
      tiradaTres = barajadas.take(3).toList();
      cartaDelDia = null;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elige una opción para tu lectura:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _mostrarCartaDelDia,
                    child: const Text('Carta del día'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _tirarTresCartas,
                    child: const Text('Tirada de 3 cartas'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (cartaDelDia != null)
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
                        cartaDelDia!.nombre,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cartaDelDia!.significado,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            if (tiradaTres != null) ...[
              for (var i = 0; i < tiradaTres!.length; i++)
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
                          ['Pasado', 'Presente', 'Futuro'][i],
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tiradaTres![i].nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tiradaTres![i].significado,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
            child: ListTile(
              title: Text(
                signo.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              subtitle: Text(
                signo.resumenHoy,
                style: theme.textTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HoroscopeDetailScreen(signo: signo),
                  ),
                );
              },
            ),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            signo.nombre,
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            signo.fecha,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
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
                    'Energía general de hoy',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(signo.resumenHoy),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    'Amor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(signo.amor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    'Dinero',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(signo.dinero),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    'Salud',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(signo.salud),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _signoSeleccionado;
  bool _notificacionesActivadas = true;
  bool _temaOscuroActivado = true; // placeholder (todavía no cambia el tema real)

  @override
  void initState() {
    super.initState();
    // Por ahora simplemente dejamos Aries como valor por defecto
    _signoSeleccionado = signos.first.nombre;
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
                    onChanged: (value) {
                      setState(() {
                        _signoSeleccionado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Este signo se usará para mostrarte primero tu horóscopo y carta del día en futuras versiones.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Card: Notificaciones
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
                // Más adelante aquí conectamos notificaciones reales
              },
            ),
          ),

          const SizedBox(height: 16),

          // Card: Tema (placeholder)
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
                // En futuras versiones podríamos cambiar el theme dinámicamente
              },
            ),
          ),

          const SizedBox(height: 16),

          // Card: Información de la app
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

