import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quip/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LoginPage();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
