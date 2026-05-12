import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/features/library/views/widgets/book_text_field.dart';
import 'package:book_life/features/library/views/widgets/cover_picker.dart';
import 'package:file_picker/file_picker.dart';

class AdicionarLivroPage extends StatefulWidget {
  const AdicionarLivroPage({super.key});

  @override
  State<AdicionarLivroPage> createState() => _AdicionarLivroPageState();
}

class _AdicionarLivroPageState extends State<AdicionarLivroPage> {
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _sinopseController = TextEditingController();
  Uint8List? _imagemLivro;

  Future<void> _selecionarImagem() async {
    FilePickerResult? resultado = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (resultado != null) {
      setState(() {
        _imagemLivro = resultado.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back, size: 28),
              ),

              const SizedBox(height: 8),
              Text(
                "Adicionar Novo Livro",
                style: GoogleFonts.inriaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4F7CAC),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Digite o código ISBN do livro para\nautocompletar os dados",
                style: GoogleFonts.inriaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              BookTextField(controller: _isbnController, hint: "..."),

              const SizedBox(height: 18),
              Center(
                child: Text(
                  "ou",
                  style: GoogleFonts.inriaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Center(
                child: Text(
                  "Adicione manualmente abaixo",
                  style: GoogleFonts.inriaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              CoverPicker(
                imagem: _imagemLivro,
                onTap: _selecionarImagem,
              ),

              const SizedBox(height: 22),
              BookTextField(
                controller: _tituloController,
                hint: "Digite o Título",
              ),

              const SizedBox(height: 10),
              BookTextField(
                controller: _autorController,
                hint: "Autor do Livro (Opcional)",
              ),

              const SizedBox(height: 10),
              BookTextField(
                controller: _editoraController,
                hint: "Editora (Opcional)",
              ),

              const SizedBox(height: 10),
              BookTextField(
                controller: _generoController,
                hint: "Gêneros do Livro (Opcional)",
              ),

              const SizedBox(height: 18),
              Text(
                "Sinopse (Opcional)",
                style: GoogleFonts.inriaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF17384F),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade500),
                ),
                child: TextField(
                  controller: _sinopseController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "Sinopse do livro aqui",
                    hintStyle: GoogleFonts.inriaSans(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    final novoLivro = Book(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: 'temp',
                      title: _tituloController.text,
                      author: _autorController.text,
                      totalPages: 0, // vamos ver como fazer isso depois.
                      status: ReadingStatus.reading,
                      coverUrl: null,
                      coverBytes: _imagemLivro,
                      addedAt: DateTime.now(),
                    );
                    Navigator.pop(context, novoLivro);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D84B3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Salvar",
                    style: GoogleFonts.inriaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
