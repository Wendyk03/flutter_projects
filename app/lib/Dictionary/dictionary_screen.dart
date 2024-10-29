import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart' as tts;
import 'package:app/Dictionary/dictionary_model.dart';
import 'package:app/Dictionary/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'dictionary_game_screen.dart';
import 'daily_challenge_screen.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  String noDataFound = " Now You Can Search";
  final tts.FlutterTts flutterTts = tts.FlutterTts(); // TTS instance
  bool isSpeaking = false;
  double speechRate = 0.5;
  double volume = 1.0;
  List<String> searchHistory = []; // List to store search history
  List<Map<String, dynamic>> flashcards =
      []; // List to store flashcards with word, meaning, and synonyms

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _loadFlashcards(); // Load flashcards on app start
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop TTS when the widget is disposed
    super.dispose();
  }

  Future<void> _speak(String word) async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(speechRate);
      await flutterTts.setVolume(volume);
      await flutterTts.speak(word);
    } catch (e) {
      print("Error in TTS: $e");
    } finally {
      setState(() {
        isSpeaking = false;
      });
    }
  }

  Future<void> _saveSearchHistory(String word) async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory.insert(0, word); // Add word to history at the beginning
    await prefs.setStringList('searchHistory', searchHistory);
    setState(() {}); // Refresh the UI
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      searchHistory.clear(); // Clear the local list
    });
  }

  Future<void> _addToFlashcards(String word) async {
    if (myDictionaryModel != null) {
      final prefs = await SharedPreferences.getInstance();
      // Extract meaning and synonyms for the word
      final meaning = myDictionaryModel!.meanings.isNotEmpty
          ? myDictionaryModel!.meanings[0].definitions[0].definition
          : "No meaning available";
      final synonyms = myDictionaryModel!.meanings[0].synonyms.isNotEmpty
          ? myDictionaryModel!.meanings[0].synonyms.join(", ")
          : "No synonyms available";

      // Create a flashcard entry with word, meaning, and synonyms
      final flashcard = {
        'word': word,
        'meaning': meaning,
        'synonyms': synonyms,
      };

      // Check if flashcard already exists
      if (!flashcards.any((card) => card['word'] == word)) {
        flashcards.add(flashcard); // Add flashcard if it doesn't already exist
        await prefs.setString(
            'flashcards', jsonEncode(flashcards)); // Save to shared_preferences
        setState(() {}); // Refresh the UI
      }
    }
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final flashcardData = prefs.getString('flashcards');
    if (flashcardData != null) {
      setState(() {
        flashcards = List<Map<String, dynamic>>.from(jsonDecode(flashcardData));
      });
    }
  }

  Future<void> _removeFromFlashcards(String word) async {
    final prefs = await SharedPreferences.getInstance();
    flashcards.removeWhere((flashcard) => flashcard['word'] == word);
    await prefs.setString(
        'flashcards', jsonEncode(flashcards)); // Update shared_preferences
    setState(() {}); // Refresh the UI
  }

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      myDictionaryModel = await APIservices.fetchData(word);
      _saveSearchHistory(word); // Save word to history after successful fetch
      setState(() {});
    } catch (e) {
      myDictionaryModel = null;
      noDataFound = "Meaning can't be found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearSearchHistory,
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardsScreen(
                    flashcards: flashcards,
                    removeFlashcard: _removeFromFlashcards,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DictionaryGameScreen(flashcards: flashcards),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.flag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyChallengeScreen(dailyGoal: 5),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Drawer for displaying search history
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                "Search History",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchHistory[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addToFlashcards(
                          searchHistory[index]), // Add to flashcards
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      searchContain(
                          searchHistory[index]); // Search again on tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Search bar
            SearchBar(
              hintText: "Search the word here",
              onSubmitted: (value) {
                searchContain(value);
              },
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const LinearProgressIndicator()
            else if (myDictionaryModel != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          myDictionaryModel!.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () =>
                              _speak(myDictionaryModel!.word), // Pronounce word
                        ),
                      ],
                    ),
                    Text(
                      myDictionaryModel!.phonetics.isNotEmpty
                          ? myDictionaryModel!.phonetics[0].text ?? ""
                          : "",
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: myDictionaryModel!.meanings.length,
                        itemBuilder: (context, index) {
                          return showMeaning(
                              myDictionaryModel!.meanings[index]);
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  noDataFound,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    String wordDefinition = "";
    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      wordDefinition += "\n${index + 1}.${element.definition}\n";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Definitions: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                wordDefinition,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1,
                ),
              ),
              wordRelation("Synonyms", meaning.synonyms),
              wordRelation("Antonyms", meaning.antonyms),
            ],
          ),
        ),
      ),
    );
  }

  wordRelation(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

// Flashcards Screen with detailed flashcards
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
