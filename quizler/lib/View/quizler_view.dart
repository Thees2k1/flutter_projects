import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';
import 'package:quizler/Model/questions.dart';

class QuizlerView extends StatefulWidget {
  const QuizlerView({super.key, this.quiz, this.onAnswered});

  final void Function(String answer)? onAnswered;
  final Quiz? quiz;

  @override
  State<QuizlerView> createState() => _QuizlerViewState();
}

class _QuizlerViewState extends State<QuizlerView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            QuizText(widget.quiz?.question ?? ''),
            TrueFalseAnswerButtonsGroup(
              onAnswered: (answer) {
                widget.onAnswered?.call(answer);
              },
            ),
          ],
        ),
      ),
    );
  }

  void submitResult() {
    QuizController.instance.goToView(QuizView.report);
  }
}

class TrueFalseAnswerButtonsGroup extends StatelessWidget {
  const TrueFalseAnswerButtonsGroup({super.key, this.onAnswered});

  final void Function(String answer)? onAnswered;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => onAnswered?.call('True'),
          child: Text('True'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => onAnswered?.call('False'),
          child: Text('False'),
        ),
      ],
    );
  }
}

class QuizText extends StatelessWidget {
  const QuizText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
