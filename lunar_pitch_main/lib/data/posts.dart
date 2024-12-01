import 'dart:convert';
import 'package:http/http.dart' as http;

// const url = "http://0.0.0.0:8000";
const url = "http://10.1.222.201:8000";

// Define the structure of the response (TweetResponse)
class TweetResponse {
  final String tweet_id;
  final String name;
  final String handle;
  final String timestamp;
  final int verified;
  final String content;
  final String comments;
  final String retweets;
  final String likes;
  final String analytics;
  final String tags;
  final String profile_image;
  final String tweet_link;

  TweetResponse({
    required this.tweet_id,
    required this.name,
    required this.handle,
    required this.timestamp,
    required this.verified,
    required this.content,
    required this.comments,
    required this.retweets,
    required this.likes,
    required this.analytics,
    required this.tags,
    required this.profile_image,
    required this.tweet_link,
  });

  factory TweetResponse.fromJson(Map<String, dynamic> json) {
    return TweetResponse(
      tweet_id: json['tweet_id'],
      name: json['name'],
      handle: json['handle'],
      timestamp: json['timestamp'],
      verified: json['verified'],
      content: json['content'],
      comments: json['comments'],
      retweets: json['retweets'],
      likes: json['likes'],
      analytics: json['analytics'],
      tags: json['tags'],
      profile_image: json['profile_image'],
      tweet_link: json['tweet_link'],
    );
  }
}

class SuggestedReply {
  final String tweetId;
  final String textReply;
  final String memeReplyUrl;
  final String gifReplyPath;
  final String hashtags;

  SuggestedReply({
    required this.tweetId,
    required this.textReply,
    required this.memeReplyUrl,
    required this.gifReplyPath,
    required this.hashtags
  });

  // Method to create a SuggestedReply from JSON
  factory SuggestedReply.fromJson(Map<String, dynamic> json, String tweet_id) {
    return SuggestedReply(
      tweetId: tweet_id,
      textReply: json['text_reply'] ?? '',
      memeReplyUrl: json['meme_reply_url'] ?? '',
      gifReplyPath: json['gif_reply_path'] ?? '',
      hashtags: json['hashtags'] ?? ''
    );
  }
}

Future<List<TweetResponse>> getTweets() async {
  const String apiUrl = 'http://10.1.222.201:8000/tweets/get_tweets';  // Replace with your actual API URL

  try {
    // Make the GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> jsonData = json.decode(response.body);

      // Convert the JSON data into a list of TweetResponse objects
      List<TweetResponse> tweets = jsonData
          .map((tweetJson) => TweetResponse.fromJson(tweetJson))
          .toList();

      return tweets;
    } else {
      throw Exception('Failed to load tweets');
    }
  } catch (e) {
    throw Exception('Error fetching tweets: $e');
  }
}

Future<List<TweetResponse>> getTweetsOwn() async {
  const String apiUrl = 'http://10.1.222.201:8000/tweets/get_tweets?handles=@SpallingMistake';  // Replace with your actual API URL

  try {
    // Make the GET request
    final response = await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> jsonData = json.decode(response.body);

      // Convert the JSON data into a list of TweetResponse objects
      List<TweetResponse> tweets = jsonData
          .map((tweetJson) => TweetResponse.fromJson(tweetJson))
          .toList();

      return tweets;
    } else {
      throw Exception('Failed to load tweets');
    }
  } catch (e) {
    throw Exception('Error fetching tweets: $e');
  }
}

// Function to create a Map<List<Map<String, String>>> of Metrics
Future<Map<String, List<Map<String, String>>>> createMetricsMap(Future<List<TweetResponse>> futureTweets) async {
  Map<String, List<Map<String, String>>> metricsMap = {};

  // Await the Future to get the list of TweetResponse objects
  List<TweetResponse> tweets = await futureTweets;

  tweets.forEach((tweet) {
    List<Map<String, String>> metricsList = [
      {"title": "analytics", "metric": tweet.analytics.toString()},
      {"title": "likes", "metric": tweet.likes.toString()},
      {"title": "comments", "metric": tweet.comments.toString()},
      {"title": "retweets", "metric": tweet.retweets.toString()},
      {"title": "saved", "metric": "Value 5"} // Add any other metric you need
    ];

    // Store the metrics list in the map, keyed by tweet_id
    metricsMap[tweet.tweet_id] = metricsList;
  });

  return metricsMap;
}

Map<String, List<Map<String, String>>> createMetricsMapNoFuture(List<TweetResponse> futureTweets) {
  Map<String, List<Map<String, String>>> metricsMap = {};

  // Await the Future to get the list of TweetResponse objects
  List<TweetResponse> tweets = futureTweets;

  tweets.forEach((tweet) {
    List<Map<String, String>> metricsList = [
      {"title": "analytics", "metric": tweet.analytics.toString()},
      {"title": "likes", "metric": tweet.likes.toString()},
      {"title": "comments", "metric": tweet.comments.toString()},
      {"title": "retweets", "metric": tweet.retweets.toString()}// Add any other metric you need
    ];

    // Store the metrics list in the map, keyed by tweet_id
    metricsMap[tweet.tweet_id] = metricsList;
  });

  return metricsMap;
}



Future<SuggestedReply> getSuggestedReply(String tweetId) async {
  final String apiUrl = 'http://10.1.222.201:8000/tweets/generate_replies/$tweetId';  // Replace with your actual API URL

  try {
    // Make the GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Convert the JSON data into a SuggestedReply object
      SuggestedReply reply = SuggestedReply.fromJson(jsonData, tweetId);

      return reply;
    } else {
      throw Exception('Failed to load suggested reply');
    }
  } catch (e) {
    throw Exception('Error fetching suggested reply: $e');
  }
}

// Function to send the tweet ID and content to the API
Future<String> postTweet(String tweetId, String tweetContent) async {
  final String apiUrl = 'http://10.1.222.201:8000/tweets/post_tweet_now';  // Replace with your actual API URL

  // Create the request body
  Map<String, String> requestBody = {
    'tweet_id': tweetId,
    'tweet_content': tweetContent,
  };

  try {
    // Send the POST request with the tweet data
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json', // Ensure the content is sent as JSON
      },
      body: json.encode(requestBody),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // If the request is successful, return the success message
      return 'Tweet posted successfully';
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to post tweet');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    throw Exception('Error posting tweet: $e');
  }
}

Future<String> addUsers(List<String> usernames) async {
  final String apiUrl = 'http://10.1.222.201:8000/users/add_users';  // Replace with your actual API URL

  // Create the request body
  Map<String, List<String>> requestBody = {
    'usernames': usernames,
  };

  try {
    // Send the POST request with the list of usernames
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',  // Ensure the content is sent as JSON
      },
      body: json.encode(requestBody),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // If the request is successful, return the success message
      return 'Users added successfully';
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to add users');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    throw Exception('Error adding users: $e');
  }
}

// Function to fetch users
Future<List<Map<String,String>>> getUsers() async {
  final String apiUrl = 'http://10.1.222.201:8000/users/get_users';  // Replace with your actual API URL

  try {
    // Send the GET request to fetch users
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',  // Ensure the content type is JSON
      },
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Parse the list of users from the response
      List<dynamic> users = json.decode(response.body);
      List<Map<String, String>> usersList = List<Map<String, String>>.from(
        users.map((user) => Map<String, String>.from(user))
      );
      return List<Map<String,String>>.from(usersList);  // Return the list of usernames
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to fetch users');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    throw Exception('Error fetching users: $e');
  }
}

// Function to delete users
Future<String> deleteUsers(List<String> usernames) async {
  final String apiUrl = 'http://10.1.222.201:8000/users/delete_user';  // Replace with your actual API URL

  // Create the request body
  Map<String, List<String>> requestBody = {
    'usernames': usernames,
  };

  try {
    // Send the POST request to delete the users
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',  // Ensure the content is sent as JSON
      },
      body: json.encode(requestBody),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // If the request is successful, return the success message
      return 'Users deleted successfully';
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to delete users');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    throw Exception('Error deleting users: $e');
  }
}




List<Map<String, dynamic>> recent_posts = [
    {
      "imageUrl": "https://www.example.com/image1.jpg",
      "postText": "Flutter for Beginnasda sdsafad sdfsddddd dfsjhdfbujskjabd kasdbkjahf kauhsf afkauhsf kausgfhkagfh kausgfuagf kaugsfkagf augsfjga jasfgujyagf ajgfjya ajsfgdshfbjs sdahfjbdsjfba ajsdbjasgfja ajfsgahdsbgers",
      "timestamp": "01 Dec 01:42",
      "hashtags": "#flutter #beginner",
    },
    {
      "imageUrl": "https://www.example.com/image2.jpg",
      "postText": "Understanding State Management",
      "timestamp": "02 Dec 14:30",
      "hashtags": "#flutter #state #management",
    },
    {
      "imageUrl": "https://www.example.com/image3.jpg",
      "postText": "Advanced Flutter Techniques",
      "timestamp": "03 Dec 08:15",
      "hashtags": "#flutter #advanced",
    },
    {
      "imageUrl": "https://www.example.com/image4.jpg",
      "postText": "Best Practices for Clean Code",
      "timestamp": "04 Dec 18:00",
      "hashtags": "#cleanCode #bestPractices",
    },
    {
      "imageUrl": "https://www.example.com/image5.jpg",
      "postText": "Flutter and Firebase Integration",
      "timestamp": "05 Dec 09:00",
      "hashtags": "#flutter #firebase",
    },
    {
      "imageUrl": "https://www.example.com/image1.jpg",
      "postText": "Flutter for Beginners",
      "timestamp": "01 Dec 01:42",
      "hashtags": "#flutter #beginner",
    },
    {
      "imageUrl": "https://www.example.com/image2.jpg",
      "postText": "Understanding State Management",
      "timestamp": "02 Dec 14:30",
      "hashtags": "#flutter #state #management",
    },
    {
      "imageUrl": "https://www.example.com/image3.jpg",
      "postText": "Advanced Flutter Techniques",
      "timestamp": "03 Dec 08:15",
      "hashtags": "#flutter #advanced",
    },
    {
      "imageUrl": "https://www.example.com/image4.jpg",
      "postText": "Best Practices for Clean Code",
      "timestamp": "04 Dec 18:00",
      "hashtags": "#cleanCode #bestPractices",
    },
    {
      "imageUrl": "https://www.example.com/image5.jpg",
      "postText": "Flutter and Firebase Integration",
      "timestamp": "05 Dec 09:00",
      "hashtags": "#flutter #firebase",
    }
  ];

List<Map<String, String>> metrics_data = [
    {"title": "Metric 1", "metric": "Value 1"},
    {"title": "Metric 2", "metric": "Value 2"},
    {"title": "Metric 3", "metric": "Value 3"},
    {"title": "Metric 4", "metric": "Value 4"},
    {"title": "Metric 5", "metric": "Value 5"},
  ];

List<Map<String, dynamic>> following_data = [
    {'name': 'User 1', 'imageUrl': 'https://example.com/user1.jpg'},
    {'name': 'User 2', 'imageUrl': 'https://example.com/user2.jpg'},
    {'name': 'User 3', 'imageUrl': 'https://example.com/user3.jpg'},
    {'name': 'User 1', 'imageUrl': 'https://example.com/user1.jpg'},
    {'name': 'User 2', 'imageUrl': 'https://example.com/user2.jpg'},
    {'name': 'User 3', 'imageUrl': 'https://example.com/user3.jpg'}
  ];