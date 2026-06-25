import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:book_life/features/progress/viewmodels/progresso_viewmodel.dart';

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
                          _buildEstatistica(
                            numero: _viewModel.totalDeLivrosLidos.toString(),
                            texto: "livros lidos",
                          ),
                          _buildEstatistica(
                            numero: _viewModel.totalDePaginasLidas.toString(),
                            texto: "páginas lidas",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildMeta(
                  texto:
                      "Cumpriu ${_viewModel.totalDeMetasCumpridas} metas hoje",
                ),
                _buildMeta(
                  texto: "Leu um total de ${_viewModel.horasLidas} horas",
                ),
                _buildMeta(
                  texto:
                      "Manteve o hábito a ${_viewModel.streakDiasSeguidos} dias seguidos",
                ),
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
                  _buildMissao(
                    titulo: "Leitor de Carteirinha",
                    descricao: "Ler mais de 5 livros",
                    completa: true,
                  ),
                if (_viewModel.missaoRatoBiblioteca)
                  _buildMissao(
                    titulo: "Rato de Biblioteca",
                    descricao: "Tenha um streak de 5 dias",
                    completa: true,
                  ),
                if (_viewModel.missaoMeiaHora)
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
                if (!_viewModel.missaoLeitorCarteirinha)
                  _buildMissao(
                    titulo: "Leitor de Carteirinha",
                    descricao: "Ler mais de 5 livros",
                    completa: false,
                  ),
                if (!_viewModel.missaoRatoBiblioteca)
                  _buildMissao(
                    titulo: "Rato de Biblioteca",
                    descricao: "Tenha um streak de 5 dias",
                    completa: false,
                  ),
                if (!_viewModel.missaoMeiaHora)
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
