import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../_mypage/my_page_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _selectedMajor;

  final List<String> majors = [
    "화학공학/고분자시스템공학부",
    "신소재공학부",
    "기계공학부",
    "건설환경공학부",
    "시스템경영공학과",
    "나노공학과",
    "식품생명공학과",
    "바이오메카트로닉스학과",
    "융합생명공학과",
    "생명과학과",
    "수학과",
    "물리학과",
    "화학과",
    "경제학과",
    "통계학과",
    "행정학과",
    "정치외교학과",
    "미디어커뮤니케이션학과",
    "사회학과",
    "사회복지학과",
    "심리학과",
    "소비자학과",
    "아동·청소년학과",
    "유학·동양학과",
    "국어국문학과",
    "영어영문학과",
    "프랑스어문학과",
    "러시아어문학과",
    "중어중문학과",
    "독어독문학과",
    "한문학과",
    "사학과",
    "철학과",
    "문헌정보학과",
    "소프트웨어학과",
    "데이터사이언스융합전공",
    "인공지능융합전공",
    "컬처앤테크놀로지융합전공",
    "자기설계융합전공",
    "지능형소프트웨어학과",
    "약학과",
    "스포츠과학과",
    "의학과",
    "글로벌바이오메디컬공학과",
    "응용AI융합학부",
    "에너지학과"
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/mypage');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        print("토큰이 없습니다.");
        return;
      }
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
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
      ..fields['major'] = _selectedMajor ?? '';

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
    const borderColor = Color.fromARGB(255, 20, 37, 26);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '프로필 편집',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 26),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 100,
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
            const SizedBox(height: 35),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '이름',
                hintText: '현재 이름: ${_nicknameController.text}',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedMajor,
              hint: Text('${_majorController.text}'),
              items: majors.map((major) {
                return DropdownMenuItem(
                  value: major,
                  child: Text(major),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMajor = value;
                });
              },
              decoration: InputDecoration(
                labelText: '학과 선택',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFC4D5BA),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // 버튼 위아래 패딩
          child: Center(
            child: SizedBox(
              width: 450, // 버튼의 가로 크기 설정
              height: 70, // 버튼의 세로 크기 설정
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF204020), // 버튼 배경색
                  foregroundColor: Colors.white, // 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "저장하기",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
