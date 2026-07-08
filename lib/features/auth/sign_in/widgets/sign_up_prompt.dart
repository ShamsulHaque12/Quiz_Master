import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SignUpPrompt extends StatelessWidget {
  final VoidCallback onSignUpTap;

  const SignUpPrompt({
    super.key,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onSignUpTap,
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: const Color(0xFF6C63FF),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );
}
}
