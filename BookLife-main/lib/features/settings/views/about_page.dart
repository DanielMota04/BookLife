import 'package:book_life/features/settings/models/app_info.dart';
import 'package:book_life/features/settings/viewmodels/about_viewmodel.dart';
import 'package:book_life/features/settings/views/widgets/about_page_widgets/description_section_widget.dart';
import 'package:book_life/features/settings/views/widgets/about_page_widgets/githubrepository_section_widget.dart';
import 'package:book_life/features/settings/views/widgets/about_page_widgets/licenses_section_widget.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:book_life/features/settings/views/widgets/about_page_widgets/team_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final AboutViewModel _viewModel;
  late final Future<AppInfo> _appInfoFuture;
  AppInfo? _appInfo;

  @override
  void initState() {
    super.initState();
    _viewModel = AboutViewModel();
    _appInfoFuture = _viewModel.loadAppInfo().then((info) {
      setState(() => _appInfo = info);
      return info;
    });
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
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back, size: 28),
              ),

              PageTitle(title: 'Sobre'),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: FutureBuilder<AppInfo>(
                    future: _appInfoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Não foi possível carregar a versão do app',
                          ),
                        );
                      }
                      final info = snapshot.data!;
                      return Column(
                        children: [
                          const Icon(Icons.menu_book, size: 72),
                          const SizedBox(height: 12),
                          Text(
                            info.appName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text('v${info.version} (build ${info.buildNumber})'),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const Divider(),

              DescriptionSection(),

              const Divider(),

              GithubRepositorySection(_viewModel),
              LicensesSection(_appInfo, _viewModel),

              const Divider(),

              TeamSection(),

            ],
          ),
        ),
      ),
    );
  }
}
