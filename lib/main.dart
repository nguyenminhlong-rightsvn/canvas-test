import 'package:flutter/material.dart';
import 'package:flutter_parent/screens/login_landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginLandingScreen(),
    ),
  );
}
