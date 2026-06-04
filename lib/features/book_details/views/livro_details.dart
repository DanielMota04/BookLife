import 'dart:developer';
import 'dart:ui';
import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/features/book_details/viewmodels/book_details_viewmodel.dart';
import 'package:book_life/features/book_details/views/widgets/modal/progress_form.dart';
import 'package:book_life/features/reading_timer/views/livro_timer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_life/features/book_details/views/widgets/button_status.dart';
import 'package:provider/provider.dart';

class LivroDetails extends StatefulWidget {
  final Book? book;
  const LivroDetails({super.key, this.book});

  @override
  State<LivroDetails> createState() => _LivroDetailsState();
}

class _LivroDetailsState extends State<LivroDetails> {
  late final BookDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BookDetailsViewModel(initialBook: widget.book);
  }

  Future<void> _abrirModalDeProgresso(
    BuildContext context,
    Book livroAtual,
  ) async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return FormAtualizarProgresso(livro: livroAtual);
      },
    );

    if (resultado != null && context.mounted) {
      _viewModel.updateProgress(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_viewModel.errorMessage != null || _viewModel.book == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_viewModel.errorMessage ?? "Livro indisponível."),
              ),
            ),
          );
        }

        final livro = _viewModel.book!;

        ImageProvider? coverImageProvider;

        if (livro.coverBytes != null && livro.coverBytes!.isNotEmpty) {
          coverImageProvider = MemoryImage(livro.coverBytes!);
        } else if (livro.coverUrl != null &&
            livro.coverUrl!.toString().isNotEmpty) {
          coverImageProvider = NetworkImage(livro.coverUrl.toString());
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => {context.pop(context)},
              icon: const Icon(Icons.arrow_back, size: 32),
            ),
            actions: [
              IconButton(
                onPressed: () => _viewModel.toggleFavorite(),
                icon: Icon(
                  livro.isFavorite ? Icons.star : Icons.star_border,
                  size: 32,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Hero(
                      tag: 'image_bg_${livro.id}',
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: coverImageProvider != null
                              ? DecorationImage(
                                  image: coverImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      child: Hero(
                        tag: 'capa_livro_${livro.id}',
                        child: Container(
                          height: 250,
                          width: 190,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            image: coverImageProvider != null
                                ? DecorationImage(
                                    image: coverImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                Text(
                  livro.title,
                  style: GoogleFonts.inriaSans(
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "de ${livro.author}",
                  style: GoogleFonts.inriaSans(
                    textStyle: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF022B3A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: livro.genres.map((genre) {
                    return Chip(
                      label: Text(
                        genre,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      backgroundColor: Color(0xFFC8C8C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Divider(color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Progresso",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inriaSans(
                        textStyle: TextStyle(fontSize: 20),
                        color: Color(0xFF022B3A),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 30),
                          Text(
                            livro.rating?.toInt().toString() ?? '0',
                            style: GoogleFonts.inriaSans(fontSize: 22),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${livro.currentPage.toString()} / ${livro.totalPages.toString()} pages",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.inriaSans(
                              textStyle: TextStyle(fontSize: 22),
                            ),
                          ),
                          Text(
                            "${livro.totalPages > 0 ? ((livro.currentPage / livro.totalPages) * 100).round() : 0} %",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.inriaSans(
                              textStyle: TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                BookStatusButton(
                  status: livro.status,
                  onPressed: () {
                    _abrirModalDeProgresso(context, livro);
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final livroAtualizado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LivroTimer(livro: livro),
                      ),
                    );
                    if (livroAtualizado != null) {
                      _viewModel.atualizarLivroRetornado(livroAtualizado);
                    }
                  },
                  icon: Icon(Icons.access_time),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F7CAC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 16,
                    ),
                    minimumSize: const Size(100, 50),
                  ),
                  label: Text(
                    "Iniciar Cronômetro de Leitura",
                    style: GoogleFonts.inriaSans(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Divider(color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Sinopse",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inriaSans(
                        textStyle: TextStyle(fontSize: 20),
                        color: Color(0xFF022B3A),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Text(
                    livro.synopsis.toString(),
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inriaSans(
                      textStyle: TextStyle(fontSize: 20),
                      color: Color(0xFF022B3A),
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
