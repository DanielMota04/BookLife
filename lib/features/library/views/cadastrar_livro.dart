import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:book_life/core/widgets/input_text_field.dart';
import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/features/library/views/widgets/cover_picker.dart';

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
  bool _carregarISBN = false;

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

  void _limparCampos() {
    _tituloController.clear();
    _autorController.clear();
    _editoraController.clear();
    _generoController.clear();
    _sinopseController.clear();
  }

  void _formatarGeneros(List? subjects) {
    if (subjects == null) {
      _generoController.text = '';
      return;
    }

    List<String> generosBrutos = subjects.map((e) => e.toString()).toList();
    Set<String> generosLimpos = {};
    for (String generoBruto in generosBrutos) {
      List<String> separados = generoBruto.split(',');
      for (String genero in separados) {
        String g = genero.trim();
        String gLower = g.toLowerCase();
        if (g.isEmpty || g.contains(':') || g.contains('=')) continue;
        if (gLower.contains('literatura') ||
            gLower.contains('literature') ||
            g.contains('(') ||
            g.contains(')')) {
          continue;
        }
        if (g.length > 1) {
          g = g[0].toUpperCase() + g.substring(1).toLowerCase();
        }
        generosLimpos.add(g);
      }
    }

    List<String> listaFinal = generosLimpos.toList();
    if (listaFinal.length > 4) {
      listaFinal = listaFinal.sublist(0, 4);
    }
    _generoController.text = listaFinal.join(', ');
  }

  Future<void> _baixarCapa(String? coverUrl) async {
    if (coverUrl != null && coverUrl.isNotEmpty) {
      final urlSegura = coverUrl.replaceAll('http:', 'https:');
      final imagemResponse = await http.get(Uri.parse(urlSegura));
      if (imagemResponse.statusCode == 200) {
        setState(() {
          _imagemLivro = imagemResponse.bodyBytes;
        });
      } else {
        _mostrarMensagem("Não foi possível carregar a imagem da capa.");
      }
    } else {
      _mostrarMensagem("Capa do livro não está cadastrada no ISBN.");
    }
  }

  Future<void> _buscarLivroISBN() async {
    final isbn = _isbnController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (isbn.isEmpty) {
      _mostrarMensagem("Digite o ISBN.");
      return;
    }
    setState(() {
      _carregarISBN = true;
      _imagemLivro = null;
    });

    _limparCampos();
    try {
      final url = Uri.parse("https://brasilapi.com.br/api/isbn/v1/$isbn");
      final resposta = await http.get(url);
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        _tituloController.text = dados['title'] ?? '';
        _editoraController.text = dados['publisher'] ?? '';
        _sinopseController.text = dados['synopsis'] ?? '';
        _autorController.text = dados['authors'] != null
            ? (dados['authors'] as List).join(', ')
            : '';

        _formatarGeneros(dados['subjects'] as List?);
        await _baixarCapa(dados['cover_url']);
      } else if (resposta.statusCode == 404) {
        _mostrarMensagem("Livro não encontrado na base de dados.");
      } else {
        _mostrarMensagem("Erro na API: Código ${resposta.statusCode}");
      }
    } catch (e) {
      _mostrarMensagem("Erro de conexão ao buscar ISBN.");
    } finally {
      setState(() {
        _carregarISBN = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _salvarLivro() async {
    if (_tituloController.text.trim().isEmpty) {
      _mostrarMensagem("O título é obrigatório.");
      return;
    }

    final usuarioLogado = FirebaseAuth.instance.currentUser;
    if (usuarioLogado == null) {
      _mostrarMensagem("Erro: Você precisa estar logado para salvar um livro.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? base64Image;
      if (_imagemLivro != null) {
        base64Image = base64Encode(_imagemLivro!);
      }

      final bookData = {
        'userId': usuarioLogado.uid,
        'title': _tituloController.text,
        'author': _autorController.text,
        'publisher': _editoraController.text,
        'genres': _generoController.text,
        'synopsis': _sinopseController.text,
        'totalPages': 0,
        'currentPage': 0,
        'status': ReadingStatus.reading.name, 
        'coverBase64': base64Image,
        'addedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('books').add(bookData);

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); 
        _mostrarMensagem("Erro ao salvar: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: SingleChildScrollView(
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
                onSubmitted: (_) => _buscarLivroISBN(),
                decoration: InputDecoration(
                  hintText: "Digite o ISBN-13 ou ISBN-10",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  suffixIcon: _carregarISBN
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _buscarLivroISBN,
                        ),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  "ou",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  "Adicione manualmente abaixo",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              CoverPicker(imagem: _imagemLivro, onTap: _selecionarImagem),
              const SizedBox(height: 22),
              InputTextField(
                controller: _tituloController,
                hint: "Digite o Título",
              ),
              const SizedBox(height: 10),
              InputTextField(
                controller: _autorController,
                hint: "Autor do Livro (Opcional)",
              ),
              const SizedBox(height: 10),
              InputTextField(
                controller: _editoraController,
                hint: "Editora (Opcional)",
              ),
              const SizedBox(height: 10),
              InputTextField(
                controller: _generoController,
                hint: "Gêneros do Livro (Opcional)",
              ),
              const SizedBox(height: 18),
              Text(
                "Sinopse (Opcional)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: TextField(
                  controller: _sinopseController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "Sinopse do livro aqui",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
                  onPressed: _salvarLivro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
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