import 'package:assignment_task/src/core/constants/app_strings.dart';
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
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                hintText: AppStrings.email,
                onChanged: (value) =>
                    ref.read(emailProvider.notifier).state = value),
            CustomTextField(
                hintText: AppStrings.password,
                obscureText: true,
                onChanged: (value) =>
                    ref.read(passwordProvider.notifier).state = value),
            CustomTextField(
                hintText: AppStrings.cpassword,
                obscureText: true,
                onChanged: (value) =>
                    ref.read(confirmPasswordProvider.notifier).state = value),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider).register(
                      ref.read(emailProvider),
                      ref.read(passwordProvider),
                    );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.registerSuccess)),
                );
              },
              child: const Text(AppStrings.register),
            ),
          ],
        ),
      ),
    );
  }
}
