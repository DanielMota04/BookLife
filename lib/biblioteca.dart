import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MinhaBiblioteca(),
    );
  }
}

class Livro {
  String titulo;
  String autor;
  String progresso;
  String nota;
  String status;
  String imageUrl;

  Livro({
    required this.titulo,
    required this.autor,
    required this.progresso,
    required this.nota,
    required this.status,
    required this.imageUrl,
  });
}

class MinhaBiblioteca extends StatefulWidget {
  const MinhaBiblioteca({super.key});

  @override
  State<MinhaBiblioteca> createState() => _MinhaBibliotecaState();
}

class _MinhaBibliotecaState extends State<MinhaBiblioteca> {
  final List<Livro> _livros = [
    Livro(
      titulo: "A Metamorfose",
      autor: "Franz Kafka",
      progresso: "100%",
      nota: "9",
      status: "Lido",
      imageUrl: "https://m.media-amazon.com/images/I/516qKNlle4L.jpg",
    ),
    Livro(
      titulo: "Senhor dos Anéis",
      autor: "J.R.R. Tolkien",
      progresso: "100%",
      nota: "10",
      status: "Lido",
      imageUrl:
          "https://m.media-amazon.com/images/I/41KWSPU9wcL._SY445_SX342_ML2_.jpg",
    ),
    Livro(
      titulo: "A Divina Comédia",
      autor: "Dante Alighieri",
      progresso: "60%",
      nota: "8",
      status: "Lendo",
      imageUrl:
          "https://m.media-amazon.com/images/I/91ekEiRiyTL._AC_UL480_FMwebp_QL65_.jpg",
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  String _pesquisa = '';
  String _filtroAtual = 'Todos';

  @override
  Widget build(BuildContext context) {
    List<Livro> livrosFiltrados = _livros.where((livro) {
      final pesquisaMatch = livro.titulo.toLowerCase().contains(
        _pesquisa.toLowerCase(),
      );

      final filtroMatch = _filtroAtual == 'Todos'
          ? true
          : livro.status == _filtroAtual;

      return pesquisaMatch && filtroMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 79, 115, 172),
        elevation: 0,

        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.white, size: 30),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Minha Biblioteca",
              style: GoogleFonts.inriaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4F7CAC),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade500),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Pesquisar livro",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _pesquisa = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.filter_alt_outlined, size: 32),
              ],
            ),
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
        onPressed: () {},
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
          color: selecionado ? const Color(0xFF4F7CAC) : Colors.grey.shade300,
          child: Text(
            texto,
            style: GoogleFonts.inriaSans(
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

class LivroCard extends StatelessWidget {
  final Livro livro;
  const LivroCard({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.network(
              livro.imageUrl,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 130,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.book),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inriaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "de ${livro.autor}",

                    style: GoogleFonts.inriaSans(fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Progresso: ${livro.progresso}",

                    style: GoogleFonts.inriaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value:
                        double.parse(livro.progresso.replaceAll('%', '')) / 100,
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            livro.nota,
                            style: GoogleFonts.inriaSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        livro.status,
                        style: GoogleFonts.inriaSans(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
