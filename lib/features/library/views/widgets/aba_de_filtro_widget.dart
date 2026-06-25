import 'package:flutter/material.dart';

class AbaDeFiltroWidget extends StatelessWidget {
  final String textoDoFiltro;
  final bool estaSelecionado;
  final VoidCallback onTap;

  const AbaDeFiltroWidget({
    super.key,
    required this.textoDoFiltro,
    required this.estaSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: estaSelecionado
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            textoDoFiltro,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: estaSelecionado
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
