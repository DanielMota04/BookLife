import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeuProgressoPage extends StatefulWidget {
  const MeuProgressoPage({super.key});

  @override
  State<MeuProgressoPage> createState() => _MeuProgressoPageState();
}

class _MeuProgressoPageState extends State<MeuProgressoPage> {
  bool _carregando = true;
  String _mensagemErro = "";

  int _totalDeLivrosLidos = 0;
  int _totalDePaginasLidas = 0;
  int _totalDeMetasCumpridas = 0;
  int _totalSegundosTimer = 0;
  int _streakDiasSeguidos = 0;

  @override
  void initState() {
    super.initState();
    _processarEstatisticas();
  }

  Future<void> _processarEstatisticas() async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;
    
    final idDoUsuario = usuarioAtual.uid;
    final firestore = FirebaseFirestore.instance;

    int paginasTemp = 0;
    int livrosTemp = 0;
    int streakTemp = 0;
    int segundosTotais = 0;
    int metasCumpridasTemp = 0;

    int paginasLidasHoje = 0;
    int segundosLidosHoje = 0;
    final hoje = DateTime.now();
    final hojeStr = hoje.toIso8601String().split('T')[0];
    
    QuerySnapshot? snapshotLivros;
    try {
      snapshotLivros = await firestore
          .collection('books')
          .where('userId', isEqualTo: idDoUsuario)
          .get();

      for (var doc in snapshotLivros.docs) {
        final dadosDoLivro = doc.data() as Map<String, dynamic>;
        final status = dadosDoLivro['status']?.toString().toLowerCase() ?? '';
        
        final paginas = dadosDoLivro['currentPage'] ?? 0;
        paginasTemp += (paginas is num) ? paginas.toInt() : 0;

        if (status == 'read' || status == 'lido' || status.contains('completed')) {
          livrosTemp += 1;
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Livros: $e\n\n";
    }

    try {
      final snapshotHistorico = await firestore
          .collectionGroup('reading_history')
          .where('userId', isEqualTo: idDoUsuario)
          .get();

      Set<String> datasLidas = {};
      final ontemStr = hoje.subtract(const Duration(days: 1)).toIso8601String().split('T')[0];

      for (var doc in snapshotHistorico.docs) {
        final dadosHist = doc.data() as Map<String, dynamic>;
        final dataStr = dadosHist['date']?.toString() ?? '';
        
        if (dataStr != "") {
          datasLidas.add(dataStr);
        }
        
        if (dataStr == hojeStr) {
          final lidas = dadosHist['pagesRead'] ?? 0;
          paginasLidasHoje += (lidas is num) ? lidas.toInt() : 0;
        }
      }

      List<String> datasOrdenadas = datasLidas.toList()..sort((a, b) => b.compareTo(a));

      if (datasOrdenadas.length > 0) {
        DateTime dataReferencia = hoje;
        if (datasOrdenadas.first == hojeStr) {
          streakTemp = 1;
        } else if (datasOrdenadas.first == ontemStr) {
          streakTemp = 1;
          dataReferencia = hoje.subtract(const Duration(days: 1));
        }

        if (streakTemp > 0) {
          for (int i = 1; i < datasOrdenadas.length; i++) {
            final dataAnteriorStr = dataReferencia.subtract(Duration(days: i)).toIso8601String().split('T')[0];
            if (datasOrdenadas[i] == dataAnteriorStr) {
              streakTemp++;
            } else {
              break;
            }
          }
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Histórico (Páginas): $e\n\n";
    }

    try {
      final snapshotTimer = await firestore
          .collectionGroup('laps')
          .where('userId', isEqualTo: idDoUsuario)
          .get();

      for (var doc in snapshotTimer.docs) {
        final dadosLap = doc.data() as Map<String, dynamic>;
        final segs = dadosLap['durationInSeconds'] ?? 0;
        final valorSegundos = (segs is num) ? segs.toInt() : 0;
        
        segundosTotais += valorSegundos;

        if (dadosLap['createdAt'] != null) {
          final dataLap = (dadosLap['createdAt'] as Timestamp).toDate();
          if (dataLap.year == hoje.year && dataLap.month == hoje.month && dataLap.day == hoje.day) {
            segundosLidosHoje += valorSegundos;
          }
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Timer: $e\n\n";
    }
    
    try {
      final snapshotMetas = await firestore
          .collection('metas')
          .where('userId', isEqualTo: idDoUsuario)
          .get();

      for (var doc in snapshotMetas.docs) {
        final dadosDaMeta = doc.data() as Map<String, dynamic>;
        final categoria = dadosDaMeta['categoria'];
        final alvo = (dadosDaMeta['alvo'] ?? 1).toDouble();

        if (categoria == 'livros' && snapshotLivros != null) {
          try {
            final livroAlvo = snapshotLivros.docs.firstWhere((l) => l.id == dadosDaMeta['livroId']);
            final dadosL = livroAlvo.data() as Map<String, dynamic>;
            final maxPaginas = (dadosL['totalPages'] ?? 1).toDouble();
            final paginas = (dadosL['currentPage'] ?? 0).toDouble();
            if (paginas >= maxPaginas && maxPaginas > 0) metasCumpridasTemp++;
          } catch (e) {
          }
        }
         else if (categoria == 'paginas') {
          if (paginasLidasHoje >= alvo && alvo > 0) metasCumpridasTemp++;
        }
         else if (categoria == 'tempo') {
          final tituloMeta = (dadosDaMeta['titulo'] ?? '').toString().toLowerCase();
          double progressoTempoHoje = segundosLidosHoje / 60.0;
          if (tituloMeta.contains('horas')) progressoTempoHoje = segundosLidosHoje / 3600.0;
          if (tituloMeta.contains('segundos')) progressoTempoHoje = segundosLidosHoje.toDouble();

          if (progressoTempoHoje >= alvo && alvo > 0) metasCumpridasTemp++;
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Metas: $e\n\n";
    }

    if (mounted) {
      setState(() {
        _totalDeLivrosLidos = livrosTemp;
        _totalDePaginasLidas = paginasTemp;
        _streakDiasSeguidos = streakTemp;
        _totalSegundosTimer = segundosTotais;
        _totalDeMetasCumpridas = metasCumpridasTemp;
        _carregando = false;
      });
    }
  }

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

    if (_carregando) {
      return const CustomScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final horasLidas = (_totalSegundosTimer / 3600).toStringAsFixed(1);
    final minutosLidos = (_totalSegundosTimer / 60).floor();

    final missaoLeitorCarteirinha = _totalDeLivrosLidos >= 5;
    final missaoRatoBiblioteca = _streakDiasSeguidos >= 5;
    final missaoMeiaHora = minutosLidos >= 30;

    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usa verificação segura sem o .isNotEmpty
            if (_mensagemErro != "")
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                color: Colors.red.shade100,
                child: Text(
                  "Atenção, algumas métricas falharam:\n$_mensagemErro",
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

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
                        numero: _totalDeLivrosLidos.toString(),
                        texto: "livros lidos",
                      ),
                      _buildEstatistica(
                        numero: _totalDePaginasLidas.toString(),
                        texto: "páginas lidas",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildMeta(texto: "Cumpriu $_totalDeMetasCumpridas metas hoje"),
            _buildMeta(texto: "Leu um total de $horasLidas horas"),
            _buildMeta(texto: "Manteve o hábito a $_streakDiasSeguidos dias seguidos"),
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
            if (missaoLeitorCarteirinha)
              _buildMissao(
                titulo: "Leitor de Carteirinha",
                descricao: "Ler mais de 5 livros",
                completa: true,
              ),
            if (missaoRatoBiblioteca)
              _buildMissao(
                titulo: "Rato de Biblioteca",
                descricao: "Tenha um streak de 5 dias",
                completa: true,
              ),
            if (missaoMeiaHora)
              _buildMissao(
                titulo: "A Regra da Meia Hora",
                descricao: "Leia por 30 min usando o cronômetro",
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
            if (!missaoLeitorCarteirinha)
              _buildMissao(
                titulo: "Leitor de Carteirinha",
                descricao: "Ler mais de 5 livros",
                completa: false,
              ),
            if (!missaoRatoBiblioteca)
              _buildMissao(
                titulo: "Rato de Biblioteca",
                descricao: "Tenha um streak de 5 dias",
                completa: false,
              ),
            if (!missaoMeiaHora)
              _buildMissao(
                titulo: "A Regra da Meia Hora",
                descricao: "Leia por 30 min usando o cronômetro",
                completa: false,
              ),
            const SizedBox(height: 20),
          ],
        ),
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