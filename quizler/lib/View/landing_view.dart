import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.deepOrange, Colors.redAccent],
          stops: [.1, .8, .9],
          transform: GradientRotation(pi / 2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text("Take the Quiz!"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .center,
              children: [
                ElevatedButton(
                  onPressed: onPlayPressed,
                  child: Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: onAppClosePressed,
                  child: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPlayPressed() {
    QuizController.instance.goToView(QuizView.quizler);
  }

  void onAppClosePressed() {
    QuizController.instance.quitApp();
  }
}
