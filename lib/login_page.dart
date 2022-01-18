import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

late BuildContext _context;
late FirebaseAuth _firebaseAuth;
late CollectionReference users;
String emailID = "";
String password = "";
String username = "";

class LoginPage extends StatelessWidget {
  const LoginPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _firebaseAuth = FirebaseAuth.instance;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign In Via Email'),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: Key('jew'),
                  onChanged: (value) {
                    emailID = value;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Email ID",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: Key('hew'),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: Key('lew'),
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Username (use the same username everytime)",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                child: Text('Sign in'),
                onPressed: () {
                  if (password.length < 7) {
                    const snackBar = SnackBar(
                        content: Text(
                            'Please choose a password with more than 6 characters'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _signInOrSignUp();
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green, padding: EdgeInsets.all(8)),
              )
            ],
          ),
        ),
      ),
    );
  }

  _signInOrSignUp() async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailID, password: password);
      users = FirebaseFirestore.instance.collection('users');
      print('New user created.');
      createUser(username);
      Navigator.pushNamed(_context, '/a');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        try {
          await _firebaseAuth.signInWithEmailAndPassword(
              email: emailID, password: password);
          Navigator.pushNamed(_context, '/a');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(String username) {
    return users
        .doc()
        .set({
          'username': username,
          'emailID': _firebaseAuth.currentUser!.email.toString()
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
