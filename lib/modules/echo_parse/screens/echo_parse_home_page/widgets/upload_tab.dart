part of '../echo_parse_home_page.dart';

class _UploadTab extends StatelessWidget {
  const _UploadTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EchoParseBloc, EchoParseState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: _UploadSection(state: state),
            ),
          ),
        );
      },
    );
  }
}