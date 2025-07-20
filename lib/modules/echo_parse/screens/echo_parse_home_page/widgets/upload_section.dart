part of '../echo_parse_home_page.dart';

class _UploadSection extends StatelessWidget {
  final EchoParseState state;

  const _UploadSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        if (!state.nextFile) ...[
          if (state.image != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.memory(state.image!),
            ),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: () {
              context.read<EchoParseBloc>().add(
                EchoParseUploadAudiogramFileToServerEvent(),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<EchoParseBloc>(),
                        child: const EchoParseConversionResults(),
                      ),
                ),
              );
            },
            child: Text(langLoc.echoparse_upload_buttonUpload),
          ),
        ] else ...[
          Text(
            langLoc.echoparse_upload_headerUpload,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 40),
          Lottie.asset(
            "assets/lotties/echoparse_arrow_upload.json",
            height: 150,
          ),
          const SizedBox(height: 32),
        ],
        const SizedBox(height: 8),
        FilledButton(
          style: attentionFilledButtonStyle(theme.colorScheme),
          onPressed: () {
            context.read<EchoParseBloc>().add(
              EchoParseChooseAudiogramFileEvent(),
            );
          },
          child: Text(langLoc.echoparse_upload_buttonPick),
        ),
      ],
    );
  }
}
