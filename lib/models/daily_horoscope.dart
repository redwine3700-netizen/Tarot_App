class DailyHoroscope {
  final String description;
  final String mood;
  final String color;
  final String luckyNumber;

  const DailyHoroscope({
    required this.description,
    required this.mood,
    required this.color,
    required this.luckyNumber,
  });

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) {
    return DailyHoroscope(
      description: (json['description'] ?? '').toString(),
      mood: (json['mood'] ?? '—').toString(),
      color: (json['color'] ?? '—').toString(),
      luckyNumber: (json['lucky_number'] ?? json['luckyNumber'] ?? '—').toString(),
    );
  }
}
