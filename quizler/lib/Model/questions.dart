class Quiz {
  const Quiz({required String q, required String a}) : question = q, answer = a;

  final String question;
  final String answer;

  bool checkAnswer(String userAnswer) {
    return answer == userAnswer;
  }
}
