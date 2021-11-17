import 'package:flutter/material.dart';

class SocialLoginButtonComponent extends StatelessWidget {
  final ButtonStyle style;
  final String text;
  final void Function() function;
  final Color textColor;
  final Widget icon;

  SocialLoginButtonComponent({
    required this.style,
    required this.text,
    required this.function,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton.icon(
        onPressed: function,
        style: style,
        label: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        icon: icon,
      ),
    );
  }
}