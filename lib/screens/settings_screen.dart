import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Ajusta estos imports si en tu proyecto están en otra ruta:
import '../services/user_prefs.dart'; // <-- cambia si tu UserPrefs está en otro archivo/ruta

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameCtrl = TextEditingController();

  String _userName = "";
  String _selectedSign = "";

  // Si ya tienes tu lista en otro lado, puedes borrar esta y usar la tuya.
  final List<_ZodiacItem> _zodiacs = const [
    _ZodiacItem("Aries", "♈"),
    _ZodiacItem("Tauro", "♉"),
    _ZodiacItem("Géminis", "♊"),
    _ZodiacItem("Cáncer", "♋"),
    _ZodiacItem("Leo", "♌"),
    _ZodiacItem("Virgo", "♍"),
    _ZodiacItem("Libra", "♎"),
    _ZodiacItem("Escorpio", "♏"),
    _ZodiacItem("Sagitario", "♐"),
    _ZodiacItem("Capricornio", "♑"),
    _ZodiacItem("Acuario", "♒"),
    _ZodiacItem("Piscis", "♓"),
  ];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    const String kDefaultSignKey = 'default_sign';
    final name = await UserPrefs.getUserName();

    final prefs = await SharedPreferences.getInstance();
    final sign = (prefs.getString(kDefaultSignKey) ?? '').trim();

    setState(() {
      _userName = name;
      _selectedSign = sign;
      _nameCtrl.text = _userName;
    });
  }

  Future<void> _saveName(String v) async {
    final name = v.trim();
    await UserPrefs.setUserName(name);
    setState(() => _userName = name); // sin fallback "Mauricio"
  }

  Future<void> _saveDefaultSign(String sign) async {
    const String kDefaultSignKey = 'default_sign';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kDefaultSignKey, sign);
    setState(() => _selectedSign = sign);
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _stripCardPrefix(String s) {
    return s.trim().replaceFirst(
      RegExp(r'^(•\s*)?Carta\s*[:\-–—]\s*[^\n]+\n?', caseSensitive: false),
      '',
    ).trim();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
      ),
      body: Container(
        color: scheme.surface,
        child: CustomScrollView(
          slivers: [
            // ===== Nombre =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outline.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tu nombre",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Lo usaremos para personalizar tus lecturas y respuestas.",
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
                          hintText: "Ej: Escribe tu nombre",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "✨ Te llamaremos: ${UserPrefs.formatName(_userName)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== Título signos =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "Elige tu signo",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      "Se guarda al tocar",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== Grid signos =====
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
                    final isSelected = z.name == _selectedSign;
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
    );
  }
}

// ===== Model =====
class _ZodiacItem {
  final String name;
  final String emoji;
  const _ZodiacItem(this.name, this.emoji);
}

// ===== Tile =====
// Si tú ya tienes _ZodiacTile en tu archivo, borra esta clase y usa la tuya.
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
    final border = isSelected ? accent : outline.withOpacity(0.35);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: isSelected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? accent : outline.withOpacity(0.6),
            )
          ],
        ),
      ),
    );
  }
}
