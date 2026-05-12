import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_life/biblioteca.dart';
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
              Text("Digite o código ISBN do livro para\nautocompletar os dados",
                style: GoogleFonts.inriaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              _buildTextField(controller: _isbnController, hint: "..."),

              const SizedBox(height: 18),
              Center(
                child: Text("ou",
                  style: GoogleFonts.inriaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Center(
                child: Text("Adicione manualmente abaixo",
                  style: GoogleFonts.inriaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _selecionarImagem,
                  child: Container(
                    width: 120,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade500),
                    ),
                    child: _imagemLivro != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.memory(
                              _imagemLivro!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.upload,
                                size: 38,
                                color: Color(0xFF1D8CA3),
                              ),

                              const SizedBox(height: 8),
                              Text(
                                "Capa do livro",
                                style: GoogleFonts.inriaSans(
                                  fontSize: 16,
                                  color: const Color(0xFF1D8CA3),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
              _buildTextField(
                controller: _tituloController,
                hint: "Digite o Título",
              ),

              const SizedBox(height: 10),
              _buildTextField(
                controller: _autorController,
                hint: "Autor do Livro (Opcional)",
              ),

              const SizedBox(height: 10),
              _buildTextField(
                controller: _editoraController,
                hint: "Editora (Opcional)",
              ),

              const SizedBox(height: 10),
              _buildTextField(
                controller: _generoController,
                hint: "Gêneros do Livro (Opcional)",
              ),

              const SizedBox(height: 18),
              Text("Sinopse (Opcional)",
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
                    final novoLivro = Livro(
                      titulo: _tituloController.text,
                      autor: _autorController.text,
                      progresso: "0%",
                      nota: "0",
                      status: "Lendo",
                      imageUrl: null,
                      imagemBytes: _imagemLivro,
                    );
                    Navigator.pop(context, novoLivro);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D84B3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Salvar",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF4F7CAC), width: 2),
          ),
        ),
      ),
    );
  }
}
