import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_theme/hm_theme.dart';

// THIS IS REALLY BUGGY...
// A bit of a hack function...
// We should implement our own router with preserving state in the future.
String? _getCurrentRouteName(BuildContext context) {
  String? currentRoute;
  Navigator.of(context).popUntil((route) {
    currentRoute = route.settings.name;
    return true;
  });
  return currentRoute;
}

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HMAppBar({super.key, required this.title});
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? "", style: TextStyle()),
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
        _getCurrentRouteName(context) != "/settings"
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
