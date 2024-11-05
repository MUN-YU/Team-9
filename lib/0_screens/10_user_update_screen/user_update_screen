import 'package:flutter/material.dart';

class UserUpdateScreen extends StatefulWidget {
  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  String? _profileImageUrl;

  // This method simulates saving the user profile
  void _saveProfile() {
    // Add your API call or logic to save profile data here
    print('Nickname: ${_nicknameController.text}');
    print('Major: ${_majorController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 편집'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Placeholder for image picker functionality
                print('Profile image tapped');
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.edit, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _majorController,
              decoration: InputDecoration(
                labelText: '학과',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('저장하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
