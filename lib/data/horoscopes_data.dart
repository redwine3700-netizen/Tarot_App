class HoroscopeSign {
  final String id;
  final String name;
  final String dateRange;
  final String emoji;
  final String message;

  const HoroscopeSign({
    required this.id,
    required this.name,
    required this.dateRange,
    required this.emoji,
    required this.message,
  });
}

const List<HoroscopeSign> horoscopeSigns = [
  HoroscopeSign(
    id: 'aries',
    name: 'Aries',
    dateRange: '21 mar - 19 abr',
    emoji: '♈️',
    message:
    'Tu energía está alta. Buen día para iniciar algo que llevas tiempo postergando.',
  ),
  HoroscopeSign(
    id: 'tauro',
    name: 'Tauro',
    dateRange: '20 abr - 20 may',
    emoji: '♉️',
    message:
    'Busca la calma y el placer en las cosas simples. No te apresures, el tiempo juega a tu favor.',
  ),
  HoroscopeSign(
    id: 'geminis',
    name: 'Géminis',
    dateRange: '21 may - 20 jun',
    emoji: '♊️',
    message:
    'Las conversaciones hoy pueden abrir caminos. Escucha tanto como hablas.',
  ),
  HoroscopeSign(
    id: 'cancer',
    name: 'Cáncer',
    dateRange: '21 jun - 22 jul',
    emoji: '♋️',
    message:
    'Tu sensibilidad es un regalo. Rodéate de personas que la cuiden y la valoren.',
  ),
  HoroscopeSign(
    id: 'leo',
    name: 'Leo',
    dateRange: '23 jul - 22 ago',
    emoji: '♌️',
    message:
    'Tu brillo natural se nota. Día ideal para mostrar tus talentos y recibir reconocimiento.',
  ),
  HoroscopeSign(
    id: 'virgo',
    name: 'Virgo',
    dateRange: '23 ago - 22 sep',
    emoji: '♍️',
    message:
    'Ordenar, limpiar y poner en claro tus ideas te dará una paz enorme hoy.',
  ),
  HoroscopeSign(
    id: 'libra',
    name: 'Libra',
    dateRange: '23 sep - 22 oct',
    emoji: '♎️',
    message:
    'Busca el equilibrio entre lo que das y lo que recibes. No te olvides de ti.',
  ),
  HoroscopeSign(
    id: 'escorpio',
    name: 'Escorpio',
    dateRange: '23 oct - 21 nov',
    emoji: '♏️',
    message:
    'La intensidad te acompaña. Úsala para transformarte, no para pelear con todo el mundo.',
  ),
  HoroscopeSign(
    id: 'sagitario',
    name: 'Sagitario',
    dateRange: '22 nov - 21 dic',
    emoji: '♐️',
    message:
    'Tu espíritu aventurero pide movimiento. Aunque sea algo pequeño, cambia de rutina.',
  ),
  HoroscopeSign(
    id: 'capricornio',
    name: 'Capricornio',
    dateRange: '22 dic - 19 ene',
    emoji: '♑️',
    message:
    'Paso a paso, pero sin detenerte. Hoy un pequeño avance vale más que mil planes en la cabeza.',
  ),
  HoroscopeSign(
    id: 'acuario',
    name: 'Acuario',
    dateRange: '20 ene - 18 feb',
    emoji: '♒️',
    message:
    'Tu forma distinta de ver el mundo hoy puede inspirar a alguien cercano.',
  ),
  HoroscopeSign(
    id: 'piscis',
    name: 'Piscis',
    dateRange: '19 feb - 20 mar',
    emoji: '♓️',
    message:
    'Escucha tu intuición y tus sueños. Hay mensajes importantes para ti en lo sutil.',
  ),
];
