import 'package:assignment_task/src/core/app_routes.dart';
import 'package:assignment_task/src/core/constants/app_strings.dart';
import 'package:assignment_task/src/core/widgets/common_elevated_button.dart';
import 'package:assignment_task/src/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: user.when(
        data: (user) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${AppStrings.email}: ${user?.email ?? AppStrings.guest}'),
              const SizedBox(height: 20),
              CommonElevatedButton(
                text: AppStrings.logout,
                elevation: 0.0,
                borderRadius: 50,
                width: 200,
                height: 45,
                style: TextStyle(fontSize: 18, color: Colors.white),
                onPressed: () async {
                  await ref.read(authProvider).signOut();
                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}
