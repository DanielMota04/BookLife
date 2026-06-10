import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/core/services/auth_state_notifier.dart';
import 'package:book_life/features/auth/repositories/auth_repository.dart';
import 'package:book_life/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:book_life/features/book_details/views/livro_details.dart';
import 'package:book_life/features/auth/views/welcome_page.dart';
import 'package:book_life/features/library/views/biblioteca.dart';
import 'package:book_life/features/library/views/cadastrar_livro.dart';
import 'package:book_life/features/progress/views/meu_progresso.dart';
import 'package:book_life/features/settings/repositories/profile_repository.dart';
import 'package:book_life/features/settings/viewmodels/change_password_viewmodel.dart';
import 'package:book_life/features/settings/viewmodels/logout_viewmodel.dart';
import 'package:book_life/features/settings/viewmodels/profile_viewmodel.dart';
import 'package:book_life/features/settings/viewmodels/update_profile_viewmodel.dart';
import 'package:book_life/features/settings/views/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:book_life/features/goals/views/metas.dart';
import 'package:provider/provider.dart';

import '../../features/settings/views/settings_page.dart';
import '../../features/settings/views/edit_profile_page.dart';
import '../../features/settings/views/change_password_page.dart';
import '../../features/settings/views/themes_page.dart';
import '../../features/settings/views/about_page.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes.welcome,
  refreshListenable: AuthStateNotifier(FirebaseAuth.instance),
  redirect: (context, state) {
  final loggedIn = FirebaseAuth.instance.currentUser != null;
  final onWelcome = state.matchedLocation == Routes.welcome;

  if (!loggedIn && !onWelcome) return Routes.welcome;
  if (loggedIn && onWelcome) return Routes.library;
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.welcome,
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LoginViewModel(
              AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
            ),
          ),

            ChangeNotifierProvider(
            create: (context) => ForgotPasswordViewModel(
              AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
            ),
          ),

          ChangeNotifierProvider(
            create: (context) => RegisterViewModel(
              AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
            ),
          ),
        ],
        child: const WelcomePage(),
      ),
    ),

    // settings
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => LogoutViewModel(
          AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => UpdateProfileViewmodel(
          ProfileRepository(FirebaseFirestore.instance, FirebaseAuth.instance),
        ),
        child: const EditProfilePage(),
      ),
    ),
    GoRoute(
      path: Routes.changePassword,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => ChangePasswordViewModel(
          AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        child: const ChangePasswordPage(),
      ),
    ),
    GoRoute(path: Routes.about, builder: (context, state) => const AboutPage()),
    GoRoute(
      path: Routes.themes,
      builder: (context, state) => const ThemesPage(),
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => ProfileViewmodel(
          ProfileRepository(FirebaseFirestore.instance, FirebaseAuth.instance),
        ),
        child: const ProfilePage(),
      ),
    ),

    // library
    GoRoute(
      path: Routes.library,
      builder: (context, state) => const MinhaBiblioteca(),
    ),
    GoRoute(
      path: Routes.addBook,
      builder: (context, state) => const AdicionarLivroPage(),
    ),
    GoRoute(
      path: '${Routes.library}/:name',
      builder: (context, state) {
        final livro = state.extra as Book?;
        return LivroDetails(book: livro);
      },
    ),

    // progress
    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const MeuProgressoPage(),
    ),

    // goals
    GoRoute(path: Routes.goals, builder: (context, state) => const MetasPage()),
  ],
);
