import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(
        title: 'Menu',
        route: ModalRoute.of(context)?.settings.name ?? "",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(loc.menu_settings),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(loc.menu_about),
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
