import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key, required this.isAuthenticated});

  final bool isAuthenticated;

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
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Card(
            margin: const EdgeInsets.all(16),

            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Text("Take the Quiz!"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    ElevatedButton(
                      onPressed: () => onPlayPressed(context),
                      style: ElevatedButton.styleFrom(
                        // shape: CircleBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                      ),
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
        ),
      ),
    );
  }

  void onPlayPressed(BuildContext context) {
    if (!isAuthenticated) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Authentication Required"),
            content: Text("Please login to continue."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    QuizController.instance.goToView(QuizView.quizler);
  }

  void onAppClosePressed() {
    QuizController.instance.quitApp();
  }
}
