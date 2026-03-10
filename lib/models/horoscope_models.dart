class HoroscopeSign {
  final String nombre;     // "Aries", "Tauro", etc.
  final String fecha;      // "21 Mar - 19 Abr"
  final String resumenHoy; // texto corto para la card

  const HoroscopeSign({
    required this.nombre,
    required this.fecha,
    required this.resumenHoy,
  });
}

class DailyHoroscope {
  final String description;  // horóscopo principal
  final String mood;         // ánimo
  final String color;        // color
  final String luckyNumber;  // número de la suerte

  const DailyHoroscope({
    required this.description,
    required this.mood,
    required this.color,
    required this.luckyNumber,
  });

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) {
    // Soporta varias keys típicas según API
    String pickDesc() {
      return (json['description'] ??
          json['horoscope'] ??
          json['text'] ??
          json['data']?['horoscope'] ??
          '')
          .toString();
    }

    return DailyHoroscope(
      description: pickDesc(),
      mood: (json['mood'] ?? json['data']?['mood'] ?? '—').toString(),
      color: (json['color'] ?? json['data']?['color'] ?? '—').toString(),
      luckyNumber:
      (json['lucky_number'] ?? json['luckyNumber'] ?? json['data']?['lucky_number'] ?? '—')
          .toString(),
    );
  }
}
