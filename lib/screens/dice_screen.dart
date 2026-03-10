import 'package:flutter/material.dart';

class DiceScreen extends StatelessWidget {
  const DiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados místicos')),
      body: const Center(
        child: Text('Aquí va tu juego de dados ✨'),
      ),
    );
  }
}
