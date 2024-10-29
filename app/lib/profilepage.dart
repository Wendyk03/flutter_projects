import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "User";
  String _selectedCharacteristic = "Friendly"; // Example characteristic
  final List<String> _characteristics = ["Friendly", "Smart", "Creative", "Funny"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customize Your Avatar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _showAvatarOptions, // Show avatar customization options
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Username",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter username",
              ),
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Username: $_username",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              "Characteristics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedCharacteristic,
              items: _characteristics.map((characteristic) {
                return DropdownMenuItem<String>(
                  value: characteristic,
                  child: Text(characteristic),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCharacteristic = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text("Change Avatar Face"),
              onTap: () {
                // Add functionality to change avatar face here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("Change Avatar Color"),
              onTap: () {
                // Add functionality to change avatar color here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.style),
              title: const Text("Add Accessories"),
              onTap: () {
                // Add functionality to add avatar accessories here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    // Here you can save the username and characteristic updates
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );
  }
}
