import 'package:flutter/material.dart';
import 'package:app/more_page.dart';
import 'package:app/profilepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab

  // List of widgets to display for each tab
  final List<Widget> _pages = [
    const HomePageContent(),
    const ProfilePage(), // Updated to use ProfilePage
    const Center(child: Text("Settings Page Content")),
    const MorePage(), // Use MorePage from the more_page folder
  ];

  // List to store chatbot messages
  final List<String> _chatMessages = [];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Show the chatbot modal bottom sheet
  void _showChatbotModal() {
    // Add the introductory message only if it's not already in the list
    if (_chatMessages.isEmpty) {
      _chatMessages.add(
          "Hi! I am the chatbot that will help you in your journey of learning English");
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Chatbot",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: Text(_chatMessages[index]),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onSubmitted: (message) {
                          if (message.isNotEmpty) {
                            setState(() {
                              _chatMessages.add(message);
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // Add functionality to handle message send if needed
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: _pages[_selectedIndex], // Display the selected page content
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "More",
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the selected item
        onTap: _onItemTapped, // Update the index when tapped
        selectedItemColor: Theme.of(context).primaryColor, // Highlight color
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showChatbotModal,
        tooltip: "Chatbot",
        backgroundColor:
            Theme.of(context).primaryColor, // Show chatbot modal on press
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Bottom right
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 50,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(Icons.star, color: Colors.amber.shade600),
            title: Text("Level ${index + 1}"),
            subtitle: const Text("Unlock new words and phrases!"),
            trailing: const Icon(Icons.lock_open),
            onTap: () {
              // Add functionality for when a level is tapped
            },
          ),
        );
      },
    );
  }
}
