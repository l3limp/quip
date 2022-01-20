import 'package:flutter/material.dart';
import 'package:quip/ChatPage.dart';
import 'package:quip/chooseReceiver.dart';
import 'package:quip/real_chat_page.dart';
import 'package:quip/splash_screen.dart';
import 'package:quip/chooseUsername.dart';
import 'package:quip/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/e': (context) => ChooseReceiver(),
        '/': (context) => SplashScreen(),
        '/c': (context) => LoginPage(),
        '/a': (context) => ChooseUsername(),
        '/b': (context) => ChatPage(),
        '/f': (context) => RealChatPage(),
      },
    );
  }
}
