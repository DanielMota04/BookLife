import 'dart:typed_data';
import 'package:book_life/core/widgets/button.dart';
import 'package:book_life/features/settings/views/widgets/edit_user_input.dart';
import 'package:book_life/features/settings/views/widgets/image_picker_widget.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Uint8List? _imagem;

  Future<void> _pickImage() async {
    FilePickerResult? resultado = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (resultado != null) {
      setState(() {
        _imagem = resultado.files.first.bytes;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back, size: 28),
              ),

              PageTitle(title: 'Editar Perfil'),

              Center(
                child: ImagePickerWidget(
                  label: 'Foto de perfil',
                  imagem: _imagem,
                  onTap: _pickImage,
                ),
              ),

              SizedBox(height: 35),

              EditUserInput(controller: _usernameController, hint: 'Username'),

              SizedBox(height: 25),

              EditUserInput(controller: _emailController, hint: 'Email'),

              SizedBox(height: 25),

              Button(
                text: 'Salvar',
                onPressed: () {
                  // implementar função de salvar alterações depois
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
