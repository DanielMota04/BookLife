import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvaliacaoSelectorSheet extends StatelessWidget {
  final int avaliacaoSelecionada;
  final ValueChanged<int> onNotaSelected;

  const AvaliacaoSelectorSheet({
    super.key,
    required this.avaliacaoSelecionada,
    required this.onNotaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Qual a sua nota?',
            style: GoogleFonts.inriaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(10, 
            (index) {
              final nota = index + 1;
              final selecionado = nota == avaliacaoSelecionada;

              return InkWell(
                onTap: () => onNotaSelected(nota),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selecionado ? Colors.amber : Color(0xFFC9C9C9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$nota',
                    style: GoogleFonts.inriaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}