import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../7_search_screen/search_screen';
import '../6_detail_screen/detail_screen';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  List<dynamic> _items = []; // Full item list
  List<dynamic> _filteredItems = []; // Filtered item list for search results
  Set<int> likedItems = {}; // Set to store liked item indices

  String? _selectedDepartment;
  String? _selectedCategory;
  String? _searchQuery; // Store search query from SearchScreen

  List<String> departments = ['컴퓨터공학과', '전자공학과', '기계공학과'];
  List<String> categories = ['교재', '전자기기', '의류', '생활용품'];

  @override
  void initState() {
    super.initState();
    _fetchLikedItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchItems(); // Fetch items each time MainScreen is opened
  }

  Future<void> _fetchLikedItems() async {
    final url = Uri.parse('https://swe9.comit-server.com/mypage/likes');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU'
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
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU'
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _items = decodedData['content'];
          _filteredItems = _items; // Initialize filteredItems with all items
        });
        print('Items loaded successfully');
      } else {
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _toggleLike(int itemIdx) async {
    final url = Uri.parse('https://swe9.comit-server.com/items/likes');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU',
          'Content-Type': 'application/json',
        },
        body: json.encode({'itemIdx': itemIdx}),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (likedItems.contains(itemIdx)) {
            likedItems.remove(itemIdx); // Unlike
          } else {
            likedItems.add(itemIdx); // Like
          }
        });
        print('Toggled like for item $itemIdx');
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
        _searchQuery = result['query']; // Capture search query
      });
    }
  }

  void _clearSearchFilter() {
    setState(() {
      _searchQuery = null;
      _filteredItems = _items; // Reset to show all items
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = _filteredItems.isNotEmpty ? _filteredItems : _items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          '성대한 마켓',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 1
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                              child: Text(department),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value;
                            });
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
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Text("현재 필터: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (_selectedDepartment != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(_selectedDepartment!),
                            onDeleted: () {
                              setState(() {
                                _selectedDepartment = null;
                              });
                            },
                          ),
                        ),
                      if (_selectedCategory != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(_selectedCategory!),
                            onDeleted: () {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                          ),
                        ),
                      if (_searchQuery != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text('검색어: $_searchQuery'),
                            onDeleted:
                                _clearSearchFilter, // Clear search filter
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleLike(item['itemIdx']);
                            },
                          ),
                          onTap: () => _navigateToDetail(
                              item['itemIdx']), // Replace this line
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(child: Text('Other Page Content')),
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
