part of '../hearing_test_welcome_page.dart';

class _TestTab extends StatelessWidget {
  const _TestTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Hero Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.08),
                    theme.colorScheme.primary.withValues(alpha: 0.02),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.hearing,
                      size: 48,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Test słuchu",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sprawdź swój słuch w zaledwie 10 minut",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Quick Info Cards
                    _QuickInfoCard(
                      icon: Icons.schedule,
                      title: "10 minut",
                      subtitle: "Czas trwania testu",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _QuickInfoCard(
                      icon: Icons.headphones,
                      title: "Słuchawki",
                      subtitle: "Zalecane do najlepszych wyników",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _QuickInfoCard(
                      icon: Icons.volume_off,
                      title: "Cisza",
                      subtitle: "Znajdź ciche pomieszczenie",
                      theme: theme,
                    ),

                    const SizedBox(height: 16),

                    // Instructions Section
                    _SectionHeader(
                      icon: Icons.list_alt,
                      title: "Jak to działa",
                      theme: theme,
                    ),

                    _StepItem(
                      stepNumber: "1",
                      text: "Kliknij ekran gdy usłyszysz dźwięk",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _StepItem(
                      stepNumber: "2",
                      text: "Test sprawdzi najpierw prawe ucho",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _StepItem(
                      stepNumber: "3",
                      text: "Następnie przejdzie do lewego ucha",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _StepItem(
                      stepNumber: "4",
                      text: "Dźwięki mogą być bardzo ciche",
                      theme: theme,
                    ),
                    const Divider(height: 1),

                    _StepItem(
                      stepNumber: "5",
                      text: "Test zakończy się sam",
                      theme: theme,
                    ),

                    const SizedBox(height: 16),

                    // Important Notice
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
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
                            Icons.lightbulb_outline,
                            color: Colors.amber.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wskazówka",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Nie martw się jeśli nie usłyszysz niektórych dźwięków - to normalne!",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Start Button Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        context.read<HearingTestBloc>().add(
                          HearingTestStartTest(),
                        );
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            l10n.hearing_test_welcome_page_start_hearing_test,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Gotowy? Rozpocznij test już teraz",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;

  const _QuickInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ThemeData theme;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: theme.colorScheme.primary.withValues(alpha: 0.03),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String stepNumber;
  final String text;
  final ThemeData theme;

  const _StepItem({
    required this.stepNumber,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
