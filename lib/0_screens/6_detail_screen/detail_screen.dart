import 'package:flutter/material.dart';
import 'package:grand_market/0_screens/9_chat_list/chat_room_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final int itemIdx;

  DetailScreen({required this.itemIdx});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? itemDetails;
  bool isLoading = true;
  bool isFavorite = false;
  int currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
  }

  Future<void> _fetchItemDetails() async {
    final url = Uri.parse(
        'https://swe9.comit-server.com/items/detail/${widget.itemIdx}');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        print("토큰이 없습니다.");
        return;
      }

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          itemDetails = decodedData['content'];
          isLoading = false;
          isFavorite = itemDetails?['isFavorite'] ?? false;
        });
      } else {
        print('Failed to load item details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _toggleLike() async {
    final url = Uri.parse('https://swe9.comit-server.com/items/likes');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwidXNlcm5hbWUiOiJtb29uIiwiaWF0IjoxNzMwNzMyMjQxLCJleHAiOjE3NDYyODQyNDF9.6dyB5pxultEVmhBYSU9a8WWNrDwteCXwoTjiiM3M9SU',
          'Content-Type': 'application/json',
        },
        body: json.encode({'itemIdx': widget.itemIdx}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = !isFavorite;
          if (isFavorite) {
            itemDetails?['likes'] = (itemDetails?['likes'] ?? 0) + 1;
          } else {
            itemDetails?['likes'] = (itemDetails?['likes'] ?? 1) - 1;
          }
        });
      } else {
        print('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showPreviousImage() {
    setState(() {
      if (currentPhotoIndex > 0) {
        currentPhotoIndex--;
      }
    });
  }

  void _showNextImage() {
    setState(() {
      if (currentPhotoIndex < (itemDetails?['photos']?.length ?? 1) - 1) {
        currentPhotoIndex++;
      }
    });
  }

  Future<void> _createChatRoom() async {
    final url = Uri.parse('https://swe9.comit-server.com/chatrooms');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
    // try {
    //   // SharedPreferences에서 토큰 가져오기
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? token = prefs.getString("auth_token");

    //   if (token == null) {
    //     print("토큰이 없습니다.");
    //     return;
    //   }

    //   // POST 요청 보내기
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Authorization': 'Bearer $token',
    //       'Content-Type': 'application/json',
    //     },
    //     body: json.encode({
    //       'title': title, // 채팅룸 제목
    //       'description': description, // 채팅룸 설명
    //     }),
    //   );

    //   if (response.statusCode == 201) {
    //     print('채팅룸 생성 성공');
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => ChatScreen()),
    //     );
    //     // 채팅방 리스트를 다시 불러옵니다.
    //     // await _fetchChatRooms();
    //   } else {
    //     print('채팅룸 생성 실패: ${response.statusCode}');
    //     print('Response body: ${response.body}');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF46823E),
          title: Text('Loading...'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context, {'itemIdx': widget.itemIdx, 'isLiked': isFavorite});
            },
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46823E),
        title: Text(itemDetails?['sellerName'] ?? '판매자 이름',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context, {'itemIdx': widget.itemIdx, 'isLiked': isFavorite});
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display main image with arrow navigation and index display
            if (itemDetails?['photos'] != null &&
                itemDetails!['photos'].isNotEmpty)
              Stack(
                children: [
                  Center(
                    child: Image.network(
                      itemDetails!['photos'][currentPhotoIndex],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 100,
                      ),
                    ),
                  ),
                  if (currentPhotoIndex > 0)
                    Positioned(
                      left: 8,
                      top: 75,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: _showPreviousImage,
                      ),
                    ),
                  if (currentPhotoIndex < itemDetails!['photos'].length - 1)
                    Positioned(
                      right: 8,
                      top: 75,
                      child: IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: _showNextImage,
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        '${currentPhotoIndex + 1}/${itemDetails!['photos'].length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else
              Image.asset(
                'assets/images/item.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            // Title and like button in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    itemDetails?['title'] ?? 'No Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleLike,
                  ),
                ),
                SizedBox(width: 4),
                Text('${itemDetails?['likes'] ?? 0}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${itemDetails?['price'] ?? 'N/A'}원',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Date
            Text(
              '올린 날짜: ${itemDetails?['date'] ?? 'N/A'}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Divider(),
            // Description
            Text(
              itemDetails?['description'] ?? '제품 상세 설명이 없습니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Offer acceptance
            if (itemDetails?['isOfferAccepted'] != null) ...[
              Text(
                itemDetails?['isOfferAccepted'] == true
                    ? '가격 제안 가능'
                    : '가격 제안 불가',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
            const Spacer(),
            // Chat button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF46823E),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _createChatRoom(),
                child: const Text('채팅하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
