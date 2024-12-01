import 'package:flutter/material.dart';
import 'package:lunar_pitch/constants/colors.dart'; // Ensure AppColors are defined here
import 'package:lunar_pitch/constants/data.dart';
import 'package:lunar_pitch/data/posts.dart';

class TrendRocketPage extends StatefulWidget {
  @override
  _TrendRocketPageState createState() => _TrendRocketPageState();
}

class _TrendRocketPageState extends State<TrendRocketPage> {
  // Placeholder options for the dropdown
  List<String> dropdownOptions = ['All', 'Option 2', 'Option 3'];
  String? selectedOption;

  // Placeholder for recent posts data (can be replaced with actual data)
  // List<Map<String, dynamic>> recentPosts = recent_posts;
  // List of JSON data for titles and metrics
  late Map<String, List<Map<String, String>>> metricsData;

  late Future<List<TweetResponse>> recentPosts;

  // List of icons for each metric (you can customize the icons as per your requirement)
  List<IconData> metricIcons = metric_icons;

  // Variable to keep track of the selected post index
  late String selectedTweetId;

  // Dummy data for row 1 in the 3rd column
  late SuggestedReply row1Data;

  // Dummy data for row 2 in the 3rd column
  List<Map<String, dynamic>> row2Data = [
    {'hashtag': '#WorldAIDSDay', 'metric': '27k'},
    {'hashtag': '#BRICS', 'metric': '141k'},
    {'hashtag': '#Living Being is Our Race', 'metric': '123k'},
    {'hashtag': '#BSRFRaisingDay2024', 'metric': '2172'},
  ];

  // Dummy data for row 3 in the 3rd column
  List<Map<String, dynamic>> row3Data = [
    {'hashtag': '#barcelona vs las palmas', 'metric': '200K'},
    {'hashtag': '#west ham vs arsenal', 'metric': '50k'},
    {'hashtag': '#deep dpression fengal', 'metric': '500k'},
    {'hashtag': '#mahindra cars be 6e', 'metric': '20k'},
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    recentPosts = getTweets();
    metricsData = await createMetricsMap(recentPosts);
    await setSelectedTweetId(recentPosts);
    row1Data = await getSuggestedReply(selectedTweetId);
    setState(() {});
  }

  Future<void> setSelectedTweetId(
      Future<List<TweetResponse>> futurePosts) async {
    List<TweetResponse> recentPosts =
        await futurePosts; // Await to get the list

    if (recentPosts.isNotEmpty) {
      selectedTweetId =
          recentPosts[0].tweet_id; // Set the tweet_id of the first post
    }
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    _controller.text = row1Data.textReply;  // Pre-fill with existing reply text

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Suggested Reply"),
          content: TextField(
            controller: _controller,
            maxLines: 5, // Allow multi-line input
            decoration: InputDecoration(
              hintText: "Edit your reply...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // You can handle the updated text here
                String updatedText = _controller.text;
                print("Updated text: $updatedText");  // Or update the state as needed
                postTweet(selectedTweetId, updatedText);
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Save"),
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
                // Row 1: Recent Posts Title and Dropdown
                Row(
                  children: [
                    const SizedBox(width: 8.0),
                    // Left part of the row
                    Image.asset(
                      'logo/x.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Recent Posts',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Right part of the row - Dropdown
                    DropdownButton<String>(
                      value: selectedOption,
                      hint: const Text('All'),
                      items: dropdownOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Row 2: Displaying recent posts similar to DashboardPage
                Expanded(
                  child: FutureBuilder<List<TweetResponse>>(
                    future: getTweets(), // Fetch tweets using the function
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator()); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error fetching posts')); // Show error message
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                                'No posts available')); // Handle empty state
                      }

                      final recentPosts = snapshot.data!;

                      return Card(
                        color: AppColors.white,
                        child: Container(
                          height: 650,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: recentPosts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (selectedTweetId ==
                                        recentPosts[index].tweet_id) {
                                      selectedTweetId = recentPosts[0]
                                          .tweet_id; // Reset to first tweet if same tweet is tapped again
                                    } else {
                                      selectedTweetId = recentPosts[index]
                                          .tweet_id; // Select the new tweet
                                    }
                                  });

                                  // Fetch the new row1Data after updating selectedTweetId
                                  row1Data =
                                      await getSuggestedReply(selectedTweetId);
                                },
                                child: Container(
                                  color: selectedTweetId == index
                                      ? AppColors.light_grey
                                      : AppColors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  recentPosts[index]
                                                      .profile_image),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 300),
                                                child: Text(
                                                  recentPosts[index].content,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              recentPosts[index].timestamp,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              recentPosts[index].tags,
                                              style: TextStyle(fontSize: 14),
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
                                color: Colors.grey,
                                thickness: 1,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
              SizedBox(
                  height: 10), // Adding some space between the title and cards
              // Metric cards
              ...metricsData[selectedTweetId]!
                  .asMap()
                  .map((index, metric) {
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
                                  metricIcons[
                                      index], // Displaying the icon based on the index
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
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  .values
                  .toList(),
            ],
          ),
          SizedBox(width: 20),
          Column(
            children: [
              // Row 1: Card with dynamic content
              GestureDetector(
                onTap: (){
                  _showEditDialog(context);
                },
                child: Container(
                  width: 350,
                  height: 300,
                  child: Card(
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Suggested Reply",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              row1Data.textReply,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              row1Data.hashtags,
                              style:
                                  TextStyle(fontSize: 14, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ),
                  
                ),
              ),
              SizedBox(height: 10),
              // Row 2: Current Trends with logo and metrics
              Container(
                width: 350,
                height: 200,
                child: Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row for logo and "Current Trends" text in the same line
                        Row(
                          children: [
                            Image.asset(
                              'logo/x.png',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Current Trends',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        // Display the trends
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: row2Data.map((trend) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trend['hashtag']!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  trend['metric']!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Row 3: Trends with Google logo
              Container(
                width: 350,
                height: 200,
                child: Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row for logo and "Trending Now" text in the same line
                        Row(
                          children: [
                            Image.asset(
                              'logo/google.png',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Trending Now',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        // Display the trends
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: row3Data.map((trend) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trend['hashtag']!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  trend['metric']!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
