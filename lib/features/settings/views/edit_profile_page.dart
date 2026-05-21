import 'dart:typed_data';
import 'package:book_life/core/widgets/button.dart';
import 'package:book_life/features/settings/viewmodels/update_profile_viewmodel.dart';
import 'package:book_life/features/settings/views/widgets/edit_user_input.dart';
import 'package:book_life/features/settings/views/widgets/image_picker_widget.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewmodel = context.read<UpdateProfileViewmodel>();
      await viewmodel.loadUserData();
      _usernameController.text = viewmodel.currentUsername ?? '';
      _emailController.text = viewmodel.currentEmail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<UpdateProfileViewmodel>();
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
                onPressed: viewmodel.isLoading
                    ? null
                    : () async {
                        await viewmodel.submit(
                          _usernameController.text,
                          _emailController.text,
                        );
                        if (!mounted) return;

                        if (viewmodel.isSuccess) {
                          context.pop();
                        } else if (viewmodel.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(viewmodel.errorMessage!),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
