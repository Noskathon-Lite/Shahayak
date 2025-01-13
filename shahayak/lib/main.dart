import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(const Shahayak());
}

class Shahayak extends StatelessWidget {
  const Shahayak({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return const Homescreen(); // If logged in, navigate to homescreen
            } else {
              return const LoginScreen(); // If not logged in, show login screen
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
