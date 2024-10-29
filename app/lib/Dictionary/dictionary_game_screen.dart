import 'package:flutter/material.dart';
import 'dart:math';

class DictionaryGameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> flashcards;

  DictionaryGameScreen({required this.flashcards});

  @override
  _DictionaryGameScreenState createState() => _DictionaryGameScreenState();
}

class _DictionaryGameScreenState extends State<DictionaryGameScreen> {
  List<Map<String, dynamic>> gameFlashcards = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initializeGame());
  }

  Future<void> initializeGame() async {
    // Simulated delay if needed

    setState(() {
      gameFlashcards = widget.flashcards.length > 5
          ? widget.flashcards.sublist(0, 5)
          : List.from(widget.flashcards);
      gameFlashcards.shuffle();
      isLoading = false;
    });
  }

  void checkAnswer(String selectedAnswer) {
    if (isAnswered) return;
    setState(() {
      isAnswered = true;
      final correctAnswer = gameFlashcards[currentQuestionIndex]['synonyms'];
      if (correctAnswer.contains(selectedAnswer)) {
        score += 1;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < gameFlashcards.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
      });
    } else {
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your score is $score out of ${gameFlashcards.length}."),
        actions: [
          TextButton(
            child: Text("Restart"),
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
          ),
          TextButton(
            child: Text("Back"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      gameFlashcards.shuffle();
      isAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final word = gameFlashcards[currentQuestionIndex]['word'];
    final correctSynonym = gameFlashcards[currentQuestionIndex]['synonyms'][0];
    List<String> options = [correctSynonym];
    while (options.length < 4) {
      final randomWord =
          gameFlashcards[Random().nextInt(gameFlashcards.length)];
      final synonym = randomWord['synonyms'][0];
      if (!options.contains(synonym)) {
        options.add(synonym);
      }
    }
    options.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text("Synonym Match Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Word: $word",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Choose the synonym:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return ElevatedButton(
                  onPressed: () {
                    checkAnswer(option);
                    if (!isAnswered) nextQuestion();
                  },
                  child: Text(option),
                );
              },
            ),
            const Spacer(),
            if (isAnswered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text("Next"),
              ),
            Text("Score: $score", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
