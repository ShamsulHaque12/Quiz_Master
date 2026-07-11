import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../data/models/question_model.dart';
import '../../profile/controllers/profile_controller.dart';

class QuizController extends GetxController {
  final AssetBundle? assetBundle;

  QuizController({this.assetBundle});

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;

  // Dynamic parameters
  String category = 'Programming';
  String mode = 'MCQ';
  bool isLoading = true;
  DateTime? quizStartedAt;

  // Track skipped & wrong answers
  int wrongAnswers = 0;
  int skippedAnswers = 0;

  // Search state for Categories selection tab
  final searchQuery = ''.obs;
  late final searchController = TextEditingController();

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int get score => _score;

  Question get currentQuestion => _questions.isNotEmpty
      ? _questions[_currentQuestionIndex]
      : const Question(questionText: '', options: [], correctAnswerIndex: 0);

  bool get isQuizFinished =>
      _questions.isNotEmpty && _currentQuestionIndex >= _questions.length;
  bool get hasAnswered => _selectedAnswerIndex != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      category = args['category'] ?? 'Programming';
      mode = args['mode'] ?? 'MCQ';
    }
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    isLoading = true;
    update();

    try {
      final bool isMcq =
          mode.toUpperCase() == 'MCQ' || mode.toLowerCase().contains('option');
      String prefix = category.toLowerCase().replaceAll(' ', '_');
      if (prefix.contains('program')) {
        prefix = 'program';
      } else if (prefix.contains('general') || prefix.contains('genarel')) {
        prefix = 'genarel';
      }
      final String modeSuffix = isMcq ? 'option' : 'tf';
      final String filepath =
          'assets/quiz_json_file/${prefix}_$modeSuffix.json';

      final AssetBundle bundle = assetBundle ?? rootBundle;
      final String response = await bundle.loadString(filepath);
      final List<dynamic> jsonList = json.decode(response);

      List<Question> allQuestions = [];
      for (var jsonItem in jsonList) {
        final String questionText = jsonItem['question'] ?? '';
        List<String> options = [];
        int correctAnswerIndex = 0;

        if (isMcq) {
          final rawOptions = jsonItem['options'] as List<dynamic>?;
          if (rawOptions != null) {
            options = rawOptions.map((e) => e.toString()).toList();
          }
          final dynamic rawAnswer =
              jsonItem['correct_answer'] ?? jsonItem['answer'];
          if (rawAnswer is int) {
            correctAnswerIndex = rawAnswer;
          } else {
            final String answerStr = rawAnswer?.toString() ?? '';
            correctAnswerIndex = options.indexOf(answerStr);
            if (correctAnswerIndex == -1) {
              final parsed = int.tryParse(answerStr);
              if (parsed != null && parsed >= 0 && parsed < options.length) {
                correctAnswerIndex = parsed;
              } else {
                correctAnswerIndex = 0;
              }
            }
          }
        } else {
          // True/False Mode
          options = ['True', 'False'];
          final dynamic ans = jsonItem['answer'];
          if (ans is bool) {
            correctAnswerIndex = ans ? 0 : 1;
          } else {
            correctAnswerIndex = (ans.toString().toLowerCase() == 'true')
                ? 0
                : 1;
          }
        }

        allQuestions.add(
          Question(
            questionText: questionText,
            options: options,
            correctAnswerIndex: correctAnswerIndex,
          ),
        );
      }

      // Shuffle and take 30 random questions
      allQuestions.shuffle();
      _questions = allQuestions.take(30).toList();
    } catch (e) {
      log('Error loading quiz questions: $e');
      // Fallback
      _questions = [
        const Question(
          questionText: 'Which programming language is used by Flutter?',
          options: ['Java', 'Kotlin', 'Dart', 'Swift'],
          correctAnswerIndex: 2,
        ),
      ];
    } finally {
      isLoading = false;
      _currentQuestionIndex = 0;
      _selectedAnswerIndex = null;
      _score = 0;
      wrongAnswers = 0;
      skippedAnswers = 0;
      quizStartedAt = DateTime.now();
      update();
    }
  }

  void selectAnswer(int index) {
    if (hasAnswered) return;
    _selectedAnswerIndex = index;
    if (index == currentQuestion.correctAnswerIndex) {
      _score++;
    } else {
      wrongAnswers++;
    }
    update();
  }

  void skipQuestion() {
    if (hasAnswered) return;
    _selectedAnswerIndex = -1; // -1 represents skipped
    skippedAnswers++;
    update();
  }

  void nextQuestion() {
    if (!hasAnswered) return;
    _currentQuestionIndex++;
    _selectedAnswerIndex = null;
    update();

    if (isQuizFinished) {
      _showQuizResultDialog();
    }
  }

  void resetQuiz() {
    loadQuestions();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  void _showQuizResultDialog() {
    final correct = score;
    final wrong = wrongAnswers;
    final skipped = skippedAnswers;
    final total = correct + wrong + skipped;

    final earnedScore = correct * 10;
    final earnedXP = correct * 15;
    final earnedCoins = correct * 5;

    final double computedAccuracy = total > 0 ? (correct / total) * 100 : 0.0;

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF161233),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text('🏆', style: TextStyle(fontSize: 48.sp)),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Here is your professional breakdown:',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),

                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDialogMetricRow(
                        label: 'Total Questions',
                        value: '$total',
                        icon: '📋',
                        valueColor: Colors.white,
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 24.h,
                      ),
                      _buildDialogMetricRow(
                        label: 'Total Correct',
                        value: '$correct',
                        icon: '✅',
                        valueColor: const Color(0xFF00B074),
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 24.h,
                      ),
                      _buildDialogMetricRow(
                        label: 'Total Wrong',
                        value: '$wrong',
                        icon: '❌',
                        valueColor: const Color(0xFFFF5252),
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 24.h,
                      ),
                      _buildDialogMetricRow(
                        label: 'Total Skip',
                        value: '$skipped',
                        icon: '⏭️',
                        valueColor: const Color(0xFFFFB200),
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 24.h,
                      ),
                      _buildDialogMetricRow(
                        label: 'Accuracy',
                        value: '${computedAccuracy.toStringAsFixed(1)}%',
                        icon: '🎯',
                        valueColor: const Color(0xFF00D2FF),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                ElevatedButton(
                  onPressed: () async {
                    if (Get.isRegistered<ProfileController>()) {
                      final profile = Get.find<ProfileController>();
                      final completedAt = DateTime.now();
                      final startedAt = quizStartedAt ?? completedAt;

                      await profile.recordQuizAttempt(
                        category: category,
                        totalQuestion: total,
                        correct: correct,
                        wrong: wrong,
                        skip: skipped,
                        score: earnedScore,
                        xp: earnedXP,
                        coin: earnedCoins,
                        accuracy: computedAccuracy,
                        startedAt: startedAt,
                        completedAt: completedAt,
                      );

                      await profile.updateUserStats(
                        addedScore: earnedScore,
                        addedXP: earnedXP,
                        addedCoins: earnedCoins,
                      );
                    }
                    Get.back(); // close dialog
                    Get.back(); // go to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Claim Rewards & Go Home',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildDialogMetricRow({
    required String label,
    required String value,
    required String icon,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
