import 'package:flutter/material.dart';

class DailyChallengeScreen extends StatefulWidget {
  final int dailyGoal;

  DailyChallengeScreen({this.dailyGoal = 5});

  @override
  _DailyChallengeScreenState createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  int wordsLearnedToday = 0;

  void incrementWordsLearned() {
    setState(() {
      wordsLearnedToday++;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool goalReached = wordsLearnedToday >= widget.dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Challenge"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Today's Goal",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Learn ${widget.dailyGoal} new words",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              value: wordsLearnedToday / widget.dailyGoal,
              strokeWidth: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                  goalReached ? Colors.green : Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              "$wordsLearnedToday / ${widget.dailyGoal} words learned",
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: goalReached ? null : incrementWordsLearned,
              child: Text(goalReached ? "Goal Reached!" : "Add Word"),
            ),
          ],
        ),
      ),
    );
  }
}
