import 'package:flutter/material.dart';

import '../models/tarot_models.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  HoroscopeSign? _selectedSign;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferredSign();
  }

  Future<void> _loadPreferredSign() async {
    final sign = await UserPreferences.getPreferredSign();
    setState(() {
      _selectedSign = sign;
      _loading = false;
    });
  }

  Future<void> _savePreferredSign(HoroscopeSign sign) async {
    setState(() {
      _selectedSign = sign;
    });
    await UserPreferences.setPreferredSign(sign.nombre);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signo preferido guardado: ${sign.nombre}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil & Ajustes'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu signo preferido',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'El signo que elijas aquí será el que se use por defecto '
                        'en la pantalla de Inicio para mostrar tu horóscopo.',
                  ),
                  const SizedBox(height: 16),
                  ...signos.map((sign) {
                    return RadioListTile<String>(
                      value: sign.nombre,
                      groupValue: _selectedSign?.nombre,
                      onChanged: (value) {
                        if (value == null) return;
                        _savePreferredSign(sign);
                      },
                      title: Text(sign.nombre),
                      subtitle: Text(sign.fecha),
                      activeColor: const Color(0xFFFFD700),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próximamente',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aquí podrás configurar recordatorios, favoritos, '
                        'modo premium y más rituales para tu camino.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
