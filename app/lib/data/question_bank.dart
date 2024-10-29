import '../models/question.dart';

class QuestionBank {
  static List<Question> getSPMEnglishQuestions() {
    return [
      Question(
        questionText: "What is the main idea of the passage?",
        options: [
          "Protecting the environment is challenging.",
          "Animals need more care.",
          "Climate change impacts are minimal.",
          "Technology solves environmental issues."
        ],
        correctAnswerIndex: 0,
      ),
      // Add more questions as needed
    ];
  }

  static List<Question> getMUETQuestions() {
    return [
      Question(
        questionText: "What is the main purpose of the passage?",
        options: [
          "To explain digital media's role in society",
          "To criticize digital media",
          "To compare digital and print media",
          "To discuss future communication technologies"
        ],
        correctAnswerIndex: 0,
      ),
      // Add more questions as needed
    ];
  }
}
