import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ThemeData theme;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: theme.colorScheme.primary.withValues(alpha: 0.03),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
