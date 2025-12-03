class TarotCardData {
  final String id;        // nombre interno
  final String title;     // texto que se muestra
  final String assetPath; // ruta a la imagen

  const TarotCardData({
    required this.id,
    required this.title,
    required this.assetPath,
  });
}

const List<TarotCardData> tarotCards = [
  TarotCardData(
    id: 'mago',
    title: 'El Mago',
    assetPath: 'assets/tarot/mago.png',
  ),
  TarotCardData(
    id: 'luna',
    title: 'La Luna',
    assetPath: 'assets/tarot/luna.png',
  ),
  TarotCardData(
    id: 'sol',
    title: 'El Sol',
    assetPath: 'assets/tarot/sol.png',
  ),
  // 👉 sigue agregando todas tus cartas:
  // emperatriz, emperador, estrella, torre, ermitaño, etc.
];
