import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomeScr()));
}

class HomeScr extends StatefulWidget {
  @override
  _HomeScrState createState() => _HomeScrState();
}

class _HomeScrState extends State<HomeScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quip"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.amberAccent,
              child: Text("Type here"),
            ),
          ],
        ));
  }
}
