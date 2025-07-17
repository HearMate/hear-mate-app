import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HMAppBar({
    super.key,
    required this.route,
    required this.title,
    this.onBackPressed,
  });
  final String title;
  final String route;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final hiddenMenuBarRoutes = ['/menu', '/settings', '/about'];
    final hiddenBackButtonRoutes = [
      '/echo_parse/conversion_results',
      '/',
    ]; // Routes where back is hidden

    return AppBar(
      leading:
          !hiddenBackButtonRoutes.contains(route)
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  }
                  Navigator.of(context).pop();
                },
              )
              : null,

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
        hiddenMenuBarRoutes.contains(route)
            ? const SizedBox.shrink()
            : IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
              icon: Icon(Icons.menu),
            ),
      ],
    );
  }
}
