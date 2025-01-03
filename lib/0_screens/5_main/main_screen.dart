import 'package:flutter/material.dart';
import 'package:grand_market/8_setting/SettingScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../_addProduct/add_product_screen.dart';
import '../7_search_screen/search_screen.dart';
import '../6_detail_screen/detail_screen.dart';
import '../10_user_update_screen/user_update_screen.dart';
import '../9_chat_list/chat_list_screen.dart';
import '../_mypage/my_page_screen.dart';

// Define category mapping for dropdown selection
const Map<String, String> categoryMapping = {
  "교재": "TEXTBOOK",
  "실험복": "EXERCISE_EQUIPMENT",
  "전자기기": "ELECTRONICS",
  "기타": "OTHER",
};

// Utility function to truncate text to 7 characters with ellipsis
String truncateText(String text, {int maxLength = 7}) {
  return (text.length > maxLength)
      ? '${text.substring(0, maxLength)}...'
      : text;
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  List<dynamic> _items = []; // Full item list
  List<dynamic> _filteredItems = []; // Filtered item list for search results
  Set<int> likedItems = {}; // Set to store liked item indices
  final PageController _pageController = PageController(initialPage: 1);

  String? _selectedDepartment;
  String? _selectedCategory;
  String? _searchQuery; // Store search query from SearchScreen

  List<String> departments = [
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

  List<String> categories = ["교재", "실험복", "전자기기", "기타"];

  @override
  void initState() {
    super.initState();
    _fetchLikedItems();
    _fetchItems();
  }

  Future<void> _fetchLikedItems() async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/likes');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        print("토큰이 없습니다.");
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          likedItems = Set<int>.from(
              decodedData['content'].map((item) => item['itemIdx']));
        });
      } else {
        print('Failed to load liked items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchItems() async {
    final url = Uri.parse('https://swe9.comit-server.com/items');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIwOTA0LCJleHAiOjE3NDYzNzI5MDR9.1TfEKkFxBgJ2HiHy05klS2C4YU3FCNsNK1-JrqSJEEI',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _items = decodedData['content'];
          _filteredItems = _items;
          _filterItems();
        });
      } else {
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _items.where((item) {
        final matchesDepartment = _selectedDepartment == null ||
            item['authorMajor'] == _selectedDepartment;
        final selectedCategoryKey = categoryMapping[_selectedCategory];
        final matchesCategory = _selectedCategory == null ||
            item['category'] == selectedCategoryKey;
        return matchesDepartment && matchesCategory;
      }).toList();
    });
  }

  Future<void> _toggleLike(int itemIdx) async {
    final url = Uri.parse('https://swe9.comit-server.com/items/likes');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwODIwOTA0LCJleHAiOjE3NDYzNzI5MDR9.1TfEKkFxBgJ2HiHy05klS2C4YU3FCNsNK1-JrqSJEEI',
          'Content-Type': 'application/json',
        },
        body: json.encode({'itemIdx': itemIdx}),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (likedItems.contains(itemIdx)) {
            likedItems.remove(itemIdx);
          } else {
            likedItems.add(itemIdx);
          }
        });
      } else {
        print('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToDetail(int itemIdx) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(itemIdx: itemIdx),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result['isLiked']) {
          likedItems.add(result['itemIdx']);
        } else {
          likedItems.remove(result['itemIdx']);
        }
      });
    }
  }

  void _onSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(items: _items),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _filteredItems = result['filteredItems'] ?? _items;
        _searchQuery = result['query'];
      });
    }
  }

  void _clearSearchFilter() {
    setState(() {
      _searchQuery = null;
      _filteredItems = _items;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = (_selectedDepartment != null ||
            _selectedCategory != null ||
            _searchQuery != null)
        ? _filteredItems
        : _items;

    print("Items to Show: $itemsToShow"); // 디버깅용 출력

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colors.white, size: 24),
                label: Text(
                  "물품등록",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  minimumSize: Size(80, 40),
                ),
              ),
            ),
            Expanded(
              child: Text(
                '성대한 마켓',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // 채팅 목록 화면 (ChatListScreen)
          ChatListScreen(),

          // 홈 화면 - 필터와 아이템 리스트 표시
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('학과'),
                        value: _selectedDepartment,
                        items: departments.map((department) {
                          return DropdownMenuItem(
                            value: department,
                            child: Text(truncateText(department)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                          _filterItems();
                        },
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('카테고리'),
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(truncateText(category)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                          _filterItems();
                        },
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Text("현재 필터: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (_selectedDepartment != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(truncateText(_selectedDepartment!)),
                          onDeleted: () {
                            setState(() {
                              _selectedDepartment = null;
                            });
                            _filterItems();
                          },
                        ),
                      ),
                    if (_selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(truncateText(_selectedCategory!)),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                            _filterItems();
                          },
                        ),
                      ),
                    if (_searchQuery != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text('검색어: $_searchQuery'),
                          onDeleted: _clearSearchFilter,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: itemsToShow.isEmpty
                    ? Center(
                        child: Text(
                          '조건에 맞는 물품이 없습니다.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: itemsToShow.length,
                        itemBuilder: (context, index) {
                          final item = itemsToShow[index];
                          final isLiked = likedItems.contains(item['itemIdx']);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item['itemImage'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported, size: 50),
                                ),
                              ),
                              title: Text(
                                item['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  '${item['price']}원',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  _toggleLike(item['itemIdx']);
                                },
                              ),
                              onTap: () => _navigateToDetail(item['itemIdx']),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // 마이 페이지 (MyPageScreen)
          MyPageScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
