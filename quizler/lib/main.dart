import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';
import 'package:quizler/View/landing_view.dart';
import 'package:quizler/View/quizler_view.dart';
import 'package:quizler/View/report_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final quizController = QuizController.instance;

  final landingView = LandingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: quizController,
        builder: (context, child) {
          if (quizController.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(buildErrorSnackbar(context, quizController.error!));
          }

          if (quizController.currentView == QuizView.landing) {
            return landingView;
          } else if (quizController.currentView == QuizView.report) {
            return buildReportView(
              context,
              quizController.getAllQuizesSync().length,
              quizController.score,
            );
          } else {
            return QuizlerView();
          }
        },
      ),
    );
  }

  Widget buildReportView(
    BuildContext context,
    int totalQuestion,
    int totalCorectAnswer,
  ) {
    return ReportView(
      totalQuestion: totalQuestion,
      totalCorectAnswer: totalCorectAnswer,
      onBackToHome: () => quizController.goToView(QuizView.landing),
    );
  }

  SnackBar buildErrorSnackbar(BuildContext context, String errorMessage) {
    return SnackBar(
      content: Text(
        "Error message",
        style: TextStyle(color: Colors.red.shade900),
      ),
      backgroundColor: Colors.redAccent.withAlpha(20),
    );
  }
}
