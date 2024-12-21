import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/core/widgets/custom_text_field.dart';
import 'package:assignment_task/src/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
            CustomTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                onChanged: (value) =>
                    ref.read(confirmPasswordProvider.notifier).state = value),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider).register(
                      ref.read(emailProvider),
                      ref.read(passwordProvider),
                    );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
