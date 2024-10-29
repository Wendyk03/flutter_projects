import 'package:flutter/material.dart';

class FlashcardsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> flashcards;
  final Function(String) removeFlashcard;

  FlashcardsScreen({required this.flashcards, required this.removeFlashcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards"),
      ),
      body: flashcards.isEmpty
          ? Center(
              child: Text("No flashcards available"),
            )
          : ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flashcard['word'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Meaning: ${flashcard['meaning']}",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Synonyms: ${flashcard['synonyms']}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeFlashcard(flashcard['word']);
                              Navigator.of(context)
                                  .pop(); // Close the screen after deletion
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
