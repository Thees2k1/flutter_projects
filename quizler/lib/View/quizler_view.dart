import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';

class QuizlerView extends StatelessWidget {
  const QuizlerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ElevatedButton(onPressed: submitResult, child: Text("Submit")),
      ),
    );
  }

  void submitResult() {
    QuizController.instance.goToView(QuizView.report);
  }
}
