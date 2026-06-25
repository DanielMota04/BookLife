import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/features/progress/repositories/progresso_repository.dart';
import 'package:book_life/core/models/progresso_model.dart';
import 'package:book_life/core/models/book_model.dart';

class ProgressoViewModel extends ChangeNotifier {
  final ProgressoRepository _repository = ProgressoRepository();

  bool _carregando = true;
  String _mensagemErro = "";
  String _nomeDoUsuario = "Carregando...";
  int _totalDeLivrosLidos = 0;
  int _totalDePaginasLidas = 0;
  int _totalDeMetasCumpridas = 0;
  int _totalSegundosTimer = 0;
  int _streakDiasSeguidos = 0;
  List<Map<String, dynamic>> _dadosGraficoMensal = [];

  bool get carregando => _carregando;
  String get mensagemErro => _mensagemErro;
  String get nomeDoUsuario => _nomeDoUsuario;
  int get totalDeLivrosLidos => _totalDeLivrosLidos;
  int get totalDePaginasLidas => _totalDePaginasLidas;
  int get totalDeMetasCumpridas => _totalDeMetasCumpridas;
  int get totalSegundosTimer => _totalSegundosTimer;
  int get streakDiasSeguidos => _streakDiasSeguidos;
  String get horasLidas => (_totalSegundosTimer / 3600).toStringAsFixed(1);
  int get minutosLidos => (_totalSegundosTimer / 60).floor();
  bool get missaoLeitorCarteirinha => _totalDeLivrosLidos >= 5;
  bool get missaoRatoBiblioteca => _streakDiasSeguidos >= 5;
  bool get missaoMeiaHora => minutosLidos >= 30;
  int get totalMissoesCompletas {
    int count = 0;
    if (missaoLeitorCarteirinha) count++;
    if (missaoRatoBiblioteca) count++;
    if (missaoMeiaHora) count++;
    return count;
  }
  List<Map<String, dynamic>> get dadosGraficoMensal => _dadosGraficoMensal;

  Future<void> inicializar() async {
    await processarEstatisticas();
  }

  Future<void> processarEstatisticas() async {
    _carregando = true;
    _mensagemErro = "";
    notifyListeners();

    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) {
      _mensagemErro = "Usuário não autenticado.";
      _carregando = false;
      notifyListeners();
      return;
    }

    final idDoUsuario = usuarioAtual.uid;
    String nomeTemp = usuarioAtual.displayName ?? "";

    if (nomeTemp.isEmpty) {
      try {
        final docUsuario = await _repository.buscarDadosDoUsuario(idDoUsuario);
        if (docUsuario.exists && docUsuario.data() != null) {
          final dados = docUsuario.data() as Map<String, dynamic>;
          nomeTemp = dados['name'] ?? dados['nome'] ?? dados['username'] ?? "";
        }
      } catch (e) {
        nomeTemp = "";
      }
    }

    if (nomeTemp.isEmpty && usuarioAtual.email != null) {
      nomeTemp = usuarioAtual.email!.split('@')[0];
    }
    _nomeDoUsuario = nomeTemp.isEmpty ? "Leitor(a)" : nomeTemp;

    int paginasTemp = 0;
    int livrosTemp = 0;
    int streakTemp = 0;
    int segundosTotais = 0;
    int metasCumpridasTemp = 0;
    int paginasLidasHoje = 0;
    int segundosLidosHoje = 0;
    final hoje = DateTime.now();
    final hojeStr = hoje.toIso8601String().split('T')[0];

    List<Book> livros = [];
    try {
      livros = await _repository.buscarLivros(idDoUsuario);
      for (var livro in livros) {
        paginasTemp += livro.currentPage;
        if (livro.isCompleted) {
          livrosTemp += 1;
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Livros: $e\n\n";
    }

    try {
      final historicos = await _repository.buscarHistoricoDeLeitura(idDoUsuario);
      Set<String> datasLidas = {};
      final ontemStr = hoje.subtract(const Duration(days: 1)).toIso8601String().split('T')[0];

      for (var hist in historicos) {
        if (hist.date.isNotEmpty) datasLidas.add(hist.date);
        if (hist.date == hojeStr) {
          paginasLidasHoje += hist.pagesRead;
        }
      }

      List<String> datasOrdenadas = datasLidas.toList()..sort((a, b) => b.compareTo(a));
      if (datasOrdenadas.isNotEmpty) {
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

    // Cálculo para o Gráfico Mensal (últimos 6 meses)
    Map<String, int> livrosLidosPorMes = {};
    for (int i = 5; i >= 0; i--) {
      DateTime m = DateTime(hoje.year, hoje.month - i, 1);
      String chave = "${m.year}-${m.month.toString().padLeft(2, '0')}";
      livrosLidosPorMes[chave] = 0;
    }

    for (var livro in livros) {
      if (livro.isCompleted && livro.addedAt != null) {
        String chave = "${livro.addedAt.year}-${livro.addedAt.month.toString().padLeft(2, '0')}";
        if (livrosLidosPorMes.containsKey(chave)) {
          livrosLidosPorMes[chave] = livrosLidosPorMes[chave]! + 1;
        }
      }
    }

    List<String> nomeMeses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    List<Map<String, dynamic>> dadosGrafico = [];
    livrosLidosPorMes.forEach((chave, valor) {
      int mesIndex = int.parse(chave.split('-')[1]) - 1;
      dadosGrafico.add({
        'mes': nomeMeses[mesIndex],
        'valor': valor,
      });
    });
    _dadosGraficoMensal = dadosGrafico;

    try {
      final laps = await _repository.buscarLapsDoTimer(idDoUsuario);
      for (var lap in laps) {
        segundosTotais += lap.durationInSeconds;
        if (lap.createdAt != null) {
          final dataLap = lap.createdAt!;
          if (dataLap.year == hoje.year && dataLap.month == hoje.month && dataLap.day == hoje.day) {
            segundosLidosHoje += lap.durationInSeconds;
          }
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Timer: $e\n\n";
    }

    try {
      final metas = await _repository.buscarMetas(idDoUsuario);
      for (var meta in metas) {
        if (meta.categoria == 'livros') {
          try {
            final livroAlvo = livros.firstWhere((l) => l.id == meta.livroId);
            if (livroAlvo.currentPage >= livroAlvo.totalPages && livroAlvo.totalPages > 0) {
              metasCumpridasTemp++;
            }
          } catch (e) {
            continue;
          }
        } else if (meta.categoria == 'paginas') {
          if (paginasLidasHoje >= meta.alvo && meta.alvo > 0) metasCumpridasTemp++;
        } else if (meta.categoria == 'tempo') {
          double progressoTempoHoje = segundosLidosHoje / 60.0;
          if (meta.titulo.contains('horas')) progressoTempoHoje = segundosLidosHoje / 3600.0;
          if (meta.titulo.contains('segundos')) progressoTempoHoje = segundosLidosHoje.toDouble();

          if (progressoTempoHoje >= meta.alvo && meta.alvo > 0) metasCumpridasTemp++;
        }
      }
    } catch (e) {
      _mensagemErro += "Erro Metas: $e\n\n";
    }

    _totalDeLivrosLidos = livrosTemp;
    _totalDePaginasLidas = paginasTemp;
    _streakDiasSeguidos = streakTemp;
    _totalSegundosTimer = segundosTotais;
    _totalDeMetasCumpridas = metasCumpridasTemp;
    _carregando = false;
    
    notifyListeners();
  }
}