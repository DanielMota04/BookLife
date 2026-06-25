import 'package:flutter/material.dart';

class EstatisticaWidget extends StatelessWidget {
  final String numero;
  final String texto;

  const EstatisticaWidget({
    super.key,
    required this.numero,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
