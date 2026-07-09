import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';

class QuizTabView extends GetView<QuizController> {
  const QuizTabView({super.key});

  final List<CategoryModel> categories = const [
    CategoryModel(
      name: 'Programming',
      icon: Text('💻', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF0091FF), Color(0xFF00D2FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'General Knowledge',
      icon: Text('🌍', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'Science',
      icon: Text('🔬', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'Math',
      icon: Text('📐', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFFFF8000), Color(0xFFFF9E00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'English',
      icon: Text('📚', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFFF857A6), Color(0xFFFF5858)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'History',
      icon: Text('🏛️', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'Geography',
      icon: Text('🗺️', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF00B0FF), Color(0xFF0081CB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'Sports',
      icon: Text('⚽', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'Bangladesh',
      icon: Text('🇧🇩', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFFE52D27), Color(0xFFB31217)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CategoryModel(
      name: 'ICT',
      icon: Text('🖥️', style: TextStyle(fontSize: 26)),
      gradient: LinearGradient(
        colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          Text(
            'Quiz Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Pick a topic and challenge yourself',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.updateSearchQuery,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Search categories...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 20.r,
                ),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 18.r,
                          ),
                          onPressed: controller.clearSearch,
                        )
                      : const SizedBox.shrink(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Quiz Types Horizontal Grid List
          Text(
            'Quiz Types',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildQuizTypeCard(
                  title: 'MCQ',
                  icon: '🎯',
                  colors: [const Color(0xFF0075FF), const Color(0xFF00C2FF)],
                ),
                SizedBox(width: 12.w),
                _buildQuizTypeCard(
                  title: 'True/False',
                  icon: '✅',
                  colors: [const Color(0xFF00B074), const Color(0xFF05D59E)],
                ),
                SizedBox(width: 12.w),
                // _buildQuizTypeCard(
                //   title: 'Fill Blank',
                //   icon: '✏️',
                //   colors: [const Color(0xFFFF7E00), const Color(0xFFFFB200)],
                // ),
                // SizedBox(width: 12.w),
                // _buildQuizTypeCard(
                //   title: 'Image Quiz',
                //   icon: '🖼️',
                //   colors: [const Color(0xFFFF2D7A), const Color(0xFFFF739D)],
                // ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // All Categories Section
          Text(
            'All Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.h),

          // Reactive Filtered Category Grid
          Obx(() {
            final query = controller.searchQuery.value.toLowerCase().trim();
            final filtered = categories.where((cat) {
              final name = cat.name.toLowerCase();
              return name.contains(query);
            }).toList();

            if (filtered.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64.r,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No category matches "$query"',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: controller.clearSearch,
                        child: const Text(
                          'Clear Search',
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final category = filtered[index];
                return CategoryCard(
                  name: category.name,
                  icon: category.icon,
                  gradient: category.gradient,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuizTypeCard({
    required String title,
    required String icon,
    required List<Color> colors,
  }) {
    return Container(
      width: 78.w,
      height: 88.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.25),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: TextStyle(fontSize: 24.sp)),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
