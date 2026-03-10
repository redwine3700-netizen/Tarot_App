
import 'package:flutter/material.dart';


class EmotionalProcessSection extends StatelessWidget {
  final int processDay;
  final String processMessage;
  final String processAction;
  final String processTitle;
  final String processClosing;
  final Color accentFill;
  final Color accentBorder;
  final VoidCallback onUpdateEmotionalState;
  final VoidCallback onStartProcess;
  final VoidCallback onContinueProcess;
  final VoidCallback onRestartProcess;
  final VoidCallback onOpenFullHistory;

  const EmotionalProcessSection({
    super.key,
    required this.processDay,
    required this.processMessage,
    required this.processAction,
    required this.processTitle,
    required this.processClosing,
    required this.accentFill,
    required this.accentBorder,
    required this.onUpdateEmotionalState,
    required this.onStartProcess,
    required this.onContinueProcess,
    required this.onRestartProcess,
    required this.onOpenFullHistory,
  });

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accentBorder.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: accentFill,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onUpdateEmotionalState,
            icon: const Icon(Icons.favorite_border),
            label: const Text('Actualizar estado emocional'),
            style: OutlinedButton.styleFrom(
              foregroundColor: accentFill,
              side: BorderSide(color: accentBorder.withOpacity(0.45)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        if (processDay == 0) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onStartProcess,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Iniciar proceso emocional de 3 días'),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentFill,
                side: BorderSide(color: accentBorder.withOpacity(0.45)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],

        if (processDay > 0 && processDay < 3) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onContinueProcess,
              icon: const Icon(Icons.psychology),
              label: Text(
                processDay == 1
                    ? 'Continuar proceso · Ir al día 2'
                    : 'Continuar proceso · Ir al día 3',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentFill,
                side: BorderSide(color: accentBorder.withOpacity(0.45)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],

        if (processDay > 0) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRestartProcess,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar proceso'),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentFill,
                side: BorderSide(color: accentBorder.withOpacity(0.35)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],

        if (processDay > 0)
          const SizedBox(height: 16),

        if (processDay > 0)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentBorder.withOpacity(0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  processTitle,
                  style: TextStyle(
                    color: accentFill,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  processMessage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

        if (processDay > 0)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Text(
              processAction,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),

        if (processDay == 3)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentBorder.withOpacity(0.25),
              ),
            ),
            child: Text(
              processClosing,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        if (processDay == 3)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: accentBorder.withOpacity(0.35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: accentFill,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Proceso completado',
                  style: TextStyle(
                    color: accentFill,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),


      ],
    );
  }
}