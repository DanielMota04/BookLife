import 'package:book_life/features/book_details/views/livro_details.dart';
import 'package:book_life/features/auth/views/welcome_page.dart';
import 'package:book_life/features/library/views/biblioteca.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/progress/views/meu_progresso.dart';
import 'package:book_life/features/settings/views/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:book_life/features/goals/views/metas.dart';

import '../../features/settings/views/settings_page.dart';
import '../../features/settings/views/edit_profile_page.dart';
import '../../features/settings/views/change_password_page.dart';
import '../../features/settings/views/themes_page.dart';
import '../../features/settings/views/about_page.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes
      .welcome,
  redirect: (context, state) {
    // implementar verificação de autenticação quando o auth ja estiver configurado
    return null;
  },
  routes: [
     GoRoute(
      path: Routes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
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
  path: Routes.profile,
  builder: (context, state) => const ProfilePage(),
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
      path: '${Routes.library}/:id', 
      builder: (context, state) {
        final idLivro = state.pathParameters['id'] ?? '1';
        return LivroDetails(bookId: idLivro,); 
      }
    ),
    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const MeuProgressoPage(),
    ),
    GoRoute(
      path: Routes.goals,
      builder: (context, state) => const MetasPage(),
    ),
  ],
);