import 'package:flutter/material.dart';
import 'package:lunar_pitch/screens/home_page.dart';
import '../constants/colors.dart'; // Import constants
import '../constants/fonts.dart';
import 'trend_rocket.dart'; // Import font constants

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedPage = 'homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Image.asset('logos/lunar_pitch.png', height: 50), // Your logo
            const SizedBox(width: 10),
          ],
        ),
        actions: [
          _buildProfileMenu(context), // Profile menu button
        ],
      ),
      body: Row(
        children: [
          // Fixed vertical navigation bar
          NavigationBar(
            onItemSelected: (String page) {
              setState(() {
                selectedPage = page;
              });
            },
          ),
          // Main content area with top-left curved edge and grey background
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.light_grey, // Set background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), // Curved top-left corner
                  ),
                ),
                child: _getPageContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Profile menu with dropdown under the profile icon
  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.account_circle,
        size: 40, // Increase the size of the icon here
        color: AppColors.black,
      ),
      onSelected: (String value) {
        if (value == 'Logout') {
          // Handle Logout
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'Profile',
          child: Text(
            'Profile',
            style: TextStyle(fontFamily: AppFonts.bodyFont, fontSize: AppFonts.bodyFontSize),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Settings',
          child: Text(
            'Settings',
            style: TextStyle(fontFamily: AppFonts.bodyFont, fontSize: AppFonts.bodyFontSize),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Logout',
          child: Text(
            'Logout',
            style: TextStyle(fontFamily: AppFonts.bodyFont, fontSize: AppFonts.bodyFontSize),
          ),
        ),
      ],
    );
  }

  Widget _getPageContent() {
    switch (selectedPage) {
      case 'homepage':
        return HomePage();
      case 'trendrocket':
        return TrendRocketScreen();
      case 'boost':
        return _buildBoostPageContent();
      default:
        return _buildHomePageContent();
    }
  }

  Widget _buildHomePageContent() {
    return const Center(
      child: Text(
        'Welcome to Homepage',
        style: TextStyle(
          fontFamily: AppFonts.headingFont,
          fontSize: AppFonts.headingFontSize,
        ),
      ),
    );
  }

  Widget _buildBoostPageContent() {
    return const Center(
      child: Text(
        'Boost Page Content',
        style: TextStyle(
          fontFamily: AppFonts.headingFont,
          fontSize: AppFonts.headingFontSize,
          color: AppColors.black,
        ),
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final Function(String) onItemSelected;

  const NavigationBar({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      color: AppColors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.red),
            title: const Text(
              'Homepage',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.bodyFont,
                fontSize: AppFonts.bodyFontSize,
              ),
            ),
            onTap: () => onItemSelected('homepage'),
          ),
          ListTile(
            leading: const Icon(Icons.rocket_launch, color: AppColors.orange),
            title: const Text(
              'TrendRocket', // Updated page name
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.bodyFont,
                fontSize: AppFonts.bodyFontSize,
              ),
            ),
            onTap: () => onItemSelected('trendrocket'), // Updated page name
          ),
          ListTile(
            leading: const Icon(Icons.local_fire_department, color: AppColors.black),
            title: const Text(
              'Boost',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.bodyFont,
                fontSize: AppFonts.bodyFontSize,
              ),
            ),
            onTap: () => onItemSelected('boost'),
          ),
        ],
      ),
    );
  }
}
