import 'package:flutter/material.dart';

class ChatRoomItem extends StatelessWidget {
  final int chatroomIdx;
  final String profileImage;
  final String major;
  final String username;
  final String lastMessageTime;
  final String lastMessage;

  ChatRoomItem({
    required this.chatroomIdx,
    required this.profileImage,
    required this.major,
    required this.username,
    required this.lastMessageTime,
    required this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
        onBackgroundImageError: (error, stackTrace) =>
            Icon(Icons.person, size: 40),
        radius: 25,
      ),
      title: Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            major,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
      trailing: Text(
        lastMessageTime,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {
        // Navigate to chat room detail screen (implementation needed)
        print('Navigate to chat room $chatroomIdx');
      },
    );
  }
}
