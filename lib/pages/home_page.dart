import 'package:fang/classes.dart';
import 'package:fang/pages/_pages.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NavPage> pages = [
    NavPage(
      'Chats',
      Icons.chat_bubble_outline,
      Icons.chat,
      ConversationsPage(),
    ),
    NavPage('Dayviewer', Icons.view_agenda, Icons.view_day, DayviewerPage()),
    NavPage('Profile', Icons.person_outline, Icons.person, ProfilePage()),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex].page,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[900],
        onDestinationSelected: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
        selectedIndex: _currentIndex,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: Colors.grey[300]),
        ),
        indicatorColor: Colors.grey[300],
        destinations: [
          for (final page in pages)
            NavigationDestination(
              icon: Icon(page.icon, color: Colors.grey[300]),
              selectedIcon: Icon(page.selectedIcon, color: Colors.grey[900]),
              label: page.label,
            ),
        ],
      ),
    );
  }
}
