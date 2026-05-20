import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/features/book_details/views/widgets/modal/radio_button_status.dart';
import 'package:book_life/features/book_details/views/widgets/modal/rating/input_rating.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormAtualizarProgresso extends StatefulWidget {
  final Book livro;

  FormAtualizarProgresso({super.key, required this.livro});

  @override
  State<FormAtualizarProgresso> createState() => _FormAtualizarProgresso();
}

class _FormAtualizarProgresso extends State<FormAtualizarProgresso> {
  late ReadingStatus _statusSelecionado;
  late int _avaliacao;
  late int _progresso;
  late int _totalPaginas;

  late TextEditingController _progressoController;
  late TextEditingController _totalController;

  @override
  void initState() {
    super.initState();
    _statusSelecionado = widget.livro.status;
    _avaliacao = widget.livro.rating!.toInt();
    _progresso = widget.livro.currentPage;
    _totalPaginas = widget.livro.totalPages;

    _progressoController = TextEditingController(
      text: widget.livro.currentPage.toString(),
    );
    _totalController = TextEditingController(
      text: widget.livro.totalPages.toString(),
    );
  }

  @override
  void dispose() {
    _progressoController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 66,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.livro.coverUrl.toString(),
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.livro.title,
                          style: GoogleFonts.inriaSans(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'de ${widget.livro.author}',
                          style: GoogleFonts.inriaSans(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Status',
                  style: GoogleFonts.inriaSans(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ReadingStatus.values.map((status) {
                    return StatusRadioButton<ReadingStatus>(
                      title: status.displayName,
                      value: status,
                      groupValue: _statusSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _statusSelecionado = status;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Avaliação',
                  style: GoogleFonts.inriaSans(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              AvaliacaoPicker(
                avaliacaoInicial: _avaliacao,
                onChanged: (int novaNota) {
                  setState(() {
                    _avaliacao = novaNota;
                  });
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 125,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                    ),
                    alignment: AlignmentGeometry.centerStart,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Progresso",
                          style: GoogleFonts.inriaSans(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _progressoController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 125,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                    ),
                    alignment: AlignmentGeometry.centerStart,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inriaSans(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _totalController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(140, 44),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inriaSans(
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      final int progressoFinal =
                          int.tryParse(_progressoController.text) ??
                          widget.livro.currentPage;
                      final int totalFinal =
                          int.tryParse(_totalController.text) ??
                          widget.livro.totalPages;

                      Navigator.of(context).pop({
                        'status': _statusSelecionado,
                        'rating': _avaliacao,
                        'currentPage': progressoFinal,
                        'totalPages': totalFinal,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F7CAC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      minimumSize: const Size(140, 44),
                    ),
                    child: Text(
                      'Salvar',
                      style: GoogleFonts.inriaSans(
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
