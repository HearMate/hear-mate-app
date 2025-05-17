import 'package:flutter/material.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SavedFileItem extends StatelessWidget {
  final String name;
  final String savedDate;
  final VoidCallback? onTap;

  const SavedFileItem({
    super.key,
    required this.name,
    required this.savedDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.green[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.insert_drive_file,
                    size: 60,
                    color: AppColors.green[200],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.green[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${langLoc.echo_parse_saved_file_saved_label}: $savedDate',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
