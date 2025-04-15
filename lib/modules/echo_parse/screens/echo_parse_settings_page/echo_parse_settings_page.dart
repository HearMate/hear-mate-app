import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/languages.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/widgets/locale_provider.dart';

class EchoParseSettingPage extends StatefulWidget {
  const EchoParseSettingPage({super.key});

  @override
  State<EchoParseSettingPage> createState() => _EchoParseSettingPageState();
}

class _EchoParseSettingPageState extends State<EchoParseSettingPage> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = LocaleProvider.of(context);
    final Locale defaultLocale = localeProvider?.locale ?? Localizations.localeOf(context);
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          isSettingPageOn.value = false;
        }
      },
      child: Scaffold(
        appBar: HMAppBar(title: "Settings"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("Language"),
                    trailing: DropdownMenu<Locale>(
                      initialSelection: defaultLocale,
                      onSelected: (Locale? locale) {
                        if (locale != null) {
                          localeProvider?.setLocale(locale);
                        }
                      },
                      dropdownMenuEntries: Languages.getDropdownMenuEntries(),
                    ),
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
