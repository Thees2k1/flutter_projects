import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizler/Data/quises.dart';

import '../Model/questions.dart';

enum QuizView { landing, quizler, report }

class QuizController extends ChangeNotifier {
  QuizController._internal();

  final _quises = mockQuises;

  QuizView currentView = QuizView.landing;
  int currentQuizIndex = 0;
  int score = 0;

  String? error;
  bool pending = false;
  bool reachLastQuiz = false;

  static final QuizController _instance = QuizController._internal();
  static QuizController get instance => _instance;

  List<Quiz> getAllQuizesSync() {
    return _quises;
  }

  Quiz? getQuizById(int index) {
    bool isIndexOutOfRange = index >= _quises.length;
    if (isIndexOutOfRange) {
      error = "Quiz index out of range.";
      notifyListeners();
      scheduledClearError();
      return null;
    } else {
      return _quises[index];
    }
  }

  void nextQuiz() {
    if (currentQuizIndex + 1 >= _quises.length) {
      reachLastQuiz = true;
      goToView(QuizView.report);
      return;
    }

    currentQuizIndex++;
    notifyListeners();
  }

  bool checkAnswer({required int quizIndex, required String answer}) {
    final answeringQuiz = getQuizById(quizIndex);
    if (answeringQuiz == null) {
      return false;
    }
    return answeringQuiz.checkAnswer(answer);
  }

  void resetQuiz() {
    pending = true;

    currentQuizIndex = 0;
    error = null;

    notifyListeners();
  }

  void scheduledClearError() {
    Future.delayed(Duration(milliseconds: 1500), clearError);
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  void goToView(QuizView destination) {
    currentView = destination;
    notifyListeners();
  }

  void quitApp() {
    SystemNavigator.pop();
  }
}
