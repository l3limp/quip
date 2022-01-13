import 'package:flutter/material.dart';
import 'package:quip/ChatPage.dart';
import 'package:quip/chooseUsername.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => ChooseUsername(),
        '/a': (context) => ChatPage(),
      },
    );
  }
}
