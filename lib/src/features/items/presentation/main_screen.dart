import 'package:assignment_task/src/core/app_routes.dart';
import 'package:assignment_task/src/core/constants/app_strings.dart';
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/features/items/presentation/widget/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.main),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: items.when(
        data: (itemsList) => itemsList.isEmpty
            ? const Center(child: Text(AppStrings.noItemsAvailable))
            : ListView.builder(
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  final item = itemsList[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    onTap: () => context.push('/details/${item.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        confirmDelete(context, ref, item.id);
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppStrings.anErrorOccurred}: $err'),
              TextButton(
                onPressed: () => ref.refresh(itemsProvider),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${AppRoutes.details}/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
