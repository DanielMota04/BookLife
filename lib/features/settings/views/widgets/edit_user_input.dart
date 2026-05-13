import 'package:book_life/core/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class EditUserInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const EditUserInput({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputTextField(controller: controller, hint: hint),
        ),
        SizedBox(width: 7),
        const Icon(Icons.edit_outlined),
      ],
    );
  }
}
