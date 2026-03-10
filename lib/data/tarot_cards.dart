import 'dart:math';
import '../models/tarot_models.dart';

/// ===============================
/// MAZO BASE · ARCANOS MAYORES
/// ===============================
/// Versión ordenada y lista para escalar.
/// Mantiene compatibilidad con tu modelo actual:
/// TarotCard(nombre, significado, imagePath)

final List<TarotCard> cartasTarot = List.unmodifiable([
  TarotCard(
    nombre: 'El Loco',
    significado:
    'Estás frente a un nuevo comienzo. Hay algo en tu corazón que quiere saltar, aunque la mente no tenga todo claro. Atrévete a dar un paso con confianza: la vida se encargará de mostrarte el camino mientras avanzas. El riesgo más grande sería quedarte inmóvil por miedo.',
    imagePath: 'assets/tarot/cards/loco.png',
  ),
  TarotCard(
    nombre: 'El Mago',
    significado:
    'Tienes todas las herramientas que necesitas: talento, experiencia y una chispa de magia interna. Hoy es un día para decir “sí” a tus ideas y empezar a materializarlas, aunque sea con un pequeño gesto. Tu palabra tiene poder: úsala para crear, no para sabotearte.',
    imagePath: 'assets/tarot/cards/mago.png',
  ),
  TarotCard(
    nombre: 'La Sacerdotisa',
    significado:
    'Hay respuestas que no están afuera, sino en tu mundo interior. Esta carta te invita a bajar el ruido, observar tus sueños, tus corazonadas, esos pequeños mensajes que la vida te susurra. No te apures en tomar decisiones: primero escucha lo que tu intuición viene diciendo hace tiempo.',
    imagePath: 'assets/tarot/cards/sacerdotisa.png',
  ),
  TarotCard(
    nombre: 'La Emperatriz',
    significado:
    'Es momento de nutrir y dejarte nutrir. La Emperatriz habla de abundancia, creatividad, amor propio y belleza en lo cotidiano. Rodéate de cosas y personas que te hagan bien. Dale espacio a tu cuerpo, a tu placer, a crear algo desde el corazón sin presión de hacerlo perfecto.',
    imagePath: 'assets/tarot/cards/emperatriz.png',
  ),
  TarotCard(
    nombre: 'El Emperador',
    significado:
    'Hoy la vida te pide estructura, límites sanos y decisión. Es tiempo de ordenar, poner reglas claras o hacerte respetar. El Emperador te recuerda que puedes ser firme sin dejar de ser amoroso. Organiza, planifica y demuestra con hechos que te tomas en serio tu propio camino.',
    imagePath: 'assets/tarot/cards/emperador.png',
  ),
  TarotCard(
    nombre: 'El Sumo Sacerdote',
    significado:
    'Tus creencias, valores y principios están en primer plano. Esta carta te invita a aprender, enseñar o buscar guía espiritual o emocional. Puede ser momento de pedir consejo a alguien sabio, o de asumir tú ese rol para otros. Lo importante es que lo que hagas esté alineado con lo que realmente crees.',
    imagePath: 'assets/tarot/cards/sacerdote.png',
  ),
  TarotCard(
    nombre: 'Los Enamorados',
    significado:
    'No se trata solo de amor romántico, sino de elecciones desde el corazón. Hay una decisión importante frente a ti, y tu alma ya sabe la respuesta. Esta carta te recuerda que elegir desde el miedo trae confusión, y elegir desde el amor trae paz, aunque el camino sea desafiante.',
    imagePath: 'assets/tarot/cards/enamorados.png',
  ),
  TarotCard(
    nombre: 'El Carro',
    significado:
    'Energía de avance, determinación y enfoque. El Carro te anima a tomar las riendas y dirigir tu vida con claridad. Es un buen momento para moverte, viajar, iniciar un proyecto o retomar algo que habías pausado. La clave es no dispersarte: elige un rumbo y avanza con confianza.',
    imagePath: 'assets/tarot/cards/carro.png',
  ),
  TarotCard(
    nombre: 'La Justicia',
    significado:
    'Hoy la balanza busca equilibrio. Puede haber temas de decisiones, papeles, acuerdos o consecuencias que llegan. Esta carta te invita a ser honesto contigo mismo y con los demás. ¿Lo que estás haciendo es justo para ti? Alinear tu vida con tu verdad interior es el acto de justicia más grande.',
    imagePath: 'assets/tarot/cards/justicia.png',
  ),
  TarotCard(
    nombre: 'El Ermitaño',
    significado:
    'Necesitas un momento a solas para reconectar contigo. El Ermitaño no habla de soledad vacía, sino de pausas sagradas. Apaga un poco el ruido, las opiniones y las distracciones. En el silencio, una luz interna se enciende y te muestra cuál es el siguiente paso, aunque sea pequeño.',
    imagePath: 'assets/tarot/cards/ermitaño.png',
  ),
  TarotCard(
    nombre: 'La Rueda de la Fortuna',
    significado:
    'La vida se está moviendo y hay cosas que simplemente están cambiando, lo quieras o no. La Rueda te recuerda que nada es permanente: lo que sube, baja, y lo que baja, en algún momento vuelve a subir. Confía en el ciclo y pregúntate: ¿cómo puedo aprovechar esta vuelta a mi favor?',
    imagePath: 'assets/tarot/cards/fortuna.png',
  ),
  TarotCard(
    nombre: 'La Fuerza',
    significado:
    'Tu poder no está en gritar más fuerte ni en controlar todo, sino en tu suavidad firme. La Fuerza habla de domar tus impulsos con cariño, no con castigo. Hoy puedes transformar rabia, miedo o ansiedad en coraje, paciencia y compasión hacia ti y hacia otros.',
    imagePath: 'assets/tarot/cards/fuerza.png',
  ),
  TarotCard(
    nombre: 'El Colgado',
    significado:
    'Una pausa obligada, un no sale como quería o un bloqueo aparente. El Colgado te pide mirar la situación desde otro ángulo. A veces el avance real viene cuando dejamos de pelear con lo que es. Ríndete un momento, suelta la prisa y permite que la vida te muestre una perspectiva nueva.',
    imagePath: 'assets/tarot/cards/colgado.png',
  ),
  TarotCard(
    nombre: 'La Muerte',
    significado:
    'Un ciclo está terminando, quieras o no. Esta carta no anuncia tragedia, sino transformación profunda. Algo que ya cumplió su función necesita soltarse para dar lugar a una nueva etapa. Duele despedirse, pero detrás de esta puerta cerrada hay espacio para una versión más auténtica de ti.',
    imagePath: 'assets/tarot/cards/muerte.png',
  ),
  TarotCard(
    nombre: 'La Templanza',
    significado:
    'Hoy el mensaje es equilibrio, calma y mezcla armoniosa. Nada de extremos: ni todo blanco ni todo negro. La Templanza te invita a ir más lento, respirar, bajar la intensidad y encontrar el punto medio que te hace bien. Poco a poco, sin apuro, también es un camino poderoso.',
    imagePath: 'assets/tarot/cards/templanza.png',
  ),
  TarotCard(
    nombre: 'El Diablo',
    significado:
    'Aparecen a la luz apegos, miedos, tentaciones o hábitos que te tienen atrapado. Esta carta no viene a asustarte, sino a mostrarte cadenas que ya están listas para romperse. ¿Dónde te estás quedando por comodidad, culpa o miedo? Reconocerlo es el primer paso para liberarte.',
    imagePath: 'assets/tarot/cards/diablo.png',
  ),
  TarotCard(
    nombre: 'La Torre',
    significado:
    'Algo inesperado puede sacudir tus planes, creencias o estructuras. Aunque se sienta duro, la Torre derrumba lo que estaba construido sobre bases frágiles. Después del impacto, quedará solo lo verdadero. Esta carta te invita a confiar en que, tras el caos, viene un nuevo orden más honesto.',
    imagePath: 'assets/tarot/cards/torre.png',
  ),
  TarotCard(
    nombre: 'La Estrella',
    significado:
    'Esperanza, guía y sanación. La Estrella aparece cuando necesitas un recordatorio de que no estás solo y que lo mejor aún puede llegar. Es un buen momento para soñar, manifestar y alimentar tu fe en ti y en la vida. Permítete descansar y volver a creer.',
    imagePath: 'assets/tarot/cards/estrella.png',
  ),
  TarotCard(
    nombre: 'La Luna',
    significado:
    'El terreno está movedizo, las emociones pueden estar intensas o confusas. La Luna te habla de miedos, ilusiones y sensaciones que no logras explicar. No tomes decisiones apresuradas: observa, siente, escribe, sueña. Lo oculto se revelará con el tiempo si te das espacio para sentir.',
    imagePath: 'assets/tarot/cards/luna.png',
  ),
  TarotCard(
    nombre: 'El Sol',
    significado:
    'Alegría, claridad y buena energía. El Sol ilumina lo que antes se veía confuso y trae una sensación de alivio. Es un excelente momento para compartir, agradecer y disfrutar lo que ya has logrado. Deja entrar la luz y permítete celebrar tus pequeñas y grandes victorias.',
    imagePath: 'assets/tarot/cards/sol.png',
  ),
  TarotCard(
    nombre: 'El Juicio',
    significado:
    'Es una llamada de despertar. Hay algo en tu vida que pide revisión: patrones, relaciones, trabajo, hábitos. El Juicio te invita a hacer balance sin culparte, y a decidir qué parte de ti está lista para renacer. Es tiempo de perdonarte y avanzar más liviano.',
    imagePath: 'assets/tarot/cards/juicio.png',
  ),
  TarotCard(
    nombre: 'El Mundo',
    significado:
    'Cierre de ciclo exitoso, integración y expansión. Has aprendido algo importante y ahora puedes ir a una nueva etapa con más sabiduría. El Mundo te habla de logros, viajes, conexiones y sentir que cuadra una pieza que antes no entendías. Agradece tu camino: no has llegado por casualidad.',
    imagePath: 'assets/tarot/cards/mundo.png',
  ),
]);

/// Acceso rápido por nombre normalizado.
final Map<String, TarotCard> cartasTarotPorNombre = {
  for (final carta in cartasTarot) _normalizarTexto(carta.nombre): carta,
};

/// Devuelve una carta por nombre.
/// Ejemplo:
/// final carta = buscarCartaTarot('La Luna');
TarotCard? buscarCartaTarot(String nombre) {
  return cartasTarotPorNombre[_normalizarTexto(nombre)];
}

/// Devuelve una carta aleatoria del mazo.
TarotCard obtenerCartaAleatoria({Random? random}) {
  final rng = random ?? Random();
  return cartasTarot[rng.nextInt(cartasTarot.length)];
}

/// Devuelve varias cartas aleatorias sin repetir.
/// Si count es mayor al total del mazo, devuelve todo mezclado.
List<TarotCard> obtenerCartasAleatorias(int count, {Random? random}) {
  final rng = random ?? Random();
  final copia = List<TarotCard>.from(cartasTarot)..shuffle(rng);

  if (count >= copia.length) return copia;
  return copia.take(count).toList();
}

/// Mezcla el mazo completo y devuelve una nueva lista.
List<TarotCard> mezclarMazo({Random? random}) {
  final rng = random ?? Random();
  final copia = List<TarotCard>.from(cartasTarot)..shuffle(rng);
  return copia;
}

/// Normaliza nombres para búsquedas más tolerantes.
/// Soporta mayúsculas, tildes y espacios extra.
String _normalizarTexto(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ñ', 'n')
      .replaceAll(RegExp(r'\s+'), ' ');
}