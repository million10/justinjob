import 'package:flutter/material.dart';
import 'package:justinjob/screens/landing_page.dart'; // Import the LandingPage

void main() {
  runApp(const JustinJobApp());
}

class JustinJobApp extends StatelessWidget {
  const JustinJobApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Justin Job',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Modern font
      ),
      home: const LandingPage(), // Set the LandingPage as the home screen
    );
  }
}
