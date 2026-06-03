import 'package:book_life/features/book_details/views/widgets/modal/rating/bottom_rating_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AvaliacaoPicker extends StatefulWidget {
  final int avaliacaoInicial;
  final ValueChanged<int> onChanged;

  const AvaliacaoPicker({
    super.key,
    this.avaliacaoInicial = 0,
    required this.onChanged,
  });

  @override
  State<AvaliacaoPicker> createState() => _AvaliacaoPickerState();
}

class _AvaliacaoPickerState extends State<AvaliacaoPicker> {
  late int _avaliacaoSelecionada;

  @override
  void initState() {
    super.initState();
    _avaliacaoSelecionada = widget.avaliacaoInicial;
  }

  void _abrirBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AvaliacaoSelectorSheet(
          avaliacaoSelecionada: _avaliacaoSelecionada,
          onNotaSelected: (novaNota) {
            setState(() => _avaliacaoSelecionada = novaNota);
            widget.onChanged(novaNota);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _abrirBottomSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star, 
                  color: Colors.black, 
                  size: 30
                ),
                const SizedBox(width: 4),
                Text(
                  '$_avaliacaoSelecionada',
                  style: GoogleFonts.inriaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}