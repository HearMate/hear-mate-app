import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_db/cubits/headphones_search_bar_db/headphones_search_bar_supabase_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesSearchBarSupabaseWidget extends StatelessWidget {
  const HeadphonesSearchBarSupabaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = theme.iconTheme.color;

    return BlocBuilder<
      HeadphonesSearchBarSupabaseCubit,
      HeadphonesSearchBarSupabaseState
    >(
      builder: (context, state) {
        final cubit = context.read<HeadphonesSearchBarSupabaseCubit>();

        return Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SearchBar(
                        controller: cubit.controller,
                        focusNode: cubit.focusNodeSearchBar,
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
                                : Icon(
                                  Icons.search,
                                  color: iconColor ?? Colors.grey,
                                ),
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
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
