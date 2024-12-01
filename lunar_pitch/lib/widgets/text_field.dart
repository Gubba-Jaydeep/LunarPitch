import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? type;
  final String? data;

  const CustomTextField({Key? key, this.type, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (type) {
      case 'card_title':
        style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
        break;
      case 'metric_title':
        style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
        break;
      case 'metric_data':
        style = TextStyle(fontSize: 14);
        break;
      case 'card_text':
        style = TextStyle(fontSize: 14, color: Colors.grey[600]);
        break;
      case 'date_text':
        style = TextStyle(fontSize: 12, color: Colors.grey);
        break;
      case 'trend_text':
        style = TextStyle(fontSize: 16, color: Colors.blue);
        break;
      case 'trend_metric':
        style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
        break;
      case 'title':
        style = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
        break;
      default:
        style = TextStyle(fontSize: 14);
    }

    return TextField(
      controller: TextEditingController(text: data),
      style: style,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
