import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipSection extends StatelessWidget {
  final ThemeData theme;

  const TipSection({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tip_section_tip,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tip_section_tip_desc,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
