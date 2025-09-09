import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HMAppBar({
    super.key,
    required this.route,
    required this.title,
    this.hideBackArrow = false,
    this.onBackPressed,
    this.customBackRoute,
  });
  final String title;
  final String route;
  final Future<bool> Function()? onBackPressed;
  final String? customBackRoute;
  final bool hideBackArrow;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hiddenMenuBarRoutes = ['/menu', '/settings', '/about'];
    final hiddenBackButtonRoutes = [
      '/echo_parse/conversion_results',
      '/',
    ]; // Routes where back is hidden

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      automaticallyImplyLeading: false,
      leading:
          (!hideBackArrow && !hiddenBackButtonRoutes.contains(route))
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  bool shouldPop = true;
                  if (onBackPressed != null) {
                    shouldPop = await onBackPressed!();
                  }
                  if (shouldPop) {
                    if (customBackRoute != null) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(customBackRoute!),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
              )
              : null,

      title: Text(title, style: theme.appBarTheme.titleTextStyle),
      actions: [
        BlocBuilder<HMThemeBloc, HMThemeState>(
          builder: (context, themeState) {
            return IconButton(
              onPressed: () {
                context.read<HMThemeBloc>().add(HMThemeToggleEvent());
              },
              icon: Icon(
                themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.appBarTheme.foregroundColor,
              ),
            );
          },
        ),
        hiddenMenuBarRoutes.contains(route)
            ? const SizedBox.shrink()
            : IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed("/menu");
              },
              icon: Icon(Icons.menu, color: theme.appBarTheme.foregroundColor),
            ),
      ],
    );
  }
}
