import 'package:flutter/material.dart';

class KTextFormField extends StatelessWidget {
  const KTextFormField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.validator,
    this.maxLine = 1,
    this.inputType = TextInputType.text
  });

  final TextEditingController controller;
  final Icon prefixIcon;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLine;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLine,
        keyboardType: inputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon,
          labelText: hintText,
        ),
      ),
    );
  }
}
