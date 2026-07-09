import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/question_model.dart';

class QuizController extends GetxController {
  final List<Question> _questions = const [
    Question(
      questionText: 'Which programming language is used by Flutter?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Who developed the Flutter framework?',
      options: ['Apple', 'Microsoft', 'Facebook', 'Google'],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: 'What are the main building blocks of a Flutter UI?',
      options: ['Widgets', 'Activities', 'Views', 'Controllers'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which widget is used to execute asynchronous operations during initialization?',
      options: ['StatefulWidget', 'FutureBuilder', 'StreamBuilder', 'InheritedWidget'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What does MVVM stand for?',
      options: [
        'Model-View-ViewManager',
        'Model-View-ViewModel',
        'Module-View-ViewModel',
        'Model-Variable-ViewModel'
      ],
      correctAnswerIndex: 1,
    ),
  ];

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;

  // Search state for Categories selection tab
  final searchQuery = ''.obs;
  late final searchController = TextEditingController();

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int get score => _score;

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  bool get hasAnswered => _selectedAnswerIndex != null;

  void selectAnswer(int index) {
    if (hasAnswered) return;
    _selectedAnswerIndex = index;
    if (index == currentQuestion.correctAnswerIndex) {
      _score++;
    }
    update();
  }

  void nextQuestion() {
    if (!hasAnswered) return;
    _currentQuestionIndex++;
    _selectedAnswerIndex = null;
    update();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _score = 0;
    update();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
