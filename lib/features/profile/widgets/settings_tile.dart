import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SettingsTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 20.r,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
            thickness: 1,
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
