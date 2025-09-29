import 'dart:async';
import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<DisplayChatData>> fetchChats() async {
  final response = await http.get(
    Uri.parse(
      'http://localhost:5000/chat/personal?profileId=ec4d20db-e552-427f-8ad8-94c8f19c9592',
    ),
    headers: <String, String>{'Content-Type': 'application/json'},
    // body: jsonEncode(<String, String>{
    //   'profileId': 'ec4d20db-e552-427f-8ad8-94c8f19c9592',
    // }),
  );

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> parsed = jsonDecode(response.body);
    List<DisplayChatData> chats = [];

    for (var obj in parsed) {
      chats.add(DisplayChatData.fromJson(obj));
    }

    print(chats);

    return chats;
  } else {
    throw Exception('Failed to fetch chats');
  }
}

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  late Future<List<DisplayChatData>>? _chats;

  @override
  void initState() {
    super.initState();
    _chats = fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actionsPadding: EdgeInsets.only(right: 16),
        title: Container(
          padding: EdgeInsets.only(left: 4),
          child: Text('Kurama', style: TextStyle(color: Colors.grey[300])),
        ),
        actions: [
          GestureDetector(child: Icon(Icons.search, color: Colors.grey[300])),
        ],
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<DisplayChatData>>(
        future: _chats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final chat = data[index];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.person),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            chat.partner.firstName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            chat.lastMessage.content!,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
