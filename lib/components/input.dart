import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscured;

  const Input({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscured,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscured,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[300]),
        fillColor: Colors.grey[800],
        filled: true,
      ),
    );
  }
}
