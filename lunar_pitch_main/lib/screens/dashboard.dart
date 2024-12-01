import 'package:flutter/material.dart';
import 'package:lunar_pitch/constants/colors.dart';
import 'package:lunar_pitch/constants/data.dart';
import 'package:lunar_pitch/data/posts.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<TweetResponse> recentPosts;
  Map<String, dynamic>? selectedPost;
  late String selectedTweetId;

  // List of JSON data for titles and metrics
  late Map<String,List<Map<String, String>>> metricsData;

  // List of icons for each metric (you can customize the icons as per your requirement)
  List<IconData> metricIcons = metric_icons;

  // Sample data for "Following" list
  late List<Map<String,String>> followingData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    recentPosts = await getTweetsOwn();
    followingData = await getUsers();
    setSelectedTweetId(recentPosts);
    metricsData = createMetricsMapNoFuture(recentPosts);
    setState(() {});
  }

  Future<void> setSelectedTweetId(
      List<TweetResponse> futurePosts) async {
    List<TweetResponse> recentPosts =
        futurePosts; // Await to get the list

    if (recentPosts.isNotEmpty) {
      selectedTweetId =
          recentPosts[0].tweet_id; // Set the tweet_id of the first post
    }
  }
  
  void _deleteFollowing(int index) {
    deleteUsers([followingData[index]['name']!]);
    setState(() {
      followingData.removeAt(index);

    });
  }

  void _addFollowing() {
    // Show the dialog to enter user handle
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String handle = "";
        return AlertDialog(
          title: Text('Add Following'),
          content: TextField(
            onChanged: (value) {
              handle = value;
            },
            decoration: InputDecoration(hintText: 'Enter user handle'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (handle.isNotEmpty) {
                  addUsers([ handle.startsWith('@') ? handle : '@$handle']);
                  setState(() {
                    followingData.add({
                      'name': '@$handle',
                      'imageUrl': 'https://www.example.com/user_image.jpg', // Use appropriate image URL
                    });
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Handle Added Successfully')),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // First column for recent posts
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Recent Posts',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Card(
                    color: AppColors.white,
                    child: Container(
                      height: 650, // Set the max height for the card
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: recentPosts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTweetId = recentPosts[index].tweet_id;
                              });
                            },
                            child: Container(
                              color: selectedTweetId == recentPosts[index].tweet_id
                                  ? AppColors.light_grey
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                recentPosts[index].profile_image),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            recentPosts[index].content,
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          recentPosts[index].timestamp,
                                          style: TextStyle(
                                              fontSize: 14, color: AppColors.black),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          recentPosts[index].tags,
                                          style: TextStyle(
                                              fontSize: 14, color: AppColors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.light_grey,
                            thickness: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Second column for metrics
          SizedBox(width: 20),
          Column(
            children: [
              // Adding the "Metrics" heading
              Text(
                'Metrics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10), // Adding some space between the title and cards
              // Metric cards
              ...metricsData[selectedTweetId]!.asMap().map((index, metric) {
                return MapEntry(
                  index,
                  Card(
                    color: AppColors.white,
                    elevation: 3,
                    child: Container(
                      height: 128.80, // Fixed height for each card
                      width: 150, // Fixed width for each card
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              metricIcons[index], // Displaying the icon based on the index
                              size: 25,
                              color: AppColors.red,
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  metric['title']!,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  metric['metric']!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).values.toList(),
            ],
          ),

          // Third column
          SizedBox(width: 20),
          Column(
            children: [
              // Row 1: "Following" title and "Add Following" button
              Row(
                children: [
                  // Column 1: Title "Following"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  // Column 2: "Add Following" button with user logo
                  ElevatedButton.icon(
                    onPressed: _addFollowing,
                    icon: Icon(Icons.person_add),
                    label: Text('Add Following'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black, backgroundColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Row 2: List of followers with delete button
              Card(
                color: AppColors.white,
                elevation: 3,
                child: Container(
                  height: 678, // Set fixed height for this section
                  width: 280, // Set fixed width for this section
                  padding: EdgeInsets.only(top: 20), // Increase top padding for users list
                  child: ListView.builder(
                    itemCount: followingData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(followingData[index]['imageUrl']!),
                        ),
                        title: Text(followingData[index]['name']!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteFollowing(index),
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
