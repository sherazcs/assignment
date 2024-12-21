import 'package:assignment_task/src/features/auth/presentation/login_screen.dart';
import 'package:assignment_task/src/features/auth/presentation/register_screen.dart';
import 'package:assignment_task/src/features/items/presentation/detail_screen.dart';
import 'package:assignment_task/src/features/items/presentation/main_screen.dart';
import 'package:assignment_task/src/features/profile/presentation/profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/main',
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
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
