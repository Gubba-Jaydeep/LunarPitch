import 'package:flutter/material.dart';
import 'package:lunar_pitch/constants/colors.dart'; // Import your colors file
import 'package:lunar_pitch/screens/post_schedular.dart';
import 'dashboard.dart';
import 'trend_rocket.dart';
import 'campaign_boost.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Default to Dashboard
  Widget _currentPage = DashboardPage();

  // Track the selected page index to highlight it
  int _selectedIndex = 0;

  void _navigateTo(Widget page, int index) {
    setState(() {
      _currentPage = page;
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed AppBar
          AppBar(
            automaticallyImplyLeading:
                false, // Hide the default back button if not needed
            title: Align(
              alignment: Alignment.centerLeft, // Align the image to the left
              child: Image.asset(
                'logo/lunar_pitch.png', // Path to your image asset
                height: 40, // Adjust the height as needed
                fit: BoxFit
                    .contain, // Adjust the image to fit the given dimensions
              ),
            ),
            backgroundColor: AppColors.white,
          ),
          Expanded(
            child: Row(
              children: [
                // Navigation Menu under AppBar
                Container(
                  width: 250,
                  color: AppColors.white, // Drawer menu background color
                  child: ListView(
                    children: [
                      // Dashboard Item
                      Material(
                        color: _selectedIndex == 0
                            ? AppColors.light_grey
                            : AppColors.white,
                        child: ListTile(
                          leading:
                              Icon(Icons.dashboard, color: AppColors.black),
                          title: Text('Dashboard',
                              style: TextStyle(color: AppColors.black)),
                          onTap: () => _navigateTo(DashboardPage(), 0),
                        ),
                      ),
                      // TrendRocket Item
                      Material(
                        color: _selectedIndex == 1
                            ? AppColors.light_grey
                            : AppColors.white,
                        child: ListTile(
                          leading:
                              Icon(Icons.trending_up, color: AppColors.black),
                          title: Text('TrendRocket',
                              style: TextStyle(color: AppColors.black)),
                          onTap: () => _navigateTo(TrendRocketPage(), 1),
                        ),
                      ),
                      // CampaignBoost Item
                      Material(
                        color: _selectedIndex == 2
                            ? AppColors.light_grey
                            : AppColors.white,
                        child: ListTile(
                          leading: Icon(Icons.campaign, color: AppColors.black),
                          title: Text('CampaignBoost',
                              style: TextStyle(color: AppColors.black)),
                          onTap: () => _navigateTo(CampaignBoostPage(), 2),
                        ),
                      ),
                      Material(
                        color: _selectedIndex == 3
                            ? AppColors.light_grey
                            : AppColors.white,
                        child: ListTile(
                          leading: Icon(Icons.campaign, color: AppColors.black),
                          title: Text('PostScheduler',
                              style: TextStyle(color: AppColors.black)),
                          onTap: () => _navigateTo(PostSchedular(), 3),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _currentPage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
