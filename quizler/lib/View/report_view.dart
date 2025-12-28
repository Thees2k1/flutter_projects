import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  const ReportView({
    super.key,
    required this.totalQuestion,
    required this.totalCorectAnswer,
    this.onBackToHome,
    this.onTryAgain,
  }) : assert(
         totalCorectAnswer <= totalQuestion,
         "The total correct answer must be equal or less then the total given questions",
       );

  final int totalQuestion;
  final int totalCorectAnswer;

  final VoidCallback? onTryAgain;

  final VoidCallback? onBackToHome;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You have correctly answered $totalCorectAnswer outta $totalQuestion questions",
            ),
            const SizedBox(height: 4),
            Text(_getFeedbackString()),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onTryAgain,
                  child: Icon(Icons.replay),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onBackToHome,
                  child: Icon(Icons.home),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFeedbackString() {
    final point = (totalCorectAnswer / totalQuestion);
    late final String feedback;
    if (point < 0.2) {
      feedback = "You really sucks, try again sometimes :(.";
    } else if (point < 0.5) {
      feedback = "You could do better, believe that!";
    } else if (totalQuestion < 0.8) {
      feedback = "Good job, It worth to try again.";
    } else {
      feedback = "Well done, you really did you homework didn't ya";
    }

    return feedback;
  }
}
