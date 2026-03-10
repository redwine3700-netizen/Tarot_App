import 'package:flutter/material.dart';

class RouletteScreen extends StatelessWidget {
  const RouletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta mística')),
      body: const Center(
        child: Text('Aquí va tu ruleta ✨'),
      ),
    );
  }
}
