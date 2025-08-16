import 'package:flutter/material.dart';

class DayviewerPage extends StatefulWidget {
  const DayviewerPage({super.key});

  @override
  State<DayviewerPage> createState() => _DayviewerPageState();
}

class _DayviewerPageState extends State<DayviewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Text('Dayviewer', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
