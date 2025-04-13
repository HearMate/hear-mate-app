import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/notifiers.dart';

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HMAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle()),
      actions: [
        IconButton(
          onPressed: () {
            isDarkModeNotifier.value = !isDarkModeNotifier.value;
          },
          icon: ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, value, child) {
              return Icon(value ? Icons.light_mode : Icons.dark_mode);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
          child: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
