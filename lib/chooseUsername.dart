import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChooseUsername extends StatefulWidget {
  const ChooseUsername({key}) : super(key: key);

  @override
  _ChooseUsernameState createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: _buildChooseUser(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildChooseUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 100,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/a',
                        arguments: {'user': "User1"});
                  },
                  child: Text(
                    'User1',
                    style: TextStyle(color: Colors.green),
                  )),
            )),
        Divider(
          thickness: 2,
          indent: 80,
          endIndent: 80,
        ),
        Container(
            height: 100,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/a',
                      arguments: {'user': "User2"});
                },
                child: Text('User2', style: TextStyle(color: Colors.green)),
              ),
            )),
      ],
    );
  }
}
