import 'package:flutter/material.dart';

class EditTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final Function(String value)? onChange;
  final bool autofocus;

  const EditTextWidget({
    super.key,
    required this.controller,
    this.hint,
    this.fontSize = 15.0,
    this.fontColor = Colors.black54,
    this.fontWeight = FontWeight.w500,
    this.onChange,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onChanged: onChange ?? (_) {},
    );
  }
}
