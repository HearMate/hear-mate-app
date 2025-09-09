import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/shared/data/languages.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_locale/hm_locale.dart';
import 'package:hm_theme/hm_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<HMLocaleBloc, HMLocaleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HMAppBar(
            title: loc.echoparse_settings_appbar_title,
            route: ModalRoute.of(context)?.settings.name ?? "",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text(loc.echoparse_settings_language_title),
                      trailing: DropdownMenu<Locale>(
                        textStyle: textStylePickedOptionGreen(),
                        inputDecorationTheme: inputDecorationDropownMenu(),
                        initialSelection: state.locale,
                        onSelected: (Locale? locale) {
                          if (locale != null) {
                            context.read<HMLocaleBloc>().add(
                              HMLocaleChangedEvent(locale),
                            );
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
        );
      },
    );
  }
}
