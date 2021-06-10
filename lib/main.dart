import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomeScr()));
}

class HomeScr extends StatefulWidget {
  @override
  _HomeScrState createState() => _HomeScrState();
}

class _HomeScrState extends State<HomeScr> {
  int num = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quip"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      num++;
                    });
                  }),
              Text('$num')
            ],
          ),
        ));
  }
}
