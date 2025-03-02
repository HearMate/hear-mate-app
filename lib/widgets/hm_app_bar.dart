import 'package:flutter/material.dart';

class HMAppBar extends StatelessWidget implements PreferredSizeWidget {
  HMAppBar({super.key, required this.enableBackButton});

  bool enableBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'HearMate',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blueAccent,
      leading:
          enableBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
