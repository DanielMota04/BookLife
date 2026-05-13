import 'package:book_life/core/widgets/input_text_field.dart';
import 'package:book_life/core/widgets/button.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                context.pop(Alignment.bottomCenter);
              },
              icon: const Icon(Icons.arrow_back, size: 28),
            ),

            const SizedBox(height: 10),

            PageTitle(title: 'Editar Perfil'),

            // picker redondo de foto com label de foto do perfil embaixo
            InputTextField(
              controller: _usernameController,
              hint: 'Username',
            ), // adicionar lapis de edição do lado e travar ele

            InputTextField(
              controller: _emailController,
              hint: 'Email',
            ), // adicionar lapis do lado e travar ele



            Button(
              text: 'Salvar',
              onPressed: () {
                // implementar função de salvar alterações depois
                context.pop();
              },
            )

          ],
        ),
      ),
    );
  }
}
