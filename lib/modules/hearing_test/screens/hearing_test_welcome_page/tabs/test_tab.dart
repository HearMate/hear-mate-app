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
            _buildHeader(theme),
            _buildContent(theme),
            _buildStartButton(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
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
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildQuickInfoCards(theme),
            const SizedBox(height: 16),
            _buildInstructions(theme),
            const SizedBox(height: 16),
            TipSection(theme: theme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoCards(ThemeData theme) {
    return Column(
      children: [
        QuickInfoCard(
          icon: Icons.schedule,
          title: "10 minut",
          subtitle: "Czas trwania testu",
          theme: theme,
        ),
        const Divider(height: 1),
        QuickInfoCard(
          icon: Icons.headphones,
          title: "Słuchawki",
          subtitle: "Zalecane do najlepszych wyników",
          theme: theme,
        ),
        const Divider(height: 1),
        QuickInfoCard(
          icon: Icons.volume_off,
          title: "Cisza",
          subtitle: "Znajdź ciche pomieszczenie",
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInstructions(ThemeData theme) {
    return Column(
      children: [
        SectionHeader(
          icon: Icons.list_alt,
          title: "Jak to działa",
          theme: theme,
        ),
        StepItem(
          stepNumber: "1",
          text: "Kliknij ekran gdy usłyszysz dźwięk",
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "2",
          text: "Test sprawdzi najpierw prawe ucho",
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "3",
          text: "Następnie przejdzie do lewego ucha",
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "4",
          text: "Dźwięki mogą być bardzo ciche",
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(stepNumber: "5", text: "Test zakończy się sam", theme: theme),
      ],
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
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
    );
  }
}
