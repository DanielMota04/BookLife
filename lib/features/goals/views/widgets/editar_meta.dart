import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_life/core/constants/app_colors.dart';

class EditarMetaModal extends StatefulWidget {
  final String metaId;
  final Map<String, dynamic> dadosAtuais;

  const EditarMetaModal({
    super.key,
    required this.metaId,
    required this.dadosAtuais,
  });

  @override
  State<EditarMetaModal> createState() => _EditarMetaModalState();
}

class _EditarMetaModalState extends State<EditarMetaModal> {
  late TextEditingController _controladorDeProgresso;
  bool _estaSalvando = false;

  @override
  void initState() {
    super.initState();
    _controladorDeProgresso = TextEditingController(
      text: widget.dadosAtuais['progressoAtual']?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _controladorDeProgresso.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (_controladorDeProgresso.text.isEmpty) return;

    setState(() => _estaSalvando = true);

    try {
      int progressoAtualizado = int.parse(_controladorDeProgresso.text);

      await FirebaseFirestore.instance
          .collection('metas')
          .doc(widget.metaId)
          .update({
        'progressoAtual': progressoAtualizado,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meta atualizada!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (erro) {
      debugPrint("Erro ao atualizar: $erro");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $erro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _estaSalvando = false);
      }
    }
  }

  Future<void> _removerMeta() async {
    setState(() => _estaSalvando = true);

    try {
      await FirebaseFirestore.instance
          .collection('metas')
          .doc(widget.metaId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meta excluída.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context);
      }
    } catch (erro) {
      debugPrint("Erro ao excluir: $erro");
    } finally {
      if (mounted) {
        setState(() => _estaSalvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objetivoDaMeta = widget.dadosAtuais['alvo'] ?? 0;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Atualizar Meta",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                widget.dadosAtuais['titulo'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Progresso Atual:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _controladorDeProgresso,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.steelBlue,
                    width: 2,
                  ),
                ),
                suffixText: "/ $objetivoDaMeta",
              ),
            ),
            const SizedBox(height: 26),
            _estaSalvando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      IconButton(
                        onPressed: _removerMeta,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        tooltip: "Excluir meta",
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _salvarAlteracoes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.steelBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Salvar Alterações",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}