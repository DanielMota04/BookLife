import 'package:flutter/material.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/goals/models/meta_model.dart';

class CriarMetaModal extends StatefulWidget {
  const CriarMetaModal({super.key});

  @override
  State<CriarMetaModal> createState() => _CriarMetaModalState();
}

class _CriarMetaModalState extends State<CriarMetaModal> {
  String? tipoMeta;
  String? categoriaMeta;
  String? quantidadeMeta;

  InputDecoration campo() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.steelBlue,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Criando nova meta",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            DropdownButtonFormField<String>(
              value: tipoMeta,
              decoration: campo(),
              hint: const Text("Escolha tipo de meta"),
              items: const [
                DropdownMenuItem(
                  value: "livro",
                  child: Text("Meta de livro"),
                ),
                DropdownMenuItem(
                  value: "pagina",
                  child: Text("Meta de páginas"),
                ),
                DropdownMenuItem(
                  value: "tempo",
                  child: Text("Meta de tempo"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  tipoMeta = value;
                });
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: categoriaMeta,
              decoration: campo(),
              hint: const Text("Escolha categoria"),
              items: const [
                DropdownMenuItem(
                  value: "paginas",
                  child: Text("Quantidade de páginas"),
                ),
                DropdownMenuItem(
                  value: "livros",
                  child: Text("Quantidade de livros"),
                ),
                DropdownMenuItem(
                  value: "tempo",
                  child: Text("Tempo de leitura"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  categoriaMeta = value;
                });
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: quantidadeMeta,
              decoration: campo(),
              hint: const Text("Quantidade"),
              items: const [
                DropdownMenuItem(
                  value: "5",
                  child: Text("5"),
                ),
                DropdownMenuItem(
                  value: "10",
                  child: Text("10"),
                ),
                DropdownMenuItem(
                  value: "20",
                  child: Text("20"),
                ),
                DropdownMenuItem(
                  value: "50",
                  child: Text("50"),
                ),
                DropdownMenuItem(
                  value: "100",
                  child: Text("100"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  quantidadeMeta = value;
                });
              },
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    Meta(
                      titulo: tipoMeta == "livro"
                          ? "Ler $quantidadeMeta livros"
                          : tipoMeta == "tempo"
                              ? "Ler por $quantidadeMeta minutos"
                              : "Ler $quantidadeMeta páginas",
                      progresso: "0%",
                      progressoValor: 0,
                      icone: Icons.flag_outlined,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.steelBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Salvar Meta",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}