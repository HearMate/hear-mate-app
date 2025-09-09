import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/tab_navigation_cubit.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_conversion_results_page/echo_parse_conversion_results_page.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
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

    return BlocProvider(
      create: (context) => TabNavigationCubit(),
      child: BlocBuilder<TabNavigationCubit, int>(
        builder: (context, currentIndex) {
          final List<Widget> pages = [
            const _UploadTab(),
            const _SavedFilesTab(),
          ];

          return Scaffold(
            appBar: HMAppBar(
              title: langLoc.echoparse_upload_appbarTitle,
              route: ModalRoute.of(context)?.settings.name ?? "",
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap:
                  (index) =>
                      context.read<TabNavigationCubit>().changeTab(index),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.upload_file),
                  label: 'Upload',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.folder),
                  label: 'Saved',
                ),
              ],
            ),
            body: IndexedStack(index: currentIndex, children: pages),
          );
        },
      ),
    );
  }
}
