import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/option_card.dart';
import '../widgets/score_gauge.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      body: Stack(
        children: [
          // Background decorative gradient glow
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                    blurRadius: 100.r,
                    spreadRadius: 50.r,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D2FF).withOpacity(0.12),
                    blurRadius: 80.r,
                    spreadRadius: 40.r,
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: GetBuilder<QuizController>(
              builder: (_) {
                if (controller.isQuizFinished) {
                  return _buildResultScreen();
                }
                return _buildQuizScreen();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final question = controller.currentQuestion;
    final totalQuestions = controller.questions.length;
    final progress = (controller.currentQuestionIndex + 1) / totalQuestions;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Quiz Master',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${controller.currentQuestionIndex + 1} of $totalQuestions',
                  style: TextStyle(
                    color: const Color(0xFF00D2FF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Linear Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 35.h),

          // Question Card
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.5,
              ),
            ),
            child: Text(
              question.questionText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 30.h),

          // Options List
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                  question.options.length,
                  (index) {
                    final isSelected = controller.selectedAnswerIndex == index;
                    final isCorrect = index == question.correctAnswerIndex;
                    return OptionCard(
                      optionText: question.options[index],
                      isSelected: isSelected,
                      isCorrect: isCorrect,
                      hasAnswered: controller.hasAnswered,
                      onTap: () => controller.selectAnswer(index),
                    );
                  },
                ),
              ),
            ),
          ),

          // Action Button (Next Question)
          AnimatedOpacity(
            opacity: controller.hasAnswered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: ElevatedButton(
                onPressed: controller.hasAnswered ? controller.nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF6C63FF).withOpacity(0.4),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0xFF6C63FF).withOpacity(0.3),
                ),
                child: Text(
                  controller.currentQuestionIndex == totalQuestions - 1
                      ? 'View Results'
                      : 'Next Question',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final score = controller.score;
    final total = controller.questions.length;
    final percentage = total > 0 ? (score / total) * 100 : 0.0;

    String feedbackTitle;
    String feedbackSubtitle;
    IconData feedbackIcon;
    Color feedbackColor;

    if (percentage >= 80.0) {
      feedbackTitle = 'Outstanding!';
      feedbackSubtitle = 'You are a true Flutter champion!';
      feedbackIcon = Icons.emoji_events_rounded;
      feedbackColor = Colors.amber;
    } else if (percentage >= 50.0) {
      feedbackTitle = 'Good Job!';
      feedbackSubtitle = 'Keep practicing and you\'ll get there.';
      feedbackIcon = Icons.thumb_up_alt_rounded;
      feedbackColor = const Color(0xFF00D2FF);
    } else {
      feedbackTitle = 'Keep Trying!';
      feedbackSubtitle = 'Failure is simply the opportunity to begin again.';
      feedbackIcon = Icons.refresh_rounded;
      feedbackColor = const Color(0xFFFF6C6C);
    }

    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // Celebration Icon
          Icon(
            feedbackIcon,
            size: 80.r,
            color: feedbackColor,
          ),
          SizedBox(height: 24.h),
          Text(
            feedbackTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            feedbackSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 48.h),

          // Animated gauge
          Center(
            child: ScoreGauge(
              score: score,
              totalQuestions: total,
            ),
          ),

          const Spacer(),

          // Replay Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF00D2FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 15.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.resetQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_rounded, color: Colors.white, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Restart Quiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
