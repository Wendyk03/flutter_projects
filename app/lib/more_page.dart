import 'package:app/Dictionary/service.dart';
import 'package:flutter/material.dart';
import 'package:app/Dictionary/dictionary_model.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "More Page Content",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Online Exam"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnlineExamPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flash_on),
              title: const Text("Flashcards"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FlashcardsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text("Exam Question Bank"),
              onTap: () {
                _showExamOptions(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Dictionary"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DictionaryHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text("English Books"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EnglishBooksPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExamOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Exam Level"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Primary School"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrimarySchoolPage()),
                  );
                },
              ),
              ListTile(
                title: const Text("SPM"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SPMPage()),
                  );
                },
              ),
              ListTile(
                title: const Text("STPM"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const STPMPage()),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

// Dictionary Home Page
class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  String noDataFound = "Now You Can Search";

  // Mock Text-to-Speech (TTS) function
  Future<void> _speak(String word) async {
    // This function would call Text-to-Speech in a real scenario
    print("Speaking: $word");
  }

  Future<void> searchWord(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Mock search result; replace with real API call
      myDictionaryModel = await APIservices.fetchData(word);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Search bar for user input
            TextField(
              decoration: InputDecoration(
                hintText: "Search the word here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchWord(value);
                }
              },
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const LinearProgressIndicator() // Show loading indicator
            else if (myDictionaryModel != null)
              // Display the dictionary results
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
                          onPressed: () => _speak(myDictionaryModel!.word),
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

  Widget showMeaning(Meaning meaning) {
    String wordDefinition = meaning.definitions
        .asMap()
        .entries
        .map((entry) => "${entry.key + 1}. ${entry.value.definition}")
        .join("\n");

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
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class OnlineExamPage extends StatelessWidget {
  const OnlineExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Online Exam")),
      body: const Center(child: Text("Online Exam Content")),
    );
  }
}

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: const Center(child: Text("Flashcards Content")),
    );
  }
}

class EnglishBooksPage extends StatelessWidget {
  const EnglishBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("English Books")),
      body: const Center(child: Text("English Books Content")),
    );
  }
}

class PrimarySchoolPage extends StatelessWidget {
  const PrimarySchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Primary School Exam Questions")),
      body: const Center(child: Text("Primary School Exam Questions Content")),
    );
  }
}

class SPMPage extends StatelessWidget {
  const SPMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SPM Exam Questions")),
      body: const Center(child: Text("SPM Exam Questions Content")),
    );
  }
}

class STPMPage extends StatelessWidget {
  const STPMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("STPM Exam Questions")),
      body: const Center(child: Text("STPM Exam Questions Content")),
    );
  }
}
