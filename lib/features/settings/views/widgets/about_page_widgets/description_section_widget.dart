import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sobre o app', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            'O BookLife é um aplicativo de gerenciamento de leitura feito para quem quer organizar sua biblioteca pessoal e manter consistência no hábito de ler. Aqui você pode cadastrar livros, acompanhar o progresso de cada leitura, criar listas de leitura, definir metas e registrar o tempo dedicado a cada leitura.',
          ),
        ],
      ),
    );
  }
}
