import 'package:flutter/material.dart';

class PainelDeEmblemas extends StatelessWidget {
  final int totalLivros;
  final int streak;
  final int totalPaginas;

  const PainelDeEmblemas({
    super.key,
    required this.totalLivros,
    required this.streak,
    required this.totalPaginas,
  });

  @override
  Widget build(BuildContext context) {
    final emblemas = [
      _buildEmblema(
        context: context,
        titulo: "Leitor Iniciante",
        icone: Icons.star_border,
        desbloqueado: totalLivros >= 1,
        corBase: const Color(0xFFCD7F32),
      ),
      _buildEmblema(
        context: context,
        titulo: "Rato de Biblioteca",
        icone: Icons.menu_book,
        desbloqueado: totalLivros >= 10,
        corBase: Colors.blueAccent,
      ),
      _buildEmblema(
        context: context,
        titulo: "Devorador",
        icone: Icons.local_fire_department,
        desbloqueado: totalPaginas >= 1000,
        corBase: Colors.orange,
      ),
      _buildEmblema(
        context: context,
        titulo: "Hábito de Ferro",
        icone: Icons.calendar_month,
        desbloqueado: streak >= 7,
        corBase: Colors.green,
      ),
      _buildEmblema(
        context: context,
        titulo: "Mestre Literário",
        icone: Icons.diamond,
        desbloqueado: totalLivros >= 50,
        corBase: Colors.purpleAccent,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suas Conquistas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: emblemas.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => emblemas[index],
          ),
        ),
      ],
    );
  }

  Widget _buildEmblema({
    required BuildContext context,
    required String titulo,
    required IconData icone,
    required bool desbloqueado,
    required Color corBase,
  }) {
    return Opacity(
      opacity: desbloqueado ? 1.0 : 0.4,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: desbloqueado 
                    ? [corBase.withValues(alpha: 0.8), corBase.withValues(alpha: 0.4)]
                    : [Colors.grey.shade400, Colors.grey.shade200],
              ),
              boxShadow: desbloqueado
                  ? [BoxShadow(color: corBase.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)]
                  : [],
            ),
            child: Icon(
              desbloqueado ? icone : Icons.lock,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
