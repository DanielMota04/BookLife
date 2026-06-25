import 'package:flutter/material.dart';
import 'dart:convert';

class MetaCard extends StatelessWidget {
  final String titulo;
  final String progresso;
  final double progressoValor;
  final IconData? icone;
  final String? imagem;
  final VoidCallback? onTap;

  const MetaCard({
    super.key,
    required this.titulo,
    required this.progresso,
    required this.progressoValor,
    this.icone,
    this.imagem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: imagem != null && imagem!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: imagem!.startsWith('http')
                                ? Image.network(
                                    imagem!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(icone ?? Icons.image_not_supported, size: 34),
                                  )
                                : Image.memory(
                                    base64Decode(imagem!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(icone ?? Icons.broken_image, size: 34),
                                  ),
                          )
                        : Icon(
                            icone,
                            size: 34,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 28,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double larguraDaBarra = constraints.maxWidth;
                    const double tamanhoDoIcone = 28.0;
                    
                    final double progressoLimitado = progressoValor.clamp(0.0, 1.0);
                    final double posicaoDoIcone = progressoLimitado * (larguraDaBarra - tamanhoDoIcone);

                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progressoLimitado,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          left: posicaoDoIcone,
                          child: Container(
                            width: tamanhoDoIcone,
                            height: tamanhoDoIcone,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book_outlined,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  progresso,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}