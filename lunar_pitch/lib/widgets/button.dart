import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? type;
  final String? image;
  final String? text;

  const CustomButton({Key? key, this.type, this.image, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'logo':
        return _buildLogoButton();
      case 'text':
        return _buildTextButton();
      case 'text_logo':
        return _buildTextLogoButton();
      default:
        return _buildTextButton();
    }
  }

  Widget _buildLogoButton() {
    return ElevatedButton(
      onPressed: () {},
      child: image != null ? Image.network(image!) : Container(),
    );
  }

  Widget _buildTextButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text ?? 'Button'),
    );
  }

  Widget _buildTextLogoButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null) Image.network(image!, width: 24, height: 24),
          if (text != null) Text(text!),
        ],
      ),
    );
  }
}
