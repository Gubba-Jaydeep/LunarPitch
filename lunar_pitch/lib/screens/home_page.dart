import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lunar_pitch/util/util.dart';

import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> accounts = [
    {'name': 'Account 1', 'logoUrl': 'https://via.placeholder.com/40'},
    {'name': 'Account 2', 'logoUrl': 'https://via.placeholder.com/40'},
    {'name': 'Account 3', 'logoUrl': 'https://via.placeholder.com/40'},
  ];

  List<Map<String, String>> metricsData = [
    {'title': 'Metric 1', 'value': '50'},
    {'title': 'Metric 2', 'value': '30'},
    {'title': 'Metric 3', 'value': '70'},
    {'title': 'Metric 4', 'value': '40'},
  ];

  List<Map<String, String>> recentPosts = [
    {'title': 'Post 1', 'hashtags': '#hashtag1 #hashtag2', 'time': '2 hrs ago'},
    {'title': 'Post 2', 'hashtags': '#hashtag3 #hashtag4', 'time': '1 hr ago'},
    {'title': 'Post 3', 'hashtags': '#hashtag5 #hashtag6', 'time': '10 mins ago'},
  ];

  String highlightedPostTitle = '';
  String highlightedPostHashtags = '';
  String highlightedPostTime = '';

  TextEditingController handleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the default highlighted post to the first post
    highlightedPostTitle = recentPosts[0]['title']!;
    highlightedPostHashtags = recentPosts[0]['hashtags']!;
    highlightedPostTime = recentPosts[0]['time']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: AppColors.light_grey, // Set background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), // Rounded top-left corner
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Column 1 - Accounts Tracked
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Padding added here
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Accounts Tracked', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                            Divider(color: Colors.grey.shade300),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                itemCount: accounts.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Image.network(accounts[index]['logoUrl']!),
                                        title: Text(accounts[index]['name']!, style: TextStyle(color: AppColors.black)),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              accounts.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                      Divider(color: Colors.grey.shade300),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showHandleDialog();
                      },
                      child: const Text('Add Handle'),
                    ),
                  ],
                ),
              ),
              
              // Column 2 - Metrics Data
              Expanded(
                child: Column(
                  children: List.generate(metricsData.length, (index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.2, // 20% of available width
                      height: MediaQuery.of(context).size.height * 0.2, // 20% of available height
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                metricsData[index]['title']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Value: ${metricsData[index]['value']}',
                                style: const TextStyle(fontSize: 14, color: AppColors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Column 3 - Highlighted & Recent Posts
              Expanded(
                child: Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding added here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Highlighted Post
                        const Text('Highlighted Post', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(highlightedPostTitle, style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(highlightedPostHashtags, style: TextStyle(color: AppColors.black, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(highlightedPostTime, style: TextStyle(color: AppColors.black, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),

                        // Recent Posts
                        const Text('Recent Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: recentPosts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(recentPosts[index]['title']!, style: TextStyle(color: AppColors.black)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(recentPosts[index]['hashtags']!, style: TextStyle(color: AppColors.black)),
                                        Text(recentPosts[index]['time']!, style: TextStyle(color: AppColors.black)),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        highlightedPostTitle = recentPosts[index]['title']!;
                                        highlightedPostHashtags = recentPosts[index]['hashtags']!;
                                        highlightedPostTime = recentPosts[index]['time']!;
                                      });
                                    },
                                  ),
                                  Divider(color: Colors.grey.shade300),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHandleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your handle'),
          content: TextField(
            controller: handleController,
            decoration: const InputDecoration(
              labelText: 'Handle',
              contentPadding: EdgeInsets.only(left: 6.0, top: 6.0),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (handleController.text.isNotEmpty) {
                  showToast(context, "Handle Added Successfully");
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
