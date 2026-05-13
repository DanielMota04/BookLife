import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeuProgressoPage extends StatelessWidget {
  const MeuProgressoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F7CAC),
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.white, size: 30),
        ),
        
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Meu Progresso",
                style: GoogleFonts.inriaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4F7CAC),
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
                            "Username",
                            style: GoogleFonts.inriaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 18,
                              ),

                              const SizedBox(width: 4),
                              Text(
                                "2",
                                style: GoogleFonts.inriaSans(
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
                      _buildEstatistica(numero: "8", texto: "livros lidos"),
                      _buildEstatistica(numero: "507", texto: "páginas lidas"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            _buildMeta(texto: "Cumpriu 7 metas"),
            _buildMeta(texto: "Leu um total de 80 horas"),
            _buildMeta(texto: "Manteve o hábito a 10 dias seguidos"),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Missões Completas",
                    style: GoogleFonts.inriaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F7CAC),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF4F7CAC),
                    size: 30,
                  ),
                ],
              ),
            ),

            _buildMissao(
              titulo: "Leitor de Carteirinha",
              descricao: "Ler mais de 5 livros",
              completa: false,
            ),
            _buildMissao(
              titulo: "Rato de Biblioteca",
              descricao: "Tenha um streak de 5 dias",
              completa: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Missões Disponíveis",
                    style: GoogleFonts.inriaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F7CAC),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF4F7CAC),
                    size: 30,
                  ),
                ],
              ),
            ),

            _buildMissao(
              titulo: "A Regra da Meia Hora",
              descricao: "Leia por 30 min usando o cronômetro",
              completa: false,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatistica({required String numero, required String texto}) {
    return Column(
      children: [
        Text(
          numero,
          style: GoogleFonts.inriaSans(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          texto,
          style: GoogleFonts.inriaSans(
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
        style: GoogleFonts.inriaSans(
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
                    style: GoogleFonts.inriaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: completa ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: GoogleFonts.inriaSans(
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
