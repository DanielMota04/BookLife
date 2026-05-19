import 'package:flutter/material.dart';

class Meta {
  final String titulo;
  final String progresso;
  final double progressoValor;
  final IconData? icone;
  final String? imagem;

  Meta({
    required this.titulo,
    required this.progresso,
    required this.progressoValor,
    this.icone,
    this.imagem,
  });
}