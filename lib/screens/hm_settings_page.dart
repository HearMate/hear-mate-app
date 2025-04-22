import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/data/languages.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/widgets/locale_provider.dart';
import 'package:hm_locale/hm_locale.dart';

class HMSettingPage extends StatelessWidget {
  const HMSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HMLocaleBloc, HMLocaleState>(
      builder: (context, state) {
        return Scaffold(
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
