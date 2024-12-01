import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart'; // Importing the constants
import '../constants/fonts.dart'; // Importing font constants

class CustomCard extends StatelessWidget {
  final String? type;
  final dynamic data; // To hold JSON data for lists or single items
  final String? source;

  const CustomCard({
    super.key,
    this.type,
    this.data,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent;

    switch (type) {
      case 'post_list':
        cardContent = _buildPostList();
        break;
      case 'suggestion':
        cardContent = _buildSuggestion();
        break;
      case 'metric':
        cardContent = _buildMetric();
        break;
      case 'post':
        cardContent = _buildPost();
        break;
      case 'trend':
        cardContent = _buildTrend();
        break;
      default:
        cardContent = _buildDefaultCard();
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.white, // Set background color to white
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cardContent,
      ),
    );
  }

  // Trend
  Widget _buildTrend() {
    Map<String, dynamic> trend = data;
    List<dynamic> trendDetails = trend['details'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trend['title'] != null)
          Text(
            trend['title'],
            style: TextStyle(
              fontSize: AppFonts.headingFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        for (var detail in trendDetails)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (detail['list_title'] != null)
                  Text(
                    detail['list_title'],
                    style: TextStyle(
                      fontSize: AppFonts.bodyFontSize,
                      color: AppColors.black,
                    ),
                  ),
                if (detail['list_metric'] != null)
                  Text(
                    detail['list_metric'],
                    style: TextStyle(
                      fontSize: AppFonts.bodyFontSize,
                      color: AppColors.black,
                    ),
                  ),
              ],
            ),
          ),
        if (source != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Source: $source',
              style: TextStyle(
                fontSize: AppFonts.smallFontSize,
                color: AppColors.black,
              ),
            ),
          ),
      ],
    );
  }

  // Post List
  Widget _buildPostList() {
    List<Map<String,dynamic>> posts = data;
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  _buildPostHeader(post),
                  const SizedBox(width: 10),
                  _buildPostBody(post),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ],
        );
      },
    );
  }

  // Post Header (Logo + Time)
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

  // Post
  Widget _buildPost() {
    Map<String, dynamic> post = data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildPostHeader(post),
            const SizedBox(width: 10),
            _buildPostBody(post),
          ],
        ),
      ],
    );
  }

  // Suggestion
  Widget _buildSuggestion() {
    Map<String, dynamic> suggestion = data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            '💬 Suggested Reply',
            style: TextStyle(
              fontSize: AppFonts.headingFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        if (suggestion['post'] != null)
          Text(
            suggestion['post'],
            style: TextStyle(
              fontSize: AppFonts.bodyFontSize,
              color: AppColors.black,
            ),
          ),
        if (suggestion['hashtags'] != null)
          Text(
            suggestion['hashtags'],
            style: TextStyle(
              fontSize: AppFonts.bodyFontSize,
              color: AppColors.black,
            ),
          ),
      ],
    );
  }

  // Metric
  Widget _buildMetric() {
    Map<String, dynamic> metric = data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (metric['title'] != null)
          AutoSizeText(
            metric['title'],
            style: TextStyle(
              fontSize: AppFonts.headingFontSize2,
              fontWeight: FontWeight.normal,
              color: AppColors.grey,
            ),
            maxFontSize: AppFonts.headingFontSize2,
            minFontSize: AppFonts.subheadingFontSize,
            maxLines: 1,
          ),
        SizedBox(height: 20),
        if (metric['metric'] != null)
          AutoSizeText(
            metric['metric'],
            style: TextStyle(
              fontSize: AppFonts.headingFontSize2,
              color: AppColors.black,
            ),
            maxFontSize: AppFonts.headingFontSize,
            minFontSize: AppFonts.subheadingFontSize,
            maxLines: 1,
          ),
      ],
    );
  }

  // Default Card (in case of missing type or data)
  Widget _buildDefaultCard() {
    return const Column(
      children: [
        Text(
          'No content available',
          style: TextStyle(
            fontSize: AppFonts.bodyFontSize,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
