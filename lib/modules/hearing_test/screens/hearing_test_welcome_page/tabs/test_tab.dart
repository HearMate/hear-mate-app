part of '../hearing_test_welcome_page.dart';

class _TestTab extends StatelessWidget {
  const _TestTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Header Section
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor.withValues(alpha: 0.1),
                      theme.primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.hearing, size: 64, color: theme.primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      "Test słuchu",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Instructions Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: theme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "Instrukcje",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _InstructionItem(
                        icon: Icons.schedule,
                        text: "Test potrwa około 10 minut",
                      ),
                      const SizedBox(height: 12),

                      _InstructionItem(
                        icon: Icons.touch_app,
                        text: "Kliknij ekran gdy usłyszysz dźwięk",
                      ),
                      const SizedBox(height: 12),

                      _InstructionItem(
                        icon: Icons.headphones,
                        text: "Zalóż słuchawki dla najlepszych rezultatów",
                      ),
                      const SizedBox(height: 12),

                      _InstructionItem(
                        icon: Icons.volume_down,
                        text: "Dźwięki mogą być bardzo ciche",
                      ),
                      const SizedBox(height: 12),

                      _InstructionItem(
                        icon: Icons.volume_off,
                        text: "Znajdź ciche pomieszczenie",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Warning Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Test najpierw sprawdzi prawe ucho, następnie lewe",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Start Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FilledButton(
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
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.hearing_test_welcome_page_start_hearing_test,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InstructionItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: theme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
