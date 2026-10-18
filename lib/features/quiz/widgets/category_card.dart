import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/quiz_controller.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final Widget icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  Future<bool> _doesAssetExist(BuildContext context, String filepath) async {
    try {
      await DefaultAssetBundle.of(context).load(filepath);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _showComingSoonDialog(BuildContext context, String categoryName) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF161233),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🚀', style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'The quiz for "$categoryName" is currently under development. Stay tuned!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuizModeDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF161233),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row with Category Icon badge and Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 32.r),
                  Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: icon,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 18.r,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Selected Category Name displayed prominently at the top
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),

              // Subtitle
              Text(
                'Select Quiz Mode',
                style: TextStyle(
                  color: const Color(0xFF6C63FF),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                'Choose your preferred quiz style to begin',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              // MCQ Mode Button
              _buildModeButton(
                title: 'MCQ (Multiple Choice)',
                subtitle: 'Single correct answer from choices',
                icon: '📝',
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                ),
                onTap: () async {
                  const String filepath = 'assets/quiz_json_file/program_option.json';
                  final bool exists = await _doesAssetExist(context, filepath);
                  if (!context.mounted) return;
                  Get.back();
                  if (exists) {
                    if (Get.isRegistered<QuizController>()) {
                      Get.find<QuizController>().startQuiz(
                        newCategory: name,
                        newMode: 'MCQ',
                        filepath: filepath,
                      );
                    }
                    Get.toNamed(
                      Routes.QUIZ,
                      arguments: {
                        'category': name,
                        'mode': 'MCQ',
                        'filepath': filepath,
                      },
                    );
                  } else {
                    _showComingSoonDialog(context, name);
                  }
                },
              ),
              SizedBox(height: 14.h),
              // True/False Mode Button
              _buildModeButton(
                title: 'True / False',
                subtitle: 'Test your quick decision making',
                icon: '⚡',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B074), Color(0xFF05D59E)],
                ),
                onTap: () async {
                  const String filepath = 'assets/quiz_json_file/program_tf.json';
                  final bool exists = await _doesAssetExist(context, filepath);
                  if (!context.mounted) return;
                  Get.back();
                  if (exists) {
                    if (Get.isRegistered<QuizController>()) {
                      Get.find<QuizController>().startQuiz(
                        newCategory: name,
                        newMode: 'TF',
                        filepath: filepath,
                      );
                    }
                    Get.toNamed(
                      Routes.QUIZ,
                      arguments: {
                        'category': name,
                        'mode': 'TF',
                        'filepath': filepath,
                      },
                    );
                  } else {
                    _showComingSoonDialog(context, name);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required String subtitle,
    required String icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20.r),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showQuizModeDialog(context),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: icon,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '20 questions',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
