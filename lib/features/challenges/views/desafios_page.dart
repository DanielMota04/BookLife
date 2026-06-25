import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/challenges/viewmodels/desafios_viewmodel.dart';

class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DesafiosViewModel>().inicializar();
    });
  }

  void _exibirDialogoMudarMeta(BuildContext context, DesafiosViewModel viewModel) {
    final controller = TextEditingController(text: viewModel.metaAnual.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mudar Meta Anual"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Quantidade de livros"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () {
                final novaMeta = int.tryParse(controller.text);
                if (novaMeta != null && novaMeta > 0) {
                  viewModel.atualizarMetaAnual(novaMeta);
                }
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DesafiosViewModel>();
    final anoAtual = DateTime.now().year;

    return CustomScaffold(
      body: viewModel.carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Desafio Literário",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _exibirDialogoMudarMeta(context, viewModel),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade400, Colors.orange.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events, size: 80, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          "Desafio $anoAtual",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Quantos livros você quer ler este ano?",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${viewModel.totalLidos}",
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "/ ${viewModel.metaAnual}\nlivros",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: viewModel.metaAnual > 0 ? (viewModel.totalLidos / viewModel.metaAnual).clamp(0.0, 1.0) : 0,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          color: Colors.white,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.totalLidos >= viewModel.metaAnual
                              ? "Parabéns! Você atingiu sua meta!"
                              : "Faltam ${viewModel.metaAnual - viewModel.totalLidos} livros para atingir sua meta!",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Sua Estante do Desafio",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.livrosLidosEsteAno.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Nenhum livro finalizado este ano ainda. Comece a ler!", style: TextStyle(color: Colors.grey)),
                    )
                  else
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: viewModel.livrosLidosEsteAno.length,
                        itemBuilder: (context, index) {
                          final livro = viewModel.livrosLidosEsteAno[index];
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Theme.of(context).colorScheme.outline),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: livro.coverUrl != null && livro.coverUrl!.isNotEmpty
                                ? Image.network(livro.coverUrl!, fit: BoxFit.cover)
                                : livro.coverBytes != null
                                    ? Image.memory(livro.coverBytes!, fit: BoxFit.cover)
                                    : const Center(child: Icon(Icons.book, size: 40, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
