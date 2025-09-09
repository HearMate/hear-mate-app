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
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Icon(Icons.search, color: Colors.grey.shade600),
              trailing:
                  state.query.isNotEmpty
                      ? [
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade600),
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
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.headphones, color: Colors.green),
                  title: Text(
                    state.result,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      onSelectedButtonPress(state.result);
                      cubit.clearQuery();
                    },
                    child: Text(l10n.common_headphones_search_bar_add_button),
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
