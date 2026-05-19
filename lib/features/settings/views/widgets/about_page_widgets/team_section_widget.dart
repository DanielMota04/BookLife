import 'package:flutter/material.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Equipe de Desenvolvimento',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Daniel de Oliveira Mendonça Mota'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Davi Lima Lôbo'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Lucca Brito Moura'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Anthony Magalhães Andrade da Costa'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Guilherme Kalel Evangelista Valenca'),
        ),
      ],
    );
  }
}
