import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../5_main/main_screen.dart';
import '../10_user_update_screen/user_update_screen.dart';

// Define a mock for ChatPage and ListPage for navigation example
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Chat Page"));
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("List Page"));
  }
}

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool _isLoading = false; // 로딩 상태
  int _index = 2;
  final List<Widget> _pages = [
    ChatPage(), // 채팅 목록 페이지
    MainScreen(), // 물품 목록 페이지 (홈)
    MyPageScreenContent(), // 마이페이지
  ];

  String? profileImage;
  String? name;
  String? major;
  double? rating;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final url = Uri.parse('https://swe9.comit-server.com/api/mypage');
    final response = await http.get(
      url,
      headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIyMTk1LCJleHAiOjE3NDYzNzQxOTV9.u_MXeLFQh-C3PbGa3ky16SlkKJgTTcj5W5HqF_XdmHM",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        profileImage = data['content']['profileImage'];
        name = data['content']['name'];
        major = data['content']['major'];
        rating = data['content']['rating'];
        _isLoading = false;
      });
    } else {
      print('Failed to load profile data');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      body: _pages[_index],
    );
  }
}

class MyPageScreenContent extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final String? major;
  final double? rating;

  const MyPageScreenContent({
    Key? key,
    this.profileImage,
    this.name,
    this.major,
    this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: MyProfile(
            profileImage: profileImage,
            name: name,
            major: major,
            rating: rating,
          ),
        ),
        Flexible(
          flex: 5,
          child: MySales(),
        ),
      ],
    );
  }
}

// 나의 프로필
class MyProfile extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final String? major;
  final double? rating;

  const MyProfile({
    Key? key,
    this.profileImage,
    this.name,
    this.major,
    this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFC4D5BA),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '나의 프로필',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: const Color(0xFFC4D5BA),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 13),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? NetworkImage(profileImage!)
                            : AssetImage("assets/images/profile_image.png")
                                as ImageProvider,
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name ?? 'Unknown User',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(major ?? 'Unknown Major'),
                            const SizedBox(height: 5),
                            Text(
                                '평균 리뷰: ${rating?.toStringAsFixed(2) ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserUpdateScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 20, 37, 26),
                    ),
                    child: Text('프로필 편집'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 나의 거래
class MySales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFC4D5BA),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '나의 거래',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child:
              _buildTransactionButton(Icons.favorite_outline, '관심 상품 목록', () {
            // 관심 상품 목록으로 이동
          }),
        ),
        Expanded(
          child: _buildTransactionButton(
              Icons.attach_money_outlined, '판매 상품 목록', () {
            // 판매 상품 목록으로 이동
          }),
        ),
        Expanded(
          child: _buildTransactionButton(
              Icons.shopping_bag_outlined, '구매 상품 목록', () {
            // 구매 상품 목록으로 이동
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTransactionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
