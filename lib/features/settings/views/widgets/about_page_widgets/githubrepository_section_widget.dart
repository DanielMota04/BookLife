import 'package:book_life/features/settings/viewmodels/about_viewmodel.dart';
import 'package:flutter/material.dart';

class GithubRepositorySection extends StatelessWidget {
  final AboutViewModel _viewModel;

  const GithubRepositorySection(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.code),
      title: const Text('Repositório no GitHub'),
      onTap: () async {
        try {
          await _viewModel.openRepository();
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
    );
  }
}