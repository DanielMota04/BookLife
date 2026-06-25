import 'package:flutter/material.dart';

class MetaWidget extends StatelessWidget {
  final String texto;

  const MetaWidget({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32,
      margin: const EdgeInsets.only(bottom: 2),
      color: const Color(0xFF4F7CAC),
      alignment: Alignment.center,
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
