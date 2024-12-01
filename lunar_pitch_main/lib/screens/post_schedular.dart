import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostSchedular extends StatefulWidget {
  @override
  _PostSchedularState createState() => _PostSchedularState();
}

class _PostSchedularState extends State<PostSchedular> {
  TextEditingController _postContentController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, String>> scheduledPosts = [];

  // Function to handle the scheduling of posts
  void _schedulePost() {
    if (_postContentController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      // Show an alert if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    String formattedTime = _selectedTime!.format(context);

    setState(() {
      scheduledPosts.add({
        'content': _postContentController.text,
        'date': formattedDate,
        'time': formattedTime,
      });
    });

    // Clear the text field and reset the date and time pickers
    _postContentController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  // Function to show date picker
  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Function to handle deleting a scheduled post
  void _deleteScheduledPost(int index) {
    setState(() {
      scheduledPosts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Column 1: Post scheduling form (center-aligned)
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center alignment for the column
                    children: [
                      // Post content field
                      TextField(
                        controller: _postContentController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          labelText: 'Post Content',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Date Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the row
                        children: [
                          Text(_selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : 'Select Date'),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _selectDate,
                          ),
                        ],
                      ),
                      // Time Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the row
                        children: [
                          Text(_selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Select Time'),
                          IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: _selectTime,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Schedule button (center-aligned)
                      ElevatedButton(
                        onPressed: _schedulePost,
                        child: Text('Schedule Post'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            // Column 2: List of scheduled posts with a heading and divider
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading for scheduled posts
                      Text(
                        'Scheduled Posts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // List of scheduled posts
                      Expanded(
                        child: ListView.builder(
                          itemCount: scheduledPosts.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(scheduledPosts[index]['content']!),
                                  subtitle: Text(
                                      '${scheduledPosts[index]['date']} at ${scheduledPosts[index]['time']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteScheduledPost(index),
                                  ),
                                ),
                                // Divider between items
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
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
    );
  }
}
