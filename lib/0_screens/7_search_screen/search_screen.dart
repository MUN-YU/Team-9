import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final List<dynamic> items; // Receive items from MainScreen

  SearchScreen({required this.items});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> recentSearches = []; // Recent searches
  List<dynamic> _searchResults = []; // Store search results

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Load recent searches on init
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches =
          prefs.getStringList('recentSearches')?.reversed.toList() ??
              ["일반 화학 8판", "실험복", "공학용 계산기"].reversed.toList();
    });
  }

  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches.reversed.toList());
  }

  void _onSearch() {
    String query = _controller.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        if (!recentSearches.contains(query)) {
          recentSearches.insert(0, query); // Add to recent searches
          _saveRecentSearches(); // Save to local storage
        }

        // Filter items based on the title containing the query
        _searchResults = widget.items
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

        // Print the search results to the console for debugging
        print("Search Results for '$query':");
        _searchResults.forEach((result) => print(result));
      });

      // Return both the search results and the search query
      Navigator.pop(context, {'filteredItems': _searchResults, 'query': query});
    }
  }

  void _clearRecentSearches() {
    setState(() {
      recentSearches.clear();
    });
    _saveRecentSearches(); // Save empty list to local storage
  }

  void _removeRecentSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
    });
    _saveRecentSearches(); // Save updated list to local storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46823E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back to MainScreen
          },
        ),
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '검색 내용 입력',
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _onSearch(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("최근 검색", style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: Text("전체 삭제"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.history),
                    title: Text(recentSearches[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _removeRecentSearch(
                          index), // Remove individual search
                    ),
                    onTap: () {
                      _controller.text =
                          recentSearches[index]; // Fill search field
                      _onSearch(); // Trigger search on selection
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF46823E),
            ),
            onPressed: _onSearch,
            child: Text("검색"),
          ),
        ),
      ),
    );
  }
}
