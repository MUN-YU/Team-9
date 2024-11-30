import 'package:flutter/material.dart';
import 'package:grand_market/0_screens/9_chat_list/%08chat_room_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> _chatRooms = []; // List to store chat room data
  bool _isLoading = true; // Loading state to show a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    final url = Uri.parse('https://swe9.comit-server.com/chatrooms');
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
          _chatRooms = decodedData['content'];
          _isLoading = false;
        });
      } else {
        print('Failed to load chat rooms: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while loading
          : _chatRooms.isEmpty
              ? Center(
                  child: Text(
                    '채팅방이 없습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = _chatRooms[index];
                    return ChatRoomItem(
                      chatroomIdx: chatRoom['chatroomIdx'],
                      profileImage: chatRoom['profileImage'],
                      major: chatRoom['major'],
                      username: chatRoom['username'],
                      lastMessageTime: chatRoom['lastMessageTime'],
                      lastMessage: chatRoom['lastMessage'],
                    );
                  },
                ),
    );
  }
}
