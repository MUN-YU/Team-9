import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"text": "구매하고 싶은데 ㅠㅠ 팔렸나요??", "isSentByUser": "false"},
    {"text": "아니요! 아직 안 팔렸어요!!", "isSentByUser": "true"},
    {"text": "아 다행이다! 필기 하셨으려나요?", "isSentByUser": "false"},
    {"text": "필기 전부 백지에 해서 깨끗해요!", "isSentByUser": "true"},
    {"text": "표지에 기스 조금 있긴해요 ㅠ", "isSentByUser": "true"},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
            {"text": _messageController.text.trim(), "isSentByUser": "true"});
        _messageController.clear();
      });
    }
  }

  Widget _buildMessageBubble(String text, bool isSentByUser) {
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
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSentByUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("tjdeo1398", style: TextStyle(fontSize: 18)),
            Text("3.47",
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
                Image.asset(
                  "assets/book_icon.png", // 아이콘 경로
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("미분적분학 1", style: TextStyle(fontSize: 18)),
                    Text("20,000원", style: TextStyle(color: Colors.grey)),
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
                  message["text"]!,
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
                  onPressed: () {
                    // 파일 추가 등의 작업
                  },
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
