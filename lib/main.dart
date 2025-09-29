import 'package:flutter/material.dart';
import 'package:fang/pages/_pages.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Fang());
}

class Fang extends StatelessWidget {
  const Fang({super.key});

  // This widget is the root of your application.HomePage
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      title: 'Kurama',
      home: const HomePage(),
    );
  }
}
