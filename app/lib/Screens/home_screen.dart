import 'package:flutter/material.dart';
import 'exam_screen.dart';
import '../../../data/question_bank.dart';

class ExamBankHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exam Bank")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamScreen(
                        title: "SPM English",
                        questions: QuestionBank.getSPMEnglishQuestions()),
                  ),
                );
              },
              child: Text("SPM English"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamScreen(
                        title: "STPM MUET",
                        questions: QuestionBank.getMUETQuestions()),
                  ),
                );
              },
              child: Text("STPM MUET"),
            ),
          ],
        ),
      ),
    );
  }
}
