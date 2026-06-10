import 'package:book_life/features/settings/viewmodels/profile_viewmodel.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:book_life/features/settings/views/widgets/progile_page_widgets/skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ProfileViewmodel>();
    final username = viewmodel.username ?? '';
    final email = viewmodel.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 28),
              ),

              PageTitle(title: 'Meu Perfil'),

              const SizedBox(height: 16),

              Center(
                child: viewmodel.isLoading
                    ? buildSkeleton()
                    : Column(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: viewmodel.photoBytes != null
                                ? MemoryImage(viewmodel.photoBytes!)
                                : null,
                            child: viewmodel.photoBytes == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            username,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
