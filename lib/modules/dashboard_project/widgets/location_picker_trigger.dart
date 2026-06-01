import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LocationPickerTrigger extends StatelessWidget {
  final String address;
  final VoidCallback onTap;

  const LocationPickerTrigger({
    super.key,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
              blurRadius: 9.r,
              offset: Offset(-20.w, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mapPin, size: 16.r, color: theme.primaryColor),
            SizedBox(width: 4.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
