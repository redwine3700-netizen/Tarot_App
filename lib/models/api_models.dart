class TarotReadingResponse {
  final String title;
  final String summary;
  final String past;
  final String present;
  final String future;
  final String advice;

  const TarotReadingResponse({
    required this.title,
    required this.summary,
    required this.past,
    required this.present,
    required this.future,
    required this.advice,
  });

  factory TarotReadingResponse.fromJson(Map<String, dynamic> json) {
    return TarotReadingResponse(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      past: json['past'] as String? ?? '',
      present: json['present'] as String? ?? '',
      future: json['future'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'past': past,
      'present': present,
      'future': future,
      'advice': advice,
    };
  }
}
class HoroscopeDailyResponse {
  final String sign;
  final String date;
  final String title;
  final String summary;
  final String love;
  final String money;
  final String health;
  final String luckyColor;
  final int luckyNumber;

  const HoroscopeDailyResponse({
    required this.sign,
    required this.date,
    required this.title,
    required this.summary,
    required this.love,
    required this.money,
    required this.health,
    required this.luckyColor,
    required this.luckyNumber,
  });

  factory HoroscopeDailyResponse.fromJson(Map<String, dynamic> json) {
    return HoroscopeDailyResponse(
      sign: json['sign'] as String? ?? '',
      date: json['date'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      love: json['love'] as String? ?? '',
      money: json['money'] as String? ?? '',
      health: json['health'] as String? ?? '',
      luckyColor: json['lucky_color'] as String? ?? '',
      luckyNumber: (json['lucky_number'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sign': sign,
      'date': date,
      'title': title,
      'summary': summary,
      'love': love,
      'money': money,
      'health': health,
      'lucky_color': luckyColor,
      'lucky_number': luckyNumber,
    };
  }
}
