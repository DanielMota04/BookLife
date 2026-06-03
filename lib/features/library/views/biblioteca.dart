import 'package:book_life/app/router/routes.dart';
import 'package:flutter/material.dart';

import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/library/views/widgets/livro_card_widget.dart';
import 'package:book_life/features/library/views/widgets/biblioteca_search_bar.dart';
import 'package:book_life/features/book_details/views/livro_details.dart';
import 'package:book_life/features/library/viewmodels/biblioteca_viewmodel.dart';
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

          BibliotecaSearchBar(
            controller: _searchController,
            onChanged: _viewModel.atualizarPesquisa,
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
                    _buildAbaDeFiltro("Todos"),
                    _buildAbaDeFiltro("Lendo"),
                    _buildAbaDeFiltro("Lido"),
                    _buildAbaDeFiltro("Em espera"),
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
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              Routes.bookDetailsOf(livro.title),
                              extra: livro, 
                            );
                          },
                          child: LivroCard(livro: livro),
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

  Widget _buildAbaDeFiltro(String textoDoFiltro) {
    final bool estaSelecionado = _viewModel.filtroAtivo == textoDoFiltro;

    return Expanded(
      child: GestureDetector(
        onTap: () => _viewModel.atualizarFiltro(textoDoFiltro),
        child: Container(
          alignment: Alignment.center,
          color: estaSelecionado
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            textoDoFiltro,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: estaSelecionado
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
