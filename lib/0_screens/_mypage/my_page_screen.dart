import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: MyProfile(),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFC4D5BA),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '나의 프로필',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/profile_image.png"),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '김@@',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('성균관대학교 소프트웨어학과'),
                            const SizedBox(height: 5),
                            Text('평균 리뷰: 3.96'),
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
                      // 프로필 편집 페이지로 이동
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFC4D5BA),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '나의 거래',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class _MyPageScreenState extends State<MyPageScreen> {
  final bool _isLoading = false; // 로딩 상태
  var _index = 0;
  var _pages = [
    //ChatPage(), // 채팅 목록 페이지
    //ListPage(), // 물품 목록 페이지
    MyPage()
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
