import 'package:flutter/material.dart';
import '../../models/question.dart';

class ExamScreen extends StatefulWidget {
  final String title;
  final List<Question> questions;

  ExamScreen({required this.title, required this.questions});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  void _nextQuestion(bool isCorrect) {
    if (isCorrect) _score++;
    setState(() {
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= widget.questions.length) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Text(
              "Exam complete! Your score is $_score out of ${widget.questions.length}."),
        ),
      );
    }

    final question = widget.questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...question.options.asMap().entries.map((option) {
              int index = option.key;
              String answerText = option.value;
              return ElevatedButton(
                onPressed: () {
                  bool isCorrect = index == question.correctAnswerIndex;
                  _nextQuestion(isCorrect);
                },
                child: Text(answerText),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
