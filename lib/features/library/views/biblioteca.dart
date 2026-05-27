import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/library/views/widgets/livro_card_widget.dart';
import 'package:book_life/features/library/views/widgets/biblioteca_search_bar.dart';
import 'package:book_life/features/book_details/views/livro_details.dart';

class MinhaBiblioteca extends StatefulWidget {
  const MinhaBiblioteca({super.key});

  @override
  State<MinhaBiblioteca> createState() => _MinhaBibliotecaState();
}

class _MinhaBibliotecaState extends State<MinhaBiblioteca> {
  final TextEditingController _searchController = TextEditingController();

  String _pesquisa = '';
  String _filtroAtual = 'Todos';

  ReadingStatus _parseStatus(String statusStr) {
    return ReadingStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => ReadingStatus.reading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Minha Biblioteca",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          BibliotecaSearchBar(
            controller: _searchController,
            onChanged: (value) => setState(() => _pesquisa = value),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 45,
            child: Row(
              children: [
                _buildFiltro("Todos"),
                _buildFiltro("Lendo"),
                _buildFiltro("Lido"),
                _buildFiltro("Em espera"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('addedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Nenhum livro encontrado."));
                }

                List<Book> livrosFirestore = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  Uint8List? coverBytes;
                  if (data['coverBase64'] != null) {
                    try {
                      coverBytes = base64Decode(data['coverBase64']);
                    } catch (e) {
                      debugPrint("Erro ao decodificar imagem: $e");
                    }
                  }

                  return Book(
                    id: doc.id,
                    userId: data['userId'] ?? '',
                    title: data['title'] ?? 'Sem Título',
                    author: data['author'] ?? '',
                    totalPages: data['totalPages'] ?? 0,
                    currentPage: data['currentPage'] ?? 0,
                    status: _parseStatus(data['status'] ?? 'reading'),
                    coverUrl: null, 
                    coverBytes: coverBytes,
                    addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  );
                }).toList();

                List<Book> livrosFiltrados = livrosFirestore.where((livro) {
                  final pesquisaMatch = livro.title.toLowerCase().contains(
                    _pesquisa.toLowerCase(),
                  );
                  final filtroMatch = _filtroAtual == 'Todos'
                      ? true
                      : livro.status.displayName == _filtroAtual;

                  return pesquisaMatch && filtroMatch;
                }).toList();

                if (livrosFiltrados.isEmpty) {
                  return const Center(child: Text("Nenhum livro corresponde à pesquisa."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: livrosFiltrados.length,
                  itemBuilder: (context, index) {
                    final livro = livrosFiltrados[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LivroDetails(bookId: livro.id),
                          ),
                        );
                      },
                      child: LivroCard(livro: livro),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdicionarLivroPage()),
          );
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ),
    );
  }

  Widget _buildFiltro(String texto) {
    final bool selecionado = _filtroAtual == texto;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filtroAtual = texto;
          });
        },
        child: Container(
          alignment: Alignment.center,
          color: selecionado
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selecionado
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}