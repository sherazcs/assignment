import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/core/widgets/custom_text_field.dart';
import 'package:assignment_task/src/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                hintText: 'Email',
                onChanged: (value) =>
                    ref.read(emailProvider.notifier).state = value),
            CustomTextField(
                hintText: 'Password',
                obscureText: true,
                onChanged: (value) =>
                    ref.read(passwordProvider.notifier).state = value),
            ElevatedButton(
              onPressed: () async {
                final success = await ref.read(authProvider).signIn(
                      ref.read(emailProvider),
                      ref.read(passwordProvider),
                    );
                if (success) {
                  if (!context.mounted) return;
                  context.go('/main');
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Failed')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
