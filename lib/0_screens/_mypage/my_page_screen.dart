import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '마이 페이지',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}

class _MyPageScreenState extends State<MyPageScreen> {
  final bool _isLoading = false; // 로딩 상태
  var _index = 0;
  var _pages = [
    // widget 폴더에 넣을지
    //ListPage(), // 물품 목록 페이지
    MyPage()
    //ChatPage(), // 채팅 목록 페이지
  ];

  //future() //백엔드에서 정보 불러오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '마이 페이지',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: const IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: null, // 더보기 버튼 구현하기
          )),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        selectedItemColor: Color.fromARGB(255, 20, 37, 26),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: '채팅', icon: Icon(Icons.chat_outlined)),
          BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: '마이페이지', icon: Icon(Icons.person_outline)),
        ],
      ),
    );
  }
}
