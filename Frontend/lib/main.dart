import 'package:flutter/material.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/SignupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String page = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      home: page == 'Login App'
          ? const LoginPage(emailId: '', password: '')
          : const SignupPage(),
    );
  }
}
