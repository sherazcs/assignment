import 'package:assignment_task/src/core/constants/app_strings.dart';
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/core/widgets/common_elevated_button.dart';
import 'package:assignment_task/src/core/widgets/custom_text_field.dart';
import 'package:assignment_task/src/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: Column(
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
          const SizedBox(height: 20),
          CommonElevatedButton(
            text: AppStrings.register,
            elevation: 0.0,
            borderRadius: 50,
            width: 200,
            height: 45,
            style: TextStyle(fontSize: 18, color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
