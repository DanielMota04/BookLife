import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/library/views/widgets/livro_card_widget.dart';
import 'package:book_life/features/library/views/widgets/biblioteca_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';

class MinhaBiblioteca extends StatefulWidget {
  const MinhaBiblioteca({super.key});

  @override
  State<MinhaBiblioteca> createState() => _MinhaBibliotecaState();
}

class _MinhaBibliotecaState extends State<MinhaBiblioteca> {
  final List<Book> _livros = [
    Book(
      id: '1',
      userId: 'temp',
      title: "A Metamorfose",
      author: "Franz Kafka",
      totalPages: 100,
      currentPage: 100,
      status: ReadingStatus.completed,
      rating: 9.0,
      coverUrl: "https://m.media-amazon.com/images/I/516qKNlle4L.jpg",
      addedAt: DateTime(2024),
    ),
    Book(
      id: '2',
      userId: 'temp',
      title: "Senhor dos Anéis",
      author: "J.R.R. Tolkien",
      totalPages: 100,
      currentPage: 100,
      status: ReadingStatus.completed,
      rating: 10.0,
      coverUrl:
          "https://m.media-amazon.com/images/I/41KWSPU9wcL._SY445_SX342_ML2_.jpg",
      addedAt: DateTime(2024),
    ),
    Book(
      id: '3',
      userId: 'temp',
      title: "A Divina Comédia",
      author: "Dante Alighieri",
      totalPages: 100,
      currentPage: 60,
      status: ReadingStatus.reading,
      rating: 8.0,
      coverUrl:
          "https://m.media-amazon.com/images/I/91ekEiRiyTL._AC_UL480_FMwebp_QL65_.jpg",
      addedAt: DateTime(2024),
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  String _pesquisa = '';
  String _filtroAtual = 'Todos';

  @override
  Widget build(BuildContext context) {
    List<Book> livrosFiltrados = _livros.where((livro) {
      final pesquisaMatch = livro.title.toLowerCase().contains(
        _pesquisa.toLowerCase(),
      );

      final filtroMatch = _filtroAtual == 'Todos'
          ? true
          : livro.status.displayName == _filtroAtual;

      return pesquisaMatch && filtroMatch;
    }).toList();

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
                color: AppColors.steelBlue,
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
            child: livrosFiltrados.isEmpty
                ? const Center(child: Text("Nenhum livro encontrado."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: livrosFiltrados.length,
                    itemBuilder: (context, index) {
                      final livro = livrosFiltrados[index];
                      return LivroCard(livro: livro);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final novoLivro = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdicionarLivroPage()),
          );

          if (novoLivro != null) {
            setState(() {
              _livros.add(novoLivro);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
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
          color: selecionado ? AppColors.steelBlue : Colors.grey.shade300,
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selecionado ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

