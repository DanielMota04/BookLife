import 'package:book_life/core/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  const ChangePasswordInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscureText,
  });

  @override
  State<ChangePasswordInput> createState() => _ChangePasswordInputState();
}

class _ChangePasswordInputState extends State<ChangePasswordInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputTextField(
            controller: widget.controller,
            hint: widget.hint,
            obscureText: _isObscure,
          ),
        ),
        SizedBox(width: 7),
        IconButton(
          onPressed: () => setState(() => _isObscure = !_isObscure),
          icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),
      ],
    );
  }
}
