String processTitle(int processDay) {
  switch (processDay) {
    case 1:
      return 'Día 1 — Comprender';
    case 2:
      return 'Día 2 — Integrar';
    case 3:
      return 'Día 3 — Elegir dirección';
    default:
      return '';
  }
}

String processMessage(int processDay) {
  switch (processDay) {
    case 1:
      return 'Hoy no necesitas resolverlo todo. Solo reconocer con honestidad qué estás sintiendo y qué parte de esta historia te está moviendo por dentro.';
    case 2:
      return 'Observa qué patrón se repite, qué te drena y qué te está enseñando esta situación sobre tus límites, tu valor y tu forma de amar.';
    case 3:
      return 'Ya no se trata solo de sentir: se trata de decidir qué te da paz, qué merece quedarse y qué necesitas soltar para volver a tu centro.';
    default:
      return '';
  }
}

String processAction(int processDay) {
  switch (processDay) {
    case 1:
      return 'Microacción de hoy: escribe en una frase qué estás sintiendo realmente, sin explicarlo ni justificarlo.';
    case 2:
      return 'Microacción de hoy: identifica un patrón que se repite en esta historia y nómbralo con honestidad.';
    case 3:
      return 'Microacción de hoy: elige una acción pequeña que te devuelva paz y hazla hoy.';
    default:
      return '';
  }
}

String processClosing(int processDay) {
  if (processDay == 3) {
    return 'Has completado este proceso. Quédate con lo que te devolvió más paz y con la verdad que hoy ya puedes sostener.';
  }
  return '';
}

String historyInsight(List<Map<String, dynamic>> emotionalHistory) {
  if (emotionalHistory.length < 2) {
    return 'Aquí comenzará a mostrarse el movimiento de tu proceso emocional.';
  }

  final current = emotionalHistory[0];
  final previous = emotionalHistory[1];

  final currentEstado = (current['estado'] ?? '').toString();
  final previousEstado = (previous['estado'] ?? '').toString();

  final currentFoco = (current['foco'] ?? '').toString();
  final previousFoco = (previous['foco'] ?? '').toString();

  final estadoCambio =
      currentEstado.isNotEmpty &&
          previousEstado.isNotEmpty &&
          currentEstado != previousEstado;

  final focoCambio =
      currentFoco.isNotEmpty &&
          previousFoco.isNotEmpty &&
          currentFoco != previousFoco;

  if (estadoCambio && focoCambio) {
    return 'Tu energía y tu foco han cambiado recientemente. Hay movimiento real en tu proceso.';
  }

  if (estadoCambio) {
    return 'Tu estado emocional muestra un cambio reciente. Observa cómo se mueve tu energía.';
  }

  if (focoCambio) {
    return 'Tu foco emocional se está moviendo. Eso también habla de una transformación interna.';
  }

  return 'Tu proceso se ve estable por ahora. A veces la claridad también crece en silencio.';
}

String formatHistoryDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = today.difference(target).inDays;

  if (diff == 0) return 'Hoy';
  if (diff == 1) return 'Ayer';

  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}