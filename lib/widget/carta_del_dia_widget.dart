import 'dart:math';
import 'package:flutter/material.dart';
import '../data/tarot_cards.dart';

class CartaDelDiaWidget extends StatefulWidget {
  const CartaDelDiaWidget({super.key});

  @override
  State<CartaDelDiaWidget> createState() => _CartaDelDiaWidgetState();
}

class _CartaDelDiaWidgetState extends State<CartaDelDiaWidget> {
  final _random = Random();
  final String _reversoPath = 'assets/tarot/reverso.png'TarotCardData? _cartaSeleccionada;
  bool _revelada = false;

  void _onTapCarta() {
    if (_revelada) return;

    final carta = tarotCards[_random.nextInt(tarotCards.length)];

    setState(() {
      _cartaSeleccionada = carta;
      _revelada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imagenMostrar =
    _revelada && _cartaSeleccionada != null
        ? _cartaSeleccionada!.assetPath
        : _reversoPath;

    final String nombreCarta =
    _revelada && _cartaSeleccionada != null
        ? _cartaSeleccionada!.title
        : 'Carta de tarot';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _onTapCarta,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 3 / 5,
              child: Image.asset(
                imagenMostrar,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Carta del día',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD54F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          nombreCarta,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
