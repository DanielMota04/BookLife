import 'dart:ui';
import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/features/book_details/views/widgets/modal/progress_form.dart';
import 'package:book_life/features/reading_timer/views/livro_timer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_life/features/reading_timer/repositories/examples_books.dart';
import 'package:book_life/features/book_details/views/widgets/button_status.dart';

class LivroDetails extends StatefulWidget {
  final String bookId;
  const LivroDetails({super.key, required this.bookId});

  @override
  State<LivroDetails> createState() => _LivroDetailsState();
}

class _LivroDetailsState extends State<LivroDetails> {
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
    if (resultado != null) {
      setState(() {
        int index = mockLivros.indexWhere((l) => l.id == livroAtual.id);

        if (index != -1) {
          mockLivros[index] = mockLivros[index].copyWith(
            status: resultado['status'],
            rating: (resultado['rating'] as int).toDouble(),
            currentPage: resultado['currentPage'],
            totalPages: resultado['totalPages'],
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final livro = mockLivros.firstWhere(
      (b) => b.id == widget.bookId,
      orElse: () => mockLivros.first,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {context.go(Routes.library)},
          icon: const Icon(Icons.arrow_back, size: 32),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                int index = mockLivros.indexWhere((l) => l.id == livro.id);

                if (index != -1) {
                  mockLivros[index] = mockLivros[index].toggleFavorite();
                }
              });
            },
            icon: Icon(
              livro.isFavorite ? Icons.star : Icons.star_border,
              size: 32,),
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
                      image: DecorationImage(
                        image: NetworkImage(livro.coverUrl.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(color: Colors.black.withOpacity(0.2)),
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
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(livro.coverUrl.toString()),
                          fit: BoxFit.cover,
                        ),
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
                textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                        livro.rating!.toInt().toString(),
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
                        "${((livro.currentPage / livro.totalPages) * 100).round().toString()} %",
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
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LivroTimer(livro: livro),
                  ),
                ),
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
  }
}
