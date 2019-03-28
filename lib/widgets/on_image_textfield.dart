import 'package:flutter/material.dart';

class OnImageTextField extends StatelessWidget {
  final TextStyle style;
  final String hintText;

  OnImageTextField(this.style, this.hintText);
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      style: this.style,
      maxLines: null,
      maxLength: 50,
      decoration: InputDecoration.collapsed(hintText: hintText, hintStyle: TextStyle(color: Colors.white)),
    );
  }
}
