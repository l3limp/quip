import 'package:firebase_auth/firebase_auth.dart';
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
      appBar: AppBar(
        title: Text('Quipster'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _buildChooseUser(),
      ),
    );
  }

  Widget _buildChooseUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          child: Text(
            'choose receiver',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/e');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: EdgeInsets.all(30),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Divider(
          thickness: 2,
          indent: 80,
          endIndent: 80,
        ),
        Container(
            height: 50,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/b',
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
            height: 50,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/b',
                      arguments: {'user': "User2"});
                },
                child: Text('User2', style: TextStyle(color: Colors.green)),
              ),
            )),
        Divider(
          thickness: 2,
          indent: 80,
          endIndent: 80,
        ),
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
          child: Text('Log Out'),
          onPressed: () {
            _signOut();
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.green, padding: EdgeInsets.all(8)),
        ),
      ],
    );
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, '/c');
  }
}
