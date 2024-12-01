import 'package:flutter/material.dart';
import '../constants/colors.dart'; // Importing constants
import '../constants/fonts.dart'; // Importing font constants
import '../widgets/custom_card.dart'; // Assuming the CustomCard widget is in 'custom_card.dart'

class TrendRocketScreen extends StatefulWidget {
  TrendRocketScreen({super.key});

  @override
  _TrendRocketScreenState createState() => _TrendRocketScreenState();
}

class _TrendRocketScreenState extends State<TrendRocketScreen> {
  // Dummy dynamic data for demonstration
  final List<String> dropdownValues = ['All', 'Option 2', 'Option 3'];
  final List<Map<String, dynamic>> postListData = [
    {
      'logo':
          'https://pbs.twimg.com/profile_images/1853669884669968384/IY_mqOoh_normal.jpg',
      'time': '30 Nov 18:34',
      'post':
          'This is a post hdkcayvdk akdfjhbcvkad akdfghbva kauygsbfa aksfygbkaksfdgv kasgydk aksfdugyka skdfygua',
      'hashtags': '#flutter #dart #abca'
    },
    {
      'logo':
          'https://pbs.twimg.com/profile_images/1853669884669968384/IY_mqOoh_normal.jpg',
      'time': '30 Nov 18:20',
      'post':
          'Another post adj,cbhdkcayvdk akdfjhbcvkad akdfghbva kauygsbfa aksfygbkaksfdgv kasgydk aksfdugyka skdfygua',
      'hashtags': '#flutter #dart'
    }
  ];
  Map<String, dynamic> postData = {
    'logo':
        'https://pbs.twimg.com/profile_images/1853669884669968384/IY_mqOoh_normal.jpg',
    'time': 'Just Now',
    'post':
        'This is a postalsdhfhbldifvlidfbvca lidfubhlaiuhdf alsduifhladushif halidfuhladuihf aliduhfs;ahsdlf aldsifguhlasugfka asdfluygadfyg',
    'hashtags': '#flutter #dart'
  };
  final List<Map<String, dynamic>> metricData = [
    {'title': '👍 Likes', 'metric': '23.5 K'},
    {'title': '💬 Comments', 'metric': '10.2 K'},
    {'title': '📈 Views', 'metric': '1.3 M'},
    {'title': '📝 Re Share', 'metric': '15.4 K'},
  ];
  final Map<String, dynamic> suggestionData = {
    'post':
        'This is a suggestion post nso fhefhiua haiushd fdjhsb skdij bb sdy oajsid byiguasd ',
    'hashtags': '#suggestion'
  };
  final Map<String, dynamic> trendData = {
    'title': 'X Current Trend',
    'details': [
      {
        'list_title': 'Flutter 3.0 Released',
        'list_metric': '5,000 Developers Joined'
      },
      {
        'list_title': 'Dart Updates',
        'list_metric': '10,000 Lines of Code Improved'
      },
      {
        'list_title': 'Firebase Enhancements',
        'list_metric': 'New Features Announced'
      }
    ],
  };

  Widget _buildPostList() {
    return ListView.builder(
      itemCount: postListData.length,
      itemBuilder: (context, index) {
        var post = postListData[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              postData = post; // Update postData when a post is clicked
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPostHeader(post),
                    const SizedBox(width: 10),
                    _buildPostBody(post),
                  ],
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (post['logo'] != null)
          CircleAvatar(
            backgroundImage: NetworkImage(post['logo']),
          ),
        const SizedBox(height: 8),
        if (post['time'] != null)
          Text(
            post['time'],
            style: TextStyle(
              fontSize: AppFonts.bodyFontSize,
              color: AppColors.black,
            ),
          ),
      ],
    );
  }

  // Post Body (Post Content + Hashtags)
  Widget _buildPostBody(Map<String, dynamic> post) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post['post'] != null)
            Text(
              post['post'],
              style: TextStyle(
                fontSize: AppFonts.bodyFontSize,
                color: AppColors.black,
              ),
            ),
          if (post['hashtags'] != null)
            Text(
              post['hashtags'],
              style: TextStyle(
                fontSize: AppFonts.bodyFontSize,
                color: AppColors.black,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // First Column (35% width)
          Expanded(
            flex: 35,
            child: Column(
              children: [
                // Row 1: Twitter logo, Recent Posts and dropdown button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.golf_course,
                            color: AppColors.black, size: 30),
                        const SizedBox(width: 8),
                        const Text('Recent Posts',
                            style: TextStyle(
                                fontSize: AppFonts.headingFontSize2,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    DropdownButton<String>(
                      value:
                          dropdownValues.isNotEmpty ? dropdownValues[0] : null,
                      items: dropdownValues
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {},
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Row 2: Post list card with clickable items
                Expanded(
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.white, // Set background color to white
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildPostList(),
                    ),
                  ), // Replacing with the updated _buildPostList
                ),
              ],
            ),
          ),

          // Second Column (65% width)
          Expanded(
            flex: 65,
            child: Column(
              children: [
                // Row 1: Post card
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.15, // 15% of height
                  child: CustomCard(type: 'post', data: postData),
                ),
                const SizedBox(height: 8),

                // Row 2: 4 Metric cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var metric in metricData)
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.20, // 25% of height
                          child: CustomCard(type: 'metric', data: metric),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 3: Metric and Suggestion cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Metric Card (25% width)
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.20, // 25% of height
                        child: CustomCard(type: 'metric', data: metricData[0]),
                      ),
                    ),
                    // Suggestion Card (takes maximum available width)
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.20, // 25% of height
                        child: CustomCard(
                            type: 'suggestion', data: suggestionData),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 4: 2 Trend cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Trend Card (50% width)
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.30, // 35% of height
                        child: CustomCard(type: 'trend', data: trendData),
                      ),
                    ),
                    // Trend Card (50% width)
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.30, // 35% of height
                        child: CustomCard(type: 'trend', data: trendData),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
