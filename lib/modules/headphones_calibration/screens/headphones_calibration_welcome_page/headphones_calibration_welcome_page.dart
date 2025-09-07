import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:hear_mate_app/modules/headphones_calibration/blocs/headphones_calibration_module/headphones_calibration_module_bloc.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_search_result.dart';
import 'package:hear_mate_app/repositories/headphones_searcher_repository.dart';
import 'package:hear_mate_app/widgets/headphones_search_bar.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesCalibrationWelcomePage extends StatelessWidget {
  const HeadphonesCalibrationWelcomePage({super.key});

  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(
        title: l10n.hearing_test_welcome_page_title, // todo: change
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
              BlocProvider(
                create:
                    (context) => HeadphonesSearchBarCubit(
                      RepositoryProvider.of<HeadphonesSearcherRepository>(
                        context,
                      ),
                    ),
                child: HeadphonesSearchBarWidget(
                  selectedButtonLabel: "Add",
                  onSelectedButtonPress: (searchedResult) {
                    context.read<HeadphonesCalibrationModuleBloc>().add(
                      HeadphonesCalibrationModuleAddHeadphoneFromSearch(
                        HeadphonesModel.empty(name: searchedResult),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Column(
                  children: [
                    Expanded(
                      child: _HeadphonesTable(
                        title: 'Reference Headphones',
                        isReference: true,
                        icon: Icons.star_border,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: _HeadphonesTable(
                        title: 'Headphones to Calibrate',
                        isReference: false,
                        icon: Icons.tune,
                        color: Colors.orange,
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
    return Card(
      elevation: 2,
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
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Welcome to Headphones Calibration',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This module is for people who want to improve our app and make hearing tests more accessible! Search up all of your headphones, if even one of them is a reference one, they can be used to calibrate all others! First you do the hearing test with reference pair. Then the second with one you wish to calibrate. After that we are done - you just helped others!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
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
    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      builder: (context, state) {
        return Card(
          elevation: 1,
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Selection',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SelectionItem(
                  label: 'Reference Headphone:',
                  selection: state.selectedReferenceHeadphone,
                  icon: Icons.star,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                _SelectionItem(
                  label: 'Target Headphone:',
                  selection: state.selectedTargetHeadphone,
                  icon: Icons.tune,
                  color: Colors.orange,
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
            selection != null ? '${selection!.name}' : 'Not selected',
            style: TextStyle(
              color: selection != null ? Colors.black87 : Colors.grey.shade600,
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withAlpha(50),
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
                        color: Theme.of(context).primaryColor,
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
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${headphones.length}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
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
                                  (context, index) => const Divider(height: 1),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.headphones_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            isReference
                ? 'No reference headphones available'
                : 'No target headphones available',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
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
        color: isSelected ? Colors.blue.shade50 : null,
        borderRadius: BorderRadius.circular(8),
        border:
            isSelected
                ? Border.all(color: Colors.blue.shade300, width: 2)
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor:
              isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            isSelected ? Icons.check : Icons.headphones,
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          headphone.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? Colors.blue.shade700 : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
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
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
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
                "In order to calibrate new headphones you need to have both reference & target headphones.",
              )
            else
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Great, we can start! Remember to connect ",
                    ),
                    TextSpan(
                      text: state.selectedReferenceHeadphone?.name ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: "!"),
                  ],
                ),
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
                label: const Text('Start Calibration'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
