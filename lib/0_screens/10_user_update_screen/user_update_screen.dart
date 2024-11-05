import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../_mypage/my_page_screen.dart';

class UserUpdateScreen extends StatefulWidget {
  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  String? _profileImageUrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/mypage');
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU"
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _profileImageUrl = data['content']['profileImage'];
          _nicknameController.text = data['content']['name'] ?? '';
          _majorController.text = data['content']['major'] ?? '';
        });
      } else {
        print('Failed to load profile data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/profile');
    var request = http.MultipartRequest('PATCH', url)
      ..headers['Authorization'] =
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU"
      ..fields['name'] = _nicknameController.text
      ..fields['major'] = _majorController.text;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        _selectedImage!.path,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _profileImageUrl = _selectedImage?.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 업데이트 완료')),
        );
        Navigator.pop(context); // 현재 화면을 닫음
      } else {
        print('Failed to save profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('assets/images/profile_image.png')
                            as ImageProvider,
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
                hintText: '현재 닉네임: ${_nicknameController.text}',
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
                hintText: '현재 학과: ${_majorController.text}',
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
