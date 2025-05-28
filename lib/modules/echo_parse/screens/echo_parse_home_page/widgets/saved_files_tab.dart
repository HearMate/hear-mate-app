part of '../echo_parse_home_page.dart';

class _SavedFilesTab extends StatelessWidget {
  const _SavedFilesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: _SavedFilesSection(),
        ),
      ),
    );
  }
}