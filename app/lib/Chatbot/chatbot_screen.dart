import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final String apiKey =
      'AIzaSyCc3iH8YeDf-cjgNOZGx5KNAplj3IuuIsQ'; // Replace with your actual API key

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": text});
    });

    _controller.clear();

    setState(() {
      messages.add({"sender": "bot", "text": "Generating response..."});
    });

    try {
      final botResponse = await _generateResponse(text);
      setState(() {
        messages.removeLast();
        messages.add({"sender": "bot", "text": botResponse});
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        messages.removeLast();
        messages.add({
          "sender": "bot",
          "text":
              "I'm having trouble generating a response. Please try again later."
        });
      });
    }
  }

  // Function to make the API request and get a response from the chatbot
  Future<String> _generateResponse(String userMessage) async {
    final prompt = _generatePrompt(userMessage);

    final response = await http.post(
      Uri.parse(
          "https://api.generativeai.googleapis.com/v1/models/gemini-1.5-pro:generate"), // Replace YOUR_MODEL_ID with the actual model ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "prompt": prompt,
        "maxTokens": 100, // Adjust this based on your needs
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['text'] ??
          "I'm sorry, I couldn't generate a response.";
    } else {
      log("Error: ${response.statusCode} - ${response.body}");
      return "I'm having trouble generating a response. Please try again.";
    }
  }

  // Helper method to generate the prompt for the chatbot
  String _generatePrompt(String userMessage) {
    return '''
You are an AI tutor specializing in e-learning. Provide a helpful and clear response to the following question or topic:
  
User: "$userMessage"
AI:
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Learning Chatbot"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'user';
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
