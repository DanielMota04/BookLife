import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/widgets/input_text_field.dart';
import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/features/library/views/widgets/cover_picker.dart';
import 'package:book_life/features/library/viewmodels/adicionar_livro_viewmodel.dart';

class AdicionarLivroPage extends StatefulWidget {
  const AdicionarLivroPage({super.key});

  @override
  State<AdicionarLivroPage> createState() => _AdicionarLivroPageState();
}

class _AdicionarLivroPageState extends State<AdicionarLivroPage> {
  final AdicionarLivroViewModel _viewModel = AdicionarLivroViewModel();

  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _sinopseController = TextEditingController(); 
  Uint8List? _imagemLivro;
  int _paginasDoLivro = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      if (_viewModel.mensagemDeErro != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_viewModel.mensagemDeErro!))
        );
        _viewModel.limparErro();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _isbnController.dispose();
    _tituloController.dispose();
    _autorController.dispose();
    _editoraController.dispose();
    _generoController.dispose();
    _sinopseController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    FilePickerResult? arquivoSelecionado = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    
    if (arquivoSelecionado != null) {
      setState(() {
        _imagemLivro = arquivoSelecionado.files.first.bytes;
      });
    }
  }

  void _limparFormulario() {
    _tituloController.clear();
    _autorController.clear();
    _editoraController.clear();
    _generoController.clear();
    _sinopseController.clear();
    setState(() {
      _imagemLivro = null;
    });
  }

  Future<void> _pesquisaPorIsbn() async {
    _limparFormulario();
    FocusScope.of(context).unfocus(); 
    final dadosRetornados = await _viewModel.pesquisarLivroPorIsbn(_isbnController.text);
    
    if (dadosRetornados != null) {
      _tituloController.text = dadosRetornados['titulo'];
      _autorController.text = dadosRetornados['autor'];
      _editoraController.text = dadosRetornados['editora'];
      _generoController.text = dadosRetornados['generos'];
      _sinopseController.text = dadosRetornados['sinopse'];
      setState(() {
        _imagemLivro = dadosRetornados['capa'];
        _paginasDoLivro = dadosRetornados['paginas'];
      });
    }
  }

  Future<void> _formDeSalvamento() async {
    if (_tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O título é obrigatório.")));
      return;
    }

    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    List<String> generosMapeados = [];
    if (_generoController.text.trim().isNotEmpty) {
      generosMapeados = _generoController.text.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();
    }

    final livroParaSalvar = Book(
      id: 'temporario', 
      userId: usuarioAtual.uid,
      title: _tituloController.text.trim(),
      author: _autorController.text.trim(),
      isbn: _isbnController.text.trim().isNotEmpty ? _isbnController.text.trim() : null,
      publisher: _editoraController.text.trim().isNotEmpty ? _editoraController.text.trim() : null,
      genres: generosMapeados,
      synopsis: _sinopseController.text.trim().isNotEmpty ? _sinopseController.text.trim() : null,
      coverBytes: _imagemLivro,
      totalPages: _paginasDoLivro,
      addedAt: DateTime.now(),
      status: ReadingStatus.wishlist,
    );

    final sucesso = await _viewModel.salvarNovoLivro(livroParaSalvar);
    if (sucesso && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Adicionar Novo Livro",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Digite o código ISBN do livro para\nautocompletar os dados",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _isbnController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _pesquisaPorIsbn(),
                    decoration: InputDecoration(
                      hintText: "Digite o ISBN-13 ou ISBN-10",
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                      suffixIcon: _viewModel.buscandoDadosDoLivro
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _pesquisaPorIsbn,
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(child: Text("ou", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 18),
                  const Center(child: Text("Adicione manualmente abaixo", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 16),
                  
                  CoverPicker(imagem: _imagemLivro, onTap: _selecionarImagem),
                  
                  const SizedBox(height: 22),
                  InputTextField(controller: _tituloController, hint: "Digite o Título"),
                  const SizedBox(height: 10),
                  InputTextField(controller: _autorController, hint: "Autor do Livro (Opcional)"),
                  const SizedBox(height: 10),
                  InputTextField(controller: _editoraController, hint: "Editora (Opcional)"),
                  const SizedBox(height: 10),
                  InputTextField(controller: _generoController, hint: "Gêneros do Livro (Opcional)"),
                  const SizedBox(height: 18),
                  
                  Text(
                    "Sinopse (Opcional)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                    ),
                    child: TextField(
                      controller: _sinopseController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: "Sinopse do livro aqui",
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                      onPressed: _viewModel.salvandoLivro ? null : _formDeSalvamento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: _viewModel.salvandoLivro
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              "Salvar",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}