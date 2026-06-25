import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:book_life/features/progress/viewmodels/progresso_viewmodel.dart';
import 'package:book_life/features/progress/views/widgets/estatistica_widget.dart';
import 'package:book_life/features/progress/views/widgets/meta_widget.dart';
import 'package:book_life/features/progress/views/widgets/missao_widget.dart';
import 'package:book_life/features/progress/views/widgets/painel_de_emblemas.dart';

class MeuProgressoPage extends StatefulWidget {
  const MeuProgressoPage({super.key});

  @override
  State<MeuProgressoPage> createState() => _MeuProgressoPageState();
}

class _MeuProgressoPageState extends State<MeuProgressoPage> {
  late ProgressoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProgressoViewModel();
    _viewModel.inicializar();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_viewModel.mensagemErro != "")
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    color: Colors.red.shade100,
                    child: Text(
                      "Atenção, algumas métricas falharam:\n${_viewModel.mensagemErro}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
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
                                _viewModel.nomeDoUsuario,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.emoji_events,color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    _viewModel.totalMissoesCompletas.toString(),
                                    style: const TextStyle(
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
                          EstatisticaWidget(
                            numero: _viewModel.totalDeLivrosLidos.toString(),
                            texto: "livros lidos",
                          ),
                          EstatisticaWidget(
                            numero: _viewModel.totalDePaginasLidas.toString(),
                            texto: "páginas lidas",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MetaWidget(
                  texto:
                      "Cumpriu ${_viewModel.totalDeMetasCumpridas} metas hoje",
                ),
                const SizedBox(height: 10),
                MetaWidget(
                  texto: "Leu um total de ${_viewModel.horasLidas} horas",
                ),
                const SizedBox(height: 10),
                MetaWidget(
                  texto: "Manteve o hábito a ${_viewModel.streakDiasSeguidos} dias seguidos",
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PainelDeEmblemas(
                    totalLivros: _viewModel.totalDeLivrosLidos,
                    streak: _viewModel.streakDiasSeguidos,
                    totalPaginas: _viewModel.totalDePaginasLidas,
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Histórico de Leitura",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F7CAC),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildGraficoHistorico(),
                const SizedBox(height: 8),
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
                if (_viewModel.missaoLeitorCarteirinha)
                  MissaoWidget(
                    titulo: "Leitor de Carteirinha",
                    descricao: "Ler mais de 5 livros",
                    completa: true,
                  ),
                if (_viewModel.missaoRatoBiblioteca)
                  MissaoWidget(
                    titulo: "Rato de Biblioteca",
                    descricao: "Tenha um streak de 5 dias",
                    completa: true,
                  ),
                if (_viewModel.missaoMeiaHora)
                  MissaoWidget(
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
                if (!_viewModel.missaoLeitorCarteirinha)
                  MissaoWidget(
                    titulo: "Leitor de Carteirinha",
                    descricao: "Ler mais de 5 livros",
                    completa: false,
                  ),
                if (!_viewModel.missaoRatoBiblioteca)
                  MissaoWidget(
                    titulo: "Rato de Biblioteca",
                    descricao: "Tenha um streak de 5 dias",
                    completa: false,
                  ),
                if (!_viewModel.missaoMeiaHora)
                  MissaoWidget(
                    titulo: "A Regra da Meia Hora",
                    descricao: "Leia por 30 min usando o cronômetro",
                    completa: false,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGraficoHistorico() {
    final dadosMensais = _viewModel.dadosGraficoMensal;

    if (dadosMensais.isEmpty) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text("Sem dados de leitura ainda.", style: TextStyle(color: Colors.black54)),
      );
    }

    final maiorValor = dadosMensais.map((e) => e['valor'] as int).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dadosMensais.map((dado) {
          final valor = dado['valor'] as int;
          final proporcao = maiorValor > 0 ? valor / maiorValor : 0.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                valor.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Container(
                width: 24,
                height: 100 * proporcao,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F7CAC),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dado['mes'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
