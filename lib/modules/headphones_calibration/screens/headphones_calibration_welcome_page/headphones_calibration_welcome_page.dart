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
        child: Column(
          children: [
            HeaderBanner(
              title: l10n.headphones_calibration_page_title,
              subtitle: l10n.headphones_calibration_welcome_title,
              icon: Icons.headphones,
            ),
            _buildContent(context, l10n),

            const _ActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _WelcomeSection(),
            const SizedBox(height: 24),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 480),
                    child: BlocProvider(
                      create: (context) => HeadphonesSearchBarSupabaseCubit(),
                      child: HeadphonesSearchBarSupabaseWidget(
                        selectedButtonLabel:
                            l10n.headphones_calibration_add_button,
                        onSelectedButtonPress: (searchedResult) {
                          context.read<HeadphonesCalibrationModuleBloc>().add(
                            HeadphonesCalibrationModuleAddHeadphoneFromSearch(
                              HeadphonesModel.empty(name: searchedResult),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Expanded(
                    child: _HeadphonesTable(
                      title:
                          l10n.headphones_calibration_reference_headphones_title,
                      isReference: true,
                      icon: Icons.star_border,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 480),
                    child: BlocProvider(
                      create: (context) => HeadphonesSearchBarCubit(),
                      child: HeadphonesSearchBarWidget(
                        selectedButtonLabel:
                            l10n.headphones_calibration_add_button,
                        onSelectedButtonPress: (searchedResult) {
                          context.read<HeadphonesCalibrationModuleBloc>().add(
                            HeadphonesCalibrationModuleAddHeadphoneFromSearch(
                              HeadphonesModel.empty(name: searchedResult),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Expanded(
                    child: _HeadphonesTable(
                      title:
                          l10n.headphones_calibration_target_headphones_title,
                      isReference: false,
                      icon: Icons.tune,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.headphones_calibration_welcome_description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      builder: (context, state) {
        final headphones =
            isReference
                ? state.availableReferenceHeadphones
                : state.availableTargetHeadphones;

        final selectedHeadphone =
            isReference
                ? state.selectedReferenceHeadphone
                : state.selectedTargetHeadphone;

        return Card(
          elevation: 2,
          color: Theme.of(context).cardColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${headphones.length}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        headphones.isEmpty
                            ? _EmptyState(isReference: isReference)
                            : ListView.separated(
                              itemCount: headphones.length,
                              separatorBuilder:
                                  (context, index) => Divider(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                              itemBuilder: (context, index) {
                                final headphone = headphones[index];
                                final isSelected =
                                    selectedHeadphone == headphone;
                                return _HeadphoneListTile(
                                  headphone: headphone,
                                  isReference: isReference,
                                  isSelected: isSelected,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isReference;

  const _EmptyState({required this.isReference});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.headphones_outlined,
            size: 48,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            isReference
                ? l10n.headphones_calibration_no_reference_headphones
                : l10n.headphones_calibration_no_target_headphones,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.headphones_calibration_empty_state_hint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeadphoneListTile extends StatelessWidget {
  final HeadphonesModel headphone;
  final bool isReference;
  final bool isSelected;

  const _HeadphoneListTile({
    required this.headphone,
    required this.isReference,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
        borderRadius: BorderRadius.circular(8),
        border:
            isSelected
                ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            isSelected ? Icons.check : Icons.headphones,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          headphone.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                if (isReference) {
                  context.read<HeadphonesCalibrationModuleBloc>().add(
                    HeadphonesCalibrationModuleRemoveReferenceHeadphone(
                      headphone,
                    ),
                  );
                } else {
                  context.read<HeadphonesCalibrationModuleBloc>().add(
                    HeadphonesCalibrationModuleRemoveTargetHeadphone(headphone),
                  );
                }
              },
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
        onTap: () {
          if (isReference) {
            context.read<HeadphonesCalibrationModuleBloc>().add(
              HeadphonesCalibrationModuleSelectReferenceHeadphone(headphone),
            );
          } else {
            context.read<HeadphonesCalibrationModuleBloc>().add(
              HeadphonesCalibrationModuleSelectTargetHeadphone(headphone),
            );
          }
        },
      ),
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
              SizedBox(
                width: double.infinity,
                height: 56,
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
