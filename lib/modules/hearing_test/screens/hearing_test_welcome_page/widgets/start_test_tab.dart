part of '../hearing_test_welcome_page.dart';

class _StartTestTab extends StatelessWidget {
  const _StartTestTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  l10n.hearing_test_welcome_page_welcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  l10n.hearing_test_welcome_page_description,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  context.read<HearingTestBloc>().add(HearingTestStartTest());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<HearingTestBloc>(),
                            child: const HearingTestPage(),
                          ),
                    ),
                  );
                },
                child: Text(l10n.hearing_test_welcome_page_start_hearing_test),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<HearingTestBloc>(),
                            child: const HearingTestHistoryResultsPage(),
                          ),
                    ),
                  );
                },
                child: Text(l10n.hearing_test_result_history_page),
              ),
            ],
          ),
        );
      },
    );
  }
}
