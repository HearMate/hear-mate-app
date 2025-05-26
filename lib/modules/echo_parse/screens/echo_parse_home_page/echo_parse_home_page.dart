import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

part 'widgets/upload_section.dart';
part 'widgets/saved_file_item.dart';
part 'widgets/saved_file_section.dart';
part 'widgets/upload_tab.dart';
part 'widgets/saved_files_tab.dart';

class EchoParseHomePage extends StatelessWidget {
  const EchoParseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: HMAppBar(
          title: langLoc.echoparse_upload_appbarTitle,
          route: ModalRoute.of(context)?.settings.name ?? "",
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            //TODO: Add language support
            Tab(icon: Icon(Icons.change_circle_rounded), text: 'Conversion'),
            Tab(icon: Icon(Icons.save), text: 'Saved files'),
          ],
        ),
        body: const TabBarView(children: [_UploadTab(), _SavedFilesTab()]),
      ),
    );
  }
}



