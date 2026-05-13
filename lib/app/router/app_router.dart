import 'package:book_life/features/library/views/biblioteca.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/progress/views/meu_progresso.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/views/settings_page.dart';
import '../../features/settings/views/edit_profile_page.dart';
import '../../features/settings/views/change_password_page.dart';
import '../../features/settings/views/themes_page.dart';
import '../../features/settings/views/about_page.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes
      .welcome, // mude isso aqui quando quiser testar uma tela (e lembre de voltar ao welcome depois :[ )
  redirect: (context, state) {
    // implementar verificação de autenticação quando o auth ja estiver configurado
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: Routes.changePassword,
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(path: Routes.about, builder: (context, state) => const AboutPage()),
    GoRoute(
      path: Routes.themes,
      builder: (context, state) => const ThemesPage(),
    ),

    GoRoute(
      path: Routes.library,
      builder: (context, state) => const MinhaBiblioteca(),
    ),
    GoRoute(
      path: Routes.addBook,
      builder: (context, state) => const AdicionarLivroPage(),
    ),

    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const MeuProgressoPage(),
    ),
  ],
);
