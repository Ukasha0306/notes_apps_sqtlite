import 'package:flutter/material.dart';


class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const InputTextField({Key? key, required this.controller, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
