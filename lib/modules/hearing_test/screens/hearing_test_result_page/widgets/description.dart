import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudiogramDescription extends StatelessWidget {
  final ThemeData theme;
  final String audiogramDescription;

  const AudiogramDescription({
    super.key,
    required this.theme,
    required this.audiogramDescription,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<HMThemeBloc, HMThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.isDarkMode;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(audiogramDescription),
              const SizedBox(height: 15),
              Text(
                loc.hearing_test_result_page_note,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                loc.hearing_test_result_page_note_description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
