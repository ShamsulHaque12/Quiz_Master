import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/daily_spin_controller.dart';

class DailySpinView extends StatefulWidget {
  const DailySpinView({super.key});

  @override
  State<DailySpinView> createState() => _DailySpinViewState();
}

class _DailySpinViewState extends State<DailySpinView> with TickerProviderStateMixin {
  final controller = Get.find<DailySpinController>();
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _spinAnimation;
  double _currentRotation = 0.0;

  @override
  void initState() {
    super.initState();
    // Spin animation controller
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    );

    // Pulse animation controller for the GO center button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (controller.isSpinning.value || !controller.canSpin.value) return;

    _pulseController.stop(); // Stop pulsing during spin
    final targetIndex = controller.calculateSpinResult();
    
    // Math to align the target slice center directly to the top pointer (-pi / 2)
    final sliceAngle = 2 * pi / controller.prizes.length;
    final targetCenterAngle = (targetIndex * sliceAngle) + (sliceAngle / 2);
    
    final double fullSpins = 8 * 2 * pi; // 8 full spins for speed
    final double targetRotation = fullSpins + (1.5 * pi - targetCenterAngle);

    _spinAnimation = Tween<double>(
      begin: _currentRotation % (2 * pi),
      end: targetRotation,
    ).animate(
      CurvedAnimation(
        parent: _spinController,
        curve: Curves.easeOutCubic,
      ),
    );

    _spinController.reset();
    _spinController.forward().then((_) async {
      _currentRotation = targetRotation;
      await controller.rewardUser(targetIndex);
      _pulseController.repeat(reverse: true); // Resume pulsing
      _showRewardDialog(controller.prizes[targetIndex]);
    });
  }

  void _showRewardDialog(SpinSlice prize) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: const Color(0xFF141129),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Color(prize.colorHex).withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(prize.colorHex).withValues(alpha: 0.15),
                blurRadius: 30.r,
                spreadRadius: 2.r,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glow light effect behind emoji
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(prize.colorHex).withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(prize.colorHex).withValues(alpha: 0.35),
                          blurRadius: 24.r,
                          spreadRadius: 2.r,
                        )
                      ],
                    ),
                  ),
                  Text(
                    prize.isMiss ? '😢' : (prize.isCoins ? '🪙' : prize.isXp ? '⚡' : '✨'),
                    style: TextStyle(fontSize: 48.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              
              Text(
                prize.isMiss ? 'Aww, Unlucky!' : 'Woohoo! You Won!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8.h),
              
              Text(
                prize.isMiss 
                    ? 'The wheel landed on Miss. Try again tomorrow!' 
                    : 'Your reward of ${prize.label} has been successfully added to your inventory.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),

              // Claim button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(prize.colorHex), Color(prize.colorHex).withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(prize.colorHex).withValues(alpha: 0.35),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    prize.isMiss ? 'Close' : 'CLAIM NOW',
                    style: TextStyle(
                      color: prize.colorHex == 0xFF6B7280 ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A071E), // Ultra-premium space dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Text('🎡', style: TextStyle(fontSize: 22.sp)),
            SizedBox(width: 8.w),
            Text(
              'Daily Spin',
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            Text(
              'Spin once per day for free rewards!',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32.h),

            // Animated Spin Wheel Stack
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Glowing radial background behind the wheel
                Container(
                  width: 250.r,
                  height: 250.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                        blurRadius: 60.r,
                        spreadRadius: 10.r,
                      ),
                    ],
                  ),
                ),

                // Rotating Wheel custom painter
                AnimatedBuilder(
                  animation: _spinAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _spinAnimation.value,
                      child: SizedBox(
                        width: 275.r,
                        height: 275.r,
                        child: CustomPaint(
                          painter: WheelPainter(prizes: controller.prizes),
                        ),
                      ),
                    );
                  },
                ),
                
                // Static Top Pointer (White/Gold Triangle)
                Positioned(
                  top: -12.h,
                  child: CustomPaint(
                    size: Size(24.w, 22.h),
                    painter: PointerPainter(),
                  ),
                ),

                // Pulsing Center GO Button
                Obx(() => ScaleTransition(
                  scale: controller.canSpin.value
                      ? Tween<double>(begin: 0.96, end: 1.04).animate(
                          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                        )
                      : const AlwaysStoppedAnimation(1.0),
                  child: GestureDetector(
                    onTap: (controller.isSpinning.value || !controller.canSpin.value) ? null : _spinWheel,
                    child: Container(
                      width: 58.r,
                      height: 58.r,
                      decoration: BoxDecoration(
                        gradient: controller.canSpin.value
                            ? const LinearGradient(
                                colors: [Color(0xFF1E1B4B), Color(0xFF0F0C20)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [Colors.grey[800]!, Colors.grey[900]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.canSpin.value ? const Color(0xFFFFD700) : Colors.grey,
                          width: 2.5.r,
                        ),
                        boxShadow: [
                          if (controller.canSpin.value)
                            BoxShadow(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                              blurRadius: 12.r,
                              spreadRadius: 1.r,
                            ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.canSpin.value ? 'GO!' : 'WAIT',
                        style: TextStyle(
                          color: controller.canSpin.value ? const Color(0xFFFFD700) : Colors.grey[400],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(height: 38.h),

             // SPIN NOW Button
             Obx(() => SizedBox(
               width: double.infinity,
               child: Container(
                 decoration: BoxDecoration(
                   gradient: (controller.isSpinning.value || !controller.canSpin.value)
                       ? null
                       : const LinearGradient(
                           colors: [Color(0xFFFF8000), Color(0xFFFF9E00)],
                           begin: Alignment.topLeft,
                           end: Alignment.bottomRight,
                         ),
                   color: (controller.isSpinning.value || !controller.canSpin.value)
                       ? Colors.white.withValues(alpha: 0.08)
                       : null,
                   borderRadius: BorderRadius.circular(20.r),
                   border: (controller.isSpinning.value || !controller.canSpin.value)
                       ? Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.2)
                       : null,
                   boxShadow: (controller.isSpinning.value || !controller.canSpin.value)
                       ? null
                       : [
                           BoxShadow(
                             color: const Color(0xFFFF8000).withValues(alpha: 0.35),
                             blurRadius: 16.r,
                             offset: Offset(0, 4.h),
                           ),
                         ],
                 ),
                 child: ElevatedButton.icon(
                   onPressed: (controller.isSpinning.value || !controller.canSpin.value) ? null : _spinWheel,
                   icon: Text('🎡', style: TextStyle(fontSize: 16.sp)),
                   label: Text(
                     controller.isSpinning.value
                         ? 'SPINNING...'
                         : (!controller.canSpin.value
                             ? 'NEXT SPIN IN: ${controller.remainingTime.value}'
                             : 'SPIN NOW!'),
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 15.sp,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.transparent,
                     shadowColor: Colors.transparent,
                     padding: EdgeInsets.symmetric(vertical: 15.h),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20.r),
                     ),
                   ),
                 ),
               ),
             )),
            SizedBox(height: 24.h),

            // Streak Bonus Rewards
            Container(
              width: double.infinity,
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
                      Row(
                        children: [
                          Text('🔥', style: TextStyle(fontSize: 14.sp)),
                          SizedBox(width: 8.w),
                          Text(
                            'Streak Bonus Rewards',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.canClaimStreak.value) {
                          return GestureDetector(
                            onTap: controller.claimDailyStreak,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'CLAIM TODAY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Obx(() => Row(
                      children: controller.dynamicStreakDays.map((day) {
                        final isCompleted = day['isCompleted'] as bool;
                        final isClaimable = day['isClaimable'] as bool;
                        final dayNum = day['day'] as String;
                        final type = day['type'] as String;
                        final reward = day['reward'] as String;
                        
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: GestureDetector(
                            onTap: isClaimable ? controller.claimDailyStreak : null,
                            child: Container(
                              width: 56.w,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isCompleted 
                                    ? const Color(0xFF6C63FF).withValues(alpha: 0.12)
                                    : (isClaimable 
                                        ? const Color(0xFFFF8000).withValues(alpha: 0.15)
                                        : Colors.white.withValues(alpha: 0.015)),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isCompleted
                                      ? const Color(0xFF6C63FF).withValues(alpha: 0.3)
                                      : (isClaimable
                                          ? const Color(0xFFFF8000).withValues(alpha: 0.6)
                                          : Colors.white.withValues(alpha: 0.04)),
                                  width: 1.2,
                                ),
                                boxShadow: isClaimable
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFF8000).withValues(alpha: 0.2),
                                          blurRadius: 8.r,
                                          spreadRadius: 1.r,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Day',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.35),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    dayNum,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Icon(
                                    type == 'xp' ? Icons.bolt_rounded : Icons.monetization_on_rounded,
                                    color: isCompleted 
                                        ? (type == 'xp' ? const Color(0xFF3B82F6) : const Color(0xFFFFD700))
                                        : (isClaimable
                                            ? (type == 'xp' ? const Color(0xFF3B82F6) : const Color(0xFFFFD700))
                                            : Colors.white.withValues(alpha: 0.2)),
                                    size: 16.r,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    reward,
                                    style: TextStyle(
                                      color: (isCompleted || isClaimable) ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Prize Pool Card Grid
            Container(
              width: double.infinity,
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
                    children: [
                      Text('🎁', style: TextStyle(fontSize: 14.sp)),
                      SizedBox(width: 8.w),
                      Text(
                        'Prize Pool',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.prizes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 3.4,
                    ),
                    itemBuilder: (context, index) {
                      final prize = controller.prizes[index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.015),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Color(prize.colorHex).withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Show beautiful mini icon instead of dot
                            Text(
                              prize.isMiss ? '❌' : (prize.isCoins ? '🪙' : prize.isXp ? '⚡' : '✨'),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              prize.label,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<SpinSlice> prizes;

  WheelPainter({required this.prizes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final sweepAngle = 2 * pi / prizes.length;

    // Draw Slices
    for (int i = 0; i < prizes.length; i++) {
      final slice = prizes[i];
      final startAngle = i * sweepAngle;

      // Draw Slice Sector
      final paint = Paint()
        ..color = Color(slice.colorHex)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // Draw Slice divider line
      final linePaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8.w;
      canvas.drawArc(rect, startAngle, sweepAngle, true, linePaint);

      // Draw Slice Label Text
      final textAngle = startAngle + sweepAngle / 2;
      canvas.save();
      
      canvas.translate(center.dx, center.dy);
      canvas.rotate(textAngle);
      
      final textSpan = TextSpan(
        text: slice.label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 4.r,
              offset: const Offset(0, 1),
            )
          ],
        ),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      // Place the text radially near the perimeter
      canvas.translate(radius * 0.52, -textPainter.height / 2);
      
      // Draw text horizontally on rotated coordinates
      textPainter.paint(canvas, Offset.zero);
      
      canvas.restore();
    }

    // Draw a premium outer ring
    final outerRingPaint = Paint()
      ..color = const Color(0xFF161233)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.r;
    canvas.drawCircle(center, radius + 7.r, outerRingPaint);

    final goldBorderPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8.r;
    canvas.drawCircle(center, radius + 14.r, goldBorderPaint);
    canvas.drawCircle(center, radius, goldBorderPaint);

    // Draw 24 glowing gold indicator dots around the outer ring rim
    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    for (int j = 0; j < 24; j++) {
      final dotAngle = j * (2 * pi / 24);
      final dotOffset = Offset(
        center.dx + (radius + 7.r) * cos(dotAngle),
        center.dy + (radius + 7.r) * sin(dotAngle),
      );
      canvas.drawCircle(dotOffset, 2.5.r, dotPaint);
    }

    // Glossy radial reflection overlay
    final glossPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.16), Colors.transparent],
        stops: const [0.0, 0.85],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, glossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Draw shadow
    canvas.drawPath(
      path.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.r),
    );

    canvas.drawPath(path, paint);
    
    // Draw a small red indicator tip
    final innerPath = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width / 2, size.height * 0.5)
      ..close();
    canvas.drawPath(
      innerPath,
      Paint()..color = const Color(0xFFFF4B5C),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
