import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [
    Message(
      title: 'Title 1',
      content: 'Content 1',
      time: DateTime.now(),
      avatar: 'https://example.com/image1.jpg',
    ),
    Message(
      title: 'Title 2',
      content: 'Content 2',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      avatar: 'https://example.com/image2.jpg',
    ),
    // Add more messages here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(message.avatar),
            ),
            title: Text(message.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.content),
                Text(message.time.toString()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Message {
  final String title;
  final String content;
  final DateTime time;
  final String avatar;

  Message({required this.title, required this.content, required this.time, required this.avatar});
}




