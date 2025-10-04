import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesSearchBarWidget extends StatelessWidget {
  const HeadphonesSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = theme.iconTheme.color;

    return BlocBuilder<HeadphonesSearchBarCubit, HeadphonesSearchBarState>(
      builder: (context, state) {
        final cubit = context.read<HeadphonesSearchBarCubit>();

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
          ],
        );
      },
    );
  }
}
