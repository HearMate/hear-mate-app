import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HMAppBar({super.key, required this.route, required this.title});
  final String title;
  final String route;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle()),
      actions: [
        BlocBuilder<HMThemeBloc, HMThemeState>(
          builder: (context, themeState) {
            return IconButton(
              onPressed: () {
                context.read<HMThemeBloc>().add(HMThemeToggleEvent());
              },
              icon: Icon(
                themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            );
          },
        ),
        route != "/settings"
            ? IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icon(Icons.settings),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
