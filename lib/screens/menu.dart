import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          isMenuPageOn.value = false;
        }
      },
      child: Scaffold(
        appBar: HMAppBar(title: "Menu"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(AppLocalizations.of(context)!.menu_settings),
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(AppLocalizations.of(context)!.menu_about),
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      
                    ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
