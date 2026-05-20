import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusRadioButton<T>extends StatelessWidget {
  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T> onChanged;

  const StatusRadioButton({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        width: min(90, 120),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF737373) : Color(0xFFC9C9C9),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color(0xFF737373),
            width: 1.0,
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.inriaSans(
            color: isSelected ? Colors.white : Colors.black,
          
          ),
        ),
      ),
    );
  }
}