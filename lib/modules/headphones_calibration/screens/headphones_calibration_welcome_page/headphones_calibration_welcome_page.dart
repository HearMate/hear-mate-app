import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/features/headphones_search/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:hear_mate_app/features/headphones_search/models/headphones_model.dart';
import 'package:hear_mate_app/features/headphones_search/screens/headphones_search_bar.dart';
import 'package:hear_mate_app/modules/headphones_calibration/blocs/headphones_calibration_module/headphones_calibration_module_bloc.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesCalibrationWelcomePage extends StatelessWidget {
  const HeadphonesCalibrationWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(
        title: l10n.headphones_calibration_page_title,
        route: ModalRoute.of(context)?.settings.name ?? "",
        customBackRoute: "/",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WelcomeSection(),
              const SizedBox(height: 24),
              const _SelectionStatusSection(),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 480),
                child: BlocProvider(
                  create: (context) => HeadphonesSearchBarCubit(),
                  child: HeadphonesSearchBarWidget(
                    selectedButtonLabel: l10n.headphones_calibration_add_button,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Expanded(
                      child: _HeadphonesTable(
                        title:
                            l10n.headphones_calibration_reference_headphones_title,
                        isReference: true,
                        icon: Icons.star_border,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
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
              const _ActionButtons(),
            ],
          ),
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
            Row(
              children: [
                Icon(
                  Icons.headphones,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.headphones_calibration_welcome_title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
  }
}

class _SelectionStatusSection extends StatelessWidget {
  const _SelectionStatusSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      builder: (context, state) {
        return Card(
          elevation: 1,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.headphones_calibration_your_selection_title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SelectionItem(
                  label: l10n.headphones_calibration_reference_headphone_label,
                  selection: state.selectedReferenceHeadphone,
                  icon: Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                _SelectionItem(
                  label: l10n.headphones_calibration_target_headphone_label,
                  selection: state.selectedTargetHeadphone,
                  icon: Icons.tune,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectionItem extends StatelessWidget {
  final String label;
  final HeadphonesModel? selection;
  final IconData icon;
  final Color color;

  const _SelectionItem({
    required this.label,
    required this.selection,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            selection != null
                ? '${selection!.name}'
                : AppLocalizations.of(
                  context,
                )!.headphones_calibration_not_selected,
            style: TextStyle(
              color:
                  selection != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle:
                  selection != null ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
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
        final canStartCalibration =
            state.selectedReferenceHeadphone != null &&
            state.selectedTargetHeadphone != null;

        return Column(
          children: [
            if (!canStartCalibration)
              Text(
                l10n.headphones_calibration_missing_selection,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: l10n.headphones_calibration_ready_prefix),
                    TextSpan(
                      text: state.selectedReferenceHeadphone?.name ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: l10n.headphones_calibration_ready_suffix),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    canStartCalibration
                        ? () {
                          context.read<HeadphonesCalibrationModuleBloc>().add(
                            HeadphonesCalibrationModuleNavigateToFirstTest(),
                          );
                        }
                        : null,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.headphones_calibration_start_button),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Theme.of(context).disabledColor,
                  disabledForegroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
