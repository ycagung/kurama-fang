import 'package:fang/components/button.dart';
import 'package:fang/components/input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCont = TextEditingController();
  final pwCont = TextEditingController();

  // void login() {
  //   final String email = emailCont.text;
  //   final String pw = pwCont.text;

  //   // final auth = context.read<AuthCubit>();

  //   if (email.isNotEmpty && pw.isNotEmpty) {
  //     auth.login(email, pw);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Email and Password cannot be empty')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kurama',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              Text('L O G I N', style: TextStyle(fontSize: 16)),
              SizedBox(height: 50),
              Input(controller: emailCont, hint: 'Email', obscured: false),
              SizedBox(height: 10),
              Input(controller: pwCont, hint: 'Password', obscured: true),
              SizedBox(height: 25),
              Button(onTap: () {}, text: 'Login'),
            ],
          ),
        ),
      ),
    );
  }
}
