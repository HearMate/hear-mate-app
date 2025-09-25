import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';

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
              Expanded(
                child: Text(audiogramDescription, textAlign: TextAlign.center),
              ),
            ],
          ),
        );
      },
    );
  }
}
