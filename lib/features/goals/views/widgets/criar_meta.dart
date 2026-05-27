import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  
  String? idDoLivroSelecionado;
  final TextEditingController _controladorDeQuantidade = TextEditingController();
  String unidadeDeTempo = 'minutos';

  bool _estaCarregandoLivros = false;
  List<Map<String, dynamic>> _listaDeLivros = [];

  Future<void> _buscarLivrosNaBase() async {
    setState(() {
      _estaCarregandoLivros = true;
    });

    try {
      String idDoUsuario = FirebaseAuth.instance.currentUser!.uid;
      
      QuerySnapshot resultadoDaBusca = await FirebaseFirestore.instance
          .collection('books')
          .where('userId', isEqualTo: idDoUsuario)
          .get();

      setState(() {
        _listaDeLivros = resultadoDaBusca.docs.map((documento) {
          final dadosDoLivro = documento.data() as Map<String, dynamic>;
          return {
            "id": documento.id,
            "title": dadosDoLivro['title']?.toString() ?? 'Livro sem título',
          };
        }).toList();
      });
    } catch (erro) {
      debugPrint("Erro ao buscar livros: $erro");
    } finally {
      setState(() {
        _estaCarregandoLivros = false;
      });
    }
  }

  Future<void> _salvarNovaMeta() async {
    if (tipoMeta == null || categoriaMeta == null) return;
    if (categoriaMeta == 'livros' && idDoLivroSelecionado == null) return;
    if ((categoriaMeta == 'paginas' || categoriaMeta == 'tempo') && _controladorDeQuantidade.text.isEmpty) return;

    try {
      String idDoUsuario = FirebaseAuth.instance.currentUser!.uid;
      
      String tituloDaMeta = "";
      int objetivoDaMeta = 0;

      if (categoriaMeta == 'livros') {
        final livroEscolhido = _listaDeLivros.firstWhere((livro) => livro['id'] == idDoLivroSelecionado);
        tituloDaMeta = "Terminar o livro: ${livroEscolhido['title']}";
        objetivoDaMeta = 1; 
      } else if (categoriaMeta == 'paginas') {
        objetivoDaMeta = int.parse(_controladorDeQuantidade.text);
        tituloDaMeta = "Ler $objetivoDaMeta páginas por dia";
      } else if (categoriaMeta == 'tempo') {
        objetivoDaMeta = int.parse(_controladorDeQuantidade.text);
        tituloDaMeta = "Ler $objetivoDaMeta $unidadeDeTempo por dia"; 
      }

      await FirebaseFirestore.instance.collection('metas').add({
        'userId': idDoUsuario,
        'titulo': tituloDaMeta,
        'tipo': tipoMeta,
        'categoria': categoriaMeta,
        'alvo': objetivoDaMeta,
        'progressoAtual': 0,
        'livroId': categoriaMeta == 'livros' ? idDoLivroSelecionado : null,
        'dataCriacao': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(
          context,
          Meta(
            titulo: tituloDaMeta,
            progresso: "0%",
            progressoValor: 0,
            icone: Icons.flag_outlined,
          ),
        );
      }
    } catch (erro) {
      debugPrint("Erro ao salvar meta: $erro");
    }
  }

  InputDecoration estiloDoCampo() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.steelBlue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),

            DropdownButtonFormField<String>(
              value: tipoMeta,
              decoration: estiloDoCampo(),
              hint: const Text("Escolha tipo de meta"),
              items: const [
                DropdownMenuItem(value: "leitura", child: Text("Meta de Leitura")),
              ],
              onChanged: (novoValor) {
                setState(() {
                  tipoMeta = novoValor;
                });
              },
            ),
            const SizedBox(height: 14),

            if (tipoMeta != null)
              DropdownButtonFormField<String>(
                value: categoriaMeta,
                decoration: estiloDoCampo(),
                hint: const Text("Escolha a métrica"),
                items: const [
                  DropdownMenuItem(value: "paginas", child: Text("Por quantidade de páginas")),
                  DropdownMenuItem(value: "livros", child: Text("Por livro específico")),
                  DropdownMenuItem(value: "tempo", child: Text("Por tempo de leitura")),
                ],
                onChanged: (novoValor) {
                  setState(() {
                    categoriaMeta = novoValor;
                    _controladorDeQuantidade.clear();
                    idDoLivroSelecionado = null;
                  });

                  if (novoValor == 'livros') {
                    _buscarLivrosNaBase();
                  }
                },
              ),
            
            const SizedBox(height: 14),

            if (categoriaMeta == 'paginas')
              TextFormField(
                controller: _controladorDeQuantidade,
                keyboardType: TextInputType.number,
                decoration: estiloDoCampo().copyWith(hintText: "Ex: 15 (páginas)"),
              )
            else if (categoriaMeta == 'tempo')
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _controladorDeQuantidade,
                      keyboardType: TextInputType.number,
                      decoration: estiloDoCampo().copyWith(hintText: "Ex: 30"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: unidadeDeTempo,
                      decoration: estiloDoCampo(),
                      items: const [
                        DropdownMenuItem(value: "segundos", child: Text("Segundos")),
                        DropdownMenuItem(value: "minutos", child: Text("Minutos")),
                        DropdownMenuItem(value: "horas", child: Text("Horas")),
                        DropdownMenuItem(value: "dias", child: Text("Dias")),
                      ],
                      onChanged: (novoValor) {
                        setState(() {
                          unidadeDeTempo = novoValor!;
                        });
                      },
                    ),
                  ),
                ],
              )
            else if (categoriaMeta == 'livros')
              _estaCarregandoLivros
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: idDoLivroSelecionado,
                      decoration: estiloDoCampo(),
                      hint: const Text("Selecione um livro"),
                      items: _listaDeLivros.map((livro) {
                        return DropdownMenuItem<String>(
                          value: livro['id'],
                          child: Text(livro['title']),
                        );
                      }).toList(),
                      onChanged: (novoValor) {
                        setState(() {
                          idDoLivroSelecionado = novoValor;
                        });
                      },
                    ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _salvarNovaMeta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.steelBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Salvar Meta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controladorDeQuantidade.dispose();
    super.dispose();
  }
}