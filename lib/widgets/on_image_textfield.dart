import 'package:flutter/material.dart';

class OnImageTextField extends StatelessWidget {
  final TextStyle style;
  final String hintText;
  final TextEditingController controller;
  OnImageTextField(this.style, this.hintText,{this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      controller: controller,
      style: this.style,
      maxLines: null,
      maxLength: 50,
      decoration: InputDecoration.collapsed(hintText: hintText, hintStyle: TextStyle(color: Colors.white)),
    );
  }
}
