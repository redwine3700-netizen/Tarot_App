import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Pantalla de pequeño ritual de manifestación
class ManifestationRitualScreen extends StatelessWidget {
  final String? pregunta;
  final String resultado;

  const ManifestationRitualScreen({
    super.key,
    required this.resultado,
    this.pregunta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pequeño ritual'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xFF1A0C2D),
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
                // Encabezado
                Text(
                  'Integra la respuesta',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usa este pequeño ritual para calmar la mente y quedarte con lo que te haga bien.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Resumen de pregunta + respuesta
                if (pregunta != null &&
                    pregunta!.trim().isNotEmpty) ...[
                  Text(
                    'Tu pregunta:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"$pregunta"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Respuesta del péndulo:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resultado,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // Paso 1
                _buildStepCard(
                  theme,
                  numero: '1',
                  titulo: 'Respira y suelta tensión',
                  contenido:
                  'Cierra los ojos unos instantes.\n\n'
                      'Inhala profundo por la nariz contando hasta 4,\n'
                      'sostén el aire 4 segundos,\n'
                      'y exhala lentamente por la boca contando hasta 6.\n\n'
                      'Repite este ciclo 3 veces, dándote permiso de aflojar hombros, mandíbula y pecho.',
                ),

                const SizedBox(height: 16),

                // Paso 2
                _buildStepCard(
                  theme,
                  numero: '2',
                  titulo: 'Acepta lo que sientes',
                  contenido:
                  'Observa cómo te hace sentir la respuesta del péndulo.\n\n'
                      'No luches contra la emoción que aparezca: alegría, alivio, miedo, duda… todo es válido.\n\n'
                      'Solo di en silencio: “Acepto lo que siento y me permito escucharlo sin juzgarlo”.',
                ),

                const SizedBox(height: 16),

                // Paso 3
                _buildStepCard(
                  theme,
                  numero: '3',
                  titulo: 'Declara tu intención',
                  contenido:
                  'Ahora, elige una intención suave que te acompañe, sin forzar nada.\n\n'
                      'Por ejemplo:\n'
                      '• “Elijo caminar hacia lo que es sano para mí”.\n'
                      '• “Confío en que lo que es para mí, se queda”.\n'
                      '• “Honro lo que siento y doy un pequeño paso hoy”.\n\n'
                      'Siente esa frase unos segundos en el corazón y agradece por la guía recibida.',
                ),

                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Terminar ritual',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
      ThemeData theme, {
        required String numero,
        required String titulo,
        required String contenido,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C0F30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700),
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFFFD700),
                child: Text(
                  numero,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            contenido,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}


/// Patrón de movimiento según la respuesta del péndulo
enum PendulumPattern {
  none,
  yesVertical,
  noHorizontal,
  maybeCircle,
}

// ------------------- PÉNDULO VISTA SUPERIOR -------------------
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

    // 2) Después de unos segundos, mostramos la respuesta
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

                // Pregunta opcional
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

                  if (_pregunta != null && _pregunta!.trim().isNotEmpty) ...[
                    Text(
                      'Pregunta: "${_pregunta!}"',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  Text(
                    _mensaje ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 👉 Botón para ir al pequeño ritual
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        if (_resultado == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManifestationRitualScreen(
                              resultado: _resultado!,
                              pregunta: _pregunta,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Hacer pequeño ritual',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
