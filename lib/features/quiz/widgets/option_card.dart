import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OptionCard extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Color borderColor;
    Color textColor;
    Widget? trailingIcon;

    if (hasAnswered) {
      if (isCorrect) {
        // Correct Option: Vibrant green styling
        cardColor = Colors.green.withOpacity(0.15);
        borderColor = Colors.green.shade400;
        textColor = Colors.green.shade100;
        trailingIcon = Icon(Icons.check_circle_rounded, color: Colors.green, size: 22.r);
      } else if (isSelected) {
        // Selected and Incorrect: Vibrant red styling
        cardColor = Colors.red.withOpacity(0.15);
        borderColor = Colors.red.shade400;
        textColor = Colors.red.shade100;
        trailingIcon = Icon(Icons.cancel_rounded, color: Colors.red, size: 22.r);
      } else {
        // Unselected, non-correct option: Dimmed styling
        cardColor = Colors.white.withOpacity(0.02);
        borderColor = Colors.white.withOpacity(0.05);
        textColor = Colors.white.withOpacity(0.4);
      }
    } else {
      // Normal state before answering
      cardColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white.withOpacity(0.1);
      textColor = Colors.white.withOpacity(0.9);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: borderColor,
                width: 2.w,
              ),
              boxShadow: isSelected || (hasAnswered && isCorrect)
                  ? [
                      BoxShadow(
                        color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.2),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: isSelected || (hasAnswered && isCorrect)
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: 10.w),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: trailingIcon,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
