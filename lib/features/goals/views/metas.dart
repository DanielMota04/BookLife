import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/goals/views/widgets/criar_meta.dart';
import 'package:book_life/features/goals/views/widgets/meta_card.dart';
import 'package:book_life/features/goals/views/widgets/editar_meta.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  void _exibirModalDeCriacao() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const CriarMetaModal(),
    );
  }

  void _exibirModalDeEdicao(String identificadorDaMeta, Map<String, dynamic> detalhesDaMeta) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => EditarMetaModal(
        metaId: identificadorDaMeta,
        dadosAtuais: detalhesDaMeta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idDoUsuario = FirebaseAuth.instance.currentUser?.uid;

    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Minhas Metas",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.steelBlue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _exibirModalDeCriacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C73),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF168DB1),
                      child: Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Adicionar Nova Meta",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Em andamento",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: idDoUsuario == null
                ? const Center(child: Text("Usuário não autenticado."))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('metas')
                        .where('userId', isEqualTo: idDoUsuario)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Erro ao carregar metas: ${snapshot.error}"));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Nenhuma meta encontrada.\nCrie sua primeira meta acima!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      final listaDeMetas = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: listaDeMetas.length,
                        itemBuilder: (context, index) {
                          final documentoMeta = listaDeMetas[index];
                          final dadosDaMeta = documentoMeta.data() as Map<String, dynamic>;
                          final objetivoFinal = (dadosDaMeta['alvo'] ?? 1).toDouble();
                          final categoria = dadosDaMeta['categoria'];

                          // Lógica para Meta de Livro Específico
                          if (categoria == 'livros' && dadosDaMeta['livroId'] != null) {
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('books')
                                  .doc(dadosDaMeta['livroId'])
                                  .snapshots(),
                              builder: (context, snapshotDeLivro) {
                                double progressoAtualizado = 0;
                                double objFinalLocal = 1;
                                String? capaBase64;

                                if (snapshotDeLivro.hasData && snapshotDeLivro.data!.exists) {
                                  final dadosDoLivro = snapshotDeLivro.data!.data() as Map<String, dynamic>;
                                  capaBase64 = dadosDoLivro['coverBase64'];
                                  progressoAtualizado = (dadosDoLivro['currentPage'] ?? 0).toDouble();
                                  objFinalLocal = (dadosDoLivro['totalPages'] ?? 1).toDouble();
                                  if (objFinalLocal == 0) objFinalLocal = 1;
                                }

                                final taxaDeConclusao = (progressoAtualizado / objFinalLocal).clamp(0.0, 1.0);
                                final rotuloDoProgresso = "${(taxaDeConclusao * 100).toInt()}%";

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: MetaCard(
                                    titulo: dadosDaMeta['titulo'] ?? 'Sem título',
                                    progresso: rotuloDoProgresso,
                                    progressoValor: taxaDeConclusao,
                                    icone: Icons.menu_book,
                                    imagem: capaBase64 ?? dadosDaMeta['imagem'],
                                    onTap: () => _exibirModalDeEdicao(documentoMeta.id, dadosDaMeta),
                                  ),
                                );
                              },
                            );
                          }

                          // Lógica para Meta de Páginas Diárias
                          if (categoria == 'paginas') {
                            final dataDeHoje = DateTime.now().toIso8601String().split('T')[0];

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collectionGroup('reading_history')
                                  .where('userId', isEqualTo: idDoUsuario)
                                  .where('date', isEqualTo: dataDeHoje)
                                  .snapshots(),
                              builder: (context, snapshotPaginas) {
                                if (snapshotPaginas.connectionState == ConnectionState.waiting && !snapshotPaginas.hasData) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 14),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                int totalPaginasLidas = 0;
                                if (snapshotPaginas.hasData) {
                                  for (var doc in snapshotPaginas.data!.docs) {
                                    totalPaginasLidas += ((doc.data() as Map<String, dynamic>)['pagesRead'] ?? 0) as int;
                                  }
                                }

                                final taxaDeConclusao = objetivoFinal > 0
                                    ? (totalPaginasLidas / objetivoFinal).clamp(0.0, 1.0)
                                    : 0.0;
                                
                                final paginasParaExibir = totalPaginasLidas > objetivoFinal.toInt()
                                    ? objetivoFinal.toInt()
                                    : totalPaginasLidas;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: MetaCard(
                                    titulo: dadosDaMeta['titulo'] ?? 'Sem título',
                                    progresso: "$paginasParaExibir/${objetivoFinal.toInt()}",
                                    progressoValor: taxaDeConclusao,
                                    icone: Icons.flag_outlined,
                                    imagem: dadosDaMeta['imagem'],
                                    onTap: () => _exibirModalDeEdicao(documentoMeta.id, dadosDaMeta),
                                  ),
                                );
                              },
                            );
                          }

                          // Lógica para Meta de Tempo Diário
                          if (categoria == 'tempo') {
                            final hoje = DateTime.now();
                            final inicioDoDia = DateTime(hoje.year, hoje.month, hoje.day);

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collectionGroup('laps')
                                  .where('userId', isEqualTo: idDoUsuario)
                                  .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDoDia))
                                  .snapshots(),
                              builder: (context, snapshotTempo) {
                                if (snapshotTempo.connectionState == ConnectionState.waiting && !snapshotTempo.hasData) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 14),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                int totalSegundos = 0;
                                if (snapshotTempo.hasData) {
                                  for (var doc in snapshotTempo.data!.docs) {
                                    totalSegundos += ((doc.data() as Map<String, dynamic>)['durationInSeconds'] ?? 0) as int;
                                  }
                                }

                                final tituloMeta = (dadosDaMeta['titulo'] ?? '').toLowerCase();
                                double progressoTempo = totalSegundos / 60; // Padrão: minutos

                                if (tituloMeta.contains('segundos')) {
                                  progressoTempo = totalSegundos.toDouble();
                                } else if (tituloMeta.contains('horas')) {
                                  progressoTempo = totalSegundos / 3600;
                                }

                                final taxaDeConclusao = objetivoFinal > 0
                                    ? (progressoTempo / objetivoFinal).clamp(0.0, 1.0)
                                    : 0.0;
                                
                                final progressoParaExibir = progressoTempo > objetivoFinal 
                                    ? objetivoFinal 
                                    : progressoTempo;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: MetaCard(
                                    titulo: dadosDaMeta['titulo'] ?? 'Sem título',
                                    progresso: "${progressoParaExibir.toInt()}/${objetivoFinal.toInt()}",
                                    progressoValor: taxaDeConclusao,
                                    icone: Icons.timer_outlined,
                                    imagem: dadosDaMeta['imagem'],
                                    onTap: () => _exibirModalDeEdicao(documentoMeta.id, dadosDaMeta),
                                  ),
                                );
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}