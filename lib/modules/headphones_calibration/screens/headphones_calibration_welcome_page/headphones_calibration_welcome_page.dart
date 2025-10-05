import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/models/headphones_model.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/screens/headphones_search_bar.dart';
import 'package:hear_mate_app/modules/headphones_calibration/blocs/headphones_calibration_module/headphones_calibration_module_bloc.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/headphones_search_db/cubits/headphones_search_bar_db/headphones_search_bar_supabase_cubit.dart';
import 'package:hear_mate_app/features/headphones_search_db/screens/headphones_search_bar_supabase.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/header_banner/header_banner.dart';

class HeadphonesCalibrationWelcomePage extends StatelessWidget {
  const HeadphonesCalibrationWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(
        title: "",
        route: ModalRoute.of(context)?.settings.name ?? "",
        customBackRoute: "/",
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                HeaderBanner(
                  title: l10n.headphones_calibration_page_title,
                  subtitle: l10n.headphones_calibration_welcome_title,
                  icon: Icons.headphones,
                  alignment:
                      _isDesktop(context)
                          ? HeaderBannerAlignment.centered
                          : HeaderBannerAlignment.start,
                ),

                _buildContent(context, l10n),
                const _ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return Expanded(
      child: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => HeadphonesSearchBarSupabaseCubit(),
          child: BlocBuilder<
            HeadphonesSearchBarSupabaseCubit,
            HeadphonesSearchBarSupabaseState
          >(
            builder: (context, supaState) {
              final supaResultsVisible = supaState.results.isNotEmpty;
              final supaShowNoResults =
                  supaState.results.isEmpty &&
                  supaState.query.isNotEmpty &&
                  !supaState.isSearching;

              return BlocProvider(
                create: (context) => HeadphonesSearchBarCubit(),
                child: BlocBuilder<
                  HeadphonesSearchBarCubit,
                  HeadphonesSearchBarState
                >(
                  builder: (context, ebayState) {
                    final ebayResultsVisible = ebayState.result.isNotEmpty;
                    final ebayShowNoResults =
                        ebayState.result.isEmpty &&
                        ebayState.query.isNotEmpty &&
                        !ebayState.isSearching;

                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const _WelcomeSection(),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  HeadphonesSearchBarSupabaseWidget(),
                                  const SizedBox(height: 16),

                                  _HeadphonesTable(
                                    title:
                                        l10n.headphones_calibration_reference_headphones_title,
                                    isReference: true,
                                    icon: Icons.star_border,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),

                                  const SizedBox(height: 24),

                                  HeadphonesSearchBarWidget(),

                                  const SizedBox(height: 16),

                                  _HeadphonesTable(
                                    title:
                                        l10n.headphones_calibration_target_headphones_title,
                                    isReference: false,
                                    icon: Icons.tune,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  SizedBox(height: 24.0),
                                ],
                              ),

                              _buildSupabaseResults(
                                context,
                                supaResultsVisible,
                                supaShowNoResults,
                                supaState,
                                (searchedResult) {
                                  context
                                      .read<HeadphonesCalibrationModuleBloc>()
                                      .add(
                                        HeadphonesCalibrationModuleAddHeadphoneFromSearch(
                                          HeadphonesModel.empty(
                                            name: searchedResult,
                                          ),
                                        ),
                                      );
                                },
                                l10n.headphones_calibration_add_button,
                                72.0,
                                // TODO: Make it dynamic ^^^^^
                              ),

                              _buildEBayResults(
                                context,
                                ebayResultsVisible,
                                ebayShowNoResults,
                                ebayState,
                                (searchedResult) {
                                  context
                                      .read<HeadphonesCalibrationModuleBloc>()
                                      .add(
                                        HeadphonesCalibrationModuleAddHeadphoneFromSearch(
                                          HeadphonesModel.empty(
                                            name: searchedResult,
                                          ),
                                        ),
                                      );
                                },
                                l10n.headphones_calibration_add_button,
                                290.0, // Position after reference table + second search bar
                                // TODO: Make it dynamic ^^^^^
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSupabaseResults(
    BuildContext context,
    bool resultsVisible,
    bool showNoResults,
    HeadphonesSearchBarSupabaseState state,
    ValueChanged<String> onSelectedButtonPress,
    String selectedButtonLabel,
    double positionTop,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final borderColor = theme.dividerColor;
    final surfaceColor = colors.surface;
    final cubit = context.read<HeadphonesSearchBarSupabaseCubit>();

    if (!resultsVisible && !showNoResults) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: positionTop,
      left: 0,
      right: 0,
      child: Center(
        child:
            resultsVisible
                ? Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Focus(
                    focusNode: cubit.focusNodeList,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        FocusScope.of(
                          context,
                        ).requestFocus(cubit.focusNodeList);
                        return false;
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.results.length,
                            separatorBuilder:
                                (_, __) =>
                                    Divider(height: 1, color: borderColor),
                            itemBuilder: (context, index) {
                              final item = state.results[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.headphones,
                                  color: colors.primary,
                                ),
                                title: Text(
                                  item,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    onSelectedButtonPress(item);
                                    cubit.clearQuery();
                                  },
                                  child: Text(selectedButtonLabel),
                                ),
                                onTap: () {
                                  onSelectedButtonPress(item);
                                  cubit.clearQuery();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: colors.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No results found",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Try different keywords",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

Widget _buildEBayResults(
  BuildContext context,
  bool resultsVisible,
  bool showNoResults,
  HeadphonesSearchBarState state,
  ValueChanged<String> onSelectedButtonPress,
  String selectedButtonLabel,
  double positionTop,
) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  final borderColor = theme.dividerColor;
  final surfaceColor = colors.surface;
  final cubit = context.read<HeadphonesSearchBarCubit>();

  if (!resultsVisible && !showNoResults) {
    return const SizedBox.shrink();
  }

  return Positioned(
    top: positionTop,
    left: 0,
    right: 0,
    child: Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            resultsVisible
                ? ListTile(
                  leading: Icon(Icons.headphones, color: colors.primary),
                  title: Text(
                    state.result,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      onSelectedButtonPress(state.result);
                      cubit.clearQuery();
                    },
                    child: Text(selectedButtonLabel),
                  ),
                )
                : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: colors.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No results found on eBay",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    ),
  );
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isDesktop(context)) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 35, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About this module',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.headphones_calibration_welcome_description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
              ),
            ),
            onPressed: () => _showInfoDialog(context, l10n),
            child: Text(
              "About the module",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showInfoDialog(context, l10n),
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            tooltip: 'Information',
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Content
                Text(
                  l10n.headphones_calibration_welcome_description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeadphonesTable extends StatelessWidget {
  final String title;
  final bool isReference;
  final IconData icon;
  final Color color;

  const _HeadphonesTable({
    required this.title,
    required this.isReference,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      builder: (context, state) {
        final selectedHeadphone =
            isReference
                ? state.selectedReferenceHeadphone
                : state.selectedTargetHeadphone;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
            ), // Set your desired max width

            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: color.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 28, color: color),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedHeadphone != null
                          ? selectedHeadphone.name
                          : l10n.headphones_calibration_not_selected,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      builder: (context, state) {
        final headphonesSelected =
            state.selectedReferenceHeadphone != null &&
            state.selectedTargetHeadphone != null;
        final isCooldownActive = state.isCooldownActive;
        final headphonesDifferent = state.headphonesDifferent;
        final canBePressed = headphonesSelected && !isCooldownActive;

        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
              Container(
                height: 56,
                constraints: BoxConstraints(maxWidth: 400),
                child: FilledButton(
                  onPressed: () {
                    canBePressed
                        ? context.read<HeadphonesCalibrationModuleBloc>().add(
                          HeadphonesCalibrationModuleNavigateToInformationBeforeTests(),
                        )
                        : null;
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        canBePressed
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                    foregroundColor:
                        canBePressed
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
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
                        l10n.headphones_calibration_start_button,
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

              if (isCooldownActive)
                Text(
                  l10n.headphones_calibration_cooldown_info,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                )
              else if (!headphonesSelected)
                Text(
                  l10n.headphones_calibration_missing_selection,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                )
              else if (!headphonesDifferent)
                Text(
                  l10n.headphones_calibration_different_selection,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }
}

bool _isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > 768;
}
