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
      appBar: AppBar(title: const Text('Profile')),
      body: user.when(
        data: (user) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Email: ${user?.email ?? 'Guest'}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider).signOut();
                  context.go('/login');
                },
                child: const Text('Logout'),
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
