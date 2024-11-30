import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _messages = [
    {"text": "구매하고 싶은데 ㅠㅠ 팔렸나요??", "isSentByUser": "true"},
    {"text": "아니요! 아직 안 팔렸어요!!", "isSentByUser": "false"},
    {"text": "아 다행이다! 필기 하셨으려나요?", "isSentByUser": "true"},
    {"text": "필기 전부 백지에 해서 깨끗해요!", "isSentByUser": "false"},
    {"text": "표지에 기스 조금 있긴해요 ㅠ", "isSentByUser": "false"},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          {
            "text": _messageController.text.trim(),
            "isSentByUser": "true",
            "image": null,
          },
        );
        _messageController.clear();
      });
    }
  }

  Widget _buildMessageBubble(String? text, File? image, bool isSentByUser) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.green[300] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isSentByUser ? Radius.circular(12) : Radius.zero,
            bottomRight: isSentByUser ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: image != null // Check if the message has an image
            ? Image.file(
                image,
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
                fit: BoxFit.cover,
              )
            : text != null // Otherwise, render text
                ? Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSentByUser ? Colors.white : Colors.black,
                    ),
                  )
                : SizedBox.shrink(),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800, // 이미지 크기 제한 (선택 사항)
        maxHeight: 800,
        imageQuality: 80, // 이미지 품질 (1-100)
      );

      if (pickedFile != null) {
        setState(() {
          _messages.add({
            "text": null, // 이미지만 보낼 경우 텍스트 없음
            "isSentByUser": "true",
            "image": File(pickedFile.path), // 찍은 이미지 파일 경로 저장
          });
        });
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("moonmove", style: TextStyle(fontSize: 18)),
            Text("4.32",
                style: TextStyle(fontSize: 14, color: Colors.grey[300])),
          ],
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 정보 표시
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.green[50],
            child: Row(
              children: [
                // Image.asset(
                //   "assets/book_icon.png", // 아이콘 경로
                //   width: 50,
                //   height: 50,
                // ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("화공 전공 책 팝니다(번역본)", style: TextStyle(fontSize: 18)),
                    Text("5000원", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          // 채팅 메시지 리스트
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message["text"],
                  message["image"],
                  message["isSentByUser"] == "true",
                );
              },
            ),
          ),

          // 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: _pickImageFromCamera,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "메시지 보내기",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
