import 'package:flutter/material.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/goals/models/meta_model.dart';
import 'package:book_life/features/goals/views/widgets/criar_meta.dart';
import 'package:book_life/features/goals/views/widgets/meta_card.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final List<Meta> metas = [
    Meta(
      titulo: "Ler 10 páginas por dia",
      progresso: "50%",
      progressoValor: 0.5,
      icone: Icons.emoji_events_outlined,
    ),

    Meta(
      titulo: "Estudar Clean Architecture",
      progresso: "50%",
      progressoValor: 0.5,
      imagem:
          "https://m.media-amazon.com/images/I/41fijVG5x7L._SY445_SX342_ML2_.jpg",
    ),

    Meta(
      titulo: "Terminar o livro: Senhor dos Anéis",
      progresso: "369/528 pags",
      progressoValor: 0.69,
      imagem:
          "https://m.media-amazon.com/images/I/41KWSPU9wcL._SY445_SX342_ML2_.jpg",
    ),
  ];

  void _abrirNovaMeta() async {
    final novaMeta = await showDialog<Meta>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const CriarMetaModal(),
    );

    if (novaMeta != null) {
      setState(() {
        metas.add(novaMeta);
      });
    }
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
                onPressed: _abrirNovaMeta,
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
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
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
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: metas.length,
              itemBuilder: (context, index) {
                final meta = metas[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: MetaCard(
                    titulo: meta.titulo,
                    progresso: meta.progresso,
                    progressoValor: meta.progressoValor,
                    icone: meta.icone,
                    imagem: meta.imagem,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}