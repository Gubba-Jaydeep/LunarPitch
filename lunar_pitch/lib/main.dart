import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'constants/colors.dart'; // Import the renamed page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      theme: ThemeData(
        primaryColor: Colors.transparent,  // Remove default purple color
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,  // Ensure AppBar background is white
          elevation: 0,  // Remove the shadow under AppBar
        ),
      ),
    );
  }
}
