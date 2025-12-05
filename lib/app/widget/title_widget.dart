import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/constants/app_widget_size.dart';

class TitleWidget extends StatelessWidget {

  final String title;
  final IconData? rightIcon;
  final VoidCallback? onRightTap;
  final TextStyle? titleStyle;

  const TitleWidget({
    super.key,
    required this.title,
    this.rightIcon,
    this.onRightTap,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.paddingXS),
      child: Row(
        children: [

          /// Title
          Expanded(
            child: Text(
              title,
              style: titleStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          /// Optional right icon
          if (rightIcon != null)
            GestureDetector(
              onTap: onRightTap,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                rightIcon,
                size: AppWidgetSize.iconSM,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}