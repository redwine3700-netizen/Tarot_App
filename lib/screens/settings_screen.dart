import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _kPrefDefaultSign = 'preferred_sign';

  final _nameCtrl = TextEditingController();
  String _userName = '';
  String? _selectedSign;
  bool _loading = true;

  final List<_ZodiacItem> _zodiacs = const [
    _ZodiacItem('Aries', '21 Mar – 19 Abr', '♈'),
    _ZodiacItem('Tauro', '20 Abr – 20 May', '♉'),
    _ZodiacItem('Géminis', '21 May – 20 Jun', '♊'),
    _ZodiacItem('Cáncer', '21 Jun – 22 Jul', '♋'),
    _ZodiacItem('Leo', '23 Jul – 22 Ago', '♌'),
    _ZodiacItem('Virgo', '23 Ago – 22 Sep', '♍'),
    _ZodiacItem('Libra', '23 Sep – 22 Oct', '♎'),
    _ZodiacItem('Escorpio', '23 Oct – 21 Nov', '♏'),
    _ZodiacItem('Sagitario', '22 Nov – 21 Dic', '♐'),
    _ZodiacItem('Capricornio', '22 Dic – 19 Ene', '♑'),
    _ZodiacItem('Acuario', '20 Ene – 18 Feb', '♒'),
    _ZodiacItem('Piscis', '19 Feb – 20 Mar', '♓'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSign = prefs.getString(_kPrefDefaultSign) ?? 'Aries';
      final savedName = prefs.getString(kUserNameKey) ?? '';
      setState(() {
        _selectedSign = savedSign;
        _userName = savedName;
        _nameCtrl.text = savedName;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _selectedSign = 'Aries';
        _userName = '';
        _loading = false;
      });
    }
  }

  Future<void> _saveDefaultSign(String sign) async {
    setState(() => _selectedSign = sign);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefDefaultSign, sign);
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Signo guardado: $sign'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1100),
      ),
    );
  }

  Future<void> _saveName(String value) async {
    final v = value.trim();
    setState(() => _userName = v);
    await UserPrefs.setUserName(v);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final selected = _selectedSign ?? 'Aries';
    final selectedItem =
    _zodiacs.firstWhere((z) => z.name == selected, orElse: () => _zodiacs[0]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil & Ajustes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0618), Color(0xFF120C2C), Color(0xFF1E163F)],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _HeaderCard(
                    title: 'Tu signo principal',
                    subtitle:
                    'Lo usaremos para personalizar tus lecturas y tu horóscopo en Inicio.',
                    pillText: 'Actual: ${selectedItem.name} ${selectedItem.symbol}',
                  ),
                ),
              ),

              // ✅ CARD DEL NOMBRE (aquí sí existe _nameCtrl y _saveName)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.surface.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: scheme.primary.withOpacity(0.18), width: 0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.55),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tu nombre',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Lo usaremos para personalizar tus lecturas y respuestas.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.done,
                          onChanged: _saveName,
                          decoration: const InputDecoration(
                            hintText: 'Ej: Mauricio',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        if (_userName.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            '✨ Te llamaremos: ${UserPrefs.formatName(_userName)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.85),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Elige tu signo',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        'Se guarda al tocar',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final z = _zodiacs[index];
                      final isSelected = z.name == selected;
                      return _ZodiacTile(
                        item: z,
                        isSelected: isSelected,
                        accent: scheme.primary,
                        surface: scheme.surface,
                        outline: scheme.outline,
                        onTap: () => _saveDefaultSign(z.name),
                      );
                    },
                    childCount: _zodiacs.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZodiacItem {
  final String name;
  final String date;
  final String symbol;
  const _ZodiacItem(this.name, this.date, this.symbol);
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String pillText;

  const _HeaderCard({
    required this.title,
    required this.subtitle,
    required this.pillText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.primary.withOpacity(0.18), width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.78),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: scheme.primary.withOpacity(0.28), width: 0.9),
              ),
              child: Text(
                pillText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZodiacTile extends StatelessWidget {
  final _ZodiacItem item;
  final bool isSelected;
  final Color accent;
  final Color surface;
  final Color outline;
  final VoidCallback onTap;

  const _ZodiacTile({
    required this.item,
    required this.isSelected,
    required this.accent,
    required this.surface,
    required this.outline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final borderColor = isSelected ? accent.withOpacity(0.45) : outline.withOpacity(0.28);
    final bg = isSelected ? accent.withOpacity(0.14) : surface.withOpacity(0.82);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accent.withOpacity(0.12),
        highlightColor: accent.withOpacity(0.06),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: isSelected ? 1.3 : 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surface.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? accent.withOpacity(0.35) : outline.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  item.symbol,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isSelected ? accent : scheme.onSurface.withOpacity(0.9),
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.68),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: accent.withOpacity(0.95), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
