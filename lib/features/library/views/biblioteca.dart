import 'package:book_life/app/router/routes.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/library/views/widgets/livro_card_widget.dart';
import 'package:book_life/features/library/views/widgets/biblioteca_search_bar.dart';
import 'package:book_life/features/library/views/scanner_page.dart';
import 'package:book_life/features/library/viewmodels/biblioteca_viewmodel.dart';
import 'package:book_life/features/library/services/google_books_service.dart';
import 'package:book_life/features/library/views/widgets/aba_de_filtro_widget.dart';
import 'package:go_router/go_router.dart';

class MinhaBiblioteca extends StatefulWidget {
  const MinhaBiblioteca({super.key});

  @override
  State<MinhaBiblioteca> createState() => _MinhaBibliotecaState();
}

class _MinhaBibliotecaState extends State<MinhaBiblioteca> {
  final BibliotecaViewModel _viewModel = BibliotecaViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: BibliotecaSearchBar(
                    controller: _searchController,
                    onChanged: _viewModel.atualizarPesquisa,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    onPressed: _openScanner,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // AnimatedBuilder para atualizar apenas as abas de filtro
          AnimatedBuilder(
            animation: _viewModel,
            builder: (context, _) {
              return SizedBox(
                height: 45,
                child: Row(
                  children: [
                    AbaDeFiltroWidget(
                      textoDoFiltro: "Todos",
                      estaSelecionado: _viewModel.filtroAtivo == "Todos",
                      onTap: () => _viewModel.atualizarFiltro("Todos"),
                    ),
                    AbaDeFiltroWidget(
                      textoDoFiltro: "Lendo",
                      estaSelecionado: _viewModel.filtroAtivo == "Lendo",
                      onTap: () => _viewModel.atualizarFiltro("Lendo"),
                    ),
                    AbaDeFiltroWidget(
                      textoDoFiltro: "Lido",
                      estaSelecionado: _viewModel.filtroAtivo == "Lido",
                      onTap: () => _viewModel.atualizarFiltro("Lido"),
                    ),
                    AbaDeFiltroWidget(
                      textoDoFiltro: "Em espera",
                      estaSelecionado: _viewModel.filtroAtivo == "Em espera",
                      onTap: () => _viewModel.atualizarFiltro("Em espera"),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: _viewModel.streamDeLivros,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar a biblioteca."));
                }

                final livrosDoBanco = snapshot.data;

                if (livrosDoBanco == null || livrosDoBanco.isEmpty) {
                  return const Center(child: Text("Nenhum livro encontrado."));
                }
                // O AnimatedBuilder envolve apenas a lista para reagir na pesquisa e nos filtros instantaneamente
                return AnimatedBuilder(
                  animation: _viewModel,
                  builder: (context, _) {
                    final livrosParaExibir = _viewModel.aplicarFiltrosNaLista(
                      livrosDoBanco,
                    );
                    if (livrosParaExibir.isEmpty) {
                      return const Center(
                        child: Text("Nenhum livro corresponde à pesquisa."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: livrosParaExibir.length,
                      itemBuilder: (context, index) {
                        final livro = livrosParaExibir[index];
                        return Dismissible(
                          key: Key(livro.id), // serve para direcionar o flutter a recarregar a pagina ao remover tal card
                          direction: DismissDirection.horizontal,
                          // Deslizamento para Editar
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.edit, color: Colors.white, size: 30),
                          ),

                          // Deslizamento para Deletar
                          secondaryBackground: Container(
                            margin: const EdgeInsets.only(
                              bottom: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.onError,
                              size: 30,
                            ),
                          ),
                          // O confirmDismiss foi utilizado para evitar que em qualquer direcao de arrasto o livro fosse deletado independentemente
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              // Ação de Editar
                              Future.microtask(() async {
                              final livroAtualizado = await Navigator.push<Book>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdicionarLivroPage(livroParaEditar: livro),
                                ),
                              );
                              // Se a tela devolver um livro que foi editado ele vai salvar no firebase
                              if (livroAtualizado != null) {
                                await _viewModel.atualizarLivro(livroAtualizado);
                              }
                              });
                              // Retorna false para o card não ser apagado  da tela
                              return false; 
                              
                            } else if (direction == DismissDirection.endToStart) {
                              // Retorna true para o card sumir ao deletar e disparar o onDismissed
                              return true; 
                            }
                            return false;
                          },
                          onDismissed: (direction) {
                            // Agora o onDismissed só é disparado se confirmDismiss retornar true par deletar
                            _viewModel.deletarLivro(livro.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${livro.title} foi removido.'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                Routes.bookDetailsOf(livro.title),
                                extra: livro,
                              );
                            },
                            child: LivroCard(livro: livro),
                          ),
                        );
                      },
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

  Future<void> _openScanner() async {
    // A tela do scanner retornará a string do ISBN (se lido com sucesso)
    final String? isbnLido = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (isbnLido != null && isbnLido.isNotEmpty) {
      _processarIsbn(isbnLido);
    }
  }

  Future<void> _processarIsbn(String isbn) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buscando Livro...')),
    );

    final dados = await _viewModel.buscarNaHardcover(isbn);

    if (!mounted) return;

    if (dados != null) {
      final titulo = dados['titulo'] ?? 'Sem título';
      final autor = dados['autor'] ?? 'Sem autor';
      final Uint8List? capaBytes = dados['capa'];
      final paginas = dados['paginas'] ?? 0;
      final sinopse = dados['sinopse'] ?? '';
      final editora = dados['editora'] ?? '';
      final generos = (dados['generos'] as String).split(', ').where((s) => s.isNotEmpty).toList();

      bool confirm = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Livro Encontrado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (capaBytes != null)
                Image.memory(capaBytes, height: 120),
              const SizedBox(height: 16),
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(autor),
              const SizedBox(height: 16),
              const Text('Deseja adicionar este livro à sua biblioteca?'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true), 
              child: const Text('Adicionar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ) ?? false;

      if (confirm && mounted) {
        try {
          // Nota: Como não temos o coverUrl real aqui, e não estamos subindo a imagem pro Storage,
          // o coverUrl ficará nulo. Se a API retornasse a URL, poderíamos salvar.
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final book = Book(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              userId: user.uid,
              title: titulo,
              author: autor,
              isbn: isbn,
              publisher: editora,
              totalPages: paginas,
              currentPage: 0,
              genres: generos,
              synopsis: sinopse,
              coverUrl: null, 
              coverBytes: capaBytes,
              addedAt: DateTime.now(),
            );
            await _viewModel.adicionarLivro(book);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Livro adicionado com sucesso!')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro não encontrado na Hardcover API.')),
      );
    }
  }
}
