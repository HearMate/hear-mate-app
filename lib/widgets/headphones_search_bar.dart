import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesSearchBarWidget extends StatelessWidget {
  final String selectedButtonLabel;
  final ValueChanged<String> onSelectedButtonPress;

  const HeadphonesSearchBarWidget({
    super.key,
    required this.selectedButtonLabel,
    required this.onSelectedButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = theme.iconTheme.color;
    final borderColor = theme.dividerColor;
    final surfaceColor = colors.surface;

    return BlocBuilder<HeadphonesSearchBarCubit, HeadphonesSearchBarState>(
      builder: (context, state) {
        final cubit = context.read<HeadphonesSearchBarCubit>();
        final resultsVisible =
            state.query.isNotEmpty && state.result.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            SearchBar(
              controller: cubit.controller,
              hintText: l10n.common_headphones_search_bar_search_hint,
              onChanged: cubit.updateQuery,
              leading:
                  state.isSearching
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      )
                      : Icon(Icons.search, color: iconColor ?? Colors.grey),
              trailing:
                  state.query.isNotEmpty
                      ? [
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: iconColor ?? Colors.grey,
                          ),
                          onPressed: cubit.clearQuery,
                        ),
                      ]
                      : null,
            ),

            // Search Results
            if (resultsVisible) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
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
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
