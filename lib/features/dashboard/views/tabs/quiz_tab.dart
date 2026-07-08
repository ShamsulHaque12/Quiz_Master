import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../routes/app_pages.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Science',
      'icon': Icons.science_outlined,
      'color': Color(0xFF00E5FF),
      'questions': '15 Questions',
      'xp': '150 XP',
      'tag': 'HOT 🔥',
    },
    {
      'name': 'Technology',
      'icon': Icons.computer_outlined,
      'color': Color(0xFF6C63FF),
      'questions': '10 Questions',
      'xp': '100 XP',
      'tag': 'POPULAR',
    },
    {
      'name': 'History',
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFFFF8C00),
      'questions': '12 Questions',
      'xp': '120 XP',
      'tag': null,
    },
    {
      'name': 'Geography',
      'icon': Icons.public_outlined,
      'color': Color(0xFF00D2FF),
      'questions': '15 Questions',
      'xp': '150 XP',
      'tag': null,
    },
    {
      'name': 'Mathematics',
      'icon': Icons.calculate_outlined,
      'color': Color(0xFFFF2D55),
      'questions': '10 Questions',
      'xp': '100 XP',
      'tag': 'NEW ⚡',
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_soccer_outlined,
      'color': Color(0xFF4CD964),
      'questions': '12 Questions',
      'xp': '120 XP',
      'tag': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            'Quiz Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Choose a topic to test your knowledge',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
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
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: Colors.white.withValues(alpha: 0.6), size: 18.r),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Categories Grid (Filtered Reactively)
          Expanded(
            child: Obx(() {
              final query = controller.searchQuery.value.toLowerCase().trim();
              final filtered = categories.where((cat) {
                final name = cat['name'].toString().toLowerCase();
                return name.contains(query);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
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
                          style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14.h,
                  crossAxisSpacing: 14.w,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final category = filtered[index];
                  return _buildCategoryCard(
                    name: category['name'],
                    icon: category['icon'],
                    accentColor: category['color'],
                    questions: category['questions'],
                    xp: category['xp'],
                    tag: category['tag'],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color accentColor,
    required String questions,
    required String xp,
    required String? tag,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.QUIZ),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: accentColor, size: 22.r),
                ),
                // Tag Banner
                if (tag != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              questions,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            // XP Reward Indicator
            Row(
              children: [
                Icon(Icons.stars_rounded, color: const Color(0xFFFFD700), size: 14.r),
                SizedBox(width: 4.w),
                Text(
                  xp,
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 14.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
