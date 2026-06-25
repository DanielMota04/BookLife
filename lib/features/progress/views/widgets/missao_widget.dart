import 'package:flutter/material.dart';

class MissaoWidget extends StatelessWidget {
  final String titulo;
  final String descricao;
  final bool completa;

  const MissaoWidget({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.completa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: completa ? const Color(0xFF2EAD43) : Colors.white,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                color: completa ? const Color(0xFF2EAD43) : Colors.black54,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: completa ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: TextStyle(
                      fontSize: 15,
                      color: completa ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
