import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_db/cubits/headphones_search_bar_db/headphones_search_bar_supabase_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesSearchBarSupabaseWidget extends StatelessWidget {
  final String selectedButtonLabel;
  final ValueChanged<String> onSelectedButtonPress;
  final List<Widget>? additionalWidgets;

  const HeadphonesSearchBarSupabaseWidget({
    super.key,
    required this.selectedButtonLabel,
    required this.onSelectedButtonPress,
    this.additionalWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = theme.iconTheme.color;
    final borderColor = theme.dividerColor;
    final surfaceColor = colors.surface;

    return BlocBuilder<
      HeadphonesSearchBarSupabaseCubit,
      HeadphonesSearchBarSupabaseState
    >(
      builder: (context, state) {
        final cubit = context.read<HeadphonesSearchBarSupabaseCubit>();
        final resultsVisible = state.results.isNotEmpty;

        return Padding(
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
                      const SizedBox(height: 16),
                      if (additionalWidgets != null)
                        ...additionalWidgets!
                            .expand(
                              (widget) => [widget, const SizedBox(height: 16)],
                            )
                            .take(additionalWidgets!.length * 2 - 1),
                    ],
                  ),
                  if (resultsVisible)
                    Positioned(
                      top: 72,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
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
                                      (_, __) => Divider(
                                        height: 1,
                                        color: borderColor,
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = state.results[index];
                                    return ListTile(
                                      leading: Icon(
                                        Icons.headphones,
                                        color: colors.primary,
                                      ),
                                      title: Text(
                                        item,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_noResultsFound(state))
                    Positioned(
                      top: 72, // Adjust based on SearchBar height
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _noResultsFound(HeadphonesSearchBarSupabaseState state) {
    return state.results.isEmpty &&
        state.query.isNotEmpty &&
        !state.isSearching;
  }
}
