import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Text('📊', style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 8.w),
            Text(
              'Statistics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze your progress and performance metrics',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),

            // Timeframe Pill Selector
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: const Color(0xFF161233).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Obx(() {
                return Row(
                  children: controller.timeframes.map((timeframe) {
                    final isSelected = controller.selectedTimeframe.value == timeframe;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTimeframe(timeframe),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            timeframe,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                              fontSize: 12.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
            SizedBox(height: 24.h),

            // fl_chart Performance Chart Card
            Container(
              height: 270.h,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.015),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'XP Gained Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() => Text(
                        controller.selectedTimeframe.value == 'Daily'
                            ? 'Today\'s Activity'
                            : controller.selectedTimeframe.value == 'Weekly'
                                ? 'Weekly Sum'
                                : 'Monthly Trend',
                        style: TextStyle(
                          color: const Color(0xFF6C63FF),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  
                  // The fl_chart LineChart
                  Expanded(
                    child: Obx(() {
                      final chartPoints = controller.currentChartData;
                      
                      return LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.04),
                              strokeWidth: 1.2.w,
                              dashArray: [6, 6],
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 34.w,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 26.h,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= chartPoints.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Text(
                                      chartPoints[index].label,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.35),
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: const Color(0xFF161233),
                              tooltipRoundedRadius: 10.r,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toInt()} XP',
                                    TextStyle(
                                      color: const Color(0xFFFFD700),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartPoints.asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(), entry.value.value);
                              }).toList(),
                              isCurved: true,
                              barWidth: 3.5.r,
                              color: const Color(0xFF6C63FF),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) =>
                                    FlDotCirclePainter(
                                  radius: 4.r,
                                  color: const Color(0xFFFFD700),
                                  strokeColor: const Color(0xFF6C63FF),
                                  strokeWidth: 2.r,
                                ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF6C63FF).withValues(alpha: 0.25),
                                    const Color(0xFF6C63FF).withValues(alpha: 0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Performance Cards Grid (2x2)
            Text(
              'Performance Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14.h),

            Obx(() => GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.4,
              ),
              children: [
                _buildStatOverviewCard(
                  icon: '🎯',
                  title: 'Quizzes Played',
                  value: controller.totalQuizzes.value,
                  accentColor: const Color(0xFF3B82F6),
                ),
                _buildStatOverviewCard(
                  icon: '🔥',
                  title: 'Avg. Accuracy',
                  value: controller.avgAccuracy.value,
                  accentColor: const Color(0xFFEF4444),
                ),
                _buildStatOverviewCard(
                  icon: '⚡',
                  title: 'Total XP Gained',
                  value: controller.totalXP.value,
                  accentColor: const Color(0xFFFFD700),
                ),
                _buildStatOverviewCard(
                  icon: '🪙',
                  title: 'Total Coins',
                  value: controller.totalCoins,
                  accentColor: const Color(0xFF10B981),
                ),
              ],
            )),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatOverviewCard({
    required String icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 18.sp),
              ),
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
