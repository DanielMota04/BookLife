import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeuProgressoPage extends StatelessWidget {
  const MeuProgressoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    final idDoUsuario = usuarioAtual?.uid;
    final nomeDoUsuario = usuarioAtual?.displayName ?? "Username";

    if (idDoUsuario == null) {
      return const CustomScaffold(
        body: Center(child: Text("Usuário não autenticado.")),
      );
    }

    return CustomScaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('userId', isEqualTo: idDoUsuario)
            .snapshots(),
        builder: (context, snapshotDeLivros) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('metas')
                .where('userId', isEqualTo: idDoUsuario)
                .snapshots(),
            builder: (context, snapshotDeMetas) {
              int totalDeLivrosLidos = 0;
              int totalDePaginasLidas = 0;
              int totalDeMetasCumpridas = 0;

              if (snapshotDeLivros.hasData) {
                for (var documento in snapshotDeLivros.data!.docs) {
                  final dadosDoLivro = documento.data() as Map<String, dynamic>;
                  final statusDeLeitura = dadosDoLivro['status'] ?? '';
                  final paginasLidasNoLivro = (dadosDoLivro['currentPage'] ?? 0) as int;

                  totalDePaginasLidas += paginasLidasNoLivro;

                  if (statusDeLeitura == 'read' || statusDeLeitura == 'lido') {
                    totalDeLivrosLidos += 1;
                  }
                }
              }

              if (snapshotDeMetas.hasData) {
                for (var documento in snapshotDeMetas.data!.docs) {
                  final dadosDaMeta = documento.data() as Map<String, dynamic>;
                  final alvoDaMeta = (dadosDaMeta['alvo'] ?? 1).toDouble();
                  final progressoDaMeta = (dadosDaMeta['progressoAtual'] ?? 0).toDouble();
                  final categoriaDaMeta = dadosDaMeta['categoria'] ?? '';

                  if (categoriaDaMeta == 'livros') {
                    if (progressoDaMeta >= 100) {
                      totalDeMetasCumpridas += 1;
                    }
                  } else {
                    if (progressoDaMeta >= alvoDaMeta && alvoDaMeta > 0) {
                      totalDeMetasCumpridas += 1;
                    }
                  }
                }
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Meu Progresso",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F7CAC),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFF3A7CAA),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 42,
                                  color: Color(0xFF3A7CAA),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nomeDoUsuario,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.emoji_events,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "2",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildEstatistica(
                                numero: totalDeLivrosLidos.toString(),
                                texto: "livros lidos",
                              ),
                              _buildEstatistica(
                                numero: totalDePaginasLidas.toString(),
                                texto: "páginas lidas",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMeta(texto: "Cumpriu $totalDeMetasCumpridas metas"),
                    _buildMeta(texto: "Leu um total de 80 horas"),
                    _buildMeta(texto: "Manteve o hábito a 10 dias seguidos"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Missões Completas",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F7CAC),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF4F7CAC),
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    _buildMissao(
                      titulo: "Leitor de Carteirinha",
                      descricao: "Ler mais de 5 livros",
                      completa: false,
                    ),
                    _buildMissao(
                      titulo: "Rato de Biblioteca",
                      descricao: "Tenha um streak de 5 dias",
                      completa: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Missões Disponíveis",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F7CAC),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF4F7CAC),
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    _buildMissao(
                      titulo: "A Regra da Meia Hora",
                      descricao: "Leia por 30 min usando o cronômetro",
                      completa: false,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEstatistica({required String numero, required String texto}) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMeta({required String texto}) {
    return Container(
      width: double.infinity,
      height: 32,
      margin: const EdgeInsets.only(bottom: 2),
      color: const Color(0xFF4F7CAC),
      alignment: Alignment.center,
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMissao({
    required String titulo,
    required String descricao,
    required bool completa,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: completa ? const Color(0xFF2EAD43) : Colors.white,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                color: completa ? const Color(0xFF2EAD43) : Colors.black54,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: completa ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: TextStyle(
                      fontSize: 15,
                      color: completa ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}