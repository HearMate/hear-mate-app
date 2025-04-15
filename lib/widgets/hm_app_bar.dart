import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/locale_provider.dart';

class HMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HMAppBar({super.key, required this.title});

  final String? title;

  @override
  State<HMAppBar> createState() => _HMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HMAppBarState extends State<HMAppBar> {
  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(widget.title ?? "", style: TextStyle()),
      
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
        ValueListenableBuilder(
          valueListenable: isSettingPageOn,
          builder: (context, isSettingPage, child) {
            if (!isSettingPage) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                child: IconButton(
                  onPressed: () {
                    isSettingPageOn.value = !isSettingPageOn.value;
                    Navigator.pushNamed(context, '/echo_parse/settings');
                  },
                  icon: Icon(Icons.settings),
                ),
              );
            } else {
              return Padding(padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0));
            }
          },
        ),
      ],
    );
  }
}
