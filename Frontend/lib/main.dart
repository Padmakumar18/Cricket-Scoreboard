import 'package:flutter/material.dart';
import 'package:my_app/screens/LoginPage.dart';
import 'package:my_app/screens/SignupPage.dart';
import 'package:my_app/screens/MainPage.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Cricket Scoreboard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
          ),
          darkTheme: ThemeData(brightness: Brightness.dark),
          themeMode: mode,
          initialRoute: '/MainPage',
          routes: {
            '/': (context) => const LoginPage(emailId: '', password: ''),
            '/LoginPage': (context) =>
                const LoginPage(emailId: '', password: ''),
            '/SignupPage': (context) => const SignupPage(),
            '/MainPage': (context) => const MainPage(),
          },
        );
      },
    );
  }
}
