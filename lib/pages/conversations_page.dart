import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int i = 0; i < 30; i++)
            Container(
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
                          'Fourien Nila',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Hello there!', style: TextStyle(fontSize: 12.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
