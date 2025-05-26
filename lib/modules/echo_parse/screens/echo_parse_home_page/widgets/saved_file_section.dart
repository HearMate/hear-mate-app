part of '../echo_parse_home_page.dart';

class _SavedFilesSection extends StatelessWidget {
  const _SavedFilesSection();

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Lottie.asset("assets/lotties/saved.json", width: 200),
        Text(
          langLoc.echoparse_upload_savedFilesHeader,
          textAlign: TextAlign.center,
          style: textTheme.displayMedium,
        ),
        const SizedBox(height: 48),
        _SavedFileItem(
          name: "Krystyna Pawłowicz",
          savedDate: "10:30, 18 maja 2025",
        ),
        const SizedBox(height: 16),
        _SavedFileItem(
          name: "Jarosław Jakimowicz",
          savedDate: "12:48, 12 grudnia 2025",
        ),
      ],
    );
  }
}
