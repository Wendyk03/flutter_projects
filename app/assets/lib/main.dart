import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Asset Test')),
        body: FutureBuilder(
          future: loadJson(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(
                child: Text(
                  'Data loaded successfully: ${snapshot.data.toString()}',
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> loadJson() async {
    // Load and decode the JSON file
    final String response =
        await rootBundle.loadString('assets/words_dictionary.json');

    final data = jsonDecode(response);
    print(data); // This will print the loaded JSON data in the console
    return data; // Returning the decoded JSON data
  }
}
