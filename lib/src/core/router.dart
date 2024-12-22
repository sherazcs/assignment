import 'package:assignment_task/src/core/app_routes.dart';
import 'package:assignment_task/src/features/auth/presentation/login_screen.dart';
import 'package:assignment_task/src/features/auth/presentation/register_screen.dart';
import 'package:assignment_task/src/features/items/presentation/detail_screen.dart';
import 'package:assignment_task/src/features/items/presentation/main_screen.dart';
import 'package:assignment_task/src/features/profile/presentation/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser != null
        ? AppRoutes.main
        : AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(itemId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
